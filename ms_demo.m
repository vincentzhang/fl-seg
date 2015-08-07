% Demo code for running on ms lession 08 data
%---------------------------------------

%% Clear up the workspace
clear; close all;

%% Set hyperparameters and data location
set_params;
basedir = '/usr/data/medical_images/MSlesion08/';
params.scansdir = strcat(basedir, 'Scans');
params.masksdir = strcat(basedir, 'Lungmasks');
params.annotsdir = strcat(basedir, 'Annotations');

filename = strcat(basedir, 'UNC_train_Case01/UNC_train_Case01_T1.nhdr');
[X, META] = NRRDREAD(filename);

disp "NRRD file has been read"


%% Learn features and extract labels
% D: learned dictionary of filters
% X: matrix of features for each labelled voxel
% labels: 0/1 labels for each datapoint in X
[D, X, labels] = run_vessel12(params);

%% Train a logistic regression classifier on X
% Applies n_folds cross validation
% model: the resulting model
% scaleparams: means and stds of X
n_folds = 10;
[model, scaleparams] = learn_classifier(X, labels, n_folds);

%% Load a volume to segment
volume_index = 20;
[V, V_seg] = load_vessel12(params, volume_index);

%% Compute a segmentation on a slice of V
slice_index = 200;
preds = segment(V(:,:,slice_index), V_seg(:,:,slice_index), model, D, params, scaleparams);

%% Visualize the result
visualize_segment(V(:,:,slice_index), preds>0.5);
