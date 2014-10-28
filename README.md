# Processing pediatric airways data

## Preprocessing
1. Transform files from DICOM to NRRD

    	python DICOM_to_NRRD.py -i ~/Data/DICOM_SUBJECTS -o ~/Data/NRRD_SUBJECTS
    
2. Pre-process the NRRD files (padding and filtering)

		>> preprocess_airways('~/Data/NRRD_SUBJECTS/Fleck_008/','~/Data/NRRD_SUBJECTS/Fleck_008_processed/')

## Manually annotation
1. Open Slicer and manually annotate two landmarks, TracheaCarina and TVC with names TC and TVC, on preprocessed images. Save the annotations to .acsv files

2. Generate landmark files base on the annotation

    	>> generate_landmarks('~/Data/NRRD_SUBJECTS/Fleck_008_annotations/', '~/Data/NRRD_SUBJECTS/Fleck_008_landmarks/');

3. Generate dummy landmarks for processing
    	
    	>> generate_dummy_landmarks('~/Data/NRRD_SUBJECTS/Fleck_008_landmarks/');

## Segmentation
1. Apply AirwaySegmenter on all pre-processed images for subject
    
    	sh segment_nrrd.sh ~/Data/NRRD_SUBJECTS/Fleck_008_landmarks/ ~/Data/NRRD_SUBJECTS/Fleck_008_segmentations/ ~/Data/NRRD_SUBJECTS/Fleck_008_processed/

## Processing
1. Apply AirwayProcessing 

## Measurement
1. Apply AirwayMeasurement

# Visualization
## One slide of dynamic data
1. vis_nrrd2gif

        >> vis_nrrd2gif('~/Data/NRRD_SUBJECTS/Fleck_008', '~/Data/NRRD_SUBJECTS/Fleck_008.gif');