function [] = save_surface(x,y,savename)
%save_surface saves the corresponding x and y vectors of surface profile to
%a .mat file for later use.

parsed_data = [x y]; 
save(savename,'parsed_data'); %Creates the new file 

end