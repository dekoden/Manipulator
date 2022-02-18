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

% [T1, T2, T3, T4, T5]=ndgrid(th1, th2, th3, th4, th5);
% M = RPR_FK(T1, T2, T3, T4, T5, 0);

% l1=500;l2=600;l3=400;l4=191.03;
% t1=linspace(-180,180,90)*pi/180;
% t2=linspace(-90,90,90)*pi/180;
% d3=linspace(-200,200,90);
% t4=linspace(-180,180,90)*pi/180;
% [T1,T2,D3]=ndgrid(t1,t2,d3);  % This will create matrices of 90x90x90 for each variable
% xM = round((-cos(T1).*cos(T2)).*((D3 + l2 + l3 + l4)));
% yM = round((-cos(T2).*sin(T1)).*(D3 + l2 + l3 + l4));
% zM = round((l1 - l4.*sin(T2) - sin(T2).*(D3 + l2 + l3)));
% plot3(xM(:),yM(:),zM(:),'.') % This is the plot type you should be using.
% % With a '.' as an argument to show only locations and not lines
% % Also, (:) converts any matrix into a list of its elements in one single column.