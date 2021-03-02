function [f,g] = cmtfac_fun(x, Z, Znormsqr)
    %% Convert the input vector into a cell array of factor matrices
    A  = cmtfac_vec_to_fac(x,Z);
    
    %% Compute the function and gradient values
    [f,G] = cmtfac_fg(Z,A,Znormsqr);
    
    %% Vectorize the cell array of matrices
    g = cmtfac_fac_to_vec(G);
end