%  ---------------------------------------------------------------------  %
%% THIS PARAMETER SCRIPT IS THE INITIALISATION FUNCTION FOR THE SIMULINK
%% MODEL "trajectory_tracking_simulation_on_kinematic_model.slx"
%
%  That this script is the initialisation function is specified in the
%  "Model Properties" of the Simulink model in the "Callbacks" tab.
%
%
%  ---------------------------------------------------------------------  %
%% HOW TO UNDERSTAND THIS SCRIPT
%
%  This script was written with the intention that comments and variable
%  names are sufficiently descriptive to document how to use this script in
%  combination with the Simulink model.
%
%  The variable names should match with those used in the respective
%  lecture slides for the subject.
%
%
%  ---------------------------------------------------------------------  %
%% YOU MUST EDIT THIS PARAMETER SCRIPT
%
%  Parameter values in this script are NOT carefully chosen.
%  You SHOULD check all parameter values and adjust them to respresent the
%  the robot that you wish to model.
%
%
%  ---------------------------------------------------------------------  %
%% YOU MUST EDIT THE SIMULINK MODEL
%
%  The "Matlab Function" blocks in the Simulink model have placeholder code
%  that always outputs zero. You must edit these functions to correctly
%  implement the respective equations. The "Matlab Function" blocks that
%  need to be edited are:
%  > The "kinemeatic model eom" block that is inside the "Kinematic Model
%    Subsystem".
%  > The "actuator values to theta_dot per wheel" block that is inside the
%    "Controller Subsystem".
%  > The "compute error signal" block.
%  > The "odometry pose update" block that is inside the
%    "Odometry Subsystem".
%
%
%  ---------------------------------------------------------------------  %
%% YOU MUST EDIT THE "get_warehouse_specification.m" SCRIPT
%
%  See the comments in that script for details about how the warehouse is
%  specified
%
%
%  ---------------------------------------------------------------------  %
%% YOU MUST EDIT THE "path_planning_and_trajectory_generation.m" SCRIPT
%
%  See the comments that script for details about how path planning and
%  trajectory generation should function.
%
%
%  ---------------------------------------------------------------------  %
%% AUTOMATIC PLOTTING WHEN SIMULATION STOPS
%
%  The "Plotting Subsystem" outputs the following signals to the Matlab
%  worksapce:
%  >> out.pose
%       This is the pose that is computed by the kinematic model
%  >> out.pose_ref
%       This is the pose reference that is computed by the "compute error
%       signal" function
%
%  The "Odometry Subsystem" outputs the following signals to the Matlab
%  worksapce:
%  >> out.odometry_pose
%      This is the pose mean estimate that is computed by odometry
%  >> out.odometry_pose_covariance
%      This is the covariance of the pose estimate that is computed by
%      odometry
%
%  The function "plot_trajectory_at_simulation_stop" is called when the
%  Simulink simulation ends. This is specified in the "Model Properties" of
%  the Simulink model in the "Callbacks" tab.
%
%  The "plot_trajectory_at_simulation_stop" function plots the variables
%  mentioned above to visualise the trajectory followed by the robot.
%
%
%  ---------------------------------------------------------------------  %


%  ---------------------------------------------------------------------  %
%% CLEAR AND CLOSE EVERYTHING
% > Clear all variables:
clear;
% > Close all open figures
close all;
% > Clear any text from the Command Window
clc;



%  ---------------------------------------------------------------------  %
%% SPECIFY HERE THE PARAMETERS OF THE MODEL
%
%  NOTE: that the suffix naming convention for the variables is:
%  >> "_for_model" variables are to be used in the "Kinematic Model
%     Subsystem".
%  >> "_for_controller" variables are to be used in the "Controller
%     Subsystem".
%  Using separate parameters for the model and the controller allows you to
%  investigate the influence of model mis-match.

% Specify the wheel radii in meters:
% > For use in the kinematic model
wheel_radius_left_for_model  = 0.050;
wheel_radius_right_for_model = 0.050;
% > For use in the controller
wheel_radius_left_for_controller  = 0.050;
wheel_radius_right_for_controller = 0.050;

% Specify half of the wheel base in meters:
% > For use in the kinematic model
half_wheel_base_for_model = 0.125;
% > For use in the controller
half_wheel_base_for_controller = 0.125;



%  ---------------------------------------------------------------------  %
%% SPECIFY THE INITIAL AND TARGET POSE

% Specify the inital location and heading
% > Note that the the initial location is used for the "initial condition"
%   of the integrator blocks in the "Kinematic Model Subsystem"
x_p_initial =  0.5;
y_p_initial =  3.0;
phi_initial =  0 * (pi/180);

% Specify the target location and heading
x_p_target =  1.5;
y_p_target =  1.0;
phi_target =  -90 * (pi/180);

% Note:
% > The units for (x_p,y_p) cordinates is meters.
% > The units for phi heading is radians.



%  ---------------------------------------------------------------------  %
%% SPECIFY THE PARAMETERS RELEVANT FOR ODOMETRY

% Specify the initial wheel positions
% > Note that when using the kinematic model, the wheel position are only
%   relevant for odometry, which is only interested in changes in wheel
%   position. But it is still good practice to initialise the respective
%   integrator using a variable, as this is easier for changing the initial
%   wheel positions and testing for any influence.
theta_l_initial = 0;
theta_r_initial = 0;

% Specify the sampling time of wheel encoder measurements, in seconds
wheel_encoder_sampling_time = 1/100;

% Specify the initial pose for odometry
odometry_x_p_initial = x_p_initial;
odometry_y_p_initial = y_p_initial;
odometry_phi_initial = phi_initial;

% Specify the variance scaling paramter for the wheel encoder measurements
% > Note: this error model of the wheel encoders makes the following
%   assumptions:
%   Assumption 1: the left and right wheel errors are independent.
%   Assumption 2: The distribution of wheel errors is Gaussian.
%   Assumption 3: The wheel error variance is propotional to the magnitude
%                 of the measurement, i.e.:
%                 variance( theta_l ) = k_l * |Delta_theta_l|
%                 where "k_l" is the constant of proportionality and is
%                 given the variable name suffix "_variance_scaling".
odometry_theta_l_variance_scaling = (0.05)^2;
odometry_theta_r_variance_scaling = (0.05)^2;

% Specify the initial pose covariance for odometry
odometry_pose_covariance_initial      = zeros(3,3);
odometry_pose_covariance_initial(1,1) = (0.01)^2;
odometry_pose_covariance_initial(2,2) = (0.01)^2;
odometry_pose_covariance_initial(3,3) = (1*pi/180)^2;



%  ---------------------------------------------------------------------  %
%% COMPUTE THE TRAJECTORY FOR THIS INSTANCE

% Get the warehouse specification
warehouse_specification = get_warehouse_specification();

% Put the initial pose into one variable
pose_initial = [x_p_initial,y_p_initial,phi_initial];

% Put the target pose into one variable
pose_target = [x_p_target,y_p_target,phi_target];

% Call the path planning and trajectory generation function
[planned_path , trajectory_description] = path_planning_and_trajectory_generation(warehouse_specification, pose_initial, pose_target );



%  ---------------------------------------------------------------------  %
%% PLOT THE PRE-SIMULATION PATH PLANNED

% Specify the colours to be used
colour_for_path      = [0.64,0.08,0.18];
colour_for_warehouse = [0.00,0.00,0.00];

% Open a figure
h_fig = figure();
h_fig.Name = 'Planned Trajectory Plotted Pre-Simulation';

% Add an axes
h_axes = axes(h_fig);

% "Hold on" the axes for plotting multiple graphics
hold(h_axes,'on');

% Plot the warehouse specification
h_line_warehouse = plot(warehouse_specification(:,1),warehouse_specification(:,2));
h_line_warehouse.LineStyle = '-';
h_line_warehouse.LineWidth = 2.0;
h_line_warehouse.Color     = colour_for_warehouse;

% Plot the planned path
h_line_path = plot(planned_path(:,1),planned_path(:,2));
h_line_path.LineStyle = '-';
h_line_path.LineWidth = 1.5;
h_line_path.Color     = colour_for_path;

% Add a legend
legend_handles = [h_line_path,h_line_warehouse];
legend_strings = ["planned path","warehouse walls"];
h_legend = legend(h_axes,legend_handles,legend_strings);
h_legend.Location = 'southoutside';
h_legend.FontSize = 14;
    
% Set the font size of the axis ticks
h_axes.FontSize = 14;

% Turn on the grid
grid(h_axes,'on');

% Make the axes equal in scaling
axis(h_axes,'equal');
