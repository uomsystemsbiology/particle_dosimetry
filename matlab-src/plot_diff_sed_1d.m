function [  ] = plot_diff_sed_1d(exp, sim_result)
    x = sim_result.concentration_profile_locations;
    sol = sim_result.concentration_profiles;
    timescale = sim_result.incubation_time;
    title_str = exp.name;

    plot_time_intervals = [1/8, 1/4, 1/2, 1];
    plot_colors = ['g','c','b','k'];
    hold on;

    for i=1:size(plot_time_intervals,2)
        plot(x, sol(round(end*plot_time_intervals(i)), :), plot_colors(i));
    end
    hold off;
    x_axis_label = 'Distance from top';
    if exp.condition.cell_position == c.vertical_cells
        x_axis_label = 'Distance from left';
    end
    
    legend(get_time_strings(plot_time_intervals, timescale),'Location','northwest');
    ylim([0 3]);

%     title_str = strcat(title_str, '     In solution: ', num2str(sim_result.amount_left), ...
%                 '     Removed: ', num2str(sim_result.amount_removed));

    title(title_str);
    xlabel(x_axis_label);
    ylabel('Relative Conc.');
end

