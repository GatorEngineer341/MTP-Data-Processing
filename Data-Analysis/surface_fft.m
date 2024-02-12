function [wavelength,amplitude] = surface_fft(x,y)
%Calculates the fft of a surface measurement for analysis
%   Detailed explanation goes here


dx=x(2)-x(1);                               % spacing
n=length(x);
zf=fft(y);                              % perform FFT
j=(2:1:floor(n/2)+1)'; % generate the wavelength array
lambda=n*dx./(j-1);                     % generate the wavelength array

wavelength = lambda; 
amplitude = abs(zf(2:floor(n/2)+1,1))/(n/2); 

% plot(lambda,abs(zf(2:floor(n/2)+1,1))); % plot half of the % FFT array
% xlabel('Wavelength (mm)');
% ylabel('Scaled amplitude (\mum)');
% 
 
end