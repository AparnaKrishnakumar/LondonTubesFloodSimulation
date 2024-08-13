# Underground Platform Flood Simulation Model README

## Overview

This repository contains a GAMA model for simulating a flood scenario in an underground platform. The model includes passengers, staff, and water spread simulation. This README provides an overview of the model, its components, and instructions for running sensitivity analysis and calibration experiments.

## Model Description

### Process Flow

1. **Initialization**: The model initializes the station layout, passengers, staff, and water simulation.

2. **Water Spread Trigger**: After a certain number of simulation cycles (10 in this case), the water spread trigger is activated, simulating the flood scenario.

3. **Update Counts**: The number of guided passengers is continuously updated.

4. **Compute Average Evacuation Time**: The average evacuation time for different passenger types (child, adult, elderly) is calculated.

5. **Stop Simulation When All Exited**: The simulation ends when all passengers have exited the platform.

### Equations

- **Social Force Model**: Passengers are modeled using a social force model, which calculates forces like repulsion and attraction between agents to simulate their movement.

- **Evacuation Time Calculation**: Evacuation time for each passenger is recorded, and average evacuation times are computed for different passenger types.

### How to Run

1. Install GAMA: Make sure you have GAMA installed on your system.

2. Clone the Repository: Clone this repository to your local machine.

3. Open the Model: Open the GAMA model file (`.gaml`) in the GAMA IDE.

4. Run the Simulation: Click the "Run" button in the GAMA IDE to start the simulation.

5. Experiment Parameters: You can modify parameters like passenger speed, staff count, and the number of passengers in the GAMA IDE.

## Sensitivity Analysis

### Purpose

The sensitivity analysis is used to study how changes in input parameters affect the average evacuation times for different passenger types. It helps identify which parameters have the most significant impact on evacuation times.

### How to Run

1. Follow the "How to Run" instructions above to open the model in the GAMA IDE.

2. In the "SensitivityAnalysis" experiment, you can specify parameter ranges and steps for child speed, adult speed, elderly speed, number of passengers, and number of staff.

3. Run the "SensitivityAnalysis" experiment to perform multiple simulations with varying parameters.

### Expected Results

- The sensitivity analysis will produce histograms showing the distribution of average evacuation times for child, adult, and elderly passengers.

## Calibration Experiment

### Purpose

The calibration experiment aims to find parameter values that minimize the total evacuation time. It uses a genetic algorithm to search for the optimal combination of parameters.

### How to Run

1. Follow the "How to Run" instructions above to open the model in the GAMA IDE.

2. In the "calibration_evacuation_time" experiment, you can specify parameter ranges and steps for child speed, adult speed, elderly speed, number of passengers, and number of staff.

3. Run the "calibration_evacuation_time" experiment to find the parameter values that minimize the total evacuation time.

### Expected Results

- The calibration experiment will produce a histogram showing the distribution of total evacuation times for different parameter combinations.

## Conclusion

This README provides an overview of the Underground Platform Flood Simulation Model, including its process flow, equations, and instructions for running sensitivity analysis and calibration experiments. By analyzing the results of these experiments, you can gain insights into the impact of parameter variations and find optimal parameter values for minimizing evacuation times.
