function Z = createSysData(varargin)
% this function is used to generate synthetic data

% parse inputs
    params = inputParser;
    params.addParameter('size', @isnumeric);
    params.addParameter('modes', @iscell);
    params.addParameter('lambdas', cell(0), @iscell);
    params.addParameter('Rank', 3, @(x) x > 0);
    params.addParameter('noise', 0.1, @(x) x > 0);

    params.parse(varargin{:});
    sz = params.Results.size; %size of data sets
    modes = params.Results.modes; % how the data sets are coupled
    noise = params.Results.noise;
    R = params.Results.Rank;
    if isempty(params.Results.lambdas)
        m = length(modes);
        lambdas = cell(1, m);
        for n = 1:m
            lambdas{n} = ones(1, R);
        end
    else
        lambdas = params.Results.lambdas;
    end

% check parameters
    % 'lambda'
    if any(cellfun(@(x) length(x), lambdas) ~= R)
        error('Mismatch between lambdas and Rank inputs');
    end
    % 'modes'
    max_modeid = max(cellfun(@(x) max(x), modes));
    if max_modeid ~= length(sz)
        error('Mismatch between size and modes inputs');
    end

% generate factor matrices
    tensorNum = length(modes);
    factors = cell(tensorNum, 1);
    for m = 1:tensorNum
        dim = length(modes{m});
        factors{m} = cell(dim, 1);
        for n = 1:dim
            factors{m}{n} = rand(sz(modes{m}(n)), R);
        end
    end

    targetTensorDim = length(modes{1});
    coupledDim = cell(targetTensorDim, 1);
    % if there are tensors or matrices that are coupled to the target tensor
    if tensorNum >= 2
        for n = 1:targetTensorDim
            for m = 2:tensorNum
                len = length(modes{m});
                if n <= len && modes{m}(n) == modes{1}(n)
                    coupledDim{n} = [coupledDim{n}, m];
                    % process the coupled factor
                    factors{m}{n} = rand(sz(modes{m}(n)), R).*factors{1}{n} + rand(sz(modes{m}(n)), R);
                end
            end
        end
    end

% generate data and add noise
    X = cell(tensorNum, 1);
    T = cell(tensorNum, 1);
    for n = 1:tensorNum
        X{n} = full(ktensor(lambdas{n}', factors{n}));
        N = tensor(randn(size(X{n})));
        X{n} = X{n} / norm(X{n});
        T{n} = X{n} + noise*norm(X{n})*N/norm(N);
    end

    Z.initFactors = factors;
    Z.noNoiseData = X;
    Z.data = T;
    Z.cpdim = coupledDim;
end
