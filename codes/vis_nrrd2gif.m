function vis_nrrd2gif(input_folder, output_path)
% VIS_NRRD2GIF generate gif annimation from 2D slides in nrrd
% inputs
% - input_folder, folder which stored nrrd files
% - output_file, output gif file

close all

files = dir(fullfile(input_folder,'*.nrrd'));
for i = 1:length(files)    
    
    subject_file = fullfile(input_folder, files(i).name);
    fprintf('process %s\n', subject_file)
    
    [im, ~] = nrrdread(subject_file);
    
    % rectify image
    slice = squeeze(im(:,size(im,2)/2,:));  % remove singluar axis
    slice = mat2gray(imresize(imrotate(slice,90),[512 512]));  % rescale
    slice = slice.^.7;  % addjust brightnest
    
    % draw as gif
    draw_gif(output_path, i, slice)
    
end