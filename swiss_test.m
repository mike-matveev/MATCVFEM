%% Problem set up
my_mesh = DelaunayMesh(p,e,t);
my_physics = Physics(0.1, 0.35, 1, @permeability);
my_pressure = Pressure(my_mesh,my_physics,@is_inlet,@is_vent,@p_D);

%% compile RTM-flow method
my_RTMflow = RTMFlow(my_mesh,my_physics,my_pressure);

%% graphical settings
my_RTMflow.visualise_class.is_plotting_volume = true;
my_RTMflow.visualise_class.is_animate_volume = true;

%% Execute solver
my_RTMflow = my_RTMflow.run();

%% Argument set up
function K = permeability(x)
    
    if norm(x - [0.5 0.5])<0.25
        K = 1e-6 * eye(2);
    else
        K = 1e-8 * eye(2);
    end

end

function p = p_D(pressure_class)

p = 0*pressure_class.pressure+1e5;
p(pressure_class.is_inlet) = 1.5e5;

end

function bool = is_inlet(x)

bool = (x(2) == 0);

end

function bool = is_vent(x)

bool = (x(2) == 1);

end