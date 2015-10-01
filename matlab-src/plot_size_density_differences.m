function plot_size_density_differences(data_file)
    %PRAGMAS FOR COMPILER
    %DONT CHANGE OR REMOVE
    %#function Particle
    %#function ExperimentalCondition
    %#function ExperimentAndParticle
    %#function cell_boundary_conditions
    %#function c
    %#function SimulationResult

    load(data_file);
    colors = [ [175 175 247]; [100 100 247]; [25 25 247]] ./ 255;
    cutoff_ratios = [0.8 0.9 0.95];
    vu_ratio = vertical_results ./ upright_results;
    %cutoff_ratios = [1.2 1.1 1.05];
    %vu_ratio = upright_results ./ vertical_results;

    %colors = [[1 0 0]; [0 1 0]; [0 0 1]];
    colors = [ [175 175 247]; [100 100 247]; [25 25 247]] ./ 255;
    %colors = [[180 51 0]; [25, 163, 25]; [50 50 50]] ./ 255;
    %colors = [[120 200 247]; [100 180 247]; [82 164 247]] ./ 255;
    %colors = [[.25 .25 1]; [.25 .25 200/255]; [.25 .25 100/255]];   
    hold on;    
    for i = 1:length(cutoff_ratios)
        cutoff_ratio = cutoff_ratios(i);
        color = colors(i,:);
        k = 1;
        plot_densities = 0;
        plot_sizes = 0;
        for j=1:length(density_range)
            for i=length(size_range):-1:1
                if vu_ratio(i,j) > cutoff_ratio
                    possible_size = size_range(i-1);
                    if k == 1 || j == length(density_range) || possible_size ~= plot_sizes(k-1)
                        plot_densities(k) = density_range(j);
                        plot_sizes(k) = possible_size;
                        k = k+1;                    
                    end
                    break
                end
            end
        end
        a = area(plot_densities, plot_sizes);
        a.FaceColor = color;
        a.EdgeColor = 'none';
    end
    hold off;
    xlabel('Density (kg/m^{3})');
    ylabel('Radius (nm)');
    l = legend('<20%', '<10%', '<5%');
    l.Position(1) = 0.95 * l.Position(1);
    set(gca, 'TickDir', 'out')
    
end

    
    
