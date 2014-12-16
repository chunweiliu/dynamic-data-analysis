function vis_axis_airway(x_labels)
% axis
fontsize = 18;
xlabel('Depth along the centerline', 'FontSize', fontsize, 'FontWeight', 'Bold');
ylabel('Cross-sectional area (mm^2)', 'FontSize', fontsize, 'FontWeight', 'Bold');
set(gca, 'FontSize', fontsize, 'FontWeight', 'Bold');
set(gca, 'XTickLabel', x_labels);
title('Dynamic data with atlas', 'FontSize', fontsize, 'FontWeight', 'Bold');
