function warehouse_specification = get_warehouse_specification()
    %  -----------------------------------------------------------------  %
    %% WAREHOUSE SPECIFICATION FUNCTION
    %
    %  > This function should only specify the warehouse.
    %  > The warehouse specification is defined with this stand-alone
    %    Matlab function so that it can be easily called from other
    %    functions.
    %  > To plot the "warehouse_specification" returned, simply use:
    %    plot(warehouse_specification(:,1),warehouse_specification(:,2));
    %
    %  -----------------------------------------------------------------  %

    % > The warehouse is specified by an ordered set of (x,y) coordinates
    %   that are joined by straight lines.
    % > These coordinate are put into a matrix of size Nx2, where N is the
    %   number of coordinates.
    % > Units of the coordinates are meters.
    % > A straight line is drawn between each subsequent pair of points to
    %   specify a wall of the warehouse.
    % > The last point is not joined back to the first point, hence you
    %   should make the last point the same as the first point if you wish
    %   to close the boundary of the warehouse.
    
    warehouse_specification = [...
            0.0 , 0.0 ;...
            2.0 , 0.0 ;...
            3.0 , 1.0 ;...
            3.0 , 2.0 ;...
            2.0 , 2.0 ;...
            2.0 , 2.5 ;...
            3.0 , 3.5 ;...
            3.0 , 4.5 ;...
            0.0 , 4.5 ;...
            0.0 , 0.0 ;...
        ];

end

