function [planned_path , trajectory_description] = ...
    path_planning_and_trajectory_generation(...
        warehouse_specification ,...
        pose_initial ,...
        pose_target ...
    )
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
        0.5 , 3 ;...
        1 , 3.5 ;...
        1  , 3 ;...
        1.5, 3.5;...
        2, 3;...
        1.5, 3.5;
    ];
    


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

trajectory_description = [0.5, 3, 1, 3.5;
                          1, 3.5, 1, 3;
                          1,3, 1.5, 3.5;
                          1.5, 3.5, 2, 3;
                          2, 3, 1.5, 3.5];

