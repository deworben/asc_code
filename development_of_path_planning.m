%  ---------------------------------------------------------------------  %
%% DEVELOPMENT OF PATH PLANNING
%
%  That this script is intended as a place for developing, testing, and
%  verifying the performance of your path planning and trajectory
%  generation algorithm.
%
%
%  ---------------------------------------------------------------------  %
%% HOW TO UNDERSTAND THIS SCRIPT
%
%  This script was written with the intention that comments and variable
%  names are sufficiently descriptive to document how to get started.
%
%
%  ---------------------------------------------------------------------  %
%% YOU MUST EDIT THE "get_warehouse_specification.m" SCRIPT
%
%  See the comments in that script for details about how the warehouse is
%  specified.
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


%  ---------------------------------------------------------------------  %
%% CLEAR AND CLOSE EVERYTHING
% > Clear all variables:
clear;
% > Close all open figures
close all;
% > Clear any text from the Command Window
clc;



%  ---------------------------------------------------------------------  %
%% REPLACE THE CODE BELOW WITH THE YOUR DEVELOPMENTS FOR PATH PLANNING
%% AND TRAJECTORY GENERATION

% SPECIFY THE STARTING AND TARGET LOCATION

% Specify the inital location and heading
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



% COMPUTE THE TRAJECTORY FOR THIS INSTANCE

% Get the warehouse specification
warehouse_specification = get_warehouse_specification();

% Put the initial pose into one variable
pose_initial = [x_p_initial,y_p_initial,phi_initial];

% Put the target pose into one variable
pose_target = [x_p_target,y_p_target,phi_target];

% Call the path planning and trajectory generation function
[planned_path , trajectory_description] = path_planning_and_trajectory_generation(warehouse_specification, pose_initial, pose_target );



% PLOT THE PATH PLANNED

% Specify the colours to be used
colour_for_path      = [0.64,0.08,0.18];
colour_for_warehouse = [0.00,0.00,0.00];

% Open a figure
h_fig = figure();
h_fig.Name = 'Development and testing for path planning';

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



