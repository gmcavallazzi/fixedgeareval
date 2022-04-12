function [var,data] = fixedGearCalc(N,n,tire,crank,imperial)
% fixedGearCalc Function to evaluate all the needed fixed gear parameters.
% 
% The function gives a plot with the speed reached at different RPM, and a plot
% with all these quantities visualized. The color scale for the skid patches 
% refers to how bad the situation is, while for the gear and gain ratios just
% to how hard they are.
%
% It also gives an approximation of the chain length. It is given assuming 
% the distance between the center of the cog and of the chain ring = 408
% mm. This parameter can be modified.
% 
% Basic usage: [var,data] = fixedGearCalc(N,n)
%     N = number of teeth on the chain ring. Default is 49.
%     n = number of teeth on the rear cog. Default is 17.
%     
% Advanced usage: [var,data] = fixedGearCalc(N,n,tire,crank,imperial)
%     tire = tire size in mm. Default is 28 mm.
%     crank = crank length in mm. Default is 170 mm.
%     imperial = switch case for km/h (0), m/s (1) and mi/h (2). Default is 0.
%     
%     Any of these last three additional parameters can be given, it is not 
%     necessary to list all of them.

addpath('./base')

% Number of input check
if nargin == 0
    N = 49; n = 17; tire = 28; crank = 165; imperial = 0;
end

if nargin == 1
    error('You need to enter at least the number of teeth of the chain ring and the rear cog')
end

if nargin == 2
    tire = 28; crank = 165; imperial = 0;
end

if nargin == 3
    crank = 165; imperial = 0;
end

if nargin == 4
    imperial    = 0;
end

if crank < 50 || crank > 200
    error('Crank length must be between 50 and 200 mm.')
end

% Check for units of measurement
if  any (imperial ~= [0,1,2])
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
    for j = 1:length(temp.factChainRing);
        if temp.factChainRing(j) == temp.factRearCog(i)
            temp.factChainRing(j)   = 1;
            temp.factRearCog(i)     = 1;
            break
        end
    end
end
var.skidPatches = prod(temp.factRearCog); % number of skid patches on the wheel

% Plot data settings
plt.rpmLow      = 30; % min numer of RPM displayed
plt.rpmHigh     = 130; % max numer of RPM displayed
plt.rpmStep     = 10;
plt.rpmArray    = [plt.rpmLow:plt.rpmStep:plt.rpmHigh];
plt.speedArray = data.unitSpeed*var.development*[30:10:130]/60;

plt.sz      = 50; % marker size for RPM vs Speed plot

plt.theta       = 0:0.00005:2*pi;
plt.thcog       = pi/2+data.alpha:0.01:3*pi/2-data.alpha;
plt.thchain     = -pi/2-data.alpha:0.01:pi/2+data.alpha;


% Define some colors
plt.gold    = [212,175,55]/255;
plt.grey    = [220,220,220]/255;
plt.silver  = [192,192,192]/255;
plt.orange  = [255,140,0]/255;
plt.green   = [50,205,50]/255;

plotFigures;