function [] = driver_plot_diff_sed()
    %PRAGMAS FOR COMPILER
    %DONT CHANGE OR REMOVE
    %#function createpde
    %#function Particle
    %#function ExperimentalCondition
    %#function ExperimentAndParticle
    %#function cell_boundary_conditions
    %#function c
    %#function SimulationResult
    
    load('diff_sed_pde.mat');
    fig_1d_plots = length(conditions) - 1;
    
    time_slices_2d = [0, 1];
    fig_2d_rows = length(conditions) - 1;
    fig_2d_plots = length(time_slices_2d) * fig_2d_rows;
    fig_per_plot = 0;
    
    str_contains = @(str, pattern) length(strfind(str, pattern)) > 0;
    sort_order = @(x) -50*str_contains(x,'PMA') + -10*str_contains(x, 'no cells') + -5*str_contains(x,'upright') + -4*str_contains(x,'inverted') + -3*str_contains(x,'vertical');
    exp_names =  union(keys(results1DMap), keys(results2DMap));    
    [~,idx] = sort(cellfun(sort_order, exp_names));
    sorted_exp_names = exp_names(idx);
    
    should_graph = @(x) ~( str_contains(x, 'inverted special'));
    i=0;
    for exp_name = sorted_exp_names
        if isKey(results1DMap, char(exp_name)) && should_graph(char(exp_name))
            r = results1DMap(char(exp_name));
            exp = r{1};
            sim_result = r{2};
            if i == 0
                figure('position', [0,0,1000,900]);
                fig_title = sprintf('1D Concentration Profiles For %s', exp.particle.name);
                s = suptitle(fig_title);
                s.Position = [0.5000 -0.0200 0];
            end 
            i = i+1;        
            if fig_per_plot
                figure();
            else
                subplot(fig_1d_plots, 1, i);
            end
            plot_diff_sed_1d(exp, sim_result);
            if i == fig_1d_plots
               i = 0;
            end
        end
    end
    
    i=0;
    for exp_name = sorted_exp_names
        if isKey(results2DMap, char(exp_name)) && should_graph(char(exp_name))
            r = results2DMap(char(exp_name));
            exp = r{1};
            sim_result = r{2};
            if i == 0
                figure('position', [0,0,1000,900]);
                fig_title = sprintf('2D Concentration Profiles For %s', exp.particle.name);
                s = suptitle(fig_title);
                s.Position = [0.5000 -0.0200 0];
            end 
            for time_slice = time_slices_2d
                i=i+1;
                if fig_per_plot
                    figure();
                else
                    subplot(fig_2d_rows, length(time_slices_2d), i);
                end
                plot_diff_sed_2d(exp, sim_result, time_slice, 0, 0);
            end

            if i == fig_2d_plots                
                i = 0;
            end
        end
    end
    
    base_1D_exp = 'wrong'; 
    base_2D_exp = 'wrong';
    %for sorting
    for exp_name = keys(results1DMap)
        exp_name = char(exp_name)
        if (str_contains(exp_name, 'PMA') && str_contains(exp_name, 'upright')) || ...
            (str_contains(exp_name, 'Non-PEG') && str_contains(exp_name, '15nm')) || ...
            (str_contains(exp_name, '190nm Calcium Phosphate'))
            r = results1DMap(exp_name);
            base_1D_exp = r{1};
            base_2D_exp = base_1D_exp;
            break
        end
    end   
    if strcmp('wrong', base_1D_exp) || strcmp('wrong', base_2D_exp)
        error('Couldn''t find base particle x condition, likely name was changed')
    end    
    
    
    %for scale_type = [c.no_spatial_scale, c.len_scale c.volume_scale, c.volume_and_surface_area_scale]
    for scale_type = [c.volume_scale, c.volume_and_surface_area_scale]
        disp(sprintf('####### CONDITION:   %s #######', c.scale_name(scale_type)))
        for exp_name = sorted_exp_names
            if isKey(results1DMap, char(exp_name))
                r = results1DMap(char(exp_name));
                exp = r{1};
                sim_result = r{2};
                scaled_amount = SimulationResult.scaled_amount(scale_type, sim_result.amount_removed, exp, base_1D_exp);
                disp(sprintf('%s 1D amount removed:                             %f', exp.name, scaled_amount));
            end
            if isKey(results2DMap, char(exp_name))
                r = results2DMap(char(exp_name));
                exp = r{1};
                sim_result = r{2};
                scaled_amount = SimulationResult.scaled_amount(scale_type, sim_result.amount_removed, exp, base_2D_exp);
                disp(sprintf('%s 2D amount removed:                             %f', exp.name, scaled_amount));
            end
        end
        disp(' ====================================');
    end
end

