classdef VoronoiMesh

    properties
    
        %% triangulation class stored for reference
        Delaunay_mesh_class;

        %% neasure of control volumes in 3D (using thickness approximation)
        volume_measures;

        %% control volume outward facing normals(multiplied by edge length)
        volume_outflow_vectors;

        %% connectivity and boundary features of the Volume elements
        node_connectivity;
        element_connectivity;
        has_node_i;
        connected_polygons;

    end % end properties

    methods
        %% constructor of the Volume class

        function obj = VoronoiMesh(Delaunay_mesh_class,physics_class)

            obj.Delaunay_mesh_class = Delaunay_mesh_class;

            obj = obj.compute_volume_measures(physics_class.thickness);
            obj = obj.compute_volume_outflow_vectors();
            obj = obj.compute_connectivity();

        end    

    end % end methods

end