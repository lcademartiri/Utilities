function Y = compute_ylm(l, theta, phi)
    % Vectorized Spherical Harmonics
    % theta, phi are [M x 1] vectors (M = number of bonds)
    % Returns [M x 2l+1] complex matrix
    
    M = numel(theta);
    Y = complex(zeros(M, 2*l+1));
    
    % legendre(l, cos(theta)) returns (l+1) x M matrix
    P = legendre(l, cos(theta)); 
    
    for m = 0:l
        % Precompute normalization factor
        fac = factorial(l-m) / factorial(l+m);
        norm_f = sqrt(((2*l+1)/(4*pi)) * fac);
        
        if m == 0
            Y(:, l+1) = norm_f * P(1,:)';
        else
            % Vectorized phase and normalization
            % (-1)^m is the Condon-Shortley phase
            phase = exp(1i * m * phi);
            p_vec = (norm_f * (-1)^m) * P(m+1, :)';
            
            Y(:, l+1+m) = p_vec .* phase;
            % Symmetry for negative m
            Y(:, l+1-m) = conj(Y(:, l+1+m)) * ((-1)^m);
        end
    end
end