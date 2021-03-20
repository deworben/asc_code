function [new_points] = drop_colinear_points(a_star_points)


a_star_points
new_points = [];
[r, c] = size(a_star_points);

j = 2;
%first point
new_points = a_star_points(1, :);

% disp('starting main loop');
% pause(5)
for i = 2:r-1
    gradient_i_minus_one = (a_star_points(i, 2)-a_star_points(i-1, 2)) / (a_star_points(i, 1)-a_star_points(i-1, 1));
    gradient_i = (a_star_points(i+1, 2)-a_star_points(i, 2))/(a_star_points(i+1, 1)-a_star_points(i, 1));
%     pause(1)
    if gradient_i_minus_one ~= gradient_i
        new_points(j, :)= a_star_points(i, :);
        j = j+1;
    end

end

%last point
new_points(j,:) = a_star_points(r, :)


end

