function grid_indicies = from_xy_to_gridindex(point, max_grid_size, n_grid_points)


del_dist = max_grid_size/n_grid_points;
grid_indicies = floor(point/del_dist) + 1;


end

