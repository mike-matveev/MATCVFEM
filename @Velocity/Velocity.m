classdef Velocity

    properties
    
        voronoi_mesh_class;
        physics_class;

        %% piecewise constant velocity field
        time;
        velocity;

    end % end properties

    methods
        %% Methods of the Volume class

        function obj = Velocity(voronoi_mesh_class,physics_class)

            obj.voronoi_mesh_class = voronoi_mesh_class;
            obj.physics_class = physics_class;
            
            num_cells = size(voronoi_mesh_class.element_connectivity,1);

            obj.time = 0;
            obj.velocity = zeros(num_cells,2);
        end    

    end % end methods

end