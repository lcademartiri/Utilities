function COLORMAPS=loadColormaps()
    
    COLORMAPS.inferno = csvread('inferno_colormap.csv');
    COLORMAPS.blackbody = csvread('blackbody_colormap.csv');
    COLORMAPS.bentcoolwarm = csvread('bentcoolwarm_colormap.csv');
    COLORMAPS.kindlmann = csvread('kindlmann_colormap.csv');
    COLORMAPS.moreland = csvread('moreland_colormap.csv');
    COLORMAPS.plasma = csvread('plasma_colormap.csv');
    COLORMAPS.turbo = csvread('turbo_colormap.csv');
    COLORMAPS.viridis = csvread('viridis_colormap.csv');
    
end