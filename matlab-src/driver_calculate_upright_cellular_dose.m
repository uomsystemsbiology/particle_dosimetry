function [ ] = driver_calculate_upright_cellular_dose()
    size_range = cat(2, linspace(1e-9, 300e-9, 100), linspace(500e-9, 5000e-9, 10));
    density_range = cat(2, linspace(1001, 2000, 200), linspace(2000, 20000, 100));
    
    size_range = cat(2, linspace(1e-9, 300e-9, 3), linspace(500e-9, 5000e-9, 3));
    density_range = cat(2, linspace(1001, 2000, 3), linspace(2000, 20000, 3));
    calculate_upright_cellular_dose(size_range, density_range, 'upright_cell_dose.mat')

end

