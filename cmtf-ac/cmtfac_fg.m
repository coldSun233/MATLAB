function [f,G] = cmtfac_fg(Z,A,Znormsqr)

    if isa(A,'ktensor')
        A = tocell(A);
    end
    
    if ~iscell(A)
        error('A must be a cell array');
    end
    
    P = numel(Z.object);
    
    if ~exist('Znormsqr','var')
        Znormsqr = cell(P,1);
        for p = 1:P
            if isa(Z.object{p},'tensor') || isa(Z.object{p},'sptensor')
                Znormsqr{p} = norm(Z.object{p})^2;
            else
                Znormsqr{p} = norm(Z.object{p},'fro')^2;
            end
        end
    end
    
    fp = cell(P,1);
    Gp = cell(P,1);
    
    %% compute object f and g
    for p = 1:P
        if length(size(Z.object{p}))>=3
            % Tensor
            if isfield(Z,'miss') && ~isempty(Z.miss{p})
                [fp{p},Gp{p}] = tt_cp_wfg(Z.object{p}, Z.miss{p}, A{p}, Znormsqr{p});
            else
                [fp{p},Gp{p}] = tt_cp_fg(Z.object{p},  A{p}, Znormsqr{p});
            end
        elseif length(size(Z.object{p}))==2
            % Matrix
            if isfield(Z,'miss') && ~isempty(Z.miss{p})
                [fp{p},Gp{p}] = pca_wfg(Z.object{p}, Z.miss{p}, A{p}, Znormsqr{p});
            else
                [fp{p},Gp{p}] = pca_fg(Z.object{p}, A{p}, Znormsqr{p});
            end
        end
    end
    
    %% Compute overall function value
    f = 0;
    weightsOfT = zeros(P, 1);
    for n = 1:P
        weightsOfT(n) = norm(Z.miss{p})^2;
        f = f + fp{n} / weightsOfT(n);
    end
    targetTensorDim = length(Z.modes{1});
    weightsOfF = zeros(targetTensorDim, 1);
    for cf = 1:targetTensorDim
        if(~isempty(Z.cpdim{cf}))
            weightsOfF(cf) = numel(A{1}{cf});
            cpTensor = [1, Z.cpdim{cf}];
            num = length(cpTensor);
            for n = 1:num-1
                idx1 = cpTensor(n);
                idx2 = cpTensor(n+1);
                f = f + (norm(A{idx1}{cf} - A{idx2}{cf},'fro')^2) / (2*weightsOfF(cf));
            end
            idx = cpTensor(num);
            f = f + (norm(A{1}{cf} - A{idx}{cf},'fro')^2) / (2*weightsOfF(cf));
        end
    end
    
    %% Compute overall gradient
    for n = 1:P
        for m = 1:length(Z.modes{n})
            Gp{n}{m} = Gp{n}{m} / weightsOfT(n);
        end
    end
    for cf = 1:targetTensorDim
        if(~isempty(Z.cpdim{cf}))
            cpTensor = [1, Z.cpdim{cf}];
            num = length(cpTensor);
            for n = 1:num
                idx = cpTensor(n);
                if n == 1
                    idx1 = cpTensor(n+1);
                    idx2 = cpTensor(num);
                elseif n == num
                    idx1 = cpTensor(1);
                    idx2 = cpTensor(n-1);
                else
                    idx1 = cpTensor(n+1);
                    idx2 = cpTensor(n-1);
                end
                Gp{n}{cf} = Gp{n}{cf} + (2*A{idx}{cf} - A{idx1}{cf} - A{idx2}{cf}) / weightsOfF(cf);
            end
        end
    end    
    G = Gp;
end