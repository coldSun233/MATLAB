A.csize = [50;50;50;50;50;50];
A.N = 2;
A.object = Z.object;
A.miss = Z.miss;
A.initData = X.data;
A.R = 10;
A.pCf = 1;

options.Display ='final';
options.MaxFuncEvals = 100000;
options.MaxIters     = 10000;
options.RelFuncTol   = 1e-6;

ctfac_out = ctf_opt(A,10,'alg_options',options);