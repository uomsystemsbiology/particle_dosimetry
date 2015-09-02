function driver_closed_container_plots
    data_folder = 'C:\Dropbox\scienceData\nanoparticle_dosage\pixel_intensities\';
    listing = dir(data_folder);
    for i=1:length(listing)
        
        params = strsplit(listing(i).name,'-');
        if(length(params) >5 )
            name = params{1};
            radius = str2num(params{2})/2 * 10^-9;
            density = str2num(params{3});
            z_pot = str2num(params{4}) * 10^-2;
            time = str2num(params{5}) * 60;
            particle = Particle(name, radius, density, z_pot, 1);
            cond = ExperimentalCondition.StandardCondition(time, .032, 1);
            exp = ExperimentAndParticle(cond, particle, 10);
            actual = load(fullfile(data_folder, listing(i).name));
            predicted = diffusion_sedimentation_pde(exp.alpha, exp.tmax, ...
                    exp.condition.timescale, exp.condition.cell_position, '', 0,1);
            time_desc = get_time_strings(1, time);
            graph_name = sprintf('Concentration profile for %s - (%s)', name, time_desc{1});
            figure();
            plot_experimental_against_predicted(actual, predicted.concentration_profile, graph_name);
        end
    end
end