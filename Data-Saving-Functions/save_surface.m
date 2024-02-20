function [] = save_surface(x,y,savename,filepath)
%save_surface saves the corresponding x and y vectors of surface profile to
%a .mat file for later use.

current_folder = cd; 

cd(filepath)

savename = strcat(savename,'.mat');

data = [x y]; 
save(savename,'data'); %Creates the new file 

cd(current_folder)

end