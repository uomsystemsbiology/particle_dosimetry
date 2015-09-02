function driver_diff_sed_pde    
    %close all;
    %particle_number = 4.5e8;
    
    cs_conc = 1;
    pma_conc = 1;
    fake_z_pot = -35.2e-3;
    boundary_condition = cell_boundary_conditions.constant_concentration_zero;
    pmash_min = Particle('PMASH particles MIN', (190e-9)/2, 1060, -35.2e-3, pma_conc);
    core_shell_min = Particle('MS/CS particles MIN', (240e-9)/2, 1650, -38.6e-3, cs_conc);
    pmash_max= Particle('PMASH particles MAX', (210e-9)/2, 1060, -35.2e-3, pma_conc);
    core_shell_max = Particle('MS/CS particles MAX', (260e-9)/2, 1650, -38.6e-3, cs_conc);
    
    pmash_avg = Particle('PMA capsules', (200e-9)/2, 1060, -35.2e-3, pma_conc);
    core_shell_avg = Particle('SC/MS particles', (250e-9)/2, 1650, -38.6e-3, cs_conc);    

    normal_particles = [pmash_min, pmash_avg, pmash_max, ...
                        core_shell_min, core_shell_avg, core_shell_max];
    normal_particles = [pmash_avg, core_shell_avg];
    normal_time = 24*60*60;
  
    normal_volume = .002; %liters
    inverted_volume = .011 * .011 * .002 * pi * 1000; %m3 == 1000 liters
    vertical_height = .01786; %volume based on assumption that 2ml goes into vertical container, 
    %slide displaces its own volume,and slide is just high enough to reach top of media
    vertical_volume = .007 * .014 * vertical_height * 1000;  %m3 == 1000 liters
    
    normal_conditions = [ExperimentalCondition.StandardCondition(normal_time, .0053, .022, normal_volume, c.no_cells), ...
                         ExperimentalCondition.StandardCondition(normal_time, .0053, .022, normal_volume, c.upright_cells), ...
                         ExperimentalCondition.StandardCondition(normal_time, .002, .022, inverted_volume, c.inverted_cells), ...
                         ExperimentalCondition.StandardCondition(normal_time, vertical_height, .007, vertical_volume, c.vertical_cells), ...
                         ExperimentalCondition.StandardCondition(normal_time, .0053, .022, normal_volume, c.inverted_cells_special2D)];  
%     normal_conditions = ...
%     [ExperimentalCondition.StandardCondition(normal_time, .0053, .022, normal_volume, c.upright_cells), ...
%      ExperimentalCondition.StandardCondition(normal_time, .016, .007, vertical_volume, c.vertical_cells)];
    %normal_conditions = [ExperimentalCondition.StandardCondition(normal_time, .0053, .022, normal_volume, c.no_cells), ... 
     %                    ExperimentalCondition.StandardCondition(normal_time, .0053, .022, normal_volume, c.inverted_cells_special2D)];    
    
                     
                     
    particles = normal_particles;
    conditions = normal_conditions;
    results1DMap = containers.Map();
    results2DMap = containers.Map();

    m = length(conditions);
    n = length(particles);
    fig_per_plot = 0;
    
    %disp(sprintf('####### CONDITION:   %s #######', c.scale_name(scale_type)))
    for p=particles
%             if fig_per_plot
%                 figure
%             else
%                 figure('position', [0,0,700, 900]);
%                 fig_title = sprintf('Concentration profiles for %s - %s', p.name, c.scale_name(scale_type));
%                 suptitle(fig_title);
%             end
        i= 0;        
        for co=conditions                
            i = i+1;
            exp = ExperimentAndParticle(co, p);
            if exp.condition.cell_position == 1
                [min_settle_time, max_settle_time] = exp.calculate_settling_times();

                min_str = cellstr(get_time_strings(1, min_settle_time));
                max_str = cellstr(get_time_strings(1, max_settle_time));
                disp_str = sprintf('Time to sediment %f m for %s: %s - %s', ...
                    exp.condition.height, exp.particle.name, min_str{:}, max_str{:});
                disp(disp_str);
            end

            if 1 %(max_settle_time - min_settle_time) / max_settle_time > .05
%                     if fig_per_plot
%                         figure();
%                     else
%                         subplot(m,1,i);
%                     end            
                disp('=================================');
                if exp.condition.cell_position ~= c.inverted_cells_special2D      
                    result1D = diffusion_sedimentation_pde(exp);
                    results1DMap(exp.name) = {exp, result1D};
                    amnt1D_str = sprintf('%s 1D relative amount removed: %f', exp.name, result1D.amount_removed);
                    disp(amnt1D_str);
                    
                end

                if 1 %exp.condition.cell_position == c.vertical_cells
                 result2D = diffusion_sedimentation_2d_pde(exp, boundary_condition);
                 results2DMap(exp.name) = {exp, result2D};
                 amnt2D_str = sprintf('%s 2D relative amount removed: %f', exp.name, result2D.amount_removed);
                 disp(amnt2D_str);
                end
            end
        end
    end 
    save('diff_sed_pde.mat');
    load 'gong.mat';
    sound(y/30);
end


