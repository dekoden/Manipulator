clc; close all; clear;
%Объявляем глобальные переменные характерных размеров робота и констант
global R_l R_r VM OQ cos120 sin120 cos240 sin240 %Размеры и константы
global minTheta QG phiMax varthetaMax %Ограничения

%Вычисляем константы
cos120 = cosd(120);
sin120 = sind(120);
cos240 = cosd(240);
sin240 = sind(240);

%Задаём размеры робота [мм]
R_l = 100;  %Длина рычагов (по осям)
R_r = 200;  %Длина штанг (по осям)

OQ = 105; %Радиус окружности осей шарниров
VM = 50; %Радиус окружности осей рычагов
%Задаём ограничения
minTheta = 135; %Минимальный угол поворота рычага
QG = 50; %Вынос основания
phiMax = 30; %Максимальный шарнирный угол
varthetaMax = 60; %Максимальный угол давления

%Шаг изменения угла при расчётах (рекомендуется от 1 до 8
stepTheta = 5;

%Вызываем функцию построения и расчётов
zoneBuilder;
