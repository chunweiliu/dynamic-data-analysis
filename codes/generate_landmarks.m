function generate_landmarks(input_folder, output_folder)
% input
% - input_folder, input folder with .acvs annotations
% - output_folder, output folder to put landmark files

prefix = strfind(input_folder, 'Fleck_');  % Fleck_0xx
subject = input_folder(prefix:prefix+8);

surfixs = {'TC*.acsv', 'TVC*.acsv'};
landmarks = {'TracheaCarina', 'TVC'};

for j = 1:length(surfixs)
    files = dir(fullfile(input_folder, surfixs{j}));
    for i = 1:length(files)
        % get keys
        file = fullfile(input_folder, files(i).name);
        points = annotations2landmarks(file);

        % output files
        landmark_name = strcat(subject, sprintf('_%02d_landmarks.txt',i));
        output_path = fullfile(output_folder, landmark_name);
        fid = fopen(output_path, 'a');  % a: append
        write_key(fid, landmarks{j}, points);
        fclose(fid);        
    end
end


end

function points = annotations2landmarks(file)
% Parse ACSV files to to
fid = fopen(file);
done = 0;
while ~done
    line = fgets(fid);
    if strcmp(line(1),'#')
        continue
    end
    
    % the last line has format point|-0.42073|-8.4046|-1118.75|1|1
    points = sscanf(line(7:end-3), '%f|%f|%f');
    done = 1;
end
fclose(fid);
end