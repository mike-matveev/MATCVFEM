%% Problem set up
my_mesh = DelaunayMesh(p,e,t);
my_darcy = Physics(0.1, 0.35, 1, @permeability);
my_pressure = Pressure(my_mesh,my_darcy,@is_inlet,@is_vent,@p_D);

%% compile RTM-flow method
my_RTMflow = RTMFlowDryspot(my_mesh,my_darcy,my_pressure);
my_RTMflow.visualise_class.is_plotting_volume = true;

%% Execute solver
my_RTMflow = my_RTMflow.run();

%% Argument set up
function K = permeability(x)
    
    if norm(x - [0.5 0.5])<0.25
        K = 1e-10 * eye(2);
    else
        K = 1e-8 * eye(2);
    end

end

function p = p_D(pressure_class)

p = 0*pressure_class.pressure;
p(pressure_class.is_inlet) = 1.5e5;

end

function bool = is_inlet(node)

bool = (node(2) == 0);

end

function bool = is_vent(node)

bool = (node(2) == 1);

end