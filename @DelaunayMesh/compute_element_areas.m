function obj = compute_element_areas(obj)

obj.element_areas = zeros(obj.num_elements,1);

for i = 1:obj.num_elements
    
    %% vectors of x,y coordinates of element nodes
    x = obj.nodes(obj.elements(i,:),1);
    y = obj.nodes(obj.elements(i,:),2);
    
    %% area formula for a polygon
    area = 0.5*abs(x'*circshift(y,-1) - circshift(x,-1)'*y);
    obj.element_areas(i) = area;
end

end