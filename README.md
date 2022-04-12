# fixedgeareval
A MATLAB function to evaluate many parameters of your fixed gear bike.

The function gives a plot with the speed reached at different RPM, and a plot
with all these quantities visualized. The color scale for the skid patches 
refers to how bad the situation is, while for the gear and gain ratios just
to how hard they are.

 
## Basic usage: 

```matlab
 [var,data] = fixedGearCalc(N,n)
 ```
    N = number of teeth on the chain ring. Default is 49.
    n = number of teeth on the rear cog. Default is 17.
    
## Advanced usage: 

```matlab
 [var,data] = fixedGearCalc(N,n,tire,crank,imperial,cogtobb)
 ```
    tire     = tire size in mm. Default 28 mm.
    crank    = crank length in mm. Default 170 mm.
    imperial = switch case for km/h (0), m/s (1) and mi/h (2). Default  0.
    cogtobb  = distance between the center of the rear cog and the bottom
               bracket in mm. Default 408 mm.
    
    
Any of these last three additional parameters can be given, it is not 
necessary to list all of them.

### Chain length

It also gives an approximation of the chain length, if the distance between the
centers of the rear cog and of the bottom bracket, *cogtobb* is provided. The chain length
is evaluated considering an integer number of 1/4" links, it could be useful to
check if modifying *cogtobb* and *n* requires adding new links.
