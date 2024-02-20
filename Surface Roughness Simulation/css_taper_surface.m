function [Ra_sim] = css_taper_surface(nr_fit)
%Constant surface speed simulation written as a function
%   Need to include nr_fit [in], theta [deg], fr [in/rev]

f_r = 0.002;

% Define turning parameters
fr = (f_r*25.4)*1e-3;            % feed per revolution in path direction, m/rev
theta = 45;             % taper angle, deg
theta = theta*pi/180;   % taper angle, rad
frz = fr*cos(theta);    % feed per revolution in z direction, m/rev
frx = fr*sin(theta);    % feed per revolution in x direction, m/rev

omega0 = 587.649;          % spindle speed at starting radius, rpm
r0 = 24.7650e-3;             % starting radius, m
V = omega0*r0*2*pi/60;  % cutting speed, m/s

% Perform simulation in equal rotation steps, dphi
dphi = 0.1;                     % angular step size, deg/step
dphi = dphi*(2*pi)/360;         % angular step size, rad/step
num_rev = 50;                   % number of revolutions, -
steps_rev = round((2*pi)/dphi); % steps per revolution, -
steps = num_rev*steps_rev;      % number of steps, -

dz = frz/steps_rev;         % z motion per step, m/step
z = (0:steps)*dz;           % z motion, m
dx = frx/steps_rev;         % x motion per step, m/step
x = (0:steps)*dx;           % x motion, m

r = r0 - z*tan(theta);      % part radius, m
ss = V./r*60/(2*pi);        % spindle speed, rpm

fx = frx*ss/60;             % x direction feed rate, m/s
fz = frz*ss/60;             % z direction feed rate, m/s

dt = dphi./ss*(60/(2*pi));  % time step, s/step
t = (0:steps).*dt;          % time vector, s

% figure(1)
% plot(z*1e3, r*1e3, 'b')
% set(gca,'FontSize', 14)
% xlabel('z (mm)')
% ylabel('r (mm)')
% grid on
% 
% figure(2)
% plot(x*1e3, r*1e3, 'b')
% set(gca,'FontSize', 14)
% xlabel('x (mm)')
% ylabel('r (mm)')
% grid on
% 
% figure(3)
% plot(r*1e3, ss, 'b')
% set(gca,'FontSize', 14)
% xlabel('r (mm)')
% ylabel('Spindle speed (rpm)')
% grid on
% 
% figure(6)
% plot(z*1e3, fz*1e3, 'b')
% set(gca,'FontSize', 14)
% xlabel('z (mm)')
% ylabel('f_z (mm/s)')
% grid on
% 
% figure(7)
% plot(x*1e3, fx*1e3, 'b')
% set(gca,'FontSize', 14)
% xlabel('x (mm)')
% ylabel('f_x (mm/s)')
% grid on
% 
% plot(t, ss, 'b')
% set(gca,'FontSize', 14)
% xlabel('t (s)')
% ylabel('Spindle speed (rpm)')
% xlim([0 max(t)])
% grid on
% 
% figure(9)
% plot(t, r*1e3, 'b')
% set(gca,'FontSize', 14)
% xlabel('t (s)')
% ylabel('r (mm)')
% xlim([0 max(t)])
% grid on
% 
% figure(10)
% plot(t, z*1e3, 'b')
% set(gca,'FontSize', 14)
% xlabel('t (s)')
% ylabel('z (mm)')
% xlim([0 max(t)])
% grid on
% 
% figure(11)
% plot(t, x*1e3, 'b')
% set(gca,'FontSize', 14)
% xlabel('t (s)')
% ylabel('x (mm)')
% xlim([0 max(t)])
% grid on
% 
% cs = r.*ss*2*pi/60;     % cutting speed, m/s
% 
% figure(12)
% plot(t, cs, 'b')
% set(gca,'FontSize', 14)
% xlabel('t (s)')
% ylabel('V (m/s)')
% xlim([0 max(t)])
% grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define MTP parameters
OPR = 0;    % oscillations per revolution, 1/rev
RAF = 0;    % ratio of oscillation amplitude to feed

alpha = 0;              % phase lag, deg
alpha = alpha*pi/180;   % phase lag, rad
zmtp = RAF*frz*sin(ss/60*2*pi*OPR.*t);          % z direction MTP motion, m
xmtp = RAF*frx*sin(ss/60*2*pi*OPR.*t + alpha);  % x direction MTP motion, m

figure(13)
plot(t, zmtp*1e3, 'r', t, xmtp*1e3, 'b--')
set(gca,'FontSize', 14)
xlabel('t (s)')
ylabel('z/x_{mtp} (mm)')
xlim([0 max(t)])
legend('z_{mtp}', 'x_{mtp}')
grid on
zoom on

figure(14)
plot(zmtp*1e3, xmtp*1e3, 'b')
set(gca,'FontSize', 14)
xlabel('z_{mtp} (mm)')
ylabel('x_{mtp} (mm)')
grid on
zoom on

% pmtp = (xmtp.^2 + zmtp.^2).^0.5;
% 
% figure(15)
% plot(t, pmtp*1e3, 'b')
% set(gca,'FontSize', 14)
% xlabel('t (s)')
% ylabel('p (mm)')
% xlim([0 max(t)])
% grid on
% zoom on

x_total = x + xmtp; % total x motion, m
z_total = z + zmtp; % total z motion, m

% parse into individual revolutions
z_parse = z_total(1:steps_rev);
x_parse = x_total(1:steps_rev);
for cnt = 2:num_rev
    z_parse = [z_parse; z_total(((cnt-1)*steps_rev + 1):(cnt*steps_rev))];
    x_parse = [x_parse; x_total(((cnt-1)*steps_rev + 1):(cnt*steps_rev))];
end

test_point = round(steps_rev/4);
z_total_test = z_parse(:, test_point);
x_total_test = x_parse(:, test_point);

figure(16)
plot(z_total*1e3, x_total*1e3, 'b')
set(gca,'FontSize', 14)
xlabel('z (mm)')
ylabel('x (mm)')
grid on
zoom on
hold on
plot(z_total_test*1e3, x_total_test*1e3, 'bo')

% Perform coordinate rotation about the y axis
t = 0*z_total;
n = 0*x_total;
t_test = 0*z_total_test;
n_test = 0*x_total_test;

R = [cos(-theta) -sin(-theta); sin(-theta) cos(-theta)]; % rotation matrix

for cnt = 1:length(x_total)
    original_data = [z_total(cnt); x_total(cnt)];
    new_data = R*original_data;
    t(cnt) = new_data(1);
    n(cnt) = new_data(2);
end
plot(t*1e3, n*1e3, 'g')

for cnt = 1:length(x_total_test)
    original_data = [z_total_test(cnt); x_total_test(cnt)];
    new_data = R*original_data;
    t_test(cnt) = new_data(1);
    n_test(cnt) = new_data(2);
end
plot(t_test*1e3, n_test*1e3, 'go')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nr_fit = (nr_fit*25.4)*1e-3;          % fit value for tool nose radius from constant feed test, m
nr = zeros(1, num_rev);     % tool nose radius for each revolution, m
nr = nr + nr_fit;

% Calculate feed since previous revolution
fr_eff = abs(diff(t_test));
fr_eff = [fr; fr_eff];

% Use current feed to set nose radius (calibrated from constant feed tests)
% for cnt = 1:num_rev
%     if fr_eff(cnt) < 0.022e-3
%         nr(cnt) = 0.1e-3;
%     elseif fr_eff(cnt) > 0.1562e-3
%         nr(cnt) = 0.794e-3;
%     else
%         nr(cnt) = 5.1724*fr_eff(cnt) - 0.0138e-3;
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t_temp = linspace(t_test(1)-0.5*nr(1), t_test(1)+0.5*nr(1), 25e3);
n_temp = -((nr(1)^2 - (t_temp - t_test(1)).^2).^0.5) + t_test(1);

figure(17)
plot(t_temp*1e3, n_temp*1e3, 'b')
set(gca,'FontSize', 14)
xlabel('t (mm)')
ylabel('n (mm)')
hold on
zoom on
grid on

t_interp = linspace(t_test(1)-0.5*nr(1), t_test(num_rev)+0.5*nr(1), 1e5);
n_interp = interp1(t_temp, n_temp, t_interp);
n_vector = n_interp;
for cnt = 2:num_rev
    t_temp = linspace(t_test(cnt)-0.5*nr(cnt), t_test(cnt)+0.5*nr(cnt), 25e3);
    n_temp = -((nr(cnt)^2 - (t_temp - t_test(cnt)).^2).^0.5) + n_test(cnt);    
    if rem(cnt, 2) == 1
        plot(t_temp*1e3, n_temp*1e3, 'b')
    else
        plot(t_temp*1e3, n_temp*1e3, 'r')
    end
    n_interp = interp1(t_temp, n_temp, t_interp);
    n_vector = [n_vector; n_interp];
end    

n_final = min(n_vector);
[peaks, index] = findpeaks(-n_final);
n_final = n_final(index(1):index(length(index)));
t_interp = t_interp(index(1):index(length(index)));
n_final = n_final - mean(n_final);

figure(18)
plot(t_interp*1e3, n_final*1e6, 'b')
set(gca,'FontSize', 14)
xlabel('t (mm)')
ylabel('n (\mum)')
zoom on
grid on
axis([min(t_interp)*1e3 max(t_interp)*1e3 1.1*min(n_final)*1e6 1.1*max(n_final)*1e6])

x_height_sim = n_final*1e6;
sim_avg = mean(x_height_sim); 
Ra_sim = mean(abs(sim_avg-x_height_sim));

end