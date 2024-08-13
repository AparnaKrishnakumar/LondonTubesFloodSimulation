/**
* Name: NewModel
* Based on the internal empty template. 
* Author: ASUS
* Tags: 
*/


model UnderGround_Platform_Flood_Simulation

/* Global definitions */
global {
    // Define the layout of the station
    geometry platform <- polygon([{20, 15}, {20, 85}, {80, 85}, {80, 15}]);
    geometry track <- line([{20, 10}, {80, 10}]);
    geometry entry <- line([{10, 50}, {20, 50}]);
    geometry stairs <- polygon([{5, 40}, {10, 40}, {10, 60}, {5, 60}]);
    geometry exit_to_another_platform <- line([{85, 50}, {95, 50}]);
    geometry emergency_exit <- line([{45, 90}, {55, 90}]);
    geometry walls <- polyline([{15, 15}, {15, 85}, {85, 85}, {85, 15}]);
    
    // Additional features: pillars, benches, waiting area
    geometry pillars <- circle(2); 
    geometry benches <- rectangle(10, 3);
    geometry waiting_area <- rectangle(15, 8);
    
    // Pathways from entry to exits
    geometry pathway_to_exit1 <- polyline([{15, 50}, {50, 50}, {85, 50}]);
    geometry pathway_to_exit2 <- polyline([{15, 50}, {50, 50}, {50, 90}]);
    
    // Specify coordinates for labels
    int pillar1_x <- 30;
    int pillar1_y <- 40;
    
    int pillar2_x <- 60;
    int pillar2_y <- 40;
    
    int pillar3_x <- 30;
    int pillar3_y <- 60;
    
    int pillar4_x <- 60;
    int pillar4_y <- 60;
    
    int bench1_x <- 30;
    int bench1_y <- 28;
    
    int bench2_x <- 65;
    int bench2_y <- 28;
    
    int waiting_area_x <- 55;
    int waiting_area_y <- 70;
    
    int exited_passengers <- 0;
    int guided_passengers <- 0;
    //Variabbles for calculating average evacuation time
    float total_child_evacuation_time <- 0.0;
    float total_adult_evacuation_time <- 0.0;
    float total_elderly_evacuation_time <- 0.0;

    int child_count <- 0;
    int adult_count <- 0;
    int elderly_count <- 0;

    float avg_child_evacuation_time <- 0.0;
    float avg_adult_evacuation_time <- 0.0;
    float avg_elderly_evacuation_time <- 0.0;
    
    float avg_evacuation_time <- 0.0;
    
    //variables for sensitivity analysis
     float child_speed <- 1.0;  // Default value
    float adult_speed <- 1.5;  // Default value
    float elderly_speed <- 0.8;  // Default value
    int num_passengers <- 50;  // Default value
    int num_staff <- 5; 
    
    
    bool start_spreading <- false;
    init {
        // Create shapes and specify their positions
        create platform_shape { shape <- geometry(platform); }
        create track_shape { shape <- track; }
        create entry_shape { shape <- entry; }
        create stairs_shape { shape <- stairs; }
        create exit_to_another_platform_shape { shape <- exit_to_another_platform; }
        create emergency_exit_shape { shape <- emergency_exit; }
        create walls_shape { shape <- walls; }
        
        create pillars_shape1 { shape <- pillars translated_to {pillar1_x, pillar1_y}; }
        create pillars_shape2 { shape <- pillars translated_to {pillar2_x, pillar2_y}; }
        create pillars_shape3 { shape <- pillars translated_to {pillar3_x, pillar3_y}; }
        create pillars_shape4 { shape <- pillars translated_to {pillar4_x, pillar4_y}; }
        
        create benches_shape1 { shape <- benches translated_to {bench1_x, bench1_y}; }
        create benches_shape2 { shape <- benches translated_to {bench2_x, bench2_y}; }
        
        create waiting_area_shape { shape <- waiting_area translated_to {waiting_area_x, waiting_area_y}; }
        
        create pathway_to_exit1_shape { shape <- pathway_to_exit1; }
        create pathway_to_exit2_shape { shape <- pathway_to_exit2; }
        
        // Create staff
		create staff number: num_staff {
		    location <- { rnd(60) + 20, rnd(70) + 15 }; // Stay within platform bounds
		}
		
		// Create passengers
		create passengers number: num_passengers {
		    location <- { rnd(60) + 20, rnd(70) + 15 }; // Stay within platform bounds  
		}
        
        // Create water at the location of stairs to simulate water spreading
    	create water { shape <- track; }
    }
    // Water spread trigger
    reflex trigger_water_spread {
        if (cycle >= 10) {
            start_spreading <- true;
        }
    }
    //Update Counts for graph values
    reflex update_counts {
        guided_passengers <- length(passengers where (each.is_guided = true));
    }
    reflex compute_average_evacuation_times {
        if (child_count != 0) {
            avg_child_evacuation_time <- total_child_evacuation_time / child_count;
        }
        if (adult_count != 0) {
            avg_adult_evacuation_time <- total_adult_evacuation_time / adult_count;
        }
        if (elderly_count != 0) {
            avg_elderly_evacuation_time <- total_elderly_evacuation_time / elderly_count;
        }
        avg_evacuation_time <- (total_child_evacuation_time + total_adult_evacuation_time + total_elderly_evacuation_time )/ num_passengers;
    }
    /*reflex stop_simulation_when_all_exited {
        if (length(passengers) = 0) {
            write "All passengers have exited. Stopping the simulation.";
            do pause; // Stops the simulation
        }
    }*/

}

// Species Definitions and functions

//Water species
species water {
    geometry current_shape <- shape;
    rgb color <- rgb(128, 0, 128, 128); // Light blue and half-transparent
    
    // Buffer value for water spread
    float buffer_value <- 0.50;
    
    reflex grow {
        // Using buffer to simulate the growth of the water area only if start_spreading is true
        if (start_spreading) {
            current_shape <- buffer(current_shape, buffer_value);
            shape <- current_shape;
        }
    }
    
    aspect base {
        draw shape color: color;
        draw "Water" color: rgb(0, 0, 0) size: 20 at: {location.x, location.y};
    }
}

// Platform features
species platform_shape {
    aspect base {
        draw shape color: rgb(200, 200, 200);
        draw "Platform" color: rgb(0,0,0) size: 20 at:{50,15};
    }
}

species stairs_shape {
    aspect base {
        draw shape color: rgb(150, 150, 150);
        draw "Stairs" color: rgb(0,0,0) size: 20 at:{10,45};
    }
}

species track_shape {
    aspect base {
        draw shape color: rgb(0, 0, 0) width: 3;
        draw "Track" color: rgb(0,0,0) size: 20 at:{50,5};
    }
}

species entry_shape {
    aspect base {
        draw shape color: rgb(0, 255, 0) width: 5;
        draw "Entry" color: rgb(0,0,0) size: 20 at:{16,49};
    }
}

species exit_to_another_platform_shape {
    aspect base {
        draw shape color: rgb(0, 255, 0) width: 5;
        draw "To Other Platform" color: rgb(0,0,0) size: 14 at:{86,49};
    }
}

species emergency_exit_shape {
    aspect base {
        draw shape color: rgb(255, 0, 0) width: 5;
        draw "Emergency Exit" color: rgb(0,0,0) size: 14 at:{55,88};
    }
}

species walls_shape {
    aspect base {
        draw shape color: rgb(255, 0, 0) width: 2; // Red color for walls
        draw "Walls" color: rgb(0,0,0) size: 14 at:{8,17};
    }
}

species pillars_shape1 {
    aspect base {
        draw shape color: rgb(150, 150, 150);
        draw "Pillar 1" color: rgb(0,0,0) size: 12 at: {32, pillar1_y};
    }
}

species pillars_shape2 {
    aspect base {
        draw shape color: rgb(150, 150, 150);
        draw "Pillar 2" color: rgb(0,0,0) size: 12 at: {62, pillar2_y};
    }
}

species pillars_shape3 {
    aspect base {
        draw shape color: rgb(150, 150, 150);
        draw "Pillar 3" color: rgb(0,0,0) size: 12 at: {32, pillar3_y};
    }
}

species pillars_shape4 {
    aspect base {
        draw shape color: rgb(150, 150, 150);
        draw "Pillar 4" color: rgb(0,0,0) size: 12 at: {62, pillar4_y};
    }
}

species benches_shape1 {
    aspect base {
        draw shape color: rgb(170, 120, 80);
        draw "Bench 1" color: rgb(0,0,0) size: 12 at: {bench1_x, 33};
    }
}

species benches_shape2 {
    aspect base {
        draw shape color: rgb(170, 120, 80);
        draw "Bench 2" color: rgb(0,0,0) size: 12 at: {bench2_x, 33};
    }
}

species waiting_area_shape {
    aspect base {
        draw shape color: rgb(220, 220, 220);
        draw "Waiting Area" color: rgb(0,0,0) size: 14 at: {waiting_area_x, waiting_area_y};
    }
}

species pathway_to_exit1_shape {
    aspect base {
        draw shape color: rgb(0, 0, 255) width: 3;
        draw "Pathway to Exit 1" color: rgb(0,0,0) size: 14 at:{55,49};
    }
}

species pathway_to_exit2_shape {
    aspect base {
        draw shape color: rgb(0, 0, 255) width: 3;
        draw "Pathway to Exit 2" color: rgb(0,0,0) size: 14;
    }
}

// Define staff species
species staff {
    point emergency_exit_location <- {55, 90};
    float speed <- 1.0;
    rgb color <- rgb(0, 0, 255); // Blue for staff
    int help_range <- 3;
    int response_time <- 1; // Response time in timesteps, set to 1 for staff
    int time_since_alert <- 0;

    reflex move {
        // Check if flooding has started
        if (start_spreading) {
            time_since_alert <- time_since_alert + 1;
            if (time_since_alert >= response_time) {
                // Move towards emergency exit and guide passengers
            float dx <- emergency_exit_location.x - location.x;
            float dy <- emergency_exit_location.y - location.y;

            float len <- sqrt(dx * dx + dy * dy);
            if (len > 1.0) { // Move only if the staff isn't already near the emergency exit
                dx <- (dx / len) * speed;
                dy <- (dy / len) * speed;

                location <- {location.x + dx, location.y + dy};
            }
        } else {
            // Your normal behavior for staff can go here (the random walk part, etc.)
            float dx <- rnd(2 * speed) - speed;
            float dy <- rnd(2 * speed) - speed;
            location <- {location.x + dx, location.y + dy};
        }
        
        // Make sure staff stays within platform bounds
        if (location.x < 20 or location.x > 80 or location.y < 15 or location.y > 85) {
            location <- {min(max(location.x, 20), 80), min(max(location.y, 15), 85)};
            }
        }
    }
    
    reflex help_passengers when: !empty(passengers at_distance help_range){
        ask passengers at_distance help_range{
            self.is_guided <- true;
        }
    }

    aspect base {
        draw circle(1) color: color;
        draw "S" color: rgb(255,255,255) size: 12;
    }
}

//Define passenger species
species passengers {
    // Define an attribute to categorize the passenger type
    string passenger_type <- one_of(["child", "adult", "elderly"]);

    // Initialize speed and color based on the type
    float speed <- (passenger_type = "child") ? child_speed : ((passenger_type = "adult") ? adult_speed : elderly_speed);
  // Speed for child, adult, elderly
	rgb color <- (passenger_type = "child") ? rgb(255, 0, 0) : ((passenger_type = "adult") ? rgb(255, 255, 0) : rgb(255, 140, 0));  
	// Red for child, yellow for adult, dark orange for elderly
	
	int response_time <- (passenger_type = "child") ? 4 : ((passenger_type = "adult") ? 3 : 2); // Response time in timesteps
    float elapsed_time <- float(0);  // Time since start_spreading became true
	bool is_exited <- false;
    bool is_guided <- false;
    bool is_moving <- rnd(100) < 50;  // 50% chance of moving towards exit from the beginning
    int start_time <- -1;  // Initialized to -1, indicating that evacuation hasn't started yet for this passenger
    float evacuation_time <- float(-1);  // Initializing with -1 indicates that the passenger hasn't evacuated yet.
    reflex record_start_time {
    if (start_spreading and start_time = -1) {
        start_time <- cycle;  // Assuming 'cycle' represents the current timestep in your model
    }
	}
    
    reflex move {
    	if (start_spreading) {
            elapsed_time <- elapsed_time + 1;
        }
        // Check if should move or not
        bool should_move <- is_moving or (start_spreading and elapsed_time >= response_time);
        if (should_move) {
        // Destination
        point target <- (start_spreading) ? {55, 90} : {85, 50}; // {55, 90} is the location of emergency exit
        
        list<passengers> nearby_passengers <- self neighbors_at 5;
        // Social force model for passengers
        float dx <- target.x - location.x;
        float dy <- target.y - location.y;
        float repulsion_x <- 0.0;
        float repulsion_y <- 0.0;
        float attraction_x <- 0.0;
        float attraction_y <- 0.0;  // New attraction component for assistance
            

        loop p over: nearby_passengers {
	    float ddx <- location.x - p.location.x;
	    float ddy <- location.y - p.location.y;
	    float distance <- sqrt((ddx * ddx) + (ddy * ddy));
	    if distance < 5 and distance != 0 {
        repulsion_x <- repulsion_x + (((5 - distance) * ddx) / distance);
        repulsion_y <- repulsion_y + (((5 - distance) * ddy) / distance);
		    }
		}
        if (passenger_type = "child" or passenger_type = "elderly") {
		    // Attraction to adults and staff for assistance
		    list<agent> helpers <- list<agent>((passengers where (each.passenger_type = "adult")) + (staff));
		    loop h over: helpers {
		        float ddx <- h.location.x - location.x;
		        float ddy <- h.location.y - location.y;
		        float distance <- sqrt((ddx * ddx) + (ddy * ddy));
		
		        if (distance < 10 and distance != 0) {  // Assuming a larger range for assistance
		            attraction_x <- attraction_x + ((10 - distance) * ddx) / distance;
		            attraction_y <- attraction_y + ((10 - distance) * ddy) / distance;
		        }
		    }
		}
        // Add forces
        float move_x <- dx + repulsion_x;
        float move_y <- dy + repulsion_y;

        // Normalize
        float len <- sqrt(move_x * move_x + move_y * move_y);
        move_x <- move_x / len;
        move_y <- move_y / len;

        // Move
        location <- {location.x + move_x, location.y + move_y};
        
        // Make sure passengers stay within platform bounds
        if (location.x < 20 or location.x > 80 or location.y < 15 or location.y > 85) {
            location <- {min(max(location.x, 20), 80), min(max(location.y, 15), 85)};
        }
}
        if (location.x > 83 and location.y = 50) or ((location.x > 44 and location.x < 56)and location.y > 83) {
        is_exited <- true;
        exited_passengers <- exited_passengers+1;
        if(evacuation_time = -1) {  // Ensure we only set this once.
            evacuation_time <- float(cycle);  // 'cycle' is the current simulation step in GAMA.
             if (passenger_type = "child") {
            total_child_evacuation_time <- total_child_evacuation_time + evacuation_time;
            child_count <- child_count + 1;
        } else if (passenger_type = "adult") {
            total_adult_evacuation_time <- total_adult_evacuation_time + evacuation_time;
            adult_count <- adult_count + 1;
        } else if (passenger_type = "elderly") {
            total_elderly_evacuation_time <- total_elderly_evacuation_time + evacuation_time;
            elderly_count <- elderly_count + 1;
        }
            do die;  // Remove the agent from the simulation
        }
    	}
        }
        
    
    aspect base {
        draw circle(1) color: (is_guided) ? #green : color;
        //Legend
        draw "Red: Child" color: #black at: {5, 90} size: 12;
        draw  "Yellow: Adult" color: #black at: {5, 92} size: 12;
        draw  "Dark Orange: Elderly" color: #black at: {5, 94} size: 12;
    }
}


experiment Flood_simulation type: gui {
    output {
        display "TubeStationDisplay" type: opengl {
            species platform_shape aspect: base;
            species walls_shape aspect: base;
            species stairs_shape aspect: base;
            species track_shape aspect: base;
            species entry_shape aspect: base;
            species exit_to_another_platform_shape aspect: base;
            species emergency_exit_shape aspect: base;
            species pillars_shape1 aspect: base;
            species pillars_shape2 aspect: base;
            species pillars_shape3 aspect: base;
            species pillars_shape4 aspect: base;
            species benches_shape1 aspect: base;
            species benches_shape2 aspect: base;
            species waiting_area_shape aspect: base;
            species pathway_to_exit1_shape aspect: base;
            species pathway_to_exit2_shape aspect: base;
            // Include staff and passengers
            species staff aspect: base;
            species passengers aspect: base;
            species water aspect: base;
            
            }
            //Graph display of passenger parameters
            display my_chart{
			chart "Passenger Metrics" type: series {
                data "Exited Passengers" value: exited_passengers color: #blue;
                data "Guided Passengers" value: guided_passengers color: #green;
                data "Active Passengers" value: (length(passengers) - exited_passengers) color: #red;
		}}
		display my_chart_1{
		chart "Average Evacuation Times" type:histogram  {
        data "Child" value: avg_child_evacuation_time color: rgb(255, 0, 0); // Red for child
        data "Adult" value: avg_adult_evacuation_time color: rgb(255, 255, 0); // Yellow for adult
        data "Elderly" value: avg_elderly_evacuation_time color: rgb(255, 140, 0); // Dark orange for elderly
    }}
			
       

  
    }
}

// Sensitivity Analysis Experiment
experiment SensitivityAnalysis type: batch repeat: 2 until: cycle > 100 { 
    // Parameters to vary in sensitivity analysis
    parameter "Child Speed" var: child_speed min: 0.5 max: 2.0 step: 0.5;
    parameter "Adult Speed" var: adult_speed min: 1.0 max: 3.0 step: 0.5;
    parameter "Elderly Speed" var: elderly_speed min: 0.3 max: 1.5 step: 0.3;
    parameter "Number of Passengers" var: num_passengers min: 10 max: 200 step: 20;
    parameter "Number of Staff" var: num_staff min: 1 max: 20 step: 1;

    output {
        // Monitoring the parameter values
        monitor "Child Speed:" value: child_speed;
        monitor "Adult Speed:" value: adult_speed;
        monitor "Elderly Speed:" value: elderly_speed;
        monitor "Number of Passengers:" value: num_passengers;
        monitor "Number of Staff:" value: num_staff;

        // Displaying sensitivity analysis results
        display "Sensitivity Analysis Output" {
            chart "Average Evacuation Times" type: histogram {
                // Data for average evacuation times
                data "Avg Child Evac Time" value: avg_child_evacuation_time;
                data "Avg Adult Evac Time" value: avg_adult_evacuation_time;
                data "Avg Elderly Evac Time" value: avg_elderly_evacuation_time;
            }
        }
    }
}

// Calibration Experiment
experiment calibration_evacuation_time type: batch until: cycle > 10 repeat: 2 {
    // Parameters to calibrate
    parameter "Child Speed" var: child_speed min: 0.5 max: 2.0 step: 0.5;
    parameter "Adult Speed" var: adult_speed min: 1.0 max: 3.0 step: 0.5;
    parameter "Elderly Speed" var: elderly_speed min: 0.3 max: 1.5 step: 0.3;
    parameter "Number of Passengers" var: num_passengers min: 10 max: 200 step: 20;
    parameter "Number of Staff" var: num_staff min: 1 max: 20 step: 1;

    // Using genetic algorithm to minimize total evacuation time
    method genetic pop_dim: 3 max_gen: 5 minimize: abs(avg_child_evacuation_time + avg_adult_evacuation_time + avg_elderly_evacuation_time - 120); 
    // Replace 120 with your desired evacuation time
    
    output {
        // Monitoring the parameter values
        monitor "Child Speed:" value: child_speed;
        monitor "Adult Speed:" value: adult_speed;
        monitor "Elderly Speed:" value: elderly_speed;
        monitor "Number of Passengers:" value: num_passengers;
        monitor "Number of Staff:" value: num_staff;

        // Displaying calibration results
        display "Calibration Output" {
            chart "Evacuation Times" type: histogram {
                // Data for total evacuation time
                data "Avg Evacuation Time" value: (avg_child_evacuation_time + avg_adult_evacuation_time + avg_elderly_evacuation_time);
            }
        }
    }
}


   
   


