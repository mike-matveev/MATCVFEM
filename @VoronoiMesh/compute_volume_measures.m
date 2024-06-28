function obj = compute_volume_measures(obj,thickness)
            
obj.volume_measures = zeros(obj.Delaunay_mesh_class.num_nodes,1);

for i = 1:obj.Delaunay_mesh_class.num_elements
    
    element_area = obj.Delaunay_mesh_class.element_areas(i);
    control_volumes = obj.Delaunay_mesh_class.elements(i,:);
    sub_volume_measures = element_area/3 * thickness *ones(3,1);
    obj.volume_measures(control_volumes) = obj.volume_measures(control_volumes) + sub_volume_measures;
end
end