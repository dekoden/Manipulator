function coords = RPR_FK(teta_1, teta_2, teta_3, teta_4, teta_5, teta_6)
    l = [1 1 1 1 1 1];
    
    local_coordinates = [0; 0; 0; 1];
    % Параметры ДХ
    A_10 = transform(0,    pi/2,    l(1),      teta_1+pi/2);
    A_21 = transform(l(2), 0,       0,         teta_2+pi/2);
    A_32 = transform(0,    pi/2,    0,         teta_3+pi/2);
    A_43 = transform(0,    pi/2,    l(3)+l(4), teta_4+pi);
    A_54 = transform(0,    pi/2,    0,         teta_5+pi);
    A_65 = transform(0,    0,       l(5)+l(6), teta_6);

    % Вычисление координат систем 0 - 3
    coord(1, :) = local_coordinates';
    coord(2, :) = (A_10 * local_coordinates)';
    coord(3, :) = (A_10 * A_21 * local_coordinates)';
    coord(4, :) = (A_10 * A_21 * A_32 * A_43 * local_coordinates)';
    coord(5, :) = (A_10 * A_21 * A_32 * A_43 * A_54 * local_coordinates)';
    coord(6, :) = (A_10 * A_21 * A_32 * A_43 * A_54 * A_65 * local_coordinates)';
    
    coords = coord(6, 1 : 3);

end

