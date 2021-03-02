function output = cmtf_ac(Z,R,varargin)
 %
 % Z is a structure with 'size', 'object', 'modes', 'miss'(if there are missing data)
    
    if (nargin < 2)
        error('Error: invalid input arguments');
    end

    %% Set parameters
    params = inputParser;
    params.addParameter('alg' , 'cmtf_ncg', @(x) ismember(x,{'cmtf_ncg','ncg','tn','lbfgs','sgd'}));
    params.addParameter('init', 'random', @(x) (iscell(x) || ismember(x,{'random','nvecs'})));
    params.addOptional('alg_options', '', @isstruct);
    params.parse(varargin{:});

    %% Set up optimization algorithm
    switch (params.Results.alg)
        case 'sgd'
            fhandle = @sgdUpdate;
        case 'cmtf_ncg'
            fhandle = @cmtf_ncg;
        case 'ncg'
            fhandle = @ncg;
        case 'tn'
            fhandle = @tn;
        case 'lbfgs'
            fhandle = @lbfgs;
    end

    %% Set up optimization algorithm options
    if isempty(params.Results.alg_options)
        options = feval(fhandle, 'defaults');
    else
        options = params.Results.alg_options;
    end

    sz = Z.size;
    N = length(sz);
    tensorNum = numel(Z.object);

    if iscell(params.Results.init)
        G = params.Results.init;
    elseif strcmpi(params.Results.init,'random')
        G = cell(tensorNum,1);
        for n = 1:tensorNum
            dim = length(Z.modes{n});
            G{n} = cell(dim, 1);
            for t = 1:dim
                G{n}{t} = randn(sz(Z.modes{n}(t)), R);
                for m = 1:R
                    G{n}{t}(:,m) = G{n}{t}(:,m) / norm(G{n}{t}(:,m));
                end
            end
        end
    elseif strcmpi(params.Results.init,'nvecs')
        T = cell(N,1);
        for n=1:N
            T{n} = cmtfac_nvecs(Z,n,R);
        end
        G = cell(tensorNum,1);
        for n = 1:tensorNum
            dim = length(Z.modes{n});
            G{n} = cell(dim, 1);
            for m = 1:dim
                index = Z.modes{n}(m);
                G{n}{m} = T{index};
            end
        end
    else
        error('Initialization type not supported')
    end
    
    % Fit CMTF_AC using Optimization
    Znormsqr = cell(tensorNum,1);
    for p = 1:tensorNum
        if isa(Z.object{p},'tensor') || isa(Z.object{p},'sptensor')
            Znormsqr{p} = norm(Z.object{p})^2;
        else
            Znormsqr{p} = norm(Z.object{p},'fro')^2;
        end
    end
    out = feval(fhandle, @(x)cmtfac_fun(x,Z,Znormsqr), cmtfac_fac_to_vec(G), options);


    output.X = out.X;
    output.options = options;
    output.normsqr = Znormsqr;
end