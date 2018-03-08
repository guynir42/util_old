MATLAB Utilities package. Will be needed for all other packages. 

Written by Guy Nir (guy.nir@weizmann.ac.il) with some code downloaded from other places. 

Orientation:
--------------
The +text sub-package is the most useful in +util. 
It contains functions for parsing strings, formatting strings 
and for unpacking keyword-value pairs in varargin using the InputVars class. 
Other notable mentions: util.text.cs compares partial strings (keyword parameters);
util.text.sa, which is short for ``slash append'' that is used to build paths. 
			  			  
The +plot sub-package is also very useful in many contexts. 
It contains functions to display images (util.plot.show), 
to draw profiles of stars/PSFs (util.plot.profile), 
and some classes used to build GUIs. 
			  
The +stat is tightly connected to image processing 
and to +img sub-package of +util. 
It has many functions that run on 2 dimensions, 
such as util.stat.sum2 and util.stat.median2.
These functions accept 2D or 3D or 4D matrices and calculate 
statistics on each image in the matrix. 
Other functions calculate their stats only on the corner of the image
(e.g.~util.stat.corner_mean). 
The divide between +img and this sub-package is 
somewhat arbitrary, but is useful for keeping each sub-package small. 
			  
The +img sub-package of +util 
(not to be confused with the general image processing +img)
contains more powerful methods for manipulating images. 
Since these are still used in many contexts, 
the functions have been kept under +util and not in the full image processing package. 
There are functions for shifting, centering, down-sampling, cropping and padding images. 
There are tools to mask out a circle or annulus, and extract data from different annuli. 
Other notable mentions: masking bad pixels using util.img.maskBadPixels, 
and making a Gaussian PSF using util.img.gaussian2.
  
The +vec sub-package has small utilities for manipulating vectors and matrices. 
It allows conversion between rows, columns and 3rd dimension vectors, 
inserting rows or columns and printing or comparing sizes of matrices. 
  
The +oop sub-package contains powerful tools for using objects. 
The most useful tools are the util.oop.full_copy used to make deep copies of objects 
(implemented in copy-constructors of handle objects), 
and the util.oop.save and util.oop.load functions
that write and read objects into text files or HDF5 files. 
Although individual objects are best saved as .mat files, 
sometimes making parameter logs in plain-text is needed, 
while other times adding parameters to data files in HDF5 format is required. 
	  
The +fft sub-package is a small set of functions based on the Fast Fourier Transform. 
Besides sub-pixel shifts using util.fft.FourierShift2D 
and more precise rotations using util.fft.RotateImage, 
the most useful tool is the FFT convolution using util.fft.conv_f. 
	  
The +time sub-package contains useful classes for measuring runtime. 
The two classes so far implemented are ProgressBar that gives the user
feedback when running slow analysis loops, 
and the TimingData that keeps track of the runtime for each section of an analysis. 
		  
The +sys package contains functions and classes that implement system resources. 
Notable mentions are the WorkingDirectory class that keeps track of folders in the file-system, 
the AudioControl class that gives audio signals to the user, 
and the util.sys.print that saves the current figure into PNG and PDF format as it is displayed on-screen. 
