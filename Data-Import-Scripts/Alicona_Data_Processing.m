%% Header
% Ryan Garcia 
% rgarci15@vols.utk.edu
% 24-Feb-2022
% Alicona_Data_Processing

clc 
clear 
close all 

filepath = 'C:\Users\ryana\Dropbox\UTK\Research\MTP Research\Alicona Measurements\ST-15 Testing\Plane Removed\'; %Folder where surface profiles are saved 
filename = '0.002 IPR 300 SFM 45 DEG VNMG'; %Name of surface profile files in .csv format

% cd (filepath) %Changes to folder where the data set is stored

%% Importing Measured Surface Profile 

[x_height,z_distance] = Alicona_surf_import(filename,filepath);


%% Coordinate Rotation 

% [z_distance_rot, x_height_rot] = surface_rot(z_distance_offset_1,x_height_offset_1,0); 

%% Filtering Surface Data

% fs = 1/(z_distance(2)-z_distance(1)); 
% w_highpass = 10; 
% x_height_highpass = highpass(x_height,w_highpass,fs);
% 
% x_height_waviness = x_height-x_height_highpass; 
% 
% w_lowpass = 0.1;
% x_height_lowpass = lowpass(x_height,w_lowpass,fs,Steepness=0.999);

lambdac = 0.15; % cutoff in mm
dx = z_distance(2)-z_distance(1); % spacing in mm
[x,w4] = npspline(x_height, dx, lambdac); % generate spline waviness profile

x_surface_rough = x_height-w4;

alpha = 1/(2*sin(pi*dx/lambdac));
lambda = (0.002:dx:8)'; % generate wavelength axis for transmission plot
T = 1./(1+16*alpha^4*sin(pi*dx./lambda).^4); % sample the spline transmission equation
figure
semilogx(lambda,T*100);
xlabel('Wavelength (mm)');
ylabel('Amplitude (%)');
hold on


%% Plotting the Surface Profile 

figure
tiledlayout(3,1)
ax1 = nexttile;
plot(z_distance, x_height,'b'); 
title('Profile')
ax2 = nexttile;
plot(z_distance, w4,'k');
% plot(z_distance, x_height_waviness,'k');
title('Waviness')
ax3 = nexttile;
plot(z_distance, x_surface_rough,'r');
% plot(z_distance, x_height_highpass,'r');
title('Roughness')
xlabel('Distance [mm]'); 
ylabel('Height [\mum]'); 
linkaxes([ax1 ax2 ax3],'xy')


figure
% plot(z_distance_offset_1, detrend(x_height_offset_1),'b'); 
plot(z_distance, x_surface_rough,'r'); 
hold on 
% plot(z_distance_offset_1, x_height_fitted,'k');
% plot(z_distance, x_height_highpass,'r');
% plot(z_distance, x_height_lowpass,'k');
% plot(xnew,ynew, 'r')
% plot(curve_fit_x, curve_fit_y); 
hold on
% plot(xnew, ynew_detrend)
hold off
xlabel('Distance [mm]'); 
ylabel('Height [\mum]'); 
% legend('Raw data', 'Linear fit')
% legend('Raw data', 'Linear fit', 'Detrended data')

% figure
% plot(z_distance, x_height_lowpass,'k');
%% Calculating FFT of Surface profile 

[wavelength_uf,amplitude_uf] = surface_fft(z_distance,x_height);
plot_fft_wavelength(wavelength_uf,amplitude_uf,'Profile', [0 1.5], [0 0.35],'b')
% plot(wavelength_uf,amplitude_uf); % plot half of the % FFT array
% xlabel('Wavelength (mm)');
% ylabel('Amplitude (\mum)');
% [f_uf,P1_uf] = execute_fft(z_distance,x_height); 

% plot_fft_surface(f_uf,P1_uf,'Unfiltered Surface FFT',[0 100])

%% Calculating FFT of Filtered Surface Roughness 

[wavelength_f,amplitude_f] = surface_fft(z_distance,x_surface_rough);
plot_fft_wavelength(wavelength_f,amplitude_f,'Roughness', [0 1.5], [0 0.35],'r')

% 
% [wavelength_f,amplitude_f] = surface_fft(z_distance,x_surface_rough);
% figure
% plot(wavelength_f,amplitude_f); % plot half of the % FFT array
% xlabel('Wavelength (mm)');
% ylabel('Amplitude (\mum)');
% 
% [f_hf,P1_hf] = execute_fft(z_distance,x_height_highpass); 
% 
% plot_fft_surface(f_hf,P1_hf,'Filtered Surface FFT Highpass',[0 100])


%% Saving the surface profile data 

%%% Uncomment the line below to save the surface profile to the desired
%%% folder for use later in comparing the recorded data set with the
%%% simulation surface

save_surface(z_distance,x_surface_rough,filename,filepath)

%% Calculating FFT of Filtered Surface Lowpass filter
% 
% [f_lf,P1_lf] = execute_fft(z_distance,x_height_lowpass); 
% 
% plot_fft_surface(f_lf,P1_lf,'Filtered Surface FFT Lowpass',[0 100])

% cd(current_folder)



