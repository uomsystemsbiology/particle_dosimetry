function calculate_upright_cellular_doses(size_range, density_range, workfile)    
    particle_number = 4.5e8;
    fake_z_pot = -35.2e-3;
    
    upright_24well_cond = ExperimentalCondition.StandardCondition(25*60*60, .0053, .022, .002, c.upright_cells);
    boundary_condition = cell_boundary_conditions.constant_concentration_zero;
    
    len_densities = length(density_range);
    len_sizes = length(size_range); 
    upright_results = zeros(len_sizes, len_densities);
    
    fprintf('Progress:\n');
    fprintf(['\n' repmat('.',1,len_sizes) '\n\n']);
    
    for i=1:len_sizes
        size = size_range(i);
        fprintf('\b|\n');
        for j=1:len_densities
            density = density_range(j);
            disp([size, density]);
            disp([i,j]);            
            particle = Particle('Test', size, density, fake_z_pot, 1);
            ec1 = ExperimentAndParticle(upright_24well_cond, particle);
            %upright_r = diffusion_sedimentation_pde(ec1);
            upright_r = diffusion_sedimentation_2d_pde(ec1, boundary_condition);
            upright_results(i,j) = upright_r.amount_removed;
        end
    end
    save(workfile)
    
end


