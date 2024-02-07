%% Header
% Ryan Garcia 
% rgarci15@vols.utk.edu
% 24-Feb-2022
% Alicona_Data_Processing

clc 
clear 
close all 


%% Importing Measured Surface Profile 


filepath = 'C:\Users\ryana\Dropbox\UTK\Research\MTP Research\Alicona Measurements\ST-15 Testing\Plane Removed\'; 
filename = '0.002 IPR 300 SFM 45 DEG VNMG'; 

[x_height,z_distance] = Alicona_surf_import(filename,filepath);

%% Saving the surface profile data 
% parsed_data = [xnew ynew_detrend]; 
% savename = 'Taper_45_Deg_300_sfm_002_ipr_20x_1.mat'; %full name of new data file created
% save(savename,'parsed_data'); %Creates the new file 


%% Coordinate Rotation 

% [z_distance_rot, x_height_rot] = surface_rot(z_distance_offset_1,x_height_offset_1,0); 

%% Filtering Surface Data

fs = 1/(z_distance(2)-z_distance(1)); 
x_height_highpass = highpass(x_height,15,fs);
x_height_lowpass = lowpass(x_height,0.01,fs);


%% Plotting the Surface Profile 
% plot(z_distance_offset_1, detrend(x_height_offset_1),'b'); 
plot(z_distance, x_height_offset_detrend,'b'); 
hold on 
% plot(z_distance_offset_1, x_height_fitted,'k');
plot(z_distance, x_height_highpass,'r');
% plot(z_distance_offset_1, x_height_lowpass,'g');
% plot(xnew,ynew, 'r')
% plot(curve_fit_x, curve_fit_y); 
hold on
% plot(xnew, ynew_detrend)
hold off
xlabel('Distance [mm]'); 
ylabel('Height [\mum]'); 
% legend('Raw data', 'Linear fit')
% legend('Raw data', 'Linear fit', 'Detrended data')


%% Calculating FFT of Surface profile 

[f_uf,P1_uf] = execute_fft(z_distance,x_height); 

plot_fft_surface(f_uf,P1_uf,'Unfiltered Surface FFT',[0 100])

%% Calculating FFT of Filtered Surface 

[f_f,P1_f] = execute_fft(z_distance,x_height_highpass); 

plot_fft_surface(f_f,P1_f,'Filtered Surface FFT',[0 100])




