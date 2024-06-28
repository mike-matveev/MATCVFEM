classdef DelaunayMesh

    %% DelaunayMesh class to store finite element mesh & properties:
    % The mesh class serves to store the finite element mesh, properties of 
    % the mesh and properties of the elements within it.
    % 
    % nodes store an N(p) x 2 matrix containing the x,y-coordinates of the
    % mesh in the first and second column. elements store an N(tri) x 3 
    % matrix indexing the points that make the elements in a counter-
    % clockwise orientation. boundary_nodes lists the rows of points that 
    % correspond to a boundary node of the mesh. centroids is an N(tri) x 2
    % matrix storing the centroid coordinates of each element. 
   
    properties
        %% Mesh Data
        nodes;
        elements;
        boundary_nodes;
        centroids;

        %% Element properties
        element_areas;

        %% Mesh Counting Properties
        num_nodes;
        num_elements;
        num_boundary_nodes;
    end
    
    methods
        %% Mesh class methods:
        % A constructor that takes either a string of a .mat file
        % containing [p,e,t] matrices produced by the MATLAB pdetool 
        % function, or can directly input the [p,e,t] matrices into the 
        % constructor.
        %
        % A method called compute_element_area stores the area of element

        function obj = DelaunayMesh(arg1, arg2, arg3)
                
                %% mesh(<.mat file containing points p and triangles t>)
                if nargin == 1

                    if ~isstring(arg1)
                        error(['single argument mesh ...' ...
                                              ' requires matlab filename'])
                    end
                    
                    %% unpacking pdetool objects
                    data = load(arg1);
                    struct_name = fieldnames(data);
                    mesh_struct = data.(struct_name{1});

                    p = mesh_struct.p;
                    e = mesh_struct.e;
                    t = mesh_struct.t;

                %% else mesh(p,e,t) as exported by pdetool
                else
                    p = arg1;
                    e = arg2;
                    t = arg3;
                end

                %% storing important mesh details
                obj.nodes = p';
                obj.elements = t(1:3,:)';
                obj.boundary_nodes = unique([e(1,:) e(2, :)])';
                obj.num_nodes = size(obj.nodes,1);
                obj.num_elements = size(obj.elements,1);
                obj.num_boundary_nodes = length(obj.boundary_nodes);
                
                %% Additional mesh properties
                obj = obj.compute_element_areas();
                obj = obj.compute_element_centroids();

        end% end constructor
        
    end% end methods
end