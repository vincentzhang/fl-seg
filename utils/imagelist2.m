function imlist = imagelist2(annotations, numscales)
% Take a list of annotations, return a list of slices with annotations
% Parameters:
%               annotations: annotation
%               numscales:   num of scale of gaussian pyramid
% Returns:
%               imlist:      a list of slices with annotations

    % Process each slice
    max_val = squeeze(max(max( annotations, [] , 2))); % a column vector of maximum value in each slice

    % slices that contain positive labels
    slice_ind = find(max_val);
    % # of slices that contain positive labels
    z_range = length(slice_ind);

    % zeros of num scales
    imlist = zeros(numscales * z_range, 1);

    for i = 1:z_range
        imlist(numscales * (i-1) + 1 : numscales * (i-1) + numscales) = numscales*slice_ind(i)-numscales+1:numscales*slice_ind(i);
    end

end

