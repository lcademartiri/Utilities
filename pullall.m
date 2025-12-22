% pullall.m - Updates all repositories from GitHub
repos = { ...
    'C:\Codebase\Utilities', ...
    'C:\Codebase\ARBD\ARBD_toolbox' ...
	'C:\Codebase\ARBD\SBCvsPBC' ...
	'C:\Codebase\ARBD\SBC_equipartition' ...
};

currentFolder = pwd; % Remember where you are now

for i = 1:length(repos)
    fprintf('\n--- Pulling Latest: %s ---\n', repos{i});
    
    if isfolder(repos{i})
        cd(repos{i});
        % Using system() for better error handling in loops
        status = system('git pull');
        
        if status == 0
            fprintf('✅ %s is up to date.\n', repos{i});
        else
            fprintf('⚠️ Issue pulling %s. Check for local conflicts.\n', repos{i});
        end
    else
        fprintf('❌ Folder not found: %s\n', repos{i});
    end
end

cd(currentFolder); % Take you back to where you started
fprintf('\n🚀 Sync complete. You are ready to work!\n');