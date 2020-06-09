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
<p align="center"><img src="https://github.com/Tahahaha7/Temperature_Forecast_Algeria/blob/master/dz_station.png"></p>  

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
![Github](https://github.com/Tahahaha7/Temperature_Forecast_Algeria/blob/master/noumerat.png)  
    
        
Using Facebook's Prophet package for timeseries forecast, the model is constructed using Fourier Transformation technique to generate the model with best fit resulting in the following graph

![Github](https://github.com/Tahahaha7/Temperature_Forecast_Algeria/blob/master/noumerat_model.png)
  
    
      
The model is decomposed to highlight the long-term trend and yearly seasonality. Notice that the graph shows that average daily temperature increased by 2 degrees Celcuis from 1973 to 2017. Furthermore, the forecast projected a rise of 0.5 degree within the next decade (i.e., by 2027).  
The seasonality trend shows the percentage rise in temperature in to reach a peack in July, then eventually goes dow in the beginning of Fall season.

![Github](https://github.com/Tahahaha7/Temperature_Forecast_Algeria/blob/master/noumerat_forecast.png)  
  
  
  
The issue of interest is to highlight the change in long-term trend for all stations. In the following graph, each data point represent the percentage change in trend between 1950 to 2020. Notice that positive change (increase) is prominent as most of the data points are aove the 0% line.  
  
![Github](https://github.com/Tahahaha7/Temperature_Forecast_Algeria/blob/master/percentage_change.png)  
  
  
Although the timeline for measurements differ across stations, most of them started registering in the mid 70s. The graph below illustrate the stations that witnessed a rise of greater than 2 degrees or less than 1 degree throughout their measurement timeline.  
  
![Github](https://github.com/Tahahaha7/Temperature_Forecast_Algeria/blob/master/temp_change.png  
  
  
Finally, the following map shows the stations with the greatest change in temperature relative to other stations. The comparison is dependent on the timeline of measurement for each station (i.e., some stations started measuring temperature before others). To mitigate this issue, only the observations registered after January 1950 are taken into account.  
It's clear that southern stations didn't register a high increase in temperature, however, some cities in the center of Algeria witnessed a sharpe rise (eg. east side of Algeria). We also notice coastal cities that witnessed a rise of more than 1 degree throughout their measuring history.  

<p align="center"><img src="https://github.com/Tahahaha7/Temperature_Forecast_Algeria/blob/master/final_algeria.png"></p>
