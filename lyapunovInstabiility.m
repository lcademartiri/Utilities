% Gelling Instability Visualization (Front Cover Edition)
% -------------------------------------------------------------------------
% Solves the Smoluchowski equation with a multiplicative kernel (K = i*j).
% 
% Configured for COVER ART:
% - Pure White Background
% - No axes, labels, or text
% - Extended trajectory (T_max = 1.4) for a dramatic "hook" shape
% -------------------------------------------------------------------------
clearvars -except cmaplibrary; 
close all; clc;

%% 1. Parameters
N_bins = 100;            
N_traj = 500;           % Increased trajectory count for a dense, smooth "brushstroke" look
T_max  = 2;           % Extended slightly to emphasize the curve/divergence
N_steps = 400;          % Higher resolution for smooth curves
time_grid = linspace(0, T_max, N_steps);
noise_level = 4e-4; 

% Kernel: Multiplicative (K_ij = i*j)
alpha = 1.0;
[I_grid, J_grid] = meshgrid(1:N_bins, 1:N_bins);
K = (I_grid .* J_grid).^alpha; 

%% 2. Run Ensemble Simulations
Data_Ensemble = zeros(N_bins, N_steps, N_traj);
fprintf('Simulating %d trajectories...\n', N_traj);

parfor tr = 1:N_traj
    % Initial Condition: Monomers with tiny noise
    c0 = zeros(N_bins, 1);
    c0(1) = 1.0; 
    
    
    perturbation = noise_level * randn(N_bins, 1);
    c0 = abs(c0 + perturbation);
    c0 = c0 / sum(c0 .* (1:N_bins)'); 
    
    [~, C_sol] = ode23s(@(t,c) smoluchowski_rhs(t, c, K, N_bins), ...
                        time_grid, c0);
    
    Data_Ensemble(:, :, tr) = C_sol';
end

%% 3. Pre-process for PCA (Weighted by Second Moment)
X_pca = zeros(N_steps * N_traj, N_bins);
weights = ((1:N_bins).^2)'; 

for tr = 1:N_traj
    C_traj = Data_Ensemble(:, :, tr);
    Weighted_C = C_traj .* repmat(weights, 1, N_steps);
    
    start_idx = (tr-1)*N_steps + 1;
    end_idx   = tr*N_steps;
    X_pca(start_idx:end_idx, :) = Weighted_C';
end

[coeff, score, ~] = pca(X_pca);

PC1 = reshape(score(:,1), N_steps, N_traj);
PC2 = reshape(score(:,2), N_steps, N_traj);
PC3 = reshape(score(:,3), N_steps, N_traj);

%% 4. Visualization (Front Cover Style)
% Pure white figure
fig = figure('Color', 'w', 'Position', [100 100 1200 1000]);

% Create axes but hide EVERYTHING
ax = axes('Parent', fig, 'Color', 'none');
hold(ax, 'on'); 

% View Angle: Adjusted to show the "fan" shape clearly
view(ax, 50, 25); 

% Colormap: 'Jet' or 'Turbo' often look great on white. 
% We use Turbo here for high contrast.
cmap = cmaplibrary.plasma; 
colormap(ax, cmap);

for tr = 1:N_traj
    x = PC1(:, tr)+1;
    y = PC2(:, tr)+1;
    z = PC3(:, tr)+1;
    % --- THE COLOR TRICK ---
    % Instead of Time, we map color to the MAGNITUDE of divergence.
    % We use PC1 (Tail Growth) because that tracks the explosion.
    % We normalize it so the start is 0 and max is 1.
    ColorData = x;
    % Smooth transparency: Low alpha makes overlapping lines glow
    surface([x, x], [y, y], [z, z], [ColorData, ColorData], ...
            'FaceColor', 'no', 'EdgeColor', 'interp', ...
            'LineWidth', 0.8, 'EdgeAlpha', 0.15);
end

% CLEANUP: Remove all chart junk
axis off;           % Turns off axes, ticks, and background box
axis tight;         % Tightens the plotting volume
grid off;           % Ensures no grid lines remain
% Force aspect ratio to look balanced
pbaspect([1 1 0.8]);

%% 5. Helper Function
function dcdt = smoluchowski_rhs(~, c, K, N)
    Reaction_Rate = K * c; 
    loss = c .* Reaction_Rate;
    
    gain = zeros(N,1);
    for k = 2:N
        i = 1:floor(k/2);
        j = k - i;
        flux = K(sub2ind(size(K), i, j))' .* c(i) .* c(j);
        symmetry_factor = 2 * ones(length(i), 1);
        if rem(k,2) == 0; symmetry_factor(end) = 1; end
        gain(k) = 0.5 * sum(flux .* symmetry_factor);
    end
    dcdt = gain - loss;
end