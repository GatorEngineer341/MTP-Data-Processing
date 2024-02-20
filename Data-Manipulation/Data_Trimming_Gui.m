%% Header
% Ryan Garcia 
% rgarci15@vols.utk.edu
% 19-Feb-2024
% Data_Trimming_Gui

clc; 
clear; 
close all;


classdef DataTrimmerApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure      matlab.ui.Figure
        LoadButton    matlab.ui.control.Button
        TrimButton    matlab.ui.control.Button
        SaveButton    matlab.ui.control.Button
        UIAxes        matlab.ui.control.UIAxes
    end

    properties (Access = private)
        x             % Description
        y             % Description
        x_trimmed     % Description
        y_trimmed     % Description
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
            [fileName, filePath] = uigetfile('*.mat');
            data = load(fullfile(filePath, fileName));
            app.x = data.x;
            app.y = data.y;
            plot(app.UIAxes, app.x, app.y);
        end

        % Button pushed function: TrimButton
        function TrimButtonPushed(app, event)
            [x_trim_points, ~] = ginput(2);
            x_trim_points = sort(x_trim_points); % Ensure points are in ascending order
            trim_indices = find(app.x >= x_trim_points(1) & app.x <= x_trim_points(2));
            app.x_trimmed = app.x(trim_indices);
            app.y_trimmed = app.y(trim_indices);
            plot(app.UIAxes, app.x_trimmed, app.y_trimmed);
        end

        % Button pushed function: SaveButton
        function SaveButtonPushed(app, event)
            if ~isempty(app.x_trimmed) && ~isempty(app.y_trimmed)
                save('trimmed_data.mat', 'app.x_trimmed', 'app.y_trimmed');
            else
                uialert(app.UIFigure, 'No trimmed data to save.', 'Error');
            end
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 500 375];
            app.UIFigure.Name = 'Data Trimmer';

            % Create LoadButton
            app.LoadButton = uibutton(app.UIFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [20 20 100 22];
            app.LoadButton.Text = 'Load Data';

            % Create TrimButton
            app.TrimButton = uibutton(app.UIFigure, 'push');
            app.TrimButton.ButtonPushedFcn = createCallbackFcn(app, @TrimButtonPushed, true);
            app.TrimButton.Position = [130 20 100 22];
            app.TrimButton.Text = 'Trim Data';

            % Create SaveButton
            app.SaveButton = uibutton(app.UIFigure, 'push');
            app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed, true);
            app.SaveButton.Position = [240 20 100 22];
            app.SaveButton.Text = 'Save Data';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.Position = [50 50 400 300];
        end
    end

    methods (Access = public)

        % Construct app
        function app = DataTrimmerApp

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end