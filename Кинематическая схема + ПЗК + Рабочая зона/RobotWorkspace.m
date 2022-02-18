clc; close all; clear;

step = pi/9;

i = 1;
V = zeros(10000000, 3);
for theta1 = -pi : step : pi
    for theta2 = -pi/2 : step : pi/2
        for theta3 = -pi/2 : step : pi/2
            for theta4 = -pi : step : pi
                for theta5 = -pi/2 : step : pi/2
                    point = RPR_FK(theta1, theta2, theta3, theta4, theta5, 0);
                    if (point(3) < 0)
                        continue;
                    end
                    V(i, 1) = point(1);
                    V(i, 2) = point(2);
                    V(i, 3) = point(3);
                    i = i + 1;
                end
            end
        end
    end
end

[K] = boundary(V);
trisurf(K, V(:, 1), V(:, 2), V(:, 3), 'Facecolor', 'red', 'FaceAlpha', 0.2);