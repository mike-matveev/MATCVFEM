function obj = compute_element_centroids(obj)

obj.centroids = zeros(obj.num_elements,2);

for i =1:obj.num_elements
    %% centroid of triangle formula
    obj.centroids(i,:) = mean(obj.nodes(obj.elements(i,:),:));
end

end