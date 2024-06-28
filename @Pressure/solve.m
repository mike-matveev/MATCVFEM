function obj = solve(obj)

%% build/update FEM stiffness matrix
obj = obj.assemble_stiffness_matrix();

%% impose dirichlet boundary conditions
free = obj.is_node_active & ~obj.is_Dirichlet; fixed = ~free;
b_free = obj.load_vector(free) - ...
                      obj.stiffness_matrix(free,fixed)*obj.pressure(fixed);
A_free = obj.stiffness_matrix(free,free);

%% solve matrix equation for pressure
obj.pressure(free) = A_free\b_free;

%% compute gradient of FEM solution
obj = obj.compute_pressure_gradient();
end