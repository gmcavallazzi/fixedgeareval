%% RPM VS SPEED PLOT
plt.fig = figure();
set(groot,'defaultAxesTickLabelInterpreter','latex');

plt.graph = scatter(plt.rpmArray,plt.speedArray,plt.sz,plt.rpmArray,'filled')%,...
    %'MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor',plt.orange);

xlabel('RPM', 'interpreter','latex')
ylabel(strcat('Speed ',data.speedNames(round(imperial+1))), 'interpreter','latex')
grid on
title ('Speed vs RPM', 'interpreter','latex')
xlim ([plt.rpmLow-plt.rpmStep/2 plt.rpmHigh+plt.rpmStep/2])
xticks(plt.rpmArray)
for i = 1:length(plt.rpmArray)
    text(plt.rpmArray(i)-1.5,plt.speedArray(i)+1.5,num2str(plt.speedArray(i),'%2.4g'),'interpreter','latex')
end
set(plt.fig, 'Position', [100,100,800,400]);

%% PLOT GEARS

% PLOT GEARS
plt.fig2 = figure();
set(groot,'defaultAxesTickLabelInterpreter','latex');

% Tire
p = nsidedpoly(1000, 'Center', [-data.dist 0], 'Radius', data.tireRadius);
plot(p, 'FaceColor', 'k','FaceAlpha',1)
hold on
p = nsidedpoly(1000, 'Center', [-data.dist 0], 'Radius', data.rim);
plot(p, 'FaceColor', plt.grey,'FaceAlpha',1)
p = nsidedpoly(1000, 'Center', [-data.dist 0], 'Radius', data.rim - data.brakePath);
plot(p, 'FaceColor', [1 1 1],'FaceAlpha',1)

% Wheel
for i = 1:data.nradius
    plot([-data.dist, -data.dist + (data.rim - data.brakePath)*cos(2*pi/data.nradius*i)]...
        , [0, (data.rim - data.brakePath)*sin(2*pi/data.nradius*i)],'k')
    hold on
end

% Skid Patches
temp.th         = linspace(pi/6, 2*pi+pi/6, var.skidPatches+1);
temp.radius     = (data.tireRadius+data.rim)/2 + (data.tireRadius-data.rim)/4;
temp.thickness  = (data.tireRadius-data.rim)/4;

if var.skidPatches < 10
    temp.degsp = 16;
else
    if var.skidPatches < 20 
        temp.degsp = 8;
    else
        temp.degsp = 4;
    end
end

if var.skidPatches < 4
    text(-100, 350, strcat('Skid patches = ', num2str(var.skidPatches), ':('), 'Color','r');
    for i = 1:var.skidPatches
        temp.theta = linspace(temp.th(i) - temp.degsp*pi/180, temp.th(i) + temp.degsp*pi/180,100);
        plot(temp.radius*cos(temp.theta)-data.dist...
        ,temp.radius*sin(temp.theta),'r','LineWidth',temp.thickness)
    end

else
    if var.skidPatches < 8
        text(-100, 350, strcat('Skid patches = ', num2str(var.skidPatches), ':/'), 'Color',plt.orange);
        for i = 1:var.skidPatches
            temp.theta = linspace(temp.th(i) - temp.degsp*pi/180, temp.th(i) + temp.degsp*pi/180,100);
            plot(temp.radius*cos(temp.theta)-data.dist...
            ,temp.radius*sin(temp.theta), 'Color',plt.orange,'LineWidth',temp.thickness)
        end

    else
        text(-100, 350, strcat('Skid patches = ', num2str(var.skidPatches), ':)'), 'Color',plt.green);
        for i = 1:var.skidPatches
            temp.theta = linspace(temp.th(i) - temp.degsp*pi/180, temp.th(i) + temp.degsp*pi/180,100);
            plot(temp.radius*cos(temp.theta)-data.dist...
            ,temp.radius*sin(temp.theta), 'Color',plt.green,'LineWidth',temp.thickness)
        end
    end
end
% 
% for i = 1:var.skidPatches
%     temp.theta = linspace(temp.th(i) - temp.degsp*pi/180, temp.th(i) + temp.degsp*pi/180,100);
%     plot(temp.radius*cos(temp.theta)-data.dist...
%         ,temp.radius*sin(temp.theta),'r','LineWidth',temp.thickness)
% end

% Chain Ring
plt.xchain = (data.Rchain + (data.r/2  + data.r/2*(sin(plt.theta*data.chainRing) > 0))...
    .*sin(data.chainRing*plt.theta)).*cos(plt.theta);
plt.ychain = (data.Rchain + (data.r/2 + data.r/2*(sin(plt.theta*data.chainRing) > 0))...
    .*sin(data.chainRing*plt.theta)).*sin(plt.theta);
fill(plt.xchain,plt.ychain,plt.silver,'LineWidth',2, 'EdgeColor','k')
hold on
p = nsidedpoly(1000, 'Center', [0 0], 'Radius', data.Rchain/5);
plot(p, 'FaceColor', 'k')

% Cog
plt.xcog = (data.Rcog + (data.r/2  + data.r/2*(sin(plt.theta*data.rearCog) > 0))...
    .*sin(data.rearCog*plt.theta)).*cos(plt.theta)-data.dist;
plt.ycog = (data.Rcog + (data.r/2  + data.r/2*(sin(plt.theta*data.rearCog) > 0))...
    .*sin(data.rearCog*plt.theta)).*sin(plt.theta);
fill(plt.xcog,plt.ycog,plt.silver,'LineWidth',2, 'EdgeColor','k')
p2 = nsidedpoly(1000, 'Center', [-data.dist 0], 'Radius', data.Rcog/5);
plot(p2, 'FaceColor', 'k')

% Chain
plt.xcog1 = (data.Rcog).*cos(plt.thcog)-data.dist;
plt.ycog1 = (data.Rcog).*sin(plt.thcog);
plot(plt.xcog1,plt.ycog1,'Color',plt.gold,'LineWidth',5);
hold on
plt.xchain1 = (data.Rchain).*cos(plt.thchain);
plt.ychain1 = (data.Rchain).*sin(plt.thchain);
plot(plt.xchain1,plt.ychain1,'Color',plt.gold,'LineWidth',5);
plot([plt.xcog1(1) plt.xchain1(end)],[plt.ycog1(1) plt.ychain1(end)],...
    'Color',plt.gold,'LineWidth',5)
hold on
plot([plt.xcog1(end) plt.xchain1(1)],[plt.ycog1(end) plt.ychain1(1)],...
    'Color',plt.gold,'LineWidth',5)

axis equal

if var.ratio < 2 
    text(-100, 320, strcat('Gear Ratio = ', num2str(var.ratio)), 'Color','b');
else
    if var.ratio < 2.7
        text(-100, 320, strcat('Gear Ratio = ', num2str(var.ratio)), 'Color',plt.green);
    else
        if var.ratio < 3.3
            text(-100, 320, strcat('Gear Ratio = ', num2str(var.ratio)), 'Color',plt.orange);
        else
            text(-100, 320, strcat('Gear Ratio = ', num2str(var.ratio)), 'Color','r');
        end
    end
end

if var.gainRatio < 4 
    text(-100, 290, strcat('Gain Ratio = ', num2str(var.gainRatio)), 'Color','b');
else
    if var.gainRatio < 5.4
        text(-100, 290, strcat('Gain Ratio = ', num2str(var.gainRatio)), 'Color',plt.green);
    else
        if var.gainRatio < 6.5
            text(-100, 290, strcat('Gain Ratio = ', num2str(var.gainRatio)), 'Color',plt.orange);
        else
            text(-100, 290, strcat('Gain Ratio = ', num2str(var.gainRatio)), 'Color','r');
        end
    end
end

text(-200, -350, strcat('Development = ', num2str(var.development),' [mm]'), 'Color','k');
set(plt.fig2, 'Position', [400,400,1000,600]);