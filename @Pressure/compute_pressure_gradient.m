function obj = compute_pressure_gradient(obj)

obj.pressure_gradient = zeros(obj.mesh_class.num_elements,2);

elements = obj.mesh_class.elements;
num_elements = obj.mesh_class.num_elements;

for i = 1:num_elements 
    
    local_pressure = obj.pressure(elements(i,:));
    grad_phi = obj.shape_fun_gradients{i};

    obj.pressure_gradient(i,:) = (grad_phi * local_pressure)';
end

end