function [ ] = driver_calculate_upright_cellular_dose()
    size_range = cat(2, linspace(1e-9, 300e-9, 100), linspace(500e-9, 5000e-9, 10));
    density_range = cat(2, linspace(1001, 2000, 200), linspace(2000, 20000, 100));
    
    size_range = cat(2, linspace(1e-9, 300e-9, 3), linspace(500e-9, 5000e-9, 3));
    density_range = cat(2, linspace(1001, 2000, 3), linspace(2000, 20000, 3));
    size_range = [1e-9, 5e-9, 10e-9, 50e-9, 75e-9]; 
    density_range = [12000, 14000, 16000, 18000, 20000];
    
    
    calculate_upright_cellular_dose(size_range, density_range, 'upright_cell_dose_extremely_heavy.mat')

end

%4 dots left