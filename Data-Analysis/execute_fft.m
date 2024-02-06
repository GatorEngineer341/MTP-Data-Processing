function [f,P1] = execute_fft(x,y)
%Function executes the fft of the given data set 
% and prepares the results for plotting 

L = length(y);
Fs = 1/(x(2)-x(1));

Y = fft(y);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

end
