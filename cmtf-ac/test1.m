%options = ncg('defaults');
options.Display ='final';
options.MaxFuncEvals = 100000;
options.MaxIters     = 10000;
options.RelFuncTol   = 1e-6;

out = cmtf_ac(Z, 10, 'alg_options', options);
% out = cmtf_ac(Z, 10, 'init', 'nvecs', 'alg_options', options);
Factors = cmtfac_vec_to_fac(out.X, Z);
% P = ktensor(cmtf_vec_to_fac(out.X, Z));

trueval = X.data{1}.*(1-Z.miss{1});
Y = full(ktensor(Factors{1}));
estvalCMTF =  Y.*(1-Z.miss{1});
TCS = norm(trueval-estvalCMTF)/norm(trueval);