function [planned_path, trajectory_description] = ...
    path_planning_and_trajectory_generation(...
        warehouse_specification ,...
        pose_initial ,...
        pose_target ...
    )
OBSTACLE = inf;
%  ---------------------------------------------------------------------  %
%% DESCRIPTION: THIS FUNCTION SHOULD IMPLEMENT PATH PLANNING AND TRAJECTORY
%% GENREATION
%
%  INPUT ARGUMENTS:
%  warehouse_specification
%                  See the function "get_warehouse_specification()" for
%                  details of how this is defined
%
%  pose_initial    The starting location and heading angle of the robot:
%                  pose_initial(1) = x_p coordinate, in meters
%                  pose_initial(2) = y_p coordinate, in meters
%                  pose_initial(3) = heading angle, in radians
%
%  pose_target     The target location and heading angle of the robot:
%                  pose_target(1) = x_p coordinate, in meters
%                  pose_target(2) = y_p coordinate, in meters
%                  pose_target(3) = heading angle, in radians
%
%  RETURN VARIABLES:
%  planned_path    The path that was planned, format is described below.
%
%  trajectory_description
%                  A description of the trajectory, format is described
%                  below.
%
%  ---------------------------------------------------------------------  %



%  ---------------------------------------------------------------------  %
%% EXTRACT THE COMPONENTS OF "pose_initial" and "pose_target"

x_p_initial  = pose_initial(1);
y_p_initial  = pose_initial(2);
phi_initial  = pose_initial(3);

x_p_target  = pose_target(1);
y_p_target  = pose_target(2);
phi_target  = pose_target(3);


%  ---------------------------------------------------------------------  %
%% REPLACE THE CODE BELOW WITH THE YOUR ALGORITHM FOR PATH PLANNING

% Similar to the warehouse specification, the planned path is:
% > Specified by an ordered set of (x,y) coordinates that are joined by
%   straight line.
% > These coordinate are put into a matrix of size Nx2, where N is the
%   number of coordinates.
% > A straight line is draw between each subsequent pair of points to
%   specify the path.

% Define a basic two section path:
planned_path = [...
        x_p_initial , y_p_initial ;...
        1.2, 2.2; ...
        4, 4; ...
        x_p_target , y_p_initial ;...
        x_p_target  , y_p_target ;...
    ];
    
%flip x and y's because x and y corresponds to column, row (not the default
%row, column)
planned_path = flip(planned_path, 2);
%Not real %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Real calculations begin here
% Note: the '_visualised' prefix means that if you print it, it will look
% correct, with the bottom left of the gridmap representing (1, 1)
% Note: if start/end loc is surrounded by obstacles, we're in trouble
% Note: you can't have en endpoint on the right edge of the plane bcs
% floor(index)+1 be one index too big



% Define how you want to grid up the space
%%% change these
max_grid_size = 5;
n_grid_points = 15;
% the following points are in normal (x, y) coords. (+ve is right and up
% respectively)
starting_point = [2, 4];
target_point = [2, 0.6];

%%%%%%%%%%%%%%%%%%%% don't change these. They convert (x, y) to matrix
%%%%%%%%%%%%%%%%%%%% index coords
MAX_X = max_grid_size;
MAX_Y = max_grid_size;
%fix the starting points so that they plot correctly 
% starting_point = [starting_point(1), MAX_Y-starting_point(2)]
% target_point = [target_point(1), MAX_Y-target_point(2)]
% starting_point = flip(starting_point, 2);
% target_point = flip(target_point, 2);
%---------------------------- uncomment the above if you want to visualise
%                             the start/target points in the array

starting_point = from_xy_to_gridindex(starting_point, max_grid_size, n_grid_points);
target_point = from_xy_to_gridindex(target_point, max_grid_size, n_grid_points);
%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Create gridmap where lines (objects) are 1's and everything else is a 0
full_grid_map_visualised = double(find_grid_map(0.5, max_grid_size, n_grid_points, warehouse_specification));
%redefine 1's as OBSTACLE's (inf value)
full_grid_map_visualised(full_grid_map_visualised==1) = OBSTACLE;
% full_grid_map_visualised(target_point(1), target_point(2)) = 6

% Run A* algo on this gridmap
% full_grid_map_visualised;
% starting_point;
% target_point;
a_star_points = a_star(full_grid_map_visualised, starting_point, target_point);
if length(a_star_points) == 0
    disp('No Path Found')
end

% drop points along the same line
a_star_points = drop_colinear_points(a_star_points);

% Generate x, y coords
planned_path = from_gridindex_to_xy(a_star_points, max_grid_size, n_grid_points);



%  ---------------------------------------------------------------------  %
%% REPLACE THE CODE BELOW WITH THE YOUR ALGORITHM FOR TRAJECTORY GENERATION

% IMPORTANT NOTE:
% The "trajectory_description" variable is passed to the Simulink model,
% and hence is can only be a matrix.
% Do NOT use a cell array, or struct array, or anything more "exoctic" for
% you trajectory description.
% It is advisable to use a matrix description where:
% > Each row of the matrix is a segment of the trajectory.
% > Each column respresents properties of the segment.

trajectory_description = 0;

end

