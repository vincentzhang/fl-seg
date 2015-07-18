function D = dictionary(patches, params)
% Train the dictionary with orthogonal matching pursuit(OMP)
% Parameters:
%   patches:    image patches
%   params:     hyperparameters
% Return:
%   D:          dictionary

    % Parameters
    nfeats = params.nfeats;
    
    % Mean substraction
    D.mean = mean(patches);
    nX = bsxfun(@minus, patches, D.mean);
    
    % Train dictionary
    disp('Training Dictionary...');
    D.codes = run_omp1(nX, nfeats, 50);
    
end

