classdef Physics
    
    %% Physics class to store Darcy's law and important material properties:
    % The physics class serves to store the domain material properties:
    % viscosity, porosity, thickness (2d -> 3d scaling).

    properties
        %% Material properties
        viscosity;
        porosity;
        thickness;
        permeability;
    end

    methods

        %% Darcy class methods:
        % A constructor that inputs 3 functions for each of the material
        % properties. These must be defined within matlab before entering
        % into the constructor function.

        function obj = Physics(viscosity, porosity, thickness, permeability)

            obj.viscosity = viscosity;
            obj.porosity = porosity;
            obj.thickness = thickness;
            obj.permeability = permeability;

        end


    end

end
