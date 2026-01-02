function [sem, mu, sigma, N_total] = get_binned_stats(x,n)
 
    % 1. Total Sample Size
    N_total = sum(n);
    
    % Edge case check: Need at least 2 samples for variance
    if N_total < 2
        sem = NaN; mu = NaN; sigma = NaN;
        return;
    end
    
    % 2. Weighted Mean
    mu = sum(x .* n) / N_total;
    
    % 3. Weighted Variance (using Bessel's correction)
    % Calculate squared deviations from the mean
    deviations = (x - mu).^2;
    weighted_sq_deviations = sum(n .* deviations);
    
    variance = weighted_sq_deviations / (N_total - 1);
    
    % 4. Standard Deviation
    sigma = sqrt(variance);
    
    % 5. Standard Error of the Mean
    sem = sigma / sqrt(N_total);
end