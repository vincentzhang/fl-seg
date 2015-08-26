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

%% Learn features and extract labels
% D: learned dictionary of filters
% X: matrix of features for each labelled voxel
% labels: 0/1 labels for each datapoint in X
[D, X, labels] = run_mslesion(params);

%% Train a logistic regression classifier on X
% Applies n_folds cross validation
% model: the resulting model
% scaleparams: means and stds of X
%n_folds = 10;
%[model, scaleparams] = learn_classifier(X, labels, n_folds);

%% Load a volume to segment
%volume_index = 20;
%[V, V_seg] = load_mslesion(params, volume_index);

%% Compute a segmentation on a slice of V
%slice_index = 200;
%preds = segment(V(:,:,slice_index), V_seg(:,:,slice_index), model, D, params, scaleparams);

%% Visualize the result
%visualize_segment(V(:,:,slice_index), preds>0.5);
