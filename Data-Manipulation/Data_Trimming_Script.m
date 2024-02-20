%% Header
% Ryan Garcia 
% rgarci15@vols.utk.edu
% 19-Feb-2024
% Data_Trimming_Script

clc; 
clear; 
close all;

% Load the .mat file
fileName = uigetfile('*.mat');
data = load(fileName);
x = data.parsed_data(:,1);
y = data.parsed_data(:,2);

[~, fileName, ~] = fileparts(fileName);

% Initial trim
[x_trimmed, y_trimmed] = plot_and_trim(x, y);

% Prompt the user to either save the trimmed data, view it, or retry the process
while true
    choice = questdlg('What would you like to do with the trimmed data?', ...
        'Choose an option', ...
        'Save', 'View', 'Retry', 'Save');

    switch choice
        case 'Save'
            % Save the trimmed data
            save('trimmed_data.mat', 'x_trimmed', 'y_trimmed');
            break;
        case 'View'
            % Display the trimmed data
            disp('Trimmed x data:');
            disp(x_trimmed);
            disp('Trimmed y data:');
            disp(y_trimmed);
            
            % Wait for the user to press Enter
            disp('Press Enter to continue...');
            waitfor(gcf, 'CurrentCharacter', char(13))
            
            % Ask the user if they want to save the data after viewing it
            save_choice = questdlg('Would you like to save the trimmed data?', ...
                'Save Data', ...
                'Yes', 'No', 'Yes');
            
            if strcmp(save_choice, 'Yes')
                % Save the trimmed data
                save('trimmed_data.mat', 'x_trimmed', 'y_trimmed');
            end
            
            break;
        case 'Retry'
            % Retry the process with the original data
            [x_trimmed, y_trimmed] = plot_and_trim(x, y);
    end
end
