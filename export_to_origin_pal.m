function export_to_origin_pal(cmap, filename)
    addpath('colormaps')
    % EXPORT_TO_ORIGIN_PAL Converts a generic Nx3 colormap to a JASC .PAL file
    % Usage: export_to_origin_pal(my_colormap, 'my_palette.pal')
    
    % 1. Check constraints: Origin often expects 256 colors.
    % If your map is not 256, you might want to interpolate it, 
    % but this script will write whatever size you give it.
    n_colors = size(cmap, 1);

    % 2. Convert from 0-1 (Matlab standard) to 0-255 (PAL standard)
    % We check if the max value is <= 1 to assume it needs scaling.
    if max(cmap(:)) <= 1
        cmap = round(cmap * 255);
    else
        cmap = round(cmap);
    end
    
    % 3. Write the JASC-PAL formatted file
    fid = fopen(filename, 'w');
    
    if fid == -1
        error('Could not open file for writing.');
    end
    
    % Header required for JASC-PAL format
    fprintf(fid, 'JASC-PAL\r\n'); 
    fprintf(fid, '0100\r\n'); 
    fprintf(fid, '%d\r\n', n_colors); 
    
    % Write RGB triplets (Transpose cmap because fprintf reads column-wise)
    fprintf(fid, '%d %d %d\r\n', cmap'); 
    
    fclose(fid);
    
    fprintf('Successfully created %s with %d colors.\n', filename, n_colors);
end