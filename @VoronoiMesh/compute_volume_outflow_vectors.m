function obj = compute_volume_outflow_vectors(obj)

nodes = obj.Delaunay_mesh_class.nodes;
elements = obj.Delaunay_mesh_class.elements;
centroids = obj.Delaunay_mesh_class.centroids;

%% compute midpoints on triangular elements
a = (nodes(elements(:,1),:) + nodes(elements(:,2),:))/2;
b = (nodes(elements(:,2),:) + nodes(elements(:,3),:))/2;
c = (nodes(elements(:,3),:) + nodes(elements(:,1),:))/2;

%% compute outward triangle element normals
n1 = [centroids(:,2)-a(:,2) a(:,1)-centroids(:,1)];
n2 = [centroids(:,2)-b(:,2) b(:,1)-centroids(:,1)];
n3 = [centroids(:,2)-c(:,2) c(:,1)-centroids(:,1)];

%% outlfow and inflow vectors for each control volume
n31 = n3 - n1;
n12 = n1 - n2;
n23 = n2 - n3;

%% outward flows for each control volume in this triangle
obj.volume_outflow_vectors = [n31 n12 n23];

end