classdef c
    properties(Constant = true)
        g = 9.80665;
        vacuum_permittivity = 8.85418782e-12;
        kb = physconst('Boltzmann');
        avo_no = 6.022e23;
        ele_charge = 1.602e-19;
        no_cells = 1
        upright_cells = 2
        inverted_cells = 3
        vertical_cells = 4
        inverted_cells_special2D = 5
        
        no_spatial_scale = 1
        len_scale = 2
        volume_scale = 3
        volume_and_surface_area_scale = 4  
    end
    
    methods (Static)
        function name = scale_name(scale_type)
            switch scale_type
                case c.no_spatial_scale
                    name = 'No spatial scale';
                case c.len_scale
                    name = 'Length (from cells) scale';
                case c.volume_scale
                    name = 'Volume of media scale';
                case c.volume_and_surface_area_scale
                    name = 'Volume and Surface area scale';
                otherwise
                    error('Unknown scale type');
            end
        end         
    end
end
