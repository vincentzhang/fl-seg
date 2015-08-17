% Demo code for running on ms lession 08 data
%---------------------------------------

%% Clear up the workspace
clc; clear; close all;

%% Set hyperparameters and data location
set_params;
basedir = '/usr/data/medical_images/MSlesion08/';
params.scansdir = strcat(basedir, 'UNC_train_Case');

%filename = strcat(basedir, 'UNC_train_Case01/UNC_train_Case01_T1.nhdr');
%volume_index = 1;
%scan = sprintf('%1$s%2$02d/UNC_train_Case%2$02d_T1.nhdr',params.scansdir,volume_index);
%I = load_mslesion(scan);
%disp 'NRRD file has been read'

%% Visualize this data
%imshow(squeeze(uint8(I(:,:,257))))

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
