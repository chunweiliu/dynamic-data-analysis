#!/bin/bash
landmarkdir=$1  #~/Data/NRRD_SUBJECTS/Fleck_007_landmarks/
outputpath=$2  #~/Data/NRRD_SUBJECTS/Fleck_007_segmentations/
filepath=$3  #~/Data/NRRD_SUBJECTS/Fleck_007_processed/*.nrrd

mkdir -p $outputpath
for f in `ls $filepath`; do
    inputlandmark=`basename $f .nrrd`_landmarks.txt
    if [ -f $landmarkdir$inputlandmark ];
    then
	a1=`grep "TracheaCarina" $landmarkdir$inputlandmark | cut -d' ' -f3`
	a2=`grep "TracheaCarina" $landmarkdir$inputlandmark | cut -d' ' -f4`
	a3=`grep "TracheaCarina" $landmarkdir$inputlandmark | cut -d' ' -f5`
	lowerSeed=$a1,$a2,$a3

        a1=`grep "TVC" $landmarkdir$inputlandmark | cut -d' ' -f3`
	a2=`grep "TVC" $landmarkdir$inputlandmark | cut -d' ' -f4`
	a3=`grep "TVC" $landmarkdir$inputlandmark | cut -d' ' -f5`
	upperSeed=$a1,$a2,$a3

	outputnrrd=$outputpath`basename $f .nrrd`.nrrd
	outputvtp=$outputpath`basename $f .nrrd`.vtp

        echo "~/lib/AirwaySegmenter/build/bin/AirwaySegmenter $f $outputnrrd $outputvtp --upperSeed $upperSeed --lowerSeed $lowerSeed --lowerSeedRadius 40"
        ~/lib/AirwaySegmenter/build/bin/AirwaySegmenter $f $outputnrrd $outputvtp --upperSeed $upperSeed --lowerSeed $lowerSeed --lowerSeedRadius 40
    fi
done

