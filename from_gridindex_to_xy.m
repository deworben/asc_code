function [xy_points] = from_gridindex_to_xy(a_star_points, max_grid_size, n_grid_points)



del_dist = max_grid_size/n_grid_points;
xy_points = (a_star_points - 1) * del_dist;




end

