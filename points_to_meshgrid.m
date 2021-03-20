
function [boolean_grid] = points_to_meshgrid(line_thickness, n_grid_points, point_from, point_to)
% Choose these parameters for testing
% line_thickness = 2.6;
% n_grid_points = 10;
% point_from = [5, 5];
% point_to = [5,4];

% lines dont work backwards, so always have the 'from' point start before
% the 'to' point
if point_from(1) > point_to(1)
    temp = point_from;
    point_from = point_to;
    point_to = temp;
end

% setup meshgrid
x = 1:n_grid_points;
y = 1:n_grid_points;
[X,Y] = meshgrid(x,y);


% find equation of line in y = ax + b form through interpolation
a = (point_to(2) - point_from(2))/(point_to(1) - point_from(1));
b = point_from(2) - a*point_from(1);
% if lines are straight up/down, change to very steep line or else Inf trouble
% if a==Inf a=9999, elseif a==-Inf a=-9999, end
% if b==Inf b=9999, elseif b==-Inf b=-9999, end
% if lines are straight up/down, draw the line and call it a day
if a == Inf 
    boolean_grid = (X>=point_from(1)-(line_thickness/2)) & (X<=point_to(1)+(line_thickness/2)) & (Y>=point_from(2)) & (Y<=point_to(2));
elseif a == -Inf
    boolean_grid = (X>=point_from(1)-(line_thickness/2)) & (X<=point_to(1)+(line_thickness/2)) & (Y<=point_from(2)) & (Y>=point_to(2));
else
%linear meshgrid
RSQ = Y-a.*X;

%radial mechgrid
% RSQ = X.^2 + Y.^2;
% RSQ2 = sqrt(X.^2 + Y.^2)

%% The plot
line_equals = b;
%apply line with thickness
boolean_grid = (RSQ <= line_equals+line_thickness) & (RSQ >= line_equals-line_thickness);
%Apply x bounds to line
boolean_grid = boolean_grid & (X>=point_from(1)) & (X<=point_to(1));
end

% When you're plotting, filp it so it looks right with (1, 1) in the bottom
% left
flipped_result = flip(boolean_grid, 1);

end
