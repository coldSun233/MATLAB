clear;
clc;
addpath('../cmtf-ac', 'cmtf_toolbox_v1_2', 'poblano_toolbox_v1_2', 'tensor_toolbox_v3_1');

% parameters
sz = [30, 40, 50, 30, 30, 10];
modes = {[1, 2, 3], [1, 4], [1, 5, 6]};
R = 30;
tensorNum = length(modes);
lambdas = cell(1, tensorNum);
for n = 1:tensorNum
    lambdas{n} = ones(1, R);
end
noise = 0.1;
M = [0.5, 0.5, 0.5];

% generate synthetic data
X = createSysData('size', sz, 'modes', modes, 'lambdas', lambdas, 'Rank', R, 'noise', noise);

W = cell(tensorNum, 1);
norms = ones(tensorNum, 1);
Z.object = cell(tensorNum, 1);
for n = 1:tensorNum
    W{n} = create_missing_data_pattern('size', sz(modes{n}), 'M', M(n));
    Z.object{n} = W{n} .* X.data{n};
    % πÈ“ªªØ
    norms(n) = norm(Z.object{n});
    Z.object{n} = Z.object{n} / norm(Z.object{n});
end
Z.miss = W;
Z.norms = norms;
Z.modes = modes;
Z.size = sz;
Z.cpdim = X.cpdim;

G = cell(tensorNum, 1);
for n = 1:tensorNum
    dim = length(Z.modes{n});
    G{n} = cell(dim, 1);
    for t = 1:dim
        G{n}{t} = randn(sz(Z.modes{n}(t)), R);
        for m = 1:R
            G{n}{t}(:, m) = G{n}{t}(:, m) / norm(G{n}{t}(:, m));
        end
    end
end
