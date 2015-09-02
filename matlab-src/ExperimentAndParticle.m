classdef ExperimentAndParticle
    %EXPERIMENTANDPARTILCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        condition
        particle
        diff_coeff
        sed_velocity
        alpha
        tmax
        surface_potential
        kappa
        name
    end
    
    methods
        function obj = ExperimentAndParticle(condition, particle)
            obj.condition = condition;
            obj.particle = particle;
            obj.diff_coeff = obj.calculate_physical_diff_coeff();
            obj.sed_velocity = obj.calculate_sedimentation_velocity();
            obj.alpha = obj.calculate_alpha();
            obj.tmax = obj.calculate_tmax();
            obj.surface_potential = obj.particle.zeta_potential;
            obj.kappa = obj.calculate_screening_parameter();
            %obj.scale_type = scale_type;
            %obj.scale_factor = obj.calculate_scale_factor();
            obj.name = obj.get_name();
        end
        
        function diff_coeff = calculate_physical_diff_coeff(obj)
            diff_coeff = c.kb .* obj.condition.temp ./ (6 .* pi .* obj.condition.medium_visc .* obj.particle.radius);
        end
        
        function sed_vel = calculate_sedimentation_velocity(obj)
            r = obj.particle.radius;
            d = obj.particle.density;
            md = obj.condition.medium_density;
            vc = obj.condition.medium_visc;
            sed_vel = 2 * c.g * (d - md) * r * r / (9 * vc);
        end  
        
        function name = get_name(obj)
            switch obj.condition.cell_position
                case c.no_cells
                    name = sprintf('%s, no cells', obj.particle.name);
                case c.upright_cells
                    name = sprintf('%s, upright', obj.particle.name);
                case c.inverted_cells
                    name = sprintf('%s, inverted', obj.particle.name);
                case c.inverted_cells_special2D
                    name = sprintf('%s, inverted special 2D', obj.particle.name);
                case c.vertical_cells
                    name = sprintf('%s, vertical', obj.particle.name);
                otherwise
                    error('Unknown cell position');
            end
        end
                
        function len = calculate_len(obj)
            
            switch obj.condition.cell_position
                case {c.no_cells, c.upright_cells, c.inverted_cells, c.inverted_cells_special2D}
                    len = obj.condition.height;
                case c.vertical_cells
                    len = obj.condition.width;
                otherwise
                    error('Unknown cell position');
            end
        end
        
        function alpha = calculate_alpha(obj)
            len = obj.calculate_len();
            alpha = obj.diff_coeff/(obj.sed_velocity * len);
        end
        
        function scale_factor = calculate_scale_factor(obj, scale_type)
            %this will vary by experiment type and how particles were
            %prepared
            switch scale_type
                case c.no_spatial_scale
                    scale_factor = obj.particle.concentration;
                case c.len_scale
                    scale_factor = obj.particle.concentration * obj.calculate_len();
                case c.volume_scale
                    scale_factor = obj.particle.concentration * obj.condition.volume;
                case c.volume_and_surface_area_scale
                    scale_factor = obj.particle.concentration * obj.condition.volume * obj.particle.surface_area;
                otherwise
                    error('Unknown scale type')
            end
        end
        
        function tmax = calculate_tmax(obj) 
            len = obj.calculate_len();
            tmax = obj.condition.timescale * obj.sed_velocity / len;
        end
        
        function [min_dist, max_dist] = calculate_settling_distances(obj)
            %min dist assumes diffusion worked entirely against sedimentation
            %max dist assumes no diffusion
            max_dist = obj.sed_velocity .* obj.condition.time;
            diff_dist = sqrt(2 .* obj.diff_coeff .* obj.condition.time);
            min_dist = max_dist - diff_dist;
        end
        
        function [min_time, max_time] = calculate_settling_times(obj)
            %CALCULATE_SETTLING_TIMES 
            %min time assumes no diffusion
            %max time assumes diffusion worked entirely against sedimentation
            len = obj.calculate_len();
            min_time = len / obj.sed_velocity;

            D = obj.diff_coeff;
            v = obj.sed_velocity;
            d = len;

            c = [v^2/(2*D), -1 * (d*v/D+1), d^2/(2*D)];
            troots = roots(c);

            max_time = max(troots);
            end
        
        %not using any of the below functions
        function kappa = calculate_screening_parameter(obj)
            % typically on the order of nms

            %this is the concentration of monovalent ions.  used DMEM 
            % concentration of sodium bicarbonate, which is 3.7 g/L
            % CHECK CHECK CHECK
            sodium_bicarbonate_conc = (3.7 / 0.084007); %mol/m^3

            %sodium_bicarbonate_number_density = c.avo_no * sodium_bicarbonate_conc;
            %ionic_strength = sodium_bicarbonate_number_density * 2; % number density

            %phosphate buffered saline calculation
            phosphate_conc = 0.01; %M (moles/L) 
            potassium_chloride_conc = .0027; %M (moles/L) 
            sodium_chloride_conc = .137; %M (moles/L)    
            density_and_ionic_strength = c.avo_no * 1000 * ...
                (phosphate_conc * 3^2 + potassium_chloride_conc * 2 + ...
                 sodium_chloride_conc * 2);

            k2 = (4 * pi * c.ele_charge * c.ele_charge) / ...
               (obj.condition.medium_absolute_permittivity * c.kb * obj.condition.temp) ...
                * (density_and_ionic_strength );
            kappa = sqrt(k2);
            %syms z0 k2
            %syms k2 positive
            %eq1 = z0 == surface_potential * (1+sqrt(k2)*radius) * ...
            %    c.medium_absolute_permittivity * radius / c.ele_charge;
            %eq2 = k2 == (4 * pi * c.ele_charge * c.ele_charge) / ...
            %    (c.medium_absolute_permittivity * c.kb * c.temp) ...
            %    * (density_and_ionic_strength + c.particle_number / c.media_volume * (z0^2) );
            %Y = vpasolve([eq1,eq2],[z0,k2]);
            %kappa = double(sqrt(Y.k2));

        end
        
        function kappa = calculate_inverse_debye_length(obj)

            phosphate_conc = 0.01; %M (moles/L) 
            potassium_chloride_conc = .0027; %M (moles/L) 
            sodium_chloride_conc = .137; %M (moles/L)    
            ionic_strength = 0.5 * 1000 * ...
                (phosphate_conc * 3^2 + potassium_chloride_conc * 2 + ...
                 sodium_chloride_conc * 2); 
            kappa_inv  = sqrt( obj.condition.medium_absolute_permittivity * c.kb * obj.condition.temp ...
                / (2 * c.avo_no * c.ele_charge^2 * ionic_strength));
            kappa = kappa_inv ^ -1;

        end
        
        function lambda = calculate_diffusion_lambda(obj)
            r = obj.particle.radius;
            ka = obj.kappa * r;   
            sp = obj.surface_potential;

            lambda = 1.45 + sp * sp * ...
                obj.condition.medium_absolute_permittivity * r / (c.kb * c.temp) ...
                * (1 + ka) * 3 / (ka * ka);
        end

        function vf = calculate_volume_fraction(obj)
            total_particle_volume = obj.particle.volume * obj.number_of_particles;
            vf = total_particle_volume/obj.condition.volume;
        end

        function sed_vel_fraction = calculate_sedimentation_velocity_fraction(obj)
            vf = obj.calculate_volume_fraction();
            k = obj.kappa;
            
            %doing something different then the paper here, NEED TO CHECK
            sed_vel_fraction =  1 - (6.54 + obj.surface_potential * obj.surface_potential ...
                * obj.condition.medium_absolute_permittivity * 3 / (c.kb * obj.condition.temp * k)) * vf;

        end      
                
    end
    
end

