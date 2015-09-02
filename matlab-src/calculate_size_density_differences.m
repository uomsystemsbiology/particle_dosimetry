function calculate_size_density_differences(size_range, density_range, timescale, workfile)    
    particle_number = 4.5e8;
    fake_z_pot = -35.2e-3;
    cond1 = ExperimentalCondition.StandardCondition(timescale, .005, .005, 1, c.upright_cells);
    cond2 = ExperimentalCondition.StandardCondition(timescale, .005, .005, 1, c.vertical_cells);
    len_densities = length(density_range);
    len_sizes = length(size_range); 
    upright_results = zeros(len_sizes, len_densities);
    vertical_results = zeros(len_sizes, len_densities);
    
    cutoff_difference = .5;

    fprintf('Progress:\n');
    fprintf(['\n' repmat('.',1,len_sizes) '\n\n']);
    
    parfor i=1:len_sizes
        size = size_range(i);
        fprintf('\b|\n');
        for j=1:len_densities
            density = density_range(j);
            %disp([i,j])            
            particle = Particle('Test', size, density, fake_z_pot, 1);
            ec1 = ExperimentAndParticle(cond1, particle, c.no_spatial_scale);
            ec2 = ExperimentAndParticle(cond2, particle, c.no_spatial_scale);
            upright_r = diffusion_sedimentation_pde(ec1.alpha, ec1.tmax, ec1.condition.timescale, ec1.condition.cell_position, ec1.name, 0, 1);
            vert_r = diffusion_sedimentation_2d_pde(ec2, 0, 1);
%             if j == 1
%                 vert_r = diffusion_sedimentation_pde(ec2.alpha, ec2.tmax, ec2.condition.timescale, ec2.condition.cell_position, ec2.particle.name, 0, 1);
%             end
            vertical_results(i,j) = vert_r.amount_removed;
            upright_results(i,j) = upright_r.amount_removed;
            if (vert_r.amount_removed/upright_r.amount_removed) < cutoff_difference
                break
            end
        end
    end
    save(workfile)
    
end


