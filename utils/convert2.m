function [X, labels] = convert2(L, mask, annotations, imagelist)
% Take features and labels from each voxel on every slice in imagelist
% Parameters:
%           L:  Feature maps that are grouped based on images
%           mask: the mask for the brain tissues
%           annotations: annotations
%           imagelist: indexes of the slices that contain annotations
% Returns:
%           X:  features
%           labels: labels
    ratio = 15; % # of total pixels / # of lesion pixels

    size_L = size(L{1}); % 512 x 512 x 192
    %rows = size_L(1)*size_L(2)*length(imagelist); % 512*512*5
    %voxels = size_L(1) * size_L(2); % 512 * 512

    % Find some positive labels
    % Find index of positive labels on the imagelist
    lesion_pos = cell(length(imagelist), 1);
    nonlesion_pos = cell(length(imagelist), 1);
    total_lesions = 0; % # of pixels that are lesions
    for i = 1:length(imagelist)
        [row, col] = find(annotations(:, :, i));
        lesion_pos{i} = sub2ind(size_L(1:2), row, col); % index
        total_lesions = total_lesions + length(row);
        % Find negative labels
            % Two approaches:
            % 1, Random Search
            % 2, Find the neighbors of the lesions
        neg_labels_ind = zeros((ratio-1)*length(row), 1);
        for j = 1 : (ratio-1) * length(row)
            not_done = true;
            while not_done
                r = random('unid', size_L(1));
                c = random('unid', size_L(2));
                % pick a pixel that is brain tissue and has negative label
                if mask(r, c, i) && ~annotations(r, c, i)
                   not_done = false;
                end
            end
            neg_labels_ind(j) = sub2ind(size_L(1:2), r, c);
        end
        nonlesion_pos{i} = neg_labels_ind;
    end

    X = zeros(ratio * total_lesions, size_L(3)); % # of pixels x 192 (scaled features)
    labels = zeros( ratio * total_lesions, 1);

    % Loop through annotations, assigning features and labels
    % index of the labels in the last iteration
    last_ind = 0;
    for i = 1:length(imagelist)
        % Get the label
        %labels((i-1)*voxels+1:i*voxels) = reshape(annotations(:,:,imagelist(i))+1, [voxels 1]);% label+1 to make all labels positive for softmax regression

        pos_row = length(lesion_pos{i});
        tmp = annotations(:, :, i);
        labels(last_ind + 1: last_ind + pos_row) = tmp(lesion_pos{i});
        labels(last_ind + pos_row + 1: last_ind + ratio*pos_row) = tmp(nonlesion_pos{i});
        for j = 1:size_L(3)
            q = L{i}(:, :, j); % 512*512
            X(last_ind + 1: last_ind + pos_row, j) = q(lesion_pos{i})';
            X(last_ind + pos_row + 1: last_ind + ratio*pos_row, j) = q(nonlesion_pos{i})';
        end
        % update the index
        last_ind = last_ind + ratio * pos_row;

        % Get the features
        %q = L{i}; % 512*512*192
        %X( (i-1)*voxels+1:i*voxels, : ) = reshape(q, [voxels size_L(3)]);
    end
    labels = labels + 1; % change to positive labels (0,1) to (1,2)
end

