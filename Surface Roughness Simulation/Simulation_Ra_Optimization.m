%Simulation_Ra_Optimization
%Programmed by: Ryan Garcia 
%Date: 20-Feb-2024
%Description: This program will use the css_taper_surface function and
%attempt to optimize the tool nose radius till the calculated Ra values are
%minimized between the measured surface and the simulation. 

clc; 
clear; 
close all; 

% nr = 0.03125; 

% Define your target value
Ra_target = 0.2040; %[um] 

% Objective Function: Directly minimizes nr
objectiveFunction = @(nr_fit) nr_fit;

% Define the constraint function
% This function should output the non-linear inequality and equality constraints
% Here, we're setting an inequality constraint to ensure Ra_sim is below a certain threshold
max_allowed_Ra = 0.5; % Example: maximum allowed Ra_sim value
constraintFunction = @(nr) deal([], css_taper_surface(nr) - max_allowed_Ra);

% Initial guess for nr
nr_initial = 0.03125; % Adjust based on your problem specifics

% Lower and upper bounds for nr, if known. Adjust these as per your requirements.
lb = 0; % Lower bound for nr
ub = Inf; % Upper bound for nr (set to Inf if no upper bound)

% Optimization options
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');

% Perform the optimization
[nr_optimized, fval, exitflag, output] = fmincon(objectiveFunction, nr_initial, [], [], [], [], lb, ub, constraintFunction, options);

% Display the optimized nr value and the corresponding Ra_sim value
disp(['Optimized nr: ', num2str(nr_optimized)]);
disp(['Optimized Ra_sim: ', num2str(css_taper_surface(nr_optimized))]);
