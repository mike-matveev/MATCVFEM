classdef RTMFlow

    %% Method class to store algorithms, steps and properties of the CVFEM:
    % The RTM-flow class store the components of the control volume finite
    % element method. This includes classes for the mesh, pressure FEM
    % solver, volume FV solver, darcy flow, visualisation & extra options.

    properties

        Delaunay_mesh_class;
        pressure_class;
        Voronoi_mesh_class;
        velocity_class;
        physics_class;
        visualise_class;

        time;
        time_step;

        %% Tracking volumes filled
        volume_fill_percentage;
        volume_filling_times;
        volume_rates_of_flow;
        new_filled_volume;
        active_elements;

    end % end properties

    methods
    %% CVFEM class methods

    function obj = RTMFlow(Delaunay_mesh_class,physics_class,pressure_class)
            
            %% store other classes
            obj.Delaunay_mesh_class = Delaunay_mesh_class;
            obj.pressure_class = pressure_class;
            obj.physics_class = physics_class;
            obj.Voronoi_mesh_class = VoronoiMesh(Delaunay_mesh_class,physics_class);
            obj.velocity_class = Velocity(obj.Voronoi_mesh_class,physics_class);
            
            %% Default to no visuals
            obj.visualise_class = Visualisation();

            %% Setting up time and time stepping
            obj.time = 0.0;
            obj.time_step = 0.0;

             %% Setting up active nodes/elements
            inlet_flag = pressure_class.is_inlet;
            
            active_elements = zeros(Delaunay_mesh_class.num_elements,1);
            inlet_nodes = find(inlet_flag);
            % We assigned 0.5 to these elements to distinguish them from finite elements.
            candidate = zeros(Delaunay_mesh_class.num_elements,1);
            for i = 1 : length(inlet_nodes)
                ival = inlet_nodes(i);
                for j = 2 : obj.Voronoi_mesh_class.has_node_i(ival,1)+1
                    candidate(obj.Voronoi_mesh_class.has_node_i(ival,j))= 1;
                end
            end
            candidate_idx = find(candidate);
            for i = 1 : length(candidate_idx)
                if sum(inlet_flag(Delaunay_mesh_class.elements(candidate_idx(i),:)))==2
                    active_elements(candidate_idx(i)) = 0.5;
                end
            end
            
            obj.active_elements = active_elements;

            %% Setting up volume tracking properties
            obj.volume_filling_times = zeros(Delaunay_mesh_class.num_nodes,1);
            obj.volume_fill_percentage = zeros(Delaunay_mesh_class.num_nodes,1);
            obj.new_filled_volume = [];
            obj = obj.compute_flow_rates();

        end

    end % end methods
end