%Функция построения реальной и желаемой рабочих областей
%дельта-робота
function [] = zoneBuilder()
    global R_l R_r VM OQ cos120 sin120 cos240 sin240 %Размеры и константы
    global minTheta maxTheta QG phiMax varthetaMax %Ограничения
    global stepTheta %Шаг изменения углов

    %Подготовительные вычисления
    gammaMin = asind(QG/R_l);
    gammaMax = 180;
    %Создаём вектор с одной нулевой точкой (потом её удалим)
    V_RZ = [0, 0, 0];
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
                X_Q1 = 0;
                Y_Q1 = OQ;
                Z_Q1 = 0;
                X_L1 = 0;
                Y_L1 = OQ+R_l*cosd(Theta1);
                Z_L1 = R_l*sind(Theta1);
                X_M1 = X_V;
                Y_M1 = Y_V + VM;
                Z_M1 = Z_V;
                    X_V_120 = X_V*cos120 - Y_V*sin120;
                    Y_V_120 = X_V*sin120 + Y_V*cos120;
                    Z_V_120 = Z_V;
                    X_Q2_120 = 0;
                    Y_Q2_120 = OQ;
                    Z_Q2_120 = 0;
                    X_L2_120 = 0;
                    Y_L2_120 = OQ+R_l*cosd(Theta2);
                    Z_L2_120 = R_l*sind(Theta2);
                    X_M2_120 = X_V_120;
                    Y_M2_120 = Y_V_120 + VM;
                    Z_M2_120 = Z_V_120;
                        X_V_240 = X_V*cos240 - Y_V*sin240;
                        Y_V_240 = X_V*sin240 + Y_V*cos240;
                        Z_V_240 = Z_V;
                        X_Q3_240 = 0;
                        Y_Q3_240 = OQ;
                        Z_Q3_240 = 0;
                        X_L3_240 = 0;
                        Y_L3_240 = OQ+R_l*cosd(Theta3);
                        Z_L3_240 = R_l*sind(Theta3);
                        X_M3_240 = X_V_240;
                        Y_M3_240 = Y_V_240 + VM;
                        Z_M3_240 = Z_V_240;
                %Собираем это в вектора
                Q1 = [X_Q1, Y_Q1, Z_Q1];
                L1 = [X_L1, Y_L1, Z_L1];
                M1 = [X_M1, Y_M1, Z_M1];
                V_120 = [X_V_120, Y_V_120, Z_V_120];
                Q2_120 = [X_Q2_120, Y_Q2_120, Z_Q2_120];
                L2_120 = [X_L2_120, Y_L2_120, Z_L2_120];
                M2_120 = [X_M2_120, Y_M2_120, Z_M2_120];
                V_240 = [X_V_240, Y_V_240, Z_V_240];
                Q3_240 = [X_Q3_240, Y_Q3_240, Z_Q3_240];
                L3_240 = [X_L3_240, Y_L3_240, Z_L3_240];
                M3_240 = [X_M3_240, Y_M3_240, Z_M3_240];
                %Вычисляем координаты точек N1 N2 N3
                N1 = [L1(1); M1(2); V(3)];
                N2_120 = [L2_120(1); M2_120(2); V_120(3)];
                N3_240 = [L3_240(1); M3_240(2); V_240(3)];
                %------Проверяем ограничения------%
                % 1 Проверяем отсутствие пересечений
                gamma1 = 180-acosd(-L1(3)/R_l)-asind((N1(2)-L1(2))/R_r);
                gamma2 = 180-acosd(-L2_120(3)/R_l)-asind((N2_120(2)-L2_120(2))/R_r);
                gamma3 = 180-acosd(-L3_240(3)/R_l)-asind((N3_240(2)-L3_240(2))/R_r);
                if (gamma1 < gammaMax) && (gamma1 > gammaMin) && (gamma2 < gammaMax) && (gamma2 > gammaMin) && (gamma3 < gammaMax) && (gamma3 > gammaMin)
                    % 2 Проверяем, могут ли трёхподвижные шарниры позволить механизму принять
                    % такое положение
                    varphi1 = asind(abs(V(1))/R_r);
                    varphi2 = asind(abs(V_120(1))/R_r);
                    varphi3 = asind(abs(V_240(1))/R_r);
                    if (varphi1<phiMax) && (varphi2<phiMax) && (varphi3<phiMax)
                        % 3 Проверяем, не превышают ли углы давления заданное
                        % максимальное значение
                        p1 = [M1(1)-L1(1); M1(2)-L1(2); M1(3)-L1(3)];
                        q1 = [0; L1(3)-Q1(3); Q1(2)-L1(2)];
                        vartheta1 = acosd(abs(p1(1)*q1(1)+p1(2)*q1(2)+p1(3)*q1(3))/(sqrt(p1(1)^2+p1(2)^2+p1(3)^2)*sqrt(q1(1)^2+q1(2)^2+q1(3)^2)));
                        p2 = [M2_120(1)-L2_120(1); M2_120(2)-L2_120(2); M2_120(3)-L2_120(3)];
                        q2 = [0; L2_120(3)-Q2_120(3); Q2_120(2)-L2_120(2)];
                        vartheta2 = acosd(abs(p2(1)*q2(1)+p2(2)*q2(2)+p2(3)*q2(3))/(sqrt(p2(1)^2+p2(2)^2+p2(3)^2)*sqrt(q2(1)^2+q2(2)^2+q2(3)^2)));
                        p3 = [M3_240(1)-L3_240(1); M3_240(2)-L3_240(2); M3_240(3)-L3_240(3)];
                        q3 = [0; L3_240(3)-Q3_240(3); Q3_240(2)-L3_240(2)];
                        vartheta3 = acosd(abs(p3(1)*q3(1)+p3(2)*q3(2)+p3(3)*q3(3))/(sqrt(p3(1)^2+p3(2)^2+p3(3)^2)*sqrt(q3(1)^2+q3(2)^2+q3(3)^2)));
                        if (vartheta1<varthetaMax) && (vartheta2<varthetaMax) && (vartheta3<varthetaMax)
                            %Если все условия выполнены - добавляем точку в
                            %вектор облака точек реальной РЗ
                            V_RZ = cat(1, V_RZ, V);
                            if V(1) == 0 && V(2) == 0 && V(3) ~= 0 && done == false
                                Z_for_platform = V(3);
                                done = true;
                            end                              
                        end
                    end
                end
            end
        end
    end

    %Удаляем первую нулевую точку
    V_RZ(1,:) = [];
    %Находим какие точки в нашем облаке являются граничными и создаём
    %группы по 3 точки, которые будем соединять треугольниками (для
    %образования поверхности)
    K = boundary(V_RZ);

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

    %Отображаем реальную РЗ
    trisurf(K, V_RZ(:,1), V_RZ(:,2), V_RZ(:,3), 'Facecolor','red', 'FaceAlpha', 0.3);
    axis([-200 200 -200 200 -150 350])
    hold on;
    %Отображаем крышку и боковую поверхность цилиндра
    patch(Xo1, Yo1, Zo1, 'c', 'FaceAlpha', 0.5);
    patch(Xo2, Yo2, Zo2, 'c', 'FaceAlpha', 0.5);
    line(Xr1, Yr1, Zr1, 'LineWidth', 3)
    line(Xs1, Ys1, Zs1, 'LineWidth', 3)
    line(Xr2, Yr2, Zr2, 'LineWidth', 3)
    line(Xs2, Ys2, Zs2, 'LineWidth', 3)
    line(Xr3, Yr3, Zr3, 'LineWidth', 3)
    line(Xs3, Ys3, Zs3, 'LineWidth', 3)
end