% Demo code for running on ms lession 08 data
%---------------------------------------

%% Clear up the workspace
clear; close all;

%% Set hyperparameters and data location
set_params;
basedir = '/usr/data/medical_images/MSlesion08/';
%params.scansdir = strcat(basedir, 'UNC_train_Case');
params.scansdir = strcat(basedir, 'skull_stripped_UNC_train_Case');
params.annotdir = strcat(basedir, 'UNC_train_Case');

%volume_index = 1;
%scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_T1.nhdr',params.scansdir,volume_index);
% load the skull stripped data
%scan2 = '/usr/data/medical_images/MSlesion08/skull_stripped_UNC_train_Case01/UNC_train_Case01_T1.nrrd';
% I = load_mslesion(scan);
% I_ss = load_mslesion(scan2);
% disp 'NRRD file has been read'
% I_mask = segmentBgr3D_new(I, 50); % th=40,

%% Visualize this data
% Visualize the mask
% imagesc(I_mask(:,:,257));
% axis equal tight; colorbar;
% title('slice # 257');
% xlabel('x'), ylabel('y'); 
% colormap jet;

% Visualize the MRI
% figure(1)
% subplot(1,3,1);
% imshow(squeeze(uint8(I(:,:,257)))); title('z = 257');
% subplot(1,3,2);
% imshow(permute(squeeze(uint8(I(257,:,:))), [2 1])); title('x = 257');
% set(gca,'YDir','normal');
% subplot(1,3,3);
% imshow(permute(squeeze(uint8(I(:,257,:))), [2 1])); title('y = 257');
% set(gca,'YDir','normal');
% 
% figure(2)
% subplot(1,3,1);
% imshow(squeeze(uint8(I_ss(:,:,257)))); title('z = 257');
% subplot(1,3,2);
% imshow(squeeze(uint8(I_ss(257,:,:)))'); title('x = 257');
% set(gca,'YDir','normal');
% subplot(1,3,3);
% imshow(squeeze(uint8(I_ss(:,257,:)))'); title('y = 257');
% set(gca,'YDir','normal');

% figure(2)
% imshow(squeeze(uint8(I(:,:,257).*I_mask(:,:,257))));
% axis equal tight;

% measure time
tic;

%% Learn features and extract labels
% D: learned dictionary of filters
% X: matrix of features for each labelled voxel
% labels: 0/1 labels for each datapoint in X
[D, X, labels] = run_mslesion(params);

%% Train a logistic regression classifier on X
% Applies n_folds cross validation
% model: the resulting model
% scaleparams: means and stds of X
n_folds = 10;
[model, scaleparams] = learn_classifier(X, labels, n_folds);

% Gather time
toc;

%% Load a volume to segment
volume_index = 1;
%[V, V_seg] = load_mslesion(params, volume_index);
scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_T1.nrrd',params.scansdir,volume_index);
V = load_mslesion(scan);
mask = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_T1_mask.nrrd',params.scansdir,volume_index);
V_mask = load_annotation(mask);

%% Compute a segmentation on a slice of V
%slice_index = 211;
slice_index = 210;
preds = segment_lesions(V(:,:,slice_index), V_mask(:,:,slice_index), model, D, params, scaleparams);

%% Visualize the result
% visualize_segment(V(:,:,slice_index), preds>0.5);
ant_file = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_lesion.nhdr',params.annotdir,volume_index);
A = load_annotation(ant_file);
figure(1);
subplot(1,3,1);imshow(uint8(V(:,:,slice_index)));title(sprintf('Slice #%d',slice_index));
seg_gt = imoverlay(uint8(V(:,:,slice_index)), A(:,:,slice_index), [255/255 0/255 221/255]);
subplot(1,3,2); imshow(seg_gt);title('Ground truth');
seg_out = imoverlay(uint8(V(:,:,slice_index)), preds>0.5, [255/255 0/255 221/255]);
subplot(1,3,3);imshow(seg_out);title('Segmentation result');

%% Visualize the dictionary
figure(2);
visualize_dictionary(D);
