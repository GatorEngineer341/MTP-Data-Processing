function [] = plot_fft_wavelength(x,y,plot_title,x_limits,y_limits,color)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


figure('Name',plot_title,'NumberTitle','on');
plot(x, y, color) 
xlabel('Wavelength [mm]');
ylabel('Amplitude [\mum]');
xlim(x_limits)
ylim(y_limits)
title(plot_title)

end