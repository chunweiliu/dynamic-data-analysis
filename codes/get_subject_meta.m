function [subjects, airway_length, age] = get_subject_meta(landmark_folder, meta_path)
% GET_LANMARKS
% input
% - input_folder, landmark files

% get landmark file
subjects = [];
files = dir(fullfile(landmark_folder,'*_Landmarks.txt'));
for i = 1:length(files)
    
    % get keys
    subject_file = fullfile(landmark_folder, files(i).name);
    fprintf('process %s\n', subject_file);
    
    fid = fopen(subject_file, 'r');
    C = textscan(fid, '%s:%[^\n]');
    fclose(fid);
    
    try
        tc = parse_key(C, 'TracheaCarina');
    catch
        tc = 0;
    end
    
    try
        tvc = parse_key(C, 'TVC');
    catch
        tvc = 0;
    end
    
    subjects(i).name = files(i).name;
    subjects(i).airway_length = norm(tc-tvc);
end

[~,~,raw] = xlsread(meta_path);
TITLE_ROWS = 9;
for i = TITLE_ROWS:size(raw,1)
    for j = 1:length(subjects)
        tmp = strsplit(subjects(j).name,'_');
        if strcmp(tmp{1},raw{i,1})
            subjects(j).age = raw{i,4};
            break
        end
    end   
end

airway_length = zeros(length(subjects),1);
age = zeros(length(subjects),1);
for i = 1:length(subjects)
    airway_length(i) = subjects(i).airway_length;
    if ~isempty(subjects(i).age)        
        age(i) = subjects(i).age;
    end
end

subjects(age==0) = [];
airway_length(age==0) = [];
age(age==0) = [];

plotregression(age,airway_length)
end

function val = parse_key(C, landmark)
% prase key
keys = C{1};
values = C{2};

idx = ismember(keys, landmark);
str = values{idx};
val = sscanf(str, '%f %f %f');
end
