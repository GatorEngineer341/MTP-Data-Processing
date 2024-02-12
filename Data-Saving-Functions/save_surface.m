function [] = save_surface(x,y,savename,filepath)
%save_surface saves the corresponding x and y vectors of surface profile to
%a .mat file for later use.

current_folder = cd; 

cd(filepath)

savename = strcat(savename,'.mat');

parsed_data = [x y]; 
save(savename,'parsed_data'); %Creates the new file 

cd(current_folder)

end