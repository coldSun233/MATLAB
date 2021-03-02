function output = fun(varargin)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description
    params = inputParser;
    params.addParameter('alg' , 'cmtf_ncg', @(x) ismember(x,{'cmtf_ncg','ncg','tn','lbfgs','sgd'}));
    params.addParameter('init', 'random', @(x) (iscell(x) || ismember(x,{'random','nvecs'})));
    params.parse(varargin{:});

    output.alg = params.Results.alg;
    output.init = params.Results.init;
end