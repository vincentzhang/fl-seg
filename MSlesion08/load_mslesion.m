function [] = load_mslesion(filename, params)
% Function for loading 3D volume
%
% Parameters:
%   params:  the dictionary of the parameters
%   patient_num: the id of the patient
% Returns:
%   I:      the scan image
%   I_seg:  the lung mask

[X, META] = nrrdread(filename)
