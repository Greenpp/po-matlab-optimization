clear all;
close all;
clc;

x0 = [0 0];
d1 = [1 0];
d2 = [0 1];
EPSILON = 0.01;
MIN_SEARCH_RANGE = [-10 10]

results = [x0]

xn = x0;
d = d1
while true
    xn = get_min_point_in_direction(xn, d);
    if d == d1
        d = d2;
    else
        d = d1;
    end
    
    if condition_is_met(x0, xn)
        break;
    end

    x0 = xn;
    results = [results ; xn]
end

fcontour(@(x1, x2) (x1-3)^2 + (x2-4)^2 + (x1-x2+1)^2);
axis([0 6 0 6]);
hold on;
plot(results(:,1), results(:,2), 'r-', 'MarkerSize', 20)

function condition_is_met = condition_is_met(x0, xn)
    condition_is_met = norm(xn - x0) <= EPSILON
end

function get_new_point = get_new_point(x_start, direction)
    dx = direction(:,1);
    dy = direction(:,2);
    if dx ~= 0
        m = dy / dx;
    else
        m = 1;
    end
    new_x = min_func_in_direction(direction, x_start, m);
    new_point = direction .* new_x + x_start;

    get_new_point = new_point;
end

function func_on_line = func_on_line(x1, vx, xs, ys, m)
    if vx ~= 0
        func_on_line = (x1 + xs - 3)^2 + ((x1 * m) + ys - 4)^2 + (x1 + xs - (x1 * m) - ys + 1)^2;
    else
        func_on_line = (xs - 3)^2 + ((x1 * m) + ys - 4)^2 + (xs - (x1 * m) - ys + 1)^2;
    end
end

function min_func_in_direction = min_func_in_direction(direction, x_start, dir_coeff)
    x = direction(:,1);
    xs = x_start(:,1);
    ys = x_start(:,2);
    min_line_x = fminbnd(@(x1) func_on_line(x1, x, xs, ys, dir_coeff), -10, 10);

    min_func_in_direction = min_line_x;
end