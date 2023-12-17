fuel_data = readmatrix('FullFuelVOF.csv');
oxi_data = readmatrix('FullOxiVOF.csv');

extracted_fuel_data = fuel_data(:,1:4);
vof_fuel = fuel_data(:,5);
mass_frac_fuel = (vof_fuel * 813) ./ ((vof_fuel * 813) + ((1 - vof_fuel) * 1142));

extracted_oxi_data = oxi_data(:,1:4);
vof_oxi = oxi_data(:,5);
mass_frac_oxi = (vof_oxi * 1142) ./ ((vof_oxi * 1142) + ((1 - vof_oxi) * 813));

mix_ratio = mass_frac_oxi ./ mass_frac_fuel; 
rounded_mix_ratio = round(mix_ratio,3);

new_data = [extracted_fuel_data, rounded_mix_ratio];

rows_to_remove = any(new_data(:, 5) == 0 | isinf(new_data(:, 5)) | isnan(new_data(:, 5)), 2);

filtered_mix_data = new_data(~rows_to_remove, :);
x = filtered_mix_data(:,2);
y = filtered_mix_data(:,3);
z = filtered_mix_data(:,4);

figure;
scatter3(x, y, z, 50, filtered_mix_data(:,5), 'filled');
colorbar;
title('3D Scatter Plot with Mixture Ratio');
xlabel('X');
ylabel('Y');
zlabel('Z');


columnHeaders = {'S.NO.', 'x coordinate', 'y coordinate', 'z coordinate', 'mixture ratio'};
dataTable = array2table(new_data, 'VariableNames', columnHeaders);

fileName = 'mixtureratio.csv';
writetable(dataTable, fileName);