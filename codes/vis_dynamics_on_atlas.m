function vis_dynamics_on_atlas(input_file, output_file)
load(input_file)
% f_atlas
% f_subject
% w_atlas
% x
% x_labels

% clip artifacts
clip_before = 0;
if clip_before ~= 0
    idx = ceil(length(x)*clip_before);
    f_atlas = interp1(0:1/(length(x(idx:end))-1):1, f_atlas(idx:end,:), x);
    f_subject = interp1(0:1/(length(x(idx:end))-1):1, f_subject(idx:end,:), x);
end

% advance the atlas for shorter portion airway
advance_atlas = 0;%0.274;
if advance_atlas ~= 0
    idx = ceil(length(x)*advance_atlas);
    f_atlas = interp1(0:1/(length(x(idx:end))-1):1, f_atlas(idx:end,:), x);
end


addpath('FunctionalBoxplot/')

for i = 1:size(f_subject,2)
    close all
    
    % plot atlas
    wfbplot(f_atlas, x, w_atlas);
    hold on

    % plot dynamic data on the atlas
    factor = 1.5;
    fullout = false;
    outliercol = 'r';
    range_color = 'y';
    barcol = 'r';
    prob = 1.0;
    show = true;
    method = 'MBD';
    depth = [];

    fbplot(f_subject(:,i), x, depth, ...
        method, show, prob, range_color, outliercol, barcol, fullout, factor, f_subject(:,1),barcol);
    hold off

    vis_axis_airway(x_labels)
    draw_gif(output_file,i);
    
end
