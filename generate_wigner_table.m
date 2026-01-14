function table = generate_wigner_table(l)
    % Finds all m1, m2, m3 such that m1+m2+m3=0 and computes 3j symbol
    list = [];
    for m1 = -l:l
        for m2 = -l:l
            m3 = -(m1 + m2);
            if m3 < -l || m3 > l, continue; end
            
            % Compute Wigner 3j symbol (l l l; m1 m2 m3)
            val = wigner3j(l, l, l, m1, m2, m3);
            if abs(val) > 1e-10
                % Store: [index1, index2, index3, value]
                list = [list; [m1+l+1, m2+l+1, m3+l+1, val]];
            end
        end
    end
    table = list;
end