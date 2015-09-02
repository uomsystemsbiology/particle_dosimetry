function result = diffusion_sedimentation_2d_pde(experiment_and_particle, cell_boundary_condition)
    width = experiment_and_particle.condition.width;
    height = experiment_and_particle.condition.height;
    diff_coeff = experiment_and_particle.diff_coeff;
    sed_velocity = experiment_and_particle.sed_velocity;
    timescale = experiment_and_particle.condition.timescale;
    particle_removal_speed = 9999999;
    z = particle_removal_speed / sed_velocity;
    
    %hmax = .0001;
    hmax = .00005;
    timepts = 100;
    
    model = createpde;
    %create geometry
    rect = [3; 4; 0; 0; width; width; 0; height; height; 0];
    shapes = [rect];
    [dl, bt] = decsg(shapes);   
    
    applyBoundaryCondition(model, 'Edge', [1,3], 'g', 0, 'q', 0);
    applyBoundaryCondition(model, 'Edge', [4], 'g', 0, 'q', -1);
    applyBoundaryCondition(model, 'Edge', [2], 'g', 0, 'q', 1);

    switch experiment_and_particle.condition.cell_position
        case c.no_cells
            ;
        case c.upright_cells
            switch cell_boundary_condition
                case cell_boundary_conditions.constant_concentration_zero
                    applyBoundaryCondition(model, 'Edge', [4], 'u', 0);
                case cell_boundary_conditions.cell_flux_out
                    applyBoundaryCondition(model, 'Edge', [4], 'g', 0, 'q', z-1);
            end
        case c.inverted_cells
            switch cell_boundary_condition
                case cell_boundary_conditions.constant_concentration_zero
                    applyBoundaryCondition(model, 'Edge', [2], 'u', 0);
                case cell_boundary_conditions.cell_flux_out
                    applyBoundaryCondition(model, 'Edge', [2], 'g', 0, 'q', z+1);                    
            end

        case c.inverted_cells_special2D %something wrong
            p_w = width -.002;
            p_h = .0001;
            p_x = .001;
            p_y = .002;
            cell_platform_rect = [3;4; p_x;p_x; p_x+p_w;p_x+p_w; p_y;p_y+p_h; p_y+p_h;p_y];
            shapes = [rect, cell_platform_rect];
            ns = char('R1','C1');
            ns = ns';
            [dl, bt] = decsg(shapes, 'R1-C1', ns);

            applyBoundaryCondition(model, 'Edge', [6,8,4,2], 'g', 0, 'q', 0);
            applyBoundaryCondition(model, 'Edge', [3,7], 'g', 0, 'q', -1);        
            applyBoundaryCondition(model, 'Edge', [1], 'g', 0, 'q', 1);
            %cell boundary
            switch cell_boundary_condition
                case cell_boundary_conditions.constant_concentration_zero
                    applyBoundaryCondition(model, 'Edge', [5], 'u', 0);
                case cell_boundary_conditions.cell_flux_out
                    applyBoundaryCondition(model, 'Edge', [5], 'g', 0, 'q', z+1);                    
            end
            
        case c.vertical_cells
            switch cell_boundary_condition
                case cell_boundary_conditions.constant_concentration_zero
                    applyBoundaryCondition(model, 'Edge', [1], 'u', 0);
                case cell_boundary_conditions.cell_flux_out
                    applyBoundaryCondition(model, 'Edge', [1], 'g', 0, 'q', z);                    
            end
                
        otherwise
            error('Unknown cell position!');
    end
       
    geometryFromEdges(model, dl);    
    generateMesh(model, 'Hmax', hmax); %, 'MesherVersion','R2013a');
    p = model.Mesh.Nodes;
    %u0 = zeros(size(p,2),1);
    %ix = find(sqrt(p(1,:).^2 + p(2,:).^2) < 0.001); 
    %u0(ix) = 10 .* ones(size(ix));
    u0 = ones(size(p,2),1);
%     u0(1) = 999999;
%     u0(size(p,2)) = -999999;
    
    d = 1 / sed_velocity;
    c = diff_coeff / sed_velocity;
    a = 0;
    f = 'uy';
    
    tlist = linspace(0, timescale, timepts);
    u = parabolic(u0, tlist, model, c, a, f, d, 'Stats', 'off');
    init_int = integrate_pde_model(model, u);
    
    amount_left = integrate_pde_model(model, u(:,timepts)) / integrate_pde_model(model, u(:,1));
    amount_gone = 1 - amount_left;
    result = SimulationResult(model, u, amount_gone, amount_left, timescale);
    
end

