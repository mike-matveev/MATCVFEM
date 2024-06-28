function obj = compute_time_increment(obj)
empty_percentage = 1 - obj.volume_fill_percentage;
Q = obj.volume_rates_of_flow;
Vol = obj.Voronoi_mesh_class.volume_measures;

candidates = find((Q>eps)&(empty_percentage>eps));

if isempty(candidates)
    warning('No positive flux found.')
    dt = 0;
else
    dt = min(empty_percentage(candidates).*Vol(candidates)./Q(candidates));
end

obj.time_step = dt;

end