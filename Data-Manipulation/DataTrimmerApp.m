%% Header
% Ryan Garcia 
% rgarci15@vols.utk.edu
% 19-Feb-2024
% DataTrimmerApp

classdef DataTrimmerApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure      matlab.ui.Figure
        LoadButton    matlab.ui.control.Button
        TrimButton    matlab.ui.control.Button
        SaveButton    matlab.ui.control.Button
        ClearButton   matlab.ui.control.Button  % New Clear button
        UIAxes        matlab.ui.control.UIAxes
    end

    properties (Access = private)
        x             % Description
        y             % Description
        x_trimmed     % Description
        y_trimmed     % Description
        trim_points   % Stores the x-coordinates of the trim points
        fileName    
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
            [fileName, filePath] = uigetfile('*.mat');
            data = load(fullfile(filePath, fileName));
            app.fileName = fileName;
            app.x = data.data(:,1);
            app.y = data.data(:,2);
            plot(app.UIAxes, app.x, app.y);
        end

        % Button pushed function: TrimButton
        function TrimButtonPushed(app, event)
            warning('off', 'all');  % Suppress warnings
            line = drawline('Parent', app.UIAxes, 'Color', 'red');  % Let the user draw a line on the axes
            warning('on', 'all');  % Enable warnings
            app.trim_points = sort([line.Position(1,1), line.Position(2,1)]);  % Sort the x-coordinates of the line's endpoints
            delete(line);  % Delete the line
            trim_indices = find(app.x >= app.trim_points(1) & app.x <= app.trim_points(2));
            app.x_trimmed = app.x(trim_indices);
            app.y_trimmed = app.y(trim_indices);
            plot(app.UIAxes, app.x_trimmed, app.y_trimmed);
        end

        % Button pushed function: SaveButton
        function SaveButtonPushed(app, event)
            if ~isempty(app.x_trimmed) && ~isempty(app.y_trimmed)
                    x_trimmed = app.x_trimmed;
                    y_trimmed = app.y_trimmed;
                    [~, new_filename, ~] = fileparts(app.fileName);
                    save(strcat(new_filename,' trimmed_data.mat'), 'x_trimmed', 'y_trimmed');
            else
                uialert(app.UIFigure, 'No trimmed data to save.', 'Error');
            end
        end

        % Button pushed function: ClearButton
        function ClearButtonPushed(app, event)
            app.x_trimmed = [];
            app.y_trimmed = [];
            plot(app.UIAxes, app.x, app.y);  % Reset the plot
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 600 375];
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

            % Create ClearButton
            app.ClearButton = uibutton(app.UIFigure, 'push');
            app.ClearButton.ButtonPushedFcn = createCallbackFcn(app, @ClearButtonPushed, true);
            app.ClearButton.Position = [350 20 100 22];
            app.ClearButton.Text = 'Clear Data';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.Position = [50 50 500 300];
            app.UIAxes.Interactions = [];
            app.UIAxes.PickableParts = 'visible';
            app.UIAxes.ButtonDownFcn = '';
        end
    end

    methods (Access = public)

        % Construct app
        function app = DataTrimmerApp

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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