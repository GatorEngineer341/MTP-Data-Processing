function [xnew,ynew] = surface_rot(z_distance,x_height,angle)
%surface_rot Preforms coordinate rotation of surface data to rotate angle
%back to zero
%   Detailed explanation goes here

xnew = 0*z_distance; %Creating empty vector with zeroes the length of the original 
ynew = 0*x_height; %Creating empty vector with zeroes the length of the original

theta = angle*pi/180;     % rotation angle, rad
R = [cos(theta) -sin(theta); sin(theta) cos(theta)]; % rotation matrix

%%% For loop performs the coordinate rotation for each data point
    for cnt = 1:length(z_distance)
        original_data = [z_distance(cnt); x_height(cnt)];
        new_data = R*original_data;
        xnew(cnt) = new_data(1);
        ynew(cnt) = new_data(2);
    end

end