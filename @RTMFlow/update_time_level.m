function obj = update_time_level(obj)

obj = obj.compute_time_increment();
obj.time = obj.time + obj.time_step;
obj.pressure_class.time = obj.time;
obj.velocity_class.time = obj.time;

end