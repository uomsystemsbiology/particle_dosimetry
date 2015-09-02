classdef SimulationResult
    %SIMULATIONRESULT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        concentration_profile_locations
        concentration_profiles
        amount_removed
        amount_left
        incubation_time 
    end
    
    methods
        function result = SimulationResult(concentration_profile_locations, concentration_profiles, amount_removed, amount_left, incubation_time)
           result.concentration_profile_locations = concentration_profile_locations;
           result.concentration_profiles = concentration_profiles;
           result.amount_removed = amount_removed;
           result.amount_left = amount_left;
           result.incubation_time = incubation_time;
        end        
    end
    
    methods (Static)
        function scaled = scaled_amount(scale_type, amount, exp, base_exp)
            normalized_scale = exp.calculate_scale_factor(scale_type) / base_exp.calculate_scale_factor(scale_type);
            scaled = amount * normalized_scale;
        end        
    end
end

