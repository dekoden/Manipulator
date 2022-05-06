clc; close all; clear;
clc; close all; clear;
%Объявляем глобальные переменные характерных размеров робота и констант
global R_l R_r VM OQ cos120 sin120 cos240 sin240 %Размеры и константы
global stepTheta minTheta maxTheta QG phiMax varthetaMax %Ограничения
global thetaError stepError errorIntervalCount errorIntervalColors%Ошибки

%Вычисляем константы
cos120 = cosd(120);
sin120 = sind(120);
cos240 = cosd(240);
sin240 = sind(240);

%Задаём размеры робота [мм]
R_l = 100;  %Длина рычагов 
R_r = 200;  %Длина штанг 

OQ = 105; %Радиус окружности осей шарниров
VM = 50; %Радиус окружности осей рычагов
%Задаём ограничения
minTheta = -30; %Минимальный угол поворота рычага
maxTheta = 90; %Максимальный угол поворота рычага
QG = 25; %Вынос основания
phiMax = 30; %Максимальный шарнирный угол
varthetaMax = 80; %Максимальный угол давления

%Шаг изменения угла при расчётах (рекомендуется от 1 до 8
stepTheta = 5;

%Задаем параметры ошибок в шарнирах
thetaError = 1;
stepError = 0.5;
errorIntervalCount = 4;
errorIntervalColors = [0.4660 0.6740 0.1880
                       0.9290 0.6940 0.1250
                       0.8500 0.3250 0.0980
                       0.6350 0.0780 0.1840];

errorZoneBuilder;