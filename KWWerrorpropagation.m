% =========================================================================
% MONTE CARLO ERROR PROPAGATION FOR KWW CHARACTERISTIC TIMESCALE
% =========================================================================

% 1. INPUTS (Replace these with the values from your Origin Fit Report)
tau_fit = 515;   % Your best-fit tau
beta_fit = 0.44434;  % Your best-fit beta

% Replace with the 2x2 section of your Origin Covariance Matrix
% Format: [ Variance(tau)     ,  Covariance(tau, beta) ;
%           Covariance(tau, beta),  Variance(beta)      ]
cov_matrix = [ 130.10,  0.04758 ;   % <--- Example numbers, replace these!
               0.04758,  2.01e-5 ];

% 2. MONTE CARLO SETUP
N_samples = 100000; % 100,000 simulations is standard for convergence

% Generate 100,000 pairs of (tau, beta) from a Multivariate Normal Distribution
% This perfectly respects the parameter degeneracy (covariance) of your fit.
mu = [tau_fit, beta_fit];
samples = mvnrnd(mu, cov_matrix, N_samples);

tau_samples = samples(:, 1);
beta_samples = samples(:, 2);

% 3. PHYSICALITY FILTER
% The Gamma function blows up at beta <= 0, and tau must be positive.
% We drop any statistically simulated points that violate physics.
valid_idx = (tau_samples > 0) & (beta_samples > 0) & (beta_samples <= 1);
tau_valid = tau_samples(valid_idx);
beta_valid = beta_samples(valid_idx);

% 4. CALCULATE THE TRUE TIMESCALE DISTRIBUTION
% <tau> = (tau / beta) * Gamma(1 / beta)
mean_tau_dist = (tau_valid ./ beta_valid) .* gamma(1 ./ beta_valid);

% 5. EXTRACT ASYMMETRIC ERROR BOUNDS (1-Sigma / 68% Confidence Interval)
% Because the Gamma function is highly skewed, we use percentiles instead of standard deviation.
tau_median = median(mean_tau_dist);        % Best estimate
lower_bound = prctile(mean_tau_dist, 1);  % -1 Sigma equivalent
upper_bound = prctile(mean_tau_dist, 99);  % +1 Sigma equivalent

error_minus = tau_median - lower_bound;
error_plus = upper_bound - tau_median;

% 6. DISPLAY RESULTS
fprintf('\n=== KWW Timescale Error Analysis ===\n');
fprintf('Fitted Parameters:\n');
fprintf('  tau  = %.2f\n', tau_fit);
fprintf('  beta = %.3f\n\n', beta_fit);

fprintf('Calculated Mean Timescale <tau>:\n');
fprintf('  %.1f  (+ %.1f / - %.1f) timesteps\n', tau_median, error_plus, error_minus);
fprintf('====================================\n');

% 7. VISUALIZE THE SKEW (Optional but highly recommended)
figure('Color', 'k');
histogram(mean_tau_dist, 100, 'Normalization', 'pdf', 'FaceColor', [0 0.8 1], 'EdgeColor', 'none');
hold on;
xline(tau_median, 'w', 'LineWidth', 3, 'Label', 'Median');
xline(lower_bound, '--w', 'LineWidth', 2);
xline(upper_bound, '--w', 'LineWidth', 2);
set(gca, 'Color', 'k', 'XColor', 'w', 'YColor', 'w', 'LineWidth', 2, 'FontWeight', 'bold');
title('Monte Carlo Distribution of \langle\tau\rangle', 'Color', 'w');
xlabel('\langle\tau\rangle (timesteps)', 'Color', 'w');
ylabel('Probability Density', 'Color', 'w');
xlim([max(0, lower_bound - 3*error_minus), upper_bound + 3*error_plus]);
grid on; set(gca, 'GridColor', 'w', 'GridAlpha', 0.2);