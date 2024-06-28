function plot(obj,RTM_class) 

%% plots moving volume
if obj.is_plotting_volume
    figure(1)
    clf;
    fluid_elements = RTM_class.active_elements;
    fluid_elements(fluid_elements>0) = 1;

    pdeplot(RTM_class.Delaunay_mesh_class.nodes',...
            RTM_class.Delaunay_mesh_class.elements', ...
            XYData=fluid_elements,ColorMap="jet",Mesh="on")
    axis equal
    caxis([0 1]);
    title(["plot of fluid position at time = " ...
                                    num2str(RTM_class.time)])

    if obj.is_animate_volume 
        exportgraphics(gca,"volume.gif","Append",true)
    end

end

%% plots pressure solution 
if obj.is_plotting_pressure
    figure(2)
    clf
    
    pressure = RTM_class.pressure_class.pressure;

    axis equal
    axis auto
    pdeplot(RTM_class.Delaunay_mesh_class.nodes',...
            RTM_class.Delaunay_mesh_class.elements', ...
            XYData=pressure,ZData = pressure,...
            ColorMap="jet")
    title(["plot of pressure at time = " ...
                                    num2str(RTM_class.time)])

    if obj.is_animate_pressure
        exportgraphics(gca,"pressure.gif","Append",true)
    end
end

%% plots volume flow rate
if obj.is_plotting_volume_flow
    figure(3)
    clf
    
    Q = RTM_class.volume_rates_of_flow;

    axis equal
    axis auto
    pdeplot(RTM_class.Delaunay_mesh_class.nodes',...
            RTM_class.Delaunay_mesh_class.elements', ...
            XYData=Q, ZData=Q,...
            ColorMap="jet")
    title(["plot of volume flow at time = " ...
                                    num2str(RTM_class.time)])

    if obj.is_animate_volume_flow 
        exportgraphics(gca,"volume_flow.gif","Append",true)
    end
end

%% plots velocity field
if obj.is_plotting_velocity
    figure(4)
    clf
    
    velocity = RTM_class.velocity_class.velocity;

    axis equal
    axis auto
    pdeplot(RTM_class.Delaunay_mesh_class.nodes',...
            RTM_class.Delaunay_mesh_class.elements', ...
            'flowdata',...
            velocity)
    title(["plot of velocity at time = " ...
                                    num2str(RTM_class.time)])

    if obj.is_animate_velocity 
        exportgraphics(gca,"velocity.gif","Append",true)
    end
end

end