clear;
clc;
addpath('../cmtf-ac', 'cmtf_toolbox_v1_2', 'poblano_toolbox_v1_2', 'tensor_toolbox_v3_1');

% parameters
% sz = [50, 50, 50, 50, 50];
% modes = {[1, 2, 3], [1, 4, 5]};
sz = [30, 40, 50, 30, 30, 30];
modes = {[1, 2, 3], [1, 4], [1, 5, 6]};
R = 20;
tensorNum = length(modes);
lambdas = cell(1, tensorNum);
for n = 1:tensorNum
    lambdas{n} = ones(1, R);
end
noise = 0.1;
% M = [0.5, 0.5, 0.5];
M = [0.08, 0, 0];

% generate synthetic data
X = createSysData('size', sz, 'modes', modes, 'lambdas', lambdas, 'Rank', R, 'noise', noise);

W = cell(tensorNum, 1);
norms = ones(tensorNum, 1);
Z.object = cell(tensorNum, 1);
for n = 1:tensorNum
    W{n} = create_missing_data_pattern('size', sz(modes{n}), 'M', M(n));
    Z.object{n} = W{n}.*X.data{n};
    % πÈ“ªªØ
    % norms(n) = norm(Z.object{n});
    % Z.object{n} = Z.object{n} / norm(Z.object{n});
end
Z.miss = W;
Z.norms = norms;
Z.modes = modes;
Z.size = sz;
Z.cpdim = X.cpdim;

%options = ncg('defaults');
options.Display ='final';
options.MaxFuncEvals = 100000;
options.MaxIters     = 10000;
options.StopTol      = 1e-6;
options.RelFuncTol   = 1e-6;

out = cmtf_ac(Z, 20, 'alg_options', options);
% out = cmtf_ac(Z, 10, 'init', 'nvecs', 'alg_options', options);
Factors = cmtfac_vec_to_fac(out.X, Z);
% P = ktensor(cmtf_vec_to_fac(out.X, Z));

Y = ktensor(Factors{1});

trueval = X.data{1}.*(1-W{1});
estvalCMTF =  Y.*(1-W{1});
TCS = norm(trueval-estvalCMTF)/norm(trueval);
