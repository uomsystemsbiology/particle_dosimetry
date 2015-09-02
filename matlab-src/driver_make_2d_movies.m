function [] = driver_make_2d_movies()
    close all;
    load('diff_sed_pde_constant_concentration.mat');
    time_slices_2d = [0, 1];
    exp_names = keys(results2DMap);
    exp_names = fliplr(exp_names);
    for exp_name = exp_names
        r = results2DMap(char(exp_name));
        exp = r{1};
        sim_result = r{2};
%         figure('position', [0,0,1000,900]);
        fig_title = sprintf('2D Concentration Profiles For %s', exp.particle.name);
        s = suptitle(fig_title);
        s.Position = [0.5000 -0.0200 0];
        num_slices = size(sim_result.concentration_profiles,2);
        time_slices_2d = linspace(0, 1, num_slices);
        i=0;
        %M = zeros(1, num_slices);
        for time_slice = time_slices_2d
            i=i+1;
            plot_diff_sed_2d(exp, sim_result, time_slice, 0, 0);
            M(i) = getframe(gcf);
        end
%         movie(M);
        movie_name = sprintf('%s', strrep(exp.name, '/', '-')); 
        movie2avi(M,movie_name);
    end    
end

