function dirs = fibonacci_sphere(N)
    i = (0:N-1)';
    phi = acos(1 - 2*(i+0.5)/N);
    theta = pi*(1+sqrt(5))*(i+0.5);
    dirs = [sin(phi).*cos(theta), sin(phi).*sin(theta), cos(phi)];
end