function driver_plot_size_density_differences
    %load('size_density_24hr.mat');
    %max_sizes = zeros(1, length(densities));
    label_font_size = 12;
    
    plotline = @(ax, xpos) line([xpos,xpos], [ax.YLim(1), 0.85*ax.YLim(2)], 'Color', 'black', 'LineStyle', ':');
    label_top_of_line = @(ax, label_name, position) text(position, 0.85*ax.YLim(2), label_name, 'rotation', 30, 'FontSize', label_font_size);
    
    plot_size_density_differences('size_density_24hr_2d_5in_cube.mat')
    ylim([0 100e-9]);
    xlim([1000 20000]);
    ax = gca;    
    ax.XTick = [1000, linspace(2500, 20000, 8)];
    ax.XTickLabel = [1000, linspace(2500, 20000, 8)];
    ax.YTick = [1e-9, 10e-9, 25e-9, 50e-9, 75e-9, 100e-9];
    ax.YTickLabel = ax.YTick * 1e9;      
    
    plotline(ax, 2200);
    label_top_of_line(ax, 'Silica', 2200);
    plotline(ax,4230);
    label_top_of_line(ax, 'Titania', 4230);
    plotline(ax,5240);
    label_top_of_line(ax, 'Iron Oxide', 5240);
    plotline(ax, 10490);
    label_top_of_line(ax, 'Silver', 10490);
    plotline(ax, 19320);
    label_top_of_line(ax, 'Gold', 19320);
    
    
    figure;    
    plot_size_density_differences('size_density_24hr_2d_5in_cube.mat')  
    ylim([0 300e-9]);
    xlim([1000 2000]);
    ax = gca;
    ax.XTick = linspace(1000, 2000, 11);
    ax.XTickLabel = linspace(1000, 2000, 11);
    ax.YTick = linspace(0, 300e-9, 6);
    ax.YTickLabel = ax.YTick * 1e9;
      
    
    plotline(ax, 1128);
    label_top_of_line(ax, 'PEG', 1128);
    plotline(ax, 1050);
    label_top_of_line(ax, 'Polystyrene', 1050);
    plotline(ax, 1180);
    label_top_of_line(ax, 'PMA', 1180);

    plotline(ax, 1340);
    label_top_of_line(ax, 'PLGA', 1340);
    
    plotline(ax, 1530);
    label_top_of_line(ax, 'PGA', 1530);
    hold on;
    marker_color = [247 71  26] ./ 255;
    plot([1060,1650], [200e-9/2, 250e-9/2],'o','markersize', 7,'MarkerEdgeColor','flat','MarkerFaceColor',marker_color);
    text(1080, 200e-9/2, 'Capsule', 'FontSize', label_font_size);
    text(1670, 250e-9/2, 'Core-shell', 'FontSize', label_font_size);
    
    %plot(plot_densities, plot_sizes, 'b');
    %hold on;    
    %plot([1060,1650], [200e-9/2, 250e-9/2], 'ro');
    
    

    hold off;    
    
end

    
    