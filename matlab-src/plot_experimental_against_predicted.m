function plot_experimental_against_predicted(real, predicted, name)

    real(:,1) = scale_btw_01(real(:,1));
    integral = trapz(real(:,1), real(:,2));
    real(:,2) = real(:,2) / integral;   
    
    plot(real(:,1), real(:,2), predicted(:,1), predicted(:,2));
    legend('Actual', 'Predicted');
    xlabel('Distance from top of container');
    ylabel('Concentration');
    title(name);
    ylim([0 3]);
end


function plot_experimental_against_predicted2(real, predicted)

    load_struct = load('C:\Dropbox\scienceData\nanoparticle_dosage\177nm-si02-3day-pred.mat.mat');
    predicted = load_struct.time_pts;
    actual = load('C:\Dropbox\scienceData\nanoparticle_dosage\177nmSi02scale2.txt');
    actual(:,1) = scale_btw_01(actual(:,1));
    actual(:,2) = scale_btw_01(actual(:,2));
    actual(:,2) = actual(:,2) / median(actual(:,2));
    
    plot(actual(:,1), actual(:,2), predicted(:,1), predicted(:,2));
    legend('Actual', 'Predicted');
    xlabel('Distance from top of container/ 3.2 cm');
    ylabel('Concentration');
    title('177 nm Si02 concentration profile after 3 days');
    ylim([0 3]);
end

function new_col = scale_btw_01(start_col)
    min_val = min(start_col);
    new_col = (start_col - min_val) / (max(start_col) - min_val);
end