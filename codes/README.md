# Processing pediatric airways data
1. Transform files from DICOM to NRRD
    python DICOM_to_NRRD.py -i /Users/chunwei/Downloads/DICOM_SUBJECTS -o /Users/chunwei/Downloads/NRRD_SUBJECTS
2. Pre-process the NRRD files (padding and filtering)
    preprocess_airways('/Users/chunwe/Downloads/NRRD_SUBJECTS/Fleck_008/','/Users/chunwei/Downloads/NRRD_SUBJECTS/Fleck_008_processed/')
3. Open Slicer and manually annotate two landmarks, TracheaCarina and TVC with names TC and TVC, on preprocessed images. Save the annotations to .acsv files
4. Generate landmark files base on the annotation
    generate_landmarks('/Users/chunwei/Downloads/NRRD_SUBJECTS/Fleck_008_annotations/', '/Users/chunwei/Downloads/NRRD_SUBJECTS/Fleck_008_landmarks/');
5. Generate dummy landmarks for processing
    generate_dummy_landmarks('/Users/chunwei/Downloads/NRRD_SUBJECTS/Fleck_008_landmarks/');