function obj = update_computational_domain(obj)

%% unpacking
active_elements = obj.active_elements;
is_node_active = obj.pressure_class.is_node_active;
elem = obj.Delaunay_mesh_class.elements;
nnode = obj.Delaunay_mesh_class.num_nodes;
new_filled_volume = obj.new_filled_volume;
has_node_i = obj.Voronoi_mesh_class.has_node_i;
neumann_flag = obj.pressure_class.is_Neumann;
fFactor = obj.volume_fill_percentage;

nelem = size(elem,1);
newActiveElement = zeros(nelem,1);
candidate_elem = zeros(nelem,1);
bnd_node = zeros(nnode,1);
Dirichlet = zeros(nnode,1);

% Update the activeElement array
for i = 1 : length(new_filled_volume)
    ni = new_filled_volume(i);
    for j = 2 : has_node_i(ni,1)+1
        candidate_elem(has_node_i(ni,j)) = 1;
    end
end
newActiveElement(active_elements<1 & candidate_elem ==1) = 1;
elems = elem(newActiveElement==1,:);
is_node_active(elems(:))=1;
active_elements = min(ones(nelem,1),active_elements + newActiveElement);

aelem = elem(active_elements==1,:);

total_edge = [aelem(:,[2 3]); aelem(:,[3,1]); aelem(:,[1,2])];


Cnode = sparse(total_edge(:,1), total_edge(:,2),1,nnode,nnode);
[r,c] = find(Cnode-Cnode');
bnd_node([r;c]) = 1;

bnd_idx = find(bnd_node>0);

for i = 1:length(bnd_idx)
    bnd_idx_i = bnd_idx(i);
    if ~neumann_flag(bnd_idx_i)
        Dirichlet(bnd_idx_i)=1;
    else % We make the intersection between flow front and wall Dirichelt
        if sum(active_elements(has_node_i(bnd_idx_i,2:has_node_i(bnd_idx_i,1)+1)))<has_node_i(bnd_idx_i,1)
            Dirichlet(bnd_idx_i) = 1;
        end
    end
end
Dirichlet(fFactor>0&fFactor<1) = 1;

%% Repacking
obj.pressure_class.is_node_active = is_node_active;
obj.active_elements = active_elements;
obj.pressure_class.new_active_elements = newActiveElement;
obj.pressure_class.is_Dirichlet = Dirichlet;

%% set Dirichlet BC values
obj.pressure_class.pressure = obj.pressure_class.p_D(obj.pressure_class);

end
