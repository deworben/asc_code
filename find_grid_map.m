function [full_grid_map_visualised] = find_grid_map(line_thickness, max_grid_size, n_grid_points, all_points_along_path)

% convert cartesian points to grid points
% del_dist = max_grid_size/n_grid_points;

% find number of lines to draw
s = size(all_points_along_path);
num_rows = s(1);

% start with a whole grid of zeros, then keep adding lines
grid = logical(zeros(n_grid_points));

% add lines to the grid by iterating through all consecutive points
for i=1:1:num_rows-1
    % convert the consecutive points from xy space, to grid indicies
    start_points = from_xy_to_gridindex(all_points_along_path(i, :), max_grid_size, n_grid_points);
    end_points = from_xy_to_gridindex(all_points_along_path(i+1, :), max_grid_size, n_grid_points);
    
    % 'or' the line with the grid to overlay the line on top
    grid = grid | points_to_meshgrid(line_thickness, n_grid_points, start_points , end_points);
end 


full_grid_map_visualised = flip(grid, 1);


end

