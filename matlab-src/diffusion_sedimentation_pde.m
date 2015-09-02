%cell location = 1 - no cells (no flux boundaries)
%cell location = 2 - cells on bottom
%cell location = 3 - cells on top
% cell location = 4 - cells on side

function result = diffusion_sedimentation_pde(exp)
    %x = cat(2, linspace(0, .1, 1000), linspace(.10001, .9, 1000), linspace(.90001,1,1000));
    a = exp.alpha;
    tmax = exp.tmax;
    timescale = exp.condition.timescale;
    cell_location = exp.condition.cell_position;
    x = linspace(0,1,1000);
    t = linspace(0,tmax,100);
    b = -1;
    if cell_location == c.vertical_cells
        b = 0;
    end
    
    y = ones(size(x));
    y(1) = 0;
    y(end) = 2;
    P = polyfit(x,y,10);
    
    
    function u = diff_sed_icfun(x)
        u = polyval(P,x);
    end
    function [c,f,s] = standard_diff_sed_pde(x,t,u,dudx)
        c = 1;
        f = a .* dudx;
        s = b .* dudx;
    end
        
    function [pl,ql,pr,qr] = no_flux_diff_sed_bcfun(xl,ul,xr,ur,t)
        pl = ul;
        ql = -1;
        pr = ur;
        qr = -1;
    end
    function [pl,ql,pr,qr] = bottom_open_diff_sed_bcfun(xl,ul,xr,ur,t)
        pl = ul;
        ql = -1;
        pr = ur;
        qr = 0;
    end
    function [pl,ql,pr,qr] = top_open_diff_sed_bcfun(xl,ul,xr,ur,t)
        pl = ul;
        ql = 0;
        pr = ur;
        qr = -1;
    end
    function [pl,ql,pr,qr] = side_open_no_sed_bcfun(xl,ul,xr,ur,t)
        pl = ul;
        ql = 0;
        pr = 0;
        qr = 1/a;
    end      
    
    
    diff_sed_pde = @standard_diff_sed_pde;
    switch cell_location
        case c.no_cells
            %title_str = strcat(title_str, ', no cells');     
            diff_sed_bcfun = @no_flux_diff_sed_bcfun;
        case c.upright_cells
            %title_str = strcat(title_str, ', upright');
            diff_sed_bcfun = @bottom_open_diff_sed_bcfun;
        case c.inverted_cells
            %title_str = strcat(title_str, ', inverted');
            diff_sed_bcfun = @top_open_diff_sed_bcfun;
        case c.vertical_cells
            %title_str = strcat(title_str, ', vertical (no sedimentation)');
            diff_sed_bcfun = @side_open_no_sed_bcfun; 
        otherwise
            error('Unknown cell orientation');
    end
    
    m = 0;
    options = odeset('AbsTol', 1e-6);
    sol = pdepe(m,diff_sed_pde,@diff_sed_icfun,diff_sed_bcfun,x,t,options);
    final_time_pt_sol = [x; sol(end,:)]';   
    
    amount_left = trapz(final_time_pt_sol(:,1), final_time_pt_sol(:,2));
    amount_gone = 1 - amount_left;
    result = SimulationResult(x, sol, amount_gone, amount_left, timescale);

end



