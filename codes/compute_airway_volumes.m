function volumes = compute_airway_volumes(filename)
load(filename)
% f_atlas, f_subject, w_atlas, x, x_labels

volumes = sum(f_subject);
plot(1:length(volumes),volumes)
xlim([1, length(volumes)])