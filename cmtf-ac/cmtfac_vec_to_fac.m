function A = cmtfac_vec_to_fac(x,Z)

    %% Set-up
    P = length(x);
    tensorNum = length(Z.modes);
    all_dimsz = [];
    for n = 1:tensorNum
        all_dimsz = [all_dimsz, Z.size(Z.modes{n})];
    end
    R = P / sum(all_dimsz);

    %% Create A
    A = cell(tensorNum, 1);
    idx = 0;
    idx1 = 0;
    idx2 = 0;
    for n = 1:tensorNum
        dim = length(Z.modes{n});
        A{n} = cell(dim, 1);
        for m = 1:dim
            idx = idx + 1;
            idx1 = idx2 + 1;
            idx2 = idx2 + all_dimsz(idx)*R;
            A{n}{m} = reshape(x(idx1:idx2), all_dimsz(idx), R);
        end
    end
end