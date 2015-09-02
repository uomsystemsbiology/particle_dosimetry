function int_val = integrate_pde_model(model, u)
    int_val = trapz(u);
    %int_val = sum(mean(u(model.Mesh.Elements)));
    int_val = 0;
    
    for counter=1:length(model.Mesh.Elements)
        nodes = model.Mesh.Elements(:,counter);
        node_coords = model.Mesh.Nodes(:, nodes);
        a = polyarea(node_coords(1,:), node_coords(2,:));
        avg_val = mean(u(nodes));
        element_integral = a * avg_val;
        int_val = int_val + element_integral;
    end
        
        
%         
%         
%         
%     end
    %for counter 
    
end

