function tau = ACFtimesscale(lags, C)
    % C: Normalized autocorrelation vector (starts at 1.0)
    
    % Find where the correlation first hits zero or goes negative
    zero_idx = find(C <= 0, 1, 'first');
    
    if isempty(zero_idx)
        % If it never hits zero, integrate the whole window
        tau = trapz(lags, C);
    else
        % Integrate ONLY up to the first zero-crossing
        tau = trapz(lags(1:zero_idx), C(1:zero_idx));
    end
end