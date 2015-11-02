function [ ] = driver_calculate_upright_cellular_dose()
    size_range = [1e-9, 5e-9, 10e-9, 50e-9, 75e-9, 100e-9, 150e-9, 200e-9, 250e-9, 300e-9, 400e-9, 500e-9]; 
    density_range = [1001, 1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000, 3500, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 12000, 14000, 16000, 18000, 20000];
    calculate_upright_cellular_dose(size_range, density_range, 'upright_cell_dose_extremely_heavy.mat')
end