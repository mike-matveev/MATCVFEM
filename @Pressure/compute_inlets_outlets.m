function obj = compute_inlets_outlets(obj)

%% Extract needed mesh information
nodes = obj.mesh_class.nodes;
num_nodes = obj.mesh_class.num_nodes;
boundary_nodes = obj.mesh_class.boundary_nodes;

%% inlet/vent booleans
obj.is_inlet = false(num_nodes,1);
obj.is_vent = false(num_nodes,1);

%% Loop over each boundary node to check for inlet/outlet
for i = 1:length(boundary_nodes)

    node_index = boundary_nodes(i);
    boundary_point = nodes(node_index,:);
    obj.is_inlet(node_index) = obj.inlet_func(boundary_point);
    obj.is_vent(node_index) = obj.vent_func(boundary_point); 
end

obj.is_Dirichlet = obj.is_inlet;

%% Find Neumann boundary nodes
obj.is_Neumann = false(num_nodes,1);
obj.is_Neumann(boundary_nodes) = true;
obj.is_Neumann(obj.is_inlet | obj.is_vent) = false;
obj.is_node_active = obj.is_inlet;
end