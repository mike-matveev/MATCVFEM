function obj = compute_shape_fun_gradients(obj)

num_elements = obj.mesh_class.num_elements;

obj.shape_fun_gradients = cell(num_elements,1);

for i = 1:num_elements

    element_nodes = obj.mesh_class.elements(i,:);
    element_area = obj.mesh_class.element_areas(i);

    x = obj.mesh_class.nodes(element_nodes,1); 
    y = obj.mesh_class.nodes(element_nodes,2);
    

    grad_phi = [y(2)-y(3) y(3)-y(1) y(1)-y(2);... 
                x(3)-x(2) x(1)-x(3) x(2)-x(1)]/2/element_area;

    obj.shape_fun_gradients{i} = grad_phi;
end

end