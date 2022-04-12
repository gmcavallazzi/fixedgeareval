data.tireRadiusList = [332 335 336 342 345 347 354 365 370]; 
                % values from Sheldon Brown blog
data.tireSizeList   = [20 25 28 32 35 38 44 50 56]; 
                % values from Sheldon Brown blog
data.tireRadius     = interp1(data.tireSizeList,data.tireRadiusList,tire); 
                % to fit other tire sizes
                
data.rim         = 622/2; % standard of 700c. Soon to be adapted with other diameters
data.brakePath   = 40; % free parameter to plot the rim profile, can not be <0 or exceed data.rim
data.Rchain      = data.chainRing/2*25.4/2/pi; % radius of the chain ring [mm]
data.Rcog        = data.rearCog/2*25.4/2/pi; % radius of the cog [mm]
data.nradius     = 24; % number of spokes for the plot
data.dist        = 408; % distance between the centers of the cog and the chain ring [mm]
data.r           = 25.4/4; % tooth depth, a quarter of inch [mm]
data.alpha       = asin((data.Rchain - data.Rcog)/data.dist); 
                % angle between pi/2 and where the chain detaches from the
                % chain ring [rad]
                
var.chainLength = ceil((2*(data.dist/25.4*cos(data.alpha)) + (data.chainRing + data.rearCog)/4 + ...
                    data.alpha/2/pi*(data.chainRing - data.rearCog))); % [in]
var.chainLength = (ceil(var.chainLength) + mod(ceil(var.chainLength),2))*25.4; % [mm]
                % estimated length of the chain. It is the chain is in
                % tension and no decimal links can be added
var.nLink       = round(var.chainLength/6.35/2); % number of links in a tensioned chain