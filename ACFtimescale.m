function [tau_mean, tau_CI, tau_boot] = ACFtimescale(lags, C_curves, conf_level, num_boot)
% calculate_bootstrapped_tau: Calculates the model-free integral timescale
% with a tunable, non-parametric confidence interval.
%
% INPUTS:
%   lags:       Vector of time lags (e.g., [0, 1, 2, 4, ...])
%   C_curves:   [N_voxels x Num_lags] matrix, where each row is the 
%               autocorrelation curve of an individual voxel or particle.
%   conf_level: Desired confidence level (e.g., 95 for 95% CI, 99 for 99% CI)
%   num_boot:   Number of bootstrap iterations (default = 500)

    if nargin < 4, num_boot = 500; end
    if nargin < 3, conf_level = 95; end

    num_voxels = size(C_curves, 1);
    tau_boot = zeros(num_boot, 1);
    
    rng(42); % Seed for reproducibility
    
    fprintf('Running %d Bootstrap Resamples for %d%% CI...\n', num_boot, conf_level);
    
    for b = 1:num_boot
        % 1. Resample the voxels with replacement
        boot_idx = randi(num_voxels, num_voxels, 1);
        
        % 2. Calculate the average autocorrelation for this bootstrap sample
        C_boot_mean = mean(C_curves(boot_idx, :), 1, 'omitnan');
        
        % 3. Find the first zero crossing for this specific mean curve
        zero_idx = find(C_boot_mean <= 0, 1, 'first');
        if isempty(zero_idx)
            phi_clean = C_boot_mean;
            lags_clean = lags;
        else
            phi_clean = C_boot_mean(1:zero_idx);
            lags_clean = lags(1:zero_idx);
        end
        
        % 4. Integrate to get the timescale for this bootstrap iteration
        tau_boot(b) = trapz(lags_clean, phi_clean);
    end
    
    % --- CALCULATE CONFIDENCE LIMITS ---
    % Sort the bootstrapped timescales
    sorted_tau = sort(tau_boot);
    
    % Determine percentile cutoffs based on the desired % CI
    alpha = (100 - conf_level) / 100;
    low_pct = alpha / 2;
    high_pct = 1 - (alpha / 2);
    
    low_idx = max(1, round(num_boot * low_pct));
    high_idx = min(num_boot, round(num_boot * high_pct));
    
    % Outputs
    tau_mean = mean(tau_boot);
    tau_CI = [sorted_tau(low_idx), sorted_tau(high_idx)];
    
    fprintf('Model-Free Timescale: %.2f ( %d%% CI: [ %.2f, %.2f ] )\n', ...
        tau_mean, conf_level, tau_CI(1), tau_CI(2));
end