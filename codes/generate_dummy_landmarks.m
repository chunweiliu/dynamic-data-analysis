function generate_dummy_landmarks(input_folder)
% GENERATE_DUMMY_LANDMARKS
% input
% - input_folder, landmark files
SCALE = 0.1;
files = dir(fullfile(input_folder,'*_landmarks.txt'));
for i = 1:length(files)
    
    % get keys
    subject_file = fullfile(input_folder, files(i).name);
    fprintf('process %s\n', subject_file);
    
    fid = fopen(subject_file, 'r');
    C = textscan(fid, '%s:%[^\n]');
    fclose(fid);
    
    tc = parse_key(C, 'TracheaCarina');
    tvc = parse_key(C, 'TVC');    
    
    % rewrite keys
    fid = fopen(subject_file, 'w');
    
    write_key(fid, 'TracheaCarina', tc);
    write_key(fid, 'TVC', tvc);
    
    subglottic = tvc;
    subglottic(3) = subglottic(3) - 1*SCALE;
    write_key(fid, 'Subglottic', subglottic);    
    
    epiglottistip = tvc;    
    epiglottistip(3) = epiglottistip(3) + 2*SCALE;
    write_key(fid, 'EpiglottisTip', epiglottistip);
    
    posteriorinferiorvomercorner = tvc;
    posteriorinferiorvomercorner(3) = posteriorinferiorvomercorner(3) + 3*SCALE;
    write_key(fid, 'PosteriorInferiorVomerCorner', posteriorinferiorvomercorner);
    
    nasalspine = tvc;    
    nasalspine(3) = nasalspine(3) + 6*SCALE;
    write_key(fid, 'NasalSpine', nasalspine);
    
    nosetip = tvc;
    nosetip(3) = nosetip(3) + 7*SCALE;
    nosetip(2) = nosetip(2) + 1*SCALE;
    write_key(fid, 'NoseTip', nosetip);
    
    columella = tvc;
    columella(3) = columella(3) + 8*SCALE;
    columella(2) = columella(2) - 1*SCALE;
    write_key(fid, 'Columella', columella);
    
    leftalarim = tvc;
    leftalarim(3) = leftalarim(3) + 1*SCALE;
    leftalarim(1) = leftalarim(1) + 1*SCALE;
    write_key(fid, 'LeftAlaRim', leftalarim);    
    
    rightalarim = tvc;
    rightalarim(3) = rightalarim(3) + 1*SCALE;
    rightalarim(1) = rightalarim(1) - 1*SCALE;
    write_key(fid, 'RightAlaRim', rightalarim);
       

    fclose(fid);
    
end

files = dir(fullfile(input_folder,'*_landmarks.txt'));
for i = 1:length(files)
    
    % get keys
    a = files(i).name;
    pre_fix = strfind(a, '_landmarks');
    clipping = strcat(a(1:pre_fix), 'clipping.txt');    
    
    subject_file = fullfile(input_folder, clipping);    
    fprintf('process %s\n', subject_file);
   
    fid = fopen(subject_file, 'w');
    
    % to remove lung
    center = [18.5, -15, 1136.2];
    write_key(fid, 'ClipSphereCenter', center);
    radius = 20;
    write_key(fid, 'ClipSphereRadius', radius);
    
    center = [-23.0, -14.9, 1128.2];
    write_key(fid, 'ClipSphereCenter', center);
    radius = 20;
    write_key(fid, 'ClipSphereRadius', radius);
    
    fclose(fid);
    
end

end

function val = parse_key(C, landmark)
% prase key
keys = C{1};
values = C{2};

idx = ismember(keys, landmark);
str = values{idx};
val = sscanf(str, '%f %f %f');
end
