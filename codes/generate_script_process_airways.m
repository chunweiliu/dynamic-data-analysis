function generate_script_process_airways(input_folder, output_folder, ...
	output_script_file)
%PROCESS_AIRWAYS Generate iso-surface
% args
% - input_folder: string, a folder contained multiple segmented nrrd files
% - output_folder: string, a folder contained multiple preprocessed nrrd
% - output_script_file

% AIRWAY_PROCESSING_PATH = '/Users/chunwei/Documents/Library/AirwayProcessing/code/';
AIRWAY_PROCESSING_PATH = '/home/chunwei/lib/AirwayProcessing/code/';

addpath(genpath(AIRWAY_PROCESSING_PATH))

N_SURFACE = 100;
PATTERN = 'Fleck_\d+';

FILE_EXT = '*.nrrd';
files = dir(fullfile(input_folder,FILE_EXT));

if length(files) > 1 && ~exist(output_folder,'dir')
    mkdir(output_folder)
end

[~, end_index] = regexp(input_folder, PATTERN);
input_base = input_folder(1:end_index);  % .../.../Fleck_005
landmark_folder = strcat(input_base,'_landmarks');
segmentation_folder = strcat(input_base,'_segmentations');

% open script file
fid = fopen(output_script_file, 'w');

for i = 1:length(files)
    subject = files(i).name;
    subject_name = subject(1:end-5);  % not include .nrrd
    
    fprintf(fid, '#process %s\n\n',fullfile(input_folder,subject));
    
    %  computing centerline and its tangent normals
    iso_path = fullfile(output_folder,...
    	strcat('IsoSurface',subject_name));  
    segment_path = fullfile(input_folder,subject);
    landmark_path = fullfile(landmark_folder, ...
    	strcat(subject_name,'_landmarks.txt'));
    clip_path = fullfile(landmark_folder, ...
    	strcat(subject_name,'_clipping.txt'));


   	% generateCenterlineOfAirway(subject_name,segment_path,iso_path,...
    %     N_SURFACE,landmark_path,clip_path);
	prefix_command = 'matlab -nodesktop -nosplash -nodisplay -r';
    matlab_function = 'generateCenterlineOfAirway';
	
	fprintf(fid, 'rm -r %s\n', iso_path);
	fprintf(fid, 'mkdir %s\n', iso_path);
	fprintf(fid, 'cd %scenterline\n', AIRWAY_PROCESSING_PATH);
    fprintf(fid, '%s \"%s(''%s'',''%s'',''%s'',%d,''%s'',''%s''); quit;\"\n\n',prefix_command, matlab_function,...
    	subject_name,segment_path,iso_path,N_SURFACE,landmark_path,clip_path);

    % computing the cross-sectional area based on above centerline
    contour_path = fullfile(output_folder,...
		strcat('Contour',subject_name));

    bin = strcat(AIRWAY_PROCESSING_PATH, 'crossSections/bin/computeAreaAndContourWithMeanNorm');
	geometry_path = fullfile(segmentation_folder, ...
		strcat(subject_name,'.vtp'));
	mean_and_normal_path = fullfile(iso_path, ...
		strcat(subject_name,'_MeanAndNormal.txt'));
	area_path = fullfile(contour_path, ...
		strcat(subject_name,'_Area.txt'));
	perimeter_path = fullfile(contour_path,...
		strcat(subject_name,'_Perimeter.txt'));
	contour_dir = fullfile(contour_path,...
		strcat('/contour'));
	cmd = sprintf('%s %s %s %s %s %s %s',bin,...
		geometry_path,mean_and_normal_path,clip_path,...
		area_path, perimeter_path, contour_dir);
	
	% system(cmd, '-echo')
	fprintf(fid, 'rm -r %s\n', contour_path);
	fprintf(fid, 'mkdir %s\n', contour_path);	
	fprintf(fid, '%s\n\n', cmd);


	% displaying the cross-sections and the cross-sectional curve
	curve_path = fullfile(output_folder,...
		strcat('Curve',subject_name));
	curve_contours_path = fullfile(curve_path,...
		strcat(strcat(strcat('contour',subject_name),'_contours')));
	
    normReliableCheck_path = fullfile(iso_path,...
    	strcat(subject_name,'_NormReliableCheck.txt'));
    areaEllipse_path = fullfile(curve_path,...
    	strcat(subject_name,'_AreaEllipse.txt'));

	% drawContourOfAirway(mean_and_normal_path,normReliableCheck_path,contour_dir,...
	% 	curve_contours_path(1:end-9),areaEllipse_path,landmark_path);
	matlab_function = 'drawContourOfAirway';

	fprintf(fid, 'rm -r %s\n', curve_path);
	fprintf(fid, 'mkdir %s\n', curve_path);	
	fprintf(fid, 'rm -r %s\n', curve_contours_path);
	fprintf(fid, 'mkdir %s\n', curve_contours_path);
		
	fprintf(fid, 'cd %sdisplay\n', AIRWAY_PROCESSING_PATH);
    fprintf(fid, '%s \"%s(''%s'',''%s'',''%s'',''%s'',''%s'',''%s''); quit;\"\n\n',prefix_command,matlab_function,...
    	mean_and_normal_path,normReliableCheck_path,contour_dir,...
    	curve_contours_path(1:end-9),areaEllipse_path,landmark_path);


    landmarksIdOnCenterline_path = fullfile(iso_path,...
    	strcat(subject_name,'_LandmarksIdOnCenterline.txt'));
    curveAndLandmarks_path = fullfile(curve_path,...
    	strcat(subject_name,'_CurveAndLandmarks.png'));

	% drawLandmarksOnOneCurve(mean_and_normal_path,area_path,perimeter_path,...
	% 	areaEllipse_path,landmarksIdOnCenterline_path,curveAndLandmarks_path,curve_path);
	matlab_function = 'drawLandmarksOnOneCurve';

	fprintf(fid, 'cd %sdisplay\n', AIRWAY_PROCESSING_PATH);
    fprintf(fid, '%s \"%s(''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',''%s''); quit;\"\n\n',prefix_command,matlab_function,...
    	mean_and_normal_path,area_path,perimeter_path,...
    	areaEllipse_path,landmarksIdOnCenterline_path,curveAndLandmarks_path,curve_path);

end

fclose(fid);