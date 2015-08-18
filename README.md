
# Note

Originally written by Ryan Kiros (rkiros@cs.toronto.edu) and achieved the 1st place VESSEL12 grand challenge result. The original programs are available from [here](http://www.cs.toronto.edu/~rkiros/)

The programs and documents are distributed without any warranty, express or
implied.  As the programs were written for research purposes only, they have
not been tested to the degree that would be advisable in any important
application.  All use of these programs is entirely at the user's own risk.

# How to use

To train a classifier on the VESSEL12 competition data:

    - Download the vessel12 data from http://vessel12.grand-challenge.org/

    - Open the script 'demo.m' and set the data directories. Optionally,
      open the script 'set_params.m' to modify the hyperparameters.

    - Run the script 'demo.m'. This will learn features using the 3 labelled
      volumes and train a logistic regression classifier using features from
      the labelled voxels with 10-fold cross validation. A sample
      segmentation is displayed.


To use the method with your own data:

    - Put your annotations in the same format as the vessel12 data. More
      specifically, each volume should have its own CSV file. Each line
      should contain 4 numbers: x,y,z,label: x,y and z designate 0-based
      voxel coordinates. I.e. point 0,0,0 is the voxel in the upper left
      corner of the first slice. label = 1 means this voxel is classified
      as a vessel while label = 0 means this voxel is classified as not a
      vessel. Not every voxel needs to be labelled.

    - Each volume should be a 3D array with slice indexing on the third
      dimension. For example loading/preprocessing code, check out the
      script 'load_vessel12.m' in the vessel12 folder.

    - From here, it should be easy to modify the 'run_vessel12.m' script
      to handle your data.


## Setup

    - It's recommended to have at least 16 GB of memory available.
      (Although 8 GB should be sufficent)

    - This code makes use of the parallel computing toolbox. If you have it 
      available, make sure to load some workers e.g. 'matlabpool open 8'. 
      This will speed up the feature extraction.

    - While we use 2 layers of feature learning for the competition, the
      number of scales is significantly more important for good vessel
      segmentation results. For simplicity and ease of use, we just include
      1 layer of learning with this code.

    - When setting the hyperparameters on your own data, try experimenting
      with the number of scales, receptive field size and number of features,
      probably in that order.


# Reference
This package reuses the following 3rd party code:

    - Mark Schmidt's minFunc optimization package (minFunc_2012):
      http://www.di.ens.fr/~mschmidt/Software/minFunc.html

    - Adam Coates' VQ code (run_omp1.m): http://www.stanford.edu/~acoates/

    - Pranam Janney's Gaussian pyramid code (Gscale.m):
      http://www.mathworks.com/matlabcentral/fileexchange/25254-gaussian-pyramid

    - Steven L. Eddins' image overlay code (imoverlay.m):
      http://www.mathworks.com/matlabcentral/fileexchange/10502-image-overlay/

    - Dirk-Jan Kroon's medical data reader code:
      http://www.mathworks.com/matlabcentral/fileexchange/29344-read-medical-data-3d/

    - Jeff Mather's NRRD format data reader
      http://www.mathworks.com/matlabcentral/fileexchange/34653-nrrd-format-file-reader

    - Bruno Luong's C implementation of min/max selection algorithm (partial quicksort)
      http://www.mathworks.com/matlabcentral/fileexchange/23576-min-max-selection
