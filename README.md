# ASV
Accumulated Stability Voting


ASV Demo Code 
Version: 1 (2016/3/11)


All rights reserved.
-----------------------------------------------------------------------------------------------
Code author: Tsun-Yi Yang 
Email: shamangary@hotmail.com
Project page: http://shamangary.logdown.com/posts/587520
Paper: [CVPR16] Accumulated Stability Voting: A Robust Descriptor from Descriptors of Multiple Scales

If you use the code, please cite the paper.
If any bug is found, please email me.
You may use the code for academic study.
However, using the provided code for commercial purpose is forbidden.
-----------------------------------------------------------------------------------------------
Tested platform:
Ubuntu 12.04 LTS (I do not test the code on Windows or Mac.)
Matlab R2012b

-----------------------------------------------------------------------------------------------






================================================
How to use the code? Step-by-step procedure: (very simple)

For each dataset (Oxford/Fischer), you need to run the following 
command seperately.

1. run "extractSIFT.m"
    run "extractDSP.m"
    run "extractASV.m"
    run "extract1M2M.m"

The extraction of the whole dataset might take minutes.
Once its done, you don't have to do it again 
unless you need to change the parameters of the descriptors.

2. run "TYY_evaluation_des.m" by using desType = 1, isSave = 1
    run "TYY_evaluation_des.m" by using desType = 2, isSave = 1
    run "TYY_evaluation_des.m" by using desType = 3, isSave = 1
    run "TYY_evaluation_des.m" by using desType = 4, isSave = 1

3. run "showResults", you should change desType1 and desType2
    to see the results comparison.

================================================









-----------------------------------------------------------------------------------------------
Library: (attached, you don't need to download it again)
Vlfeat library 0.9.18
http://www.vlfeat.org/
Vlfeat benchmark library (slightly modified)
http://www.vlfeat.org/benchmarks/overview/repeatability.html

-----------------------------------------------------------------------------------------------
Dataset: (attached, you don't need to download it again)
Oxford dataset
http://www.robots.ox.ac.uk/~vgg/data/data-aff.html
Fischer dataset
http://lmb.informatik.uni-freiburg.de/resources/datasets/genmatch.en.html

-----------------------------------------------------------------------------------------------
Evaluation:
Precision-recall curve
Mean average precision
Head-to-head comparison
Total correct matches

-----------------------------------------------------------------------------------------------
Baseline:
SIFT
DSP-SIFT
http://vision.ucla.edu/~jingming/proj/dsp/

-----------------------------------------------------------------------------------------------
Proposed Method:
Accumulated Stability Voting

1. ASV(1S)-SIFT: 
Only apply first stage single threshold (median threshold),
the output are real-valued descriptors.

2. ASV(1M2M)-SIFT:
Apply two stage multi-thresholds procedure, the number 
of threshold is tunable. The output are binary descriptors.


You may also choose different descriptors and apply ASV on them.
ASV-LIOP
ASV-PATCH

================================================
Important function:

1. extract.m
This function control the parameters of vlfeat covariant 
detection function "vl_covdet.m"
---------------------------------------------------------------------------------------------------
The keypoints are sorted by the returned peak scores. (important!)

Default setting: (important!)
-> peakthreshold = 0.001
-> doubleimage = 'true'
-> estimateorientation = 'true'
-> estimateaffineshape = 'true'

---------------------------------------------------------------------------------------------------
1. vl_dspcovsift.m
A slightly modified version from DSP-SIFT. 
(Original code didnt use affine approximated detector.)
[CVPR15] Domain-Size Pooling in Local Descriptors: DSP-SIFT
http://vision.ucla.edu/~jingming/proj/dsp/

You also need the following mex file to run the DSP function.
-> mexNormalizeHistogramChar.mexa64

2. vl_asvcovdet.m (OUTPUT real-valued descriptor)
A function to extract ASV(1S)-SIFT. 
The function only applies first stage single threshold (median threshold),
and the output are real-valued descriptors. 
You only need vlfeat library to run this function.

3. vl_asv1m2mcovdet.m (OUTPUT binary descriptor)
A function to extract ASV(1M2M)-SIFT.
The function applies two stage multi-thresholds procedure, 
the number of threshold is tunable. 
The output are binary descriptors.
You only need vlfeat library to run this function.


