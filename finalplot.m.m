%reading the csv files
fuel_data = readmatrix('FullFuelVOF.csv');
oxi_data = readmatrix('FullOxiVOF.csv');

%sorting the data according fuel vofs 
[F, I] = sortrows(fuel_data, 5);
non_zero_rows_fuel = F(:, 5) ~= 0;
%removing zero value vof rows
filtered_matrix_fuel = F(non_zero_rows_fuel, :);

%sorting the data according oxi vofs 
[O, I] = sortrows(oxi_data, 5);
non_zero_rows_oxi = O(:, 5) ~= 0;
%removing zero value vof rows
filtered_matrix_oxi = O(non_zero_rows_oxi, :);

%finding submatrice vof limits
values = linspace(0.1,1,100);


%assigning cell array in submatrice
submatrices_fuel = cell(1, length(values)-1);
submatrices_oxi = cell(1, length(values)-1);

%splitting data in submatrices
for i = 1:(length(values) - 1)
fuel_range = (filtered_matrix_fuel(:, end) > values(i)) & (filtered_matrix_fuel(:, end) <= values(i + 1));
submatrices_fuel{i} = filtered_matrix_fuel(fuel_range, :);
end

figure;
%assigning color maps for fuel and oxi
colors_fuel = autumn(length(submatrices_fuel));
colors_oxi = winter(length(submatrices_oxi));

%extracting coordinates
for i = 1:length(submatrices_fuel)
fuelx = submatrices_fuel{i}(:,2);
fuely = submatrices_fuel{i}(:,3);
fuelz = submatrices_fuel{i}(:,4);
%assigning color for each submatrice
colorfuel = colors_fuel(i, :);
scatter3(fuelx,fuely,fuelz,5,colorfuel,'filled', 'DisplayName', 'FUEL');

colorbar;
hold on;
end


 
%splitting oxi values into submatrices
for i = 1:(length(values) - 1)
oxi_range = (filtered_matrix_oxi(:, end) > values(i)) & (filtered_matrix_oxi(:, end) <= values(i + 1));
submatrices_oxi{i} = filtered_matrix_oxi(oxi_range, :);
end

%extracting coordinates
for i = 1:length(submatrices_oxi)
oxix = submatrices_oxi{i}(:,2);
oxiy = submatrices_oxi{i}(:,3);
oxiz = submatrices_oxi{i}(:,4);
%assigning color for each submatrice
coloroxi = colors_oxi(i, :);
scatter3(oxix,oxiy,oxiz,5,coloroxi,'filled', 'DisplayName', 'OXIDIZER');

colorbar;
end


%legend specification
view([0, 90]);

legend('Location', 'South');
legend('boxoff')
title('Fuel Oxidiser VOFs');
xlabel('X-axis');
ylabel('Y-axis');
hold off;

extracted_data = F(:,1:4);
mix_ratio = O(:, 5) ./ F(:, 5);
new_data = [extracted_data, mix_ratio];
rows_to_remove = any(isnan(new_data(:, 5)) | isinf(new_data(:, 5)), 2);
filtered_mix_data = new_data(~rows_to_remove, :);

user_ratio = input('Enter the mixture ratio: ');

columnToMatch = filtered_mix_data(:, 5);


% Round off the values in columnToMatch to a whole number
roundedColumn = round(columnToMatch);

% Compare the rounded values to user_ratio
matchingRows = find(roundedColumn == user_ratio);


if isempty(matchingRows)
    disp('No data with the entered mixture ratio');
else
    matchingData = filtered_mix_data(matchingRows, :);
    % Continue with the rest of your code using matchingData
    x = matchingData(:, 1); % Replace with the appropriate column index
    y = matchingData(:, 2); % Replace with the appropriate column index
    z = matchingData(:, 3); % Replace with the appropriate column index


    % Create a 3D scatter plot
    figure;
    scatter3(x, y, z, 5, "red", 'filled');

    xlabel('X-axis Label');
    ylabel('Y-axis Label');
    zlabel('Z-axis Label');
    title('3D Scatter Plot of user input MR ');
    grid on;
    end


