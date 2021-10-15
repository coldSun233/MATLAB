clear;
clc;
addpath("CMTF_Toolbox_v1_1");
mainInfo = generate_mainInfo();
%mainInfo = rate_tensor;
auxInfo = generate_auxInfo();

time_period = 6;
T = 6;
[train_set, test_set] = generate_trainAndTest(mainInfo, time_period, T);

% get UPD
upd = calculate_upd(train_set);
sf = 1-upd;
sz = size(train_set);
userNum = sz(1);
data = train_set;
for n = 1:userNum
   train_set(n,:,1:(T-1)) = train_set(n,:,1:(T-1)).*sf(n);
end

Z.object{1} = tensor(train_set);
Z.object{2} = tensor(auxInfo);
Z.size = [6040,18,T,24];
Z.modes = {[1,2,3],[1,4]};

w2 = zeros(size(auxInfo));
w2(auxInfo~=0) = 1;
%w1 = ones(size(train_set));
%temp = train_set(:,:,T);
%temp(temp ~= 0) = 1;
%w1(:,:,T) = temp;
w1 = zeros(size(train_set));
w1(train_set~=0) = 1;

Z.miss{1} = tensor(w1);
Z.miss{2} = tensor(w2);

R = 15;
init = 'random';
%init = 'nvecs';
options = ncg('defaults');
options.Display ='final';
options.MaxFuncEvals = 100000;
options.MaxIters     = 10000;

[Fac, G,out]  = cmtf_opt(Z,R,'init',init,'alg_options', );

fac = Fac.U;
estimate = full(ktensor(fac(1:3))).*Z.miss{1};
esti_test = double(estimate(:,:,T));

[recall,precision] = get_recall(esti_test, train_set(:,:,6), 3);
[recall2,precision2] = get_recall(esti_test, test_set, 3);
[recall3,precision3] = get_recall(train_set(:,:,6), train_set(:,:,6), 3);
[recall4,precision4] = get_recall(test_set, test_set, 3);
sum1 = 0;
sum2 = 0;
t = cell(6, 1);
for n = 1:6
   [recall5,precision5] = get_recall(mainInfo(:,:,6*n), mainInfo(:,:,6*n), 3);
   t{n} = [recall5,precision5];
   sum1 = sum1 + recall5;
   sum2 = sum2 + precision5;
end
sum1 = sum1 / 6;
sum2 = sum2 / 6;
 
