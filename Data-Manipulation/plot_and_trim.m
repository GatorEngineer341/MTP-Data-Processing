function [x_trimmed, y_trimmed] = plot_and_trim(x, y)
%The plot_and_trim function takes in two arrays representing x and y data, plots the data, and allows the user to select two points on the plot to trim the data. The function then trims the data between the selected points and plots the trimmed data. The function returns the trimmed x and y data.
%   Detailed explanation goes here

    % Plot the data
    figure;
    plot(x, y);
    xlabel('Distance [mm]')
    ylabel('Height [\mum]')
    title('Select two points to trim the data');

    % Enable zoom
    zoom on;
    % Wait for the user to finish zooming
    waitfor(gcf, 'CurrentCharacter', char(13))
    zoom off;

    % Prompt the user to select two points on the plot
    [x_trim_points, ~] = ginput(2);

    % Trim the data between the selected points
    x_trim_points = sort(x_trim_points); % Ensure points are in ascending order
    trim_indices = find(x >= x_trim_points(1) & x <= x_trim_points(2));
    x_trimmed = x(trim_indices);
    y_trimmed = y(trim_indices);

    % Plot the trimmed data
    figure;
    plot(x_trimmed, y_trimmed);
    xlabel('Distance [mm]')
    ylabel('Height [\mum]')
    title('Trimmed data');
end