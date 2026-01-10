function Y = compute_ylm(l, theta, phi)
    % Computes Y_lm for all m in [-l, l]
    % Returns N x (2l+1)
    
    N = numel(theta);
    Y = zeros(N, 2*l+1);
    
    % Legendre P_lm(cos theta)
    % legendre(l, x) returns matrix of size (l+1) x N for m=0..l
    P = legendre(l, cos(theta)); 
    
    % Normalization factors
    for m = 0:l
        % Renormalize P_lm to Spherical Harmonic convention
        if m==0
            norm_f = sqrt((2*l+1)/(4*pi));
            Y(:, l+1) = norm_f * P(1,:)';
        else
            fac = factorial(l-m) / factorial(l+m);
            norm_f = sqrt( (2*l+1)/(4*pi) * fac );
            
            p_vec = P(m+1, :)' * norm_f;
            
            % m > 0: Y_lm = N * P_lm * exp(i*m*phi) * (-1)^m
            phase = exp(1i * m * phi);
            Y(:, l+1+m) = p_vec .* phase * (-1)^m;
            
            % m < 0: Y_l-m = conj(Y_lm) * (-1)^m
            Y(:, l+1-m) = conj(Y(:, l+1+m)) * (-1)^m;
        end
    end
end