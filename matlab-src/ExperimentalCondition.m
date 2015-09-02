classdef ExperimentalCondition
    %EXPERIMENTALCONDITION Summary of this class goes here
    %   Detailed explanation goes here
   
    properties
        medium_visc
        medium_density
        medium_absolute_permittivity   
        temp        
        timescale        
        height
        width
        volume        
        cell_position
    end
    
    methods (Static)
        function cond = StandardCondition(time, height, width, volume, cell_position)
            cond = ExperimentalCondition();
            cond.medium_visc = .00101;
            cond.medium_density = 1000;
            cond.medium_absolute_permittivity = 80 * c.vacuum_permittivity;
            cond.temp = 310.15;
            cond.timescale = time;
            cond.height = height;
            cond.width = width;
            cond.volume = volume;
            cond.cell_position = cell_position;
        end        
        
    end

end

