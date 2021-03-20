function plot_trajectory_at_simulation_stop(out,should_plot_odometry_covariance,should_plot_heading_arrows,quiver_length)
%% THIS FUNCTIONT IS THE STOP FUNCTION FOR THE SIMULINK MODEL
%% "trajectory_tracking_simulation_on_kinematic_model.slx"
%
%  That this script is the stop function is specified in the
%  "Model Properties" of the Simulink model in the "Callbacks" tab.
%
%  The stop function, hence this function, is called when the a run of the
%  Simulink simulation finishes.
%
%
%  ---------------------------------------------------------------------  %
%% PLOTTING:

    % Check for the "should_plot_odometry_covariance" input argument
    if (nargin < 2)
        should_plot_odometry_covariance = false;
    elseif (isempty(should_plot_odometry_covariance))
        should_plot_odometry_covariance = false;
    elseif not(islogical(should_plot_odometry_covariance))
        should_plot_odometry_covariance = false;
    end

    % Check for the "should_plot_heading_arrows" input argument
    if (nargin < 3)
        should_plot_heading_arrows = false;
    elseif (isempty(should_plot_heading_arrows))
        should_plot_heading_arrows = false;
    elseif not(islogical(should_plot_heading_arrows))
        should_plot_heading_arrows = false;
    end

    % Check for the "quiver_length" input argument
    if (nargin < 4)
        should_plot_heading_arrows = false;
    elseif (isempty(should_plot_heading_arrows))
        should_plot_heading_arrows = false;
    elseif not(islogical(should_plot_heading_arrows))
        should_plot_heading_arrows = false;
    end
    
    % Specify the colours to be used
    colour_for_pose      = [0.00,0.45,0.74];
    colour_for_pose_ref  = [0.64,0.08,0.18];
    colour_for_odometry  = [0.50,0.50,0.50];
    colour_for_warehouse = [0.00,0.00,0.00];

    % Open a figure
    h_fig = figure();
    h_fig.Name = 'Robot Trajectory Plotted Post-Simulation';
    
    % Add an axes
    h_axes = axes(h_fig);
    
    % "Hold on" the axes for plotting multiple graphics
    hold(h_axes,'on');


    % Get the warehouse specification and plot it
    warehouse_specification = get_warehouse_specification();
    h_line_warehouse = plot(warehouse_specification(:,1),warehouse_specification(:,2));
    h_line_warehouse.LineStyle = '-';
    h_line_warehouse.LineWidth = 2.0;
    h_line_warehouse.Color     = colour_for_warehouse;
    
    % Plot a line for the actual (x_p,y_p) trajectory
    h_line_pose = plot(out.pose.Data(:,1),out.pose.Data(:,2));
    h_line_pose.LineStyle = '-';
    h_line_pose.LineWidth = 1.5;
    h_line_pose.Color     = colour_for_pose;
    
    % Plot the heading arrows for the actual trajectory
    if (should_plot_heading_arrows)
        h_quiver_pose = quiver(out.pose.Data(:,1),out.pose.Data(:,2),quiver_length*cos(out.pose.Data(:,3)),quiver_length*sin(out.pose.Data(:,3)));
        h_quiver_pose.AutoScale = 'off';
        h_quiver_pose.LineStyle = '-';
        h_quiver_pose.LineWidth = 0.5;
        h_quiver_pose.Color = colour_for_pose;
    end


    
    % Plot a line for the reference (x_p,y_p) trajectory
    h_line_pose_ref = plot(out.pose_ref.Data(:,1),out.pose_ref.Data(:,2));
    h_line_pose_ref.LineStyle = '-';
    h_line_pose_ref.LineWidth = 1.5;
    h_line_pose_ref.Color     = colour_for_pose_ref;

    % Plot the heading arrows for the reference trajectory
    if (should_plot_heading_arrows)
        h_quiver_pose_ref = quiver(out.pose_ref.Data(:,1),out.pose_ref.Data(:,2),quiver_length*cos(out.pose_ref.Data(:,3)),quiver_length*sin(out.pose_ref.Data(:,3)));
        h_quiver_pose_ref.AutoScale = 'off';
        h_quiver_pose_ref.LineStyle = '-';
        h_quiver_pose_ref.LineWidth = 0.5;
        h_quiver_pose_ref.Color = colour_for_pose_ref;
    end

    
    
    % Plot a line for the odometry estimate of the (x_p,y_p) trajectory
    h_line_pose_odometry = plot(out.odometry_pose.Data(:,1),out.odometry_pose.Data(:,2));
    h_line_pose_odometry.LineStyle = '-';
    h_line_pose_odometry.LineWidth = 1.5;
    h_line_pose_odometry.Color     = colour_for_odometry;
    
    % Plot the heading arrows for the odometry estimate
    if (should_plot_heading_arrows)
        h_quiver_pose_odometry = quiver(out.odometry_pose.Data(:,1),out.odometry_pose.Data(:,2),quiver_length*cos(out.odometry_pose.Data(:,3)),quiver_length*sin(out.odometry_pose.Data(:,3)));
        h_quiver_pose_odometry.AutoScale = 'off';
        h_quiver_pose_odometry.LineStyle = '-';
        h_quiver_pose_odometry.LineWidth = 0.5;
        h_quiver_pose_odometry.Color = colour_for_odometry;
    end
    
    % Plot the odometry coveriance
    if (should_plot_odometry_covariance)
        % Get the time stamps of the data
        odo_cov_time = out.odometry_pose_covariance.Time;
        % Iterate through and plot one covariance ellipse per second
        next_time_to_plot = 1;
        for i_time = 1:length(odo_cov_time)
            % Get the time for this iteration
            this_time = odo_cov_time(i_time);
            % Check if it is time to plot
            if (this_time >= next_time_to_plot)
                % Get the covariance matrix to plot
                this_cov =  out.odometry_pose_covariance.Data(1:2,1:2,i_time);
                % Get the (x_p,y_p) location at this time
                this_x_p = out.odometry_pose.Data(i_time,1);
                this_y_p = out.odometry_pose.Data(i_time,2);
                % Compute the eigenvale decomposition of the matrix
                [eig_vecs,eig_vals] = eig(this_cov);
                % Extract the eigen vector and values into separate
                % variables
                eig_vec1 = eig_vecs(:,1);
                eig_vec2 = eig_vecs(:,2);
                eig_val1 = eig_vals(1,1);
                eig_val2 = eig_vals(2,2);
                % Only proceed if the eigen values are positive
                if ((eig_val1>0) && (eig_val2>0))
                    % Compute coordinate of the ellipse
                    a = sqrt(eig_val1);
                    b = sqrt(eig_val2);
                    t = linspace(0,2*pi,20);
                    X = a*cos(t);
                    Y = b*sin(t);
                    w = atan2(eig_vec2(2)-eig_vec1(2),eig_vec2(1)-eig_vec1(1));
                    x = this_x_p + X*cos(w) - Y*sin(w);
                    y = this_y_p + X*sin(w) + Y*cos(w);
                    % Plot the ellipse
                    h_odo_cov_line = plot(x,y);
                    h_odo_cov_line.LineStyle = '-';
                    h_odo_cov_line.LineWidth = 0.5;
                    h_odo_cov_line.Color     = colour_for_odometry;
                end
                % Increment to the next time to plot
                next_time_to_plot = next_time_to_plot + 1;
            end
        end
    end
    
    % Add a legend
    legend_handles = [h_line_pose,h_line_pose_ref,h_line_pose_odometry,h_line_warehouse];
    legend_strings = ["actual pose","reference pose","odometry pose","warehouse walls"];
    h_legend = legend(h_axes,legend_handles,legend_strings);
    h_legend.Location = 'southoutside';
    h_legend.FontSize = 14;
    
    % Set the font size of the axis ticks
    h_axes.FontSize = 14;
    
    % Turn on the grid
    grid(h_axes,'on');

    % Make the axes equal in scaling
    axis(h_axes,'equal');

end