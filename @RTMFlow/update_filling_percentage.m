function obj = update_filling_percentage(obj)

%% Unpack variables for ease of reading
f = obj.volume_fill_percentage;
V = obj.Voronoi_mesh_class.volume_measures;
Q = obj.volume_rates_of_flow;
dt = obj.time_step;

%% increase volume fill factor for any inflow elements
positive_flow_volumes = find(Q>0);
already_filled = ones(length(positive_flow_volumes),1);

%% Use formula to extrapolate new filling percentages
f_new = f(positive_flow_volumes) ...
                   + dt*Q(positive_flow_volumes)./V(positive_flow_volumes);

%% Correct filling percentages for rounding and overfilling errors
f_new = min(already_filled,f_new);
f_new(1-f_new<1e+3*eps) = 1;

%% Find the control volume that has just filled to 100%
new_filled_volume = positive_flow_volumes(f_new>f(positive_flow_volumes)...
                                          & f_new == 1);

%% Repacking final outputs
obj.volume_fill_percentage(positive_flow_volumes) = f_new;
obj.new_filled_volume = new_filled_volume;
end