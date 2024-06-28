function obj = compute_connectivity(obj)

%% Unpack the arguments
elements = obj.Delaunay_mesh_class.elements;
num_node = obj.Delaunay_mesh_class.num_nodes;

%%
nelem = size(elements,1);
totalEdge = [elements(:,[2,3]); elements(:,[3,1]); elements(:,[1,2])];
has_node_i = zeros(num_node,8);
has_node_i_size = zeros(num_node,1);

%% find elements containing the node i and store them in has_node_i
for i = 1 : nelem
    node_1 = elements(i,1);
    node_2 = elements(i,2);
    node_3 = elements(i,3);

    has_node_i_size(node_1) = has_node_i_size(node_1)+1;
    has_node_i(node_1,has_node_i_size(node_1)) = i;
    has_node_i_size(node_2) = has_node_i_size(node_2)+1;
    has_node_i(node_2,has_node_i_size(node_2)) = i;
    has_node_i_size(node_3) = has_node_i_size(node_3)+1;
    has_node_i(node_3,has_node_i_size(node_3)) = i;
end
has_node_i = [has_node_i_size has_node_i];

%% Cnode is a sparse matrix with entries that are the element that contains 
%% edge between two nodes. 
Cnode = sparse(totalEdge(:,1),totalEdge(:,2),[1:nelem 1:nelem 1:nelem]',num_node,num_node);

connnected_polygons = cell(num_node,1);
for i = 1 : num_node
    connnected_polygons{i} = find(Cnode(:,i));
end

% Celem is a connectivity matrix between elements. If two elements share an
% edge then the corresponding values in Celem is an index of that edge.
icelem = zeros(3*nelem,1);
jcelem = zeros(3*nelem,1);
kcelem = zeros(3*nelem,1);
celem_index = 1;

% iteration over edges
for i = 1 : 3*nelem
    row = totalEdge(i,1);
    col = totalEdge(i,2);
    
    temp = Cnode(col,row);
    if temp ~= 0 
        icelem(celem_index) = Cnode(row,col);
        jcelem(celem_index) = temp;
        kcelem(celem_index) = i;
        celem_index = celem_index + 1;
        
    end
end
celem_index = celem_index - 1;
Celem = sparse(icelem(1:celem_index),jcelem(1:celem_index),kcelem(1:celem_index),nelem,nelem);

%% package up the outputs
obj.node_connectivity = Cnode;
obj.element_connectivity = Celem;
obj.has_node_i = has_node_i;
obj.connected_polygons = connnected_polygons;

end