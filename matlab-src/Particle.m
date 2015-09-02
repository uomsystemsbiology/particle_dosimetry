classdef Particle
    %PARTICLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name;
        radius;
        density;
        zeta_potential;
        volume;
        surface_area;
        weight;
        concentration;
    end        
    
    methods
        function prt = Particle(name, radius, density, zeta_potential, concentration)
            prt.name = name;
            prt.radius = radius;
            prt.density = density;
            prt.zeta_potential = zeta_potential;            
            prt.volume = prt.calculateVolume();
            prt.weight = prt.calculateWeight();
            prt.surface_area = prt.sphere_surface_area();
            prt.concentration = concentration;
        end
        function vol = calculateVolume(obj)
            vol = obj.radius ^ 3 * 4/3 * pi;
        end
        function wt = calculateWeight(obj)
            wt = obj.volume * obj.density;
        end
        function surface_area = sphere_surface_area(obj)
            surface_area = 4 * pi * obj.radius * obj.radius;
        end
        function r = eq(a, b)
            r = strcmp(a.name, b.name) && a.radius == b.radius && ...
                a.density == b.density && a.zeta_potential == b.zeta_potential && ...
                a.volume == b.volume && a.surface_area == b.surface_area && ...
                a.weight == b.weight && a.concentration == b.concentration;
        end
        function r = ne(a,b)
            r = ~(a == b);             
        end        
    end
    
    methods (Static)
        function prt = SilicaParticle(radius)
            prt_name = strcat(num2str(radius),'m Si02');
            prt = Particle(prt_name, radius, 2648, -35.2e-3, 1);        
        end
    end
end

