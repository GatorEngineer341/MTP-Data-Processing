function [] = plot_fft_surface(x,y,plot_title,x_limits)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

figure('Name',plot_title,'NumberTitle','on');
plot(x,y , 'b') 
xlabel("[1/mm]")
ylabel("[\mum]")
xlim(x_limits)
title(plot_title)

end