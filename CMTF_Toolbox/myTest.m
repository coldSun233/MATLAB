modes = {[1 2 3], [1, 4]};
sz = [50 30 40 20];
R = 30;
P = length(modes);
lambdas = cell(1, P);
for i = 1:P
    lambdas{i} = 900 + (1100 - 900) * rand(1, R);
end
flag_sparse = zeros(1, P);
flag_gnn = zeros(1, R);
if any(flag_sparse)
    % construct sparse data sets in the dense or sptensor format based on flag_sparse
    [X, Atrue] = create_coupled_sparse('size',sz,'modes',modes,'lambdas',lambdas, 'R', R, 'flag_nn', flag_gnn);
elseif ~any(flag_sparse) 
    % construct data sets in the dense format
    [X, Atrue] = create_coupled('size', sz, 'modes', modes, 'lambdas', lambdas, 'R', R, 'flag_nn', flag_gnn);
end