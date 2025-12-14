function COLORMAPS=loadColormaps()

    thisFunctionPath = mfilename('fullpath');
    [currentFolder, ~, ~] = fileparts(thisFunctionPath);
    colormapFolderPath = fullfile(currentFolder, 'colormaps');
    
    % Check if folder exists to avoid confusing errors later
    if ~isfolder(colormapFolderPath)
        error('The expected colormap folder does not exist at: %s', colormapFolderPath);
    end
    addpath(colormapFolderPath);
    
    COLORMAPS.blackbody = csvread([colormapFolderPath,'\blackbody_colormap.csv']);
    COLORMAPS.bentcoolwarm = csvread([colormapFolderPath,'\bentcoolwarm_colormap.csv']);
    COLORMAPS.kindlmann = csvread([colormapFolderPath,'\kindlmann_colormap.csv']);
    COLORMAPS.moreland = csvread([colormapFolderPath,'\moreland_colormap.csv']);
    COLORMAPS.turbo = csvread([colormapFolderPath,'\turbo_colormap.csv']);
    COLORMAPS.viridis = viridis();
    COLORMAPS.inferno = inferno();
    COLORMAPS.plasma = plasma();
    COLORMAPS.magma = magma();
    COLORMAPS.cividis = cividis();
    COLORMAPS.twilight = twilight();
    COLORMAPS.twilight_shifted = twilight_shifted();

    fileList = dir(fullfile(colormapFolderPath, '*.mat'));
    for k = 1:length(fileList)
        baseFileName = fileList(k).name;
        fullFileName = fullfile(colormapFolderPath, baseFileName);
        [~, nameWithoutExt, ~] = fileparts(baseFileName);
        
        % Sanitize name
        fieldName = matlab.lang.makeValidName(nameWithoutExt);
        
        % Load
        loadedData = load(fullFileName);
        varNames = fieldnames(loadedData);
        
        if ~isempty(varNames)
            COLORMAPS.(fieldName) = loadedData.(varNames{1});
        end
    end
    
end