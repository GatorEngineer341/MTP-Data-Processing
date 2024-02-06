function [x_height,z_distance] = Alicona_surf_import(filename,filepath)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

filetype = '.csv';

new_data = importdata(strcat(filepath,filename,filetype));
 
% new_data_1 = importdata("C:\Users\ryana\Dropbox\UTK\Research\MTP Research\Alicona Measurements\ST-15 Testing\0.001 IPR 300 SFM 45 DEG CNMG.csv");

x_height = new_data.data(:,2); %Saves the first column of the data to the variable 
z_distance = new_data.data(:,1); %Saves the second column of the data to the variable

x_height = x_height*1e6; %Scaling to proper units [um]
z_distance = z_distance*1e3; %Scaling to proper units [mm]

end