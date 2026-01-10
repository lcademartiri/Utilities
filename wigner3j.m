function w = wigner3j(l, m1, m2, m3)
    % Simplified Wigner 3j for (l l l; m1 m2 m3) using Racah formula
    if (m1 + m2 + m3 ~= 0), w = 0; return; end
    
    % The prefactor for (l l l) case
    % Formula: sqrt((2l-2l)!/(2l+1)!) is not right for 3j.
    % We use the standard Racah form. For l,l,l it simplifies to:
    t1 = l + l - l; % = l
    t2 = l + m1; t3 = l - m1; t4 = l + m2; t5 = l - m2; t6 = l + m3; t7 = l - m3;
    
    % Using log-factorials for numerical stability
    log_fact = @(n) sum(log(1:n));
    num = log_fact(t2) + log_fact(t3) + log_fact(t4) + log_fact(t5) + log_fact(t6) + log_fact(t7);
    den = log_fact(3*l + 1); % (j1+j2+j3+1)!
    
    prefactor = exp(0.5 * (num - den));
    
    sum_val = 0;
    % Sum over z such that factorials are non-negative
    z_min = max([0, m1-l, -l-m3]);
    z_max = min([l+m2, l-m3, l+m1]);
    
    for z = z_min:z_max
        term = ((-1)^(z + l + m3)) * exp(...
            log_fact(2*l - z) + log_fact(l + z - m1) ...
            - log_fact(z) - log_fact(l - z + m2) - log_fact(l - z - m3) - log_fact(z - m1 + l));
        % Note: The above is a simplified Racah sum for this specific symmetry.
        % For production, using a standard 'wigner3j' library is safer.
        if ~isnan(term), sum_val = sum_val + term; end
    end
    w = prefactor * sum_val;
end