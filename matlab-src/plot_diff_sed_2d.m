function [] = plot_diff_sed_2d(exp, sim_result, time_slice, show_boundary, show_mesh)

    model = sim_result.concentration_profile_locations;
    
    if show_boundary 
        pdegplot(model,'EdgeLabels','on');
        figure();
    end
    if show_mesh
        pdemesh(model, 'NodeLabels','on');    
        figure();
    end
    
    u = sim_result.concentration_profiles;
    time_name = char(get_time_strings((time_slice), exp.condition.timescale));
    
    pdeplot(model,'xydata', u(:,max(1, round(end*time_slice))));
    title(sprintf('%s, %s', exp.name, time_name));
    width_range = [0, exp.condition.width];
    height_range = [0, exp.condition.height];
    
    ax = gca;
    ax.XTick = linspace(width_range(1), width_range(2), 3);
    ax.YTick = linspace(height_range(1), height_range(2), 3);
    ax.XTickLabel = ax.XTick .* 1000;
    ax.YTickLabel = ax.YTick .* 1000;
    xlabel('Width (mm)');
    ylabel('Height (mm)');
           
    xlim([0, exp.condition.width]);
    ylim([0, exp.condition.height]);
    caxis([0 2]);
    h = colorbar;
    h.Ticks = [0 1 2];
    h.TickLabels = {'Low', 'Medium', 'High' };
 
end

