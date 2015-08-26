function [I, ind] = del_empty_slices(I)
% Skip the images with only black pixels
    z_range = size(I,3);
    empty_slices = zeros(z_range, 1);
    for i = 1:z_range
        if ~max(max(I(:,:,i)))
            % save the z-indexes of the empty slices
            empty_slices(i) = i;
        end
    end
    % Remove the zeros
    empty_slices(~empty_slices)=[];
    I(:,:,empty_slices) = [];
    ind = setdiff(1:z_range, empty_slices);