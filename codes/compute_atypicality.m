function [dy_all, dy_atp] = compute_atypicality(filename)
load(filename);  % f_atlas, f_subject

[~,~,~,~,~,upper_quarter,lower_quarter] = wfbplot(f_atlas, x, w_atlas);

% find the region that is below normal control atlas
region = zeros(1,size(f_subject,1));
for i = 1:size(f_subject,2)
    region = region | (f_subject(:,i)' < lower_quarter);
end

% find the dynamics for entire range
[dy_all(1), dy_all(2), dy_all(3)] = find_dynamic(f_subject');

% find the dynamics only for the region
[dy_atp(1), dy_atp(2), dy_atp(3)] = find_dynamic(f_subject(region,:)');

function [miny, meany, maxy] = find_dynamic(fs)
if isempty(fs)
    miny = 0; meany = 0; maxy = 0;
    return
end

y = (max(fs)-min(fs))./max(fs);
maxy = max(y);
miny = min(y);
meany = mean(y);



