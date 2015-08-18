function imlist = imagelist2(annotations, numscales)
% Take a list of annotations and return the z indexes of a selected list of slices
% Parameters:
%               annotations: annotations in 3D matrix
%               numscales:   number of scale of gaussian pyramid
% Returns:
%               imlist:      a list of slices with annotations

    % Process each slice
    max_val = squeeze(max(max( annotations, [] , 2))); % a column vector of maximum value in each slice

    % z-index of the slices that contain positive labels
    pos_slice_inds = find(max_val);

    % Find the slices that contain the largest number of pos labels
    ind = 1;
    num_pos_labels = zeros(length(pos_slice_inds),1); % # of pos labels
    for i = pos_slice_inds % process each slice
        num_pos_labels(ind) = length(find(annotations(:,:,i)));
        ind = ind + 1;
    end

    % maxk is a mex function for partical quick sort ( Average complexity: O(n) )
    num_slices = 10;
    [~, loc] = maxk(num_pos_labels, num_slices); % select the top 10 slices
    selected_slices = pos_slice_inds(loc);

    % Save the slices in different scales
    imlist = zeros(numscales * num_slices, 1);
    for i = 1:num_slices
        imlist(numscales * (i-1) + 1 : numscales * (i-1) + numscales) = ...
            numscales*selected_slices(i)-numscales+1 : numscales*selected_slices(i);
    end

end

