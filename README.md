# fixedgeareval
A MATLAB function to evaluate many parameters of your fixed gear bike.

The function gives a plot with the speed reached at different RPM, and a plot
with all these quantities visualized. The color scale for the skid patches 
refers to how bad the situation is, while for the gear and gain ratios just
to how hard they are.

It also gives an approximation of the chain length. It is given assuming 
the distance between the center of the cog and of the chain ring = 408
mm. This parameter can be modified.
 
## Basic usage: 

```matlab
 [var,data] = fixedGearCalc(N,n)
 ```
    N = number of teeth on the chain ring. Default is 49.
    n = number of teeth on the rear cog. Default is 17.
    
## Advanced usage: 

```matlab
 [var,data] = fixedGearCalc(N,n,tire,crank,imperial)
 ```
    tire = tire size in mm. Default is 28 mm.
    crank = crank length in mm. Default is 170 mm.
    imperial = switch case for km/h (0), m/s (1) and mi/h (2). Default is 0.
    
    
Any of these last three additional parameters can be given, it is not 
necessary to list all of them.
