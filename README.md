# Temperature Forecast in Algeria

## Introduction:
This report gathers temperature data from 52 stations in Algeria, each station has a different timeline with an earliest measurment taken in January 1880. The data point represent the monthly average temperature.

```Source:``` GISS Surface Temperature Analysis (v4) Based on GHCN data from NOAA-NCEI.

```Citation:``` Menne, M.J., I. Durre, B. Korzeniewski, S. McNeal, K. Thomas, X. Yin, S. Anthony, R. Ray, 
R.S. Vose, B.E.Gleason, and T.G. Houston, 2012: Global Historical Climatology Network - 
Daily (GHCN-Daily), Version 3. [indicate subset used following decimal, 
e.g. Version 3.12]. 
NOAA National Climatic Data Center. http://doi.org/10.7289/V5D21VHZ  
  
  
## Location of the stations:
![Github](https://github.com/Tahahaha7/Temperature_Forecast_Algeria/blob/master/dz_stations.png)
**The color of the stations is coded based on the elevation from sea level (Red:High → Blue:Low)**  
  
  
## Create the best fit model and forecast:
The function ```forecast``` takes the name of the station and the number of month to forecast into the future as input. The function outputs some information about the station (number of observations, missing data, timeline of measurements). Below an example of the output for the Noumerat station.
```python
forecast('Noumerat', 120)
```
```
Number of observations: 576
Number of missing data: 40
Range of data gathering: 1973-1  To  2017-9
```
