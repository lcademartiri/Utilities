% pushall.m - Automates Git backup for multiple folders
% Define your repository paths here
repos = { ...
    'C:\Codebase\Utilities', ...
    'C:\Codebase\ARBD\ARBD_toolbox' ...
	'C:\Codebase\ARBD\SBCvsPBC' ...
	'C:\Codebase\ARBD\SBC_equipartition' ...
};

commitMessage = input('Enter commit message: ', 's');

for i = 1:length(repos)
    fprintf('\n--- Syncing: %s ---\n', repos{i});
    
    % Change directory to the repo
    cd(repos{i});
    
    % Execute Git commands
    system('git add .');
    system(['git commit -m "', commitMessage, '"']);
    system('git push');
end

fprintf('\n✅ All repositories synced!\n');