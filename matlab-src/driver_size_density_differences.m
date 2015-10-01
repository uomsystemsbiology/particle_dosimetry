function driver_size_density_differences
    size_range = cat(2, linspace(1e-9, 300e-9, 100), linspace(500e-9, 5000e-9, 10));
    density_range = cat(2, linspace(1001, 2000, 200), linspace(2000, 20000, 100));
    calculate_size_density_differences(size_range, density_range, ...
        24*60*60, 'size_density_24hr.mat')
    %calculate_size_density_differences(size_range, density_range, ...
        %12*60*60, 'size_density_12hr.mat')
    %calculate_size_density_differences(size_range, density_range, ...
        %48*60*60, 'size_density_48hr.mat')
end


