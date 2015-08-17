function [D,X,labels] = run_mslesion(params)
% Function for learning features and extracting labels
    % Load volumes, annotations and pre-process
    disp('Loading and pre-processing data...')
    ntv = 1;   % number of training volumes
    V = cell(ntv, 1);
    A = cell(ntv, 1);
    Vlist = cell(ntv, 1);
    Vs = [];
    % Initialization
    for i = 1:ntv
        scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_T1.nhdr',params.scansdir,i);
        % I is a 3D volume of the scan
        I = load_mslesion(scan);
        % Load the annotations (labels: 0/1) in 3D matrix
        ant_file = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_lesion.nhdr',params.scansdir,i);
        A{i} = load_annotation(ant_file);
        % Gaussian Pyramid of the image, saved in a vector
        % V{i} is a cell array each of which is a scaled image in the pyramid
        V{i} = pyramid(I, params);
        % The list of indexes of the slices which contain positive labels (ms lesion)
        Vlist{i} = imagelist2(A{i}, params.numscales);
        % Vs is a vector of cells where each cell is a scaled image
        Vs = [Vs; V{i}];
        clear I;
    end

    % Extract patches
    patches = extract_patches(Vs, params);
    clear Vs;
    % Train dictionary
    D = dictionary(patches, params);

    % Compute first module feature maps
    disp('Extracting first module feature maps...')
    L = cell(ntv, 1);
    for i = 1:ntv
        L{i} = extract_features(V{i}(Vlist{i}), D, params);  % Only extract features from slices with meaningful annotations
    end

    % Upsample all feature maps
    disp('Upsampling feature maps...')
    for i = 1:ntv
        L{i} = upsample(L{i}, params.numscales, params.upsample);
    end

    % Compute features for classification
    disp('Computing pixel-level features...')
    X = []; labels = [];
    for i = 1:ntv
        [tr, tl] = convert2(L{i}, A{i}, Vlist{i}(params.numscales:params.numscales:end)/params.numscales);
        X = [X; tr];
        labels = [labels; tl];
    end

