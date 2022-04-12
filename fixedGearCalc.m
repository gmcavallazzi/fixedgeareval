function [var,data] = fixedGearCalc(N,n,tire,crank,imperial,cogtobb)

% fixedGearCalc Function to evaluate all the needed fixed gear parameters.
% 
% The function gives a plot with the speed reached at different RPM, and a plot
% with all these quantities visualized. The color scale for the skid patches 
% refers to how bad the situation is, while for the gear and gain ratios just
% to how hard they are.
% 
% As for now it works with 700c (28") wheels only, but it will be adapted soon
% to work with other settings.
%
% 
% Basic usage: [var,data] = fixedGearCalc(N,n)
%     N = number of teeth on the chain ring. Default is 49.
%     n = number of teeth on the rear cog. Default is 17.
%     
% Advanced usage: [var,data] = fixedGearCalc(N,n,tire,crank,imperial,cogtobb)
%     tire = tire size in mm. Default is 28 mm.
%     crank = crank length in mm. Default is 170 mm.
%     imperial = switch case for km/h (0), m/s (1) and mi/h (2). Default is 0.
%     cogtobb  = distance between the center of the rear cog and the bottom
%                bracket in mm. Default 408 mm.
%     
%     Any of these last three additional parameters can be given, it is not 
%     necessary to list all of them.
% 
% It also gives an approximation of the chain length, if the distance between the
% centers of the rear cog and of the bottom bracket, *cogtobb* is provided. The chain length
% is evaluated considering an integer number of 1/4" links, it could be useful to
% check if modifying *cogtobb* and *n* requires adding new links.

addpath('./base')

% Number of input check
if nargin == 0
    N = 49; n = 17; tire = 28; crank = 165; imperial = 0; cogtobb= 408;
end

if nargin == 1
    error('You need to enter at least the number of teeth of the chain ring and the rear cog')
end

if nargin == 2
    tire = 28; crank = 165; imperial = 0; cogtobb= 408;
end

if nargin == 3
    crank = 165; imperial = 0; cogtobb= 408;
end

if nargin == 4
    imperial    = 0; cogtobb= 408;
end

if nargin == 5
    cogtobb= 408;
end

if crank < 50 || crank > 200
    error('Crank length must be between 50 and 200 mm.')
end

% Check for units of measurement
if  mod(imperial,1)~=0 || imperial < 0 || imperial > 2
    warning('Set 0 for km/h, 1 for m/s or 2 for mph. Default = km/h.')
    imperial = 0;
end
if imperial == 0
    data.unitSpeed = 3.6; % [km/h]
else
    if imperial == 1
        data.unitSpeed = 1; % [m/s]
    else
        data.unitSpeed = 2.2369; % [mph]
    end
end
data.speedNames = {'$[km/h]$','$[m/s]$', '$[mi/h]$'};
data.speedNames = string(data.speedNames);

% Initialisation

data.chainRing      = round(N);
data.rearCog        = round(n);
data.crankLength    = round(crank,2);
data.tire           = round(tire,1);
data.dist           = round(cogtobb,1);

wheelParameters; % import wheel data

% Results
var.ratio       = data.chainRing/data.rearCog; % Adimensional gear ratio
var.development = pi*2*data.tireRadius*var.ratio/1000; % distance covered with a pedal stroke[m]
var.gainRatio   = var.ratio*data.tireRadius/data.crankLength; % Adimensional gain ratio
                    %similar to var.ratio, but it includes the crank length 

% Skid patches evaluation
temp.factChainRing = factor(data.chainRing);
temp.factRearCog = factor(data.rearCog);
for i = 1:length(temp.factRearCog)
    for j = 1:length(temp.factChainRing)
        if temp.factChainRing(j) == temp.factRearCog(i)
            temp.factChainRing(j)   = 1;
            temp.factRearCog(i)     = 1;
            break
        end
    end
end
var.skidPatches = prod(temp.factRearCog); % number of skid patches on the wheel

plotFigures;

%