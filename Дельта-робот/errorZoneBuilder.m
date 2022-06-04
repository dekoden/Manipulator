function [] = errorZoneBuilder()
    global R_l R_r VM OQ cos120 sin120 cos240 sin240 %Размеры и константы
    global minTheta maxTheta QG phiMax varthetaMax %Ограничения
    global stepTheta %Шаг изменения углов
    global thetaError stepError errorIntervalCount errorIntervalColors %Ошибки

    %Подготовительные вычисления
    gammaMin = asind(QG/R_l);
    gammaMax = 180;
    %Создаём вектор с одной нулевой точкой (потом её удалим)
    V_RZ = [0, 0, 0];
    errors = [ 0 ];
    done = false;

    %Создаём цикл перебора всех возможных комбинаций углов поворота рычагов
    for Theta1 = minTheta:stepTheta:maxTheta
        for Theta2 = minTheta:stepTheta:maxTheta
            for Theta3 = minTheta:stepTheta:maxTheta
                %Вызываем функцию, решающую ПЗК
                [L1, L2, L3, V] = PZK(Theta1, Theta2, Theta3);
                X_V = V(1); Y_V = V(2); Z_V = V(3);
                %Вычисляем координаты точек в системах координат XOY
                %X120Y120Z120 и X240Y240Z240
                V_RZ = cat(1, V_RZ, V);
                max_error = 0;
                %Цикл перебора всех возможных комбинаций ошибок
                for errorTheta1 = Theta1 - thetaError : stepError : Theta1 + thetaError
                    for errorTheta2 = Theta2 - thetaError : stepError : Theta2 + thetaError
                        for errorTheta3 = Theta3 - thetaError : stepError : Theta3 + thetaError
                            %Вызываем функцию, решающую ПЗК
                            [errorL1, errorL2, errorL3, errorV] = PZK(errorTheta1, errorTheta2, errorTheta3);
           
                            error = pdist2(V, errorV);
                            if error > max_error
                                max_error = error;
                            end
                        end
                    end
                end
                errors = cat(1, errors, max_error);
                if V(1) == 0 && V(2) == 0 && V(3) ~= 0 && done == false
                    Z_for_platform = V(3);
                    done = true;
                end                              
            end
        end
    end

    %Удаляем первую нулевую точку
    V_RZ(1,:) = [];
    errors(1, :) = [];
   
    %Классифицируем ошибки по цветам и строим рабочую зону с ошибками
    minError = min(errors);
    interval = (max(errors) - minError) / errorIntervalCount;
    %Легенда
    labels = string(zeros(errorIntervalCount, 1));
    for colorInterval = 1:1:errorIntervalCount
        plotsForLegend(colorInterval) = plot3(-1000, -1000, -1000, ...
            '.', 'Color', errorIntervalColors(colorInterval, :));
        labels(colorInterval) = string(minError + (colorInterval - 1) * interval) ...
            + " - " + string(minError + colorInterval * interval) + " мм";
        hold on;
    end
    axis([-200 200 -200 200 -150 350])
    for i = 1:1:length(errors)
        for intervalCount = 1:1:errorIntervalCount
            if errors(i) <= minError + intervalCount * interval
                plot3(V_RZ(i, 1), V_RZ(i, 2), V_RZ(i, 3), '.', ...
                    'Color', errorIntervalColors(intervalCount, :));
                break;
            end
        end
    end

    %Основание и платформа
    t = linspace(0, 2*pi, 50);
    Xo1 = (OQ) * cos(t);
    Yo1 = (OQ) * sin(t);
    Zo1 = zeros(1, 50);
    Xo2 = (VM) * cos(t);
    Yo2 = (VM) * sin(t);
    Zo2 = ones(1, 50)* Z_for_platform;
    
    % Рычаги и штанги    
    Xr1 = [0 0];
    Yr1 = [OQ OQ+R_l*cosd(minTheta)];
    Zr1 = [0 R_l*sind(minTheta)];
    Xs1 = [Xr1(2) 0];
    Ys1 = [Yr1(2) VM];
    Zs1 = [Zr1(2) Z_for_platform];
    
    Xr2 = [OQ*sin120 (OQ+R_l*cosd(minTheta))*sin120];
    Yr2 = [OQ*cos120 (OQ+R_l*cosd(minTheta))*cos120];
    Zr2 = [0 R_l*sind(minTheta)];
    Xs2 = [Xr2(2) VM*sin120];
    Ys2 = [Yr2(2) VM*cos120];
    Zs2 = [Zr2(2) Z_for_platform];
    
    Xr3 = [OQ*sin240 (OQ+R_l*cosd(minTheta))*sin240];
    Yr3 = [OQ*cos240 (OQ+R_l*cosd(minTheta))*cos240];
    Zr3 = [0 R_l*sind(minTheta)];
    Xs3 = [Xr3(2) VM*sin240];
    Ys3 = [Yr3(2) VM*cos240];
    Zs3 = [Zr3(2) Z_for_platform];

    patch(Xo1, Yo1, Zo1, 'c', 'FaceAlpha', 0.5);
    patch(Xo2, Yo2, Zo2, 'c', 'FaceAlpha', 0.5);
    line(Xr1, Yr1, Zr1, 'LineWidth', 3)
    line(Xs1, Ys1, Zs1, 'LineWidth', 3)
    line(Xr2, Yr2, Zr2, 'LineWidth', 3)
    line(Xs2, Ys2, Zs2, 'LineWidth', 3)
    line(Xr3, Yr3, Zr3, 'LineWidth', 3)
    line(Xs3, Ys3, Zs3, 'LineWidth', 3)

    legend(plotsForLegend, labels);
    title("Рабочая зона с ошибками");
end

