
%% Extraction of SM2RAIN-ASCAT rainfall at one station

lonlat_stat=[11.88,44.31]; % Coordinates of the station you want to extract

%Extraction of the pixel closest to the selected coordinates
namefile='SM2RAIN_ASCAT_0125_2018.nc';
lon_=ncread(['SM2RAIN_ASCAT_0125_2018.nc'],'Longitude');
lat_=ncread(['SM2RAIN_ASCAT_0125_2018.nc'],'Latitude');
ID=knnsearch([lon_,lat_],lonlat_stat);

% Extraction of SM2RAIN-ASCAT rainfall from 2007 to 2018
D=(datenum('1-jan-2007'):datenum('31-dec-2018'))';
Psim_SM2RASC=[];
for ii=2007:2018  % loop over the years 2007 to 2018
    ii
    Psim_SM2RASC=[Psim_SM2RASC;...
        ncread(['SM2RAIN_ASCAT_0125_',num2str(ii),'.nc'],'Rainfall',[1 ID],[yeardays(ii) 1])];
end

% Plotting the figure
plot(D,Psim_SM2RASC)
grid on, box on
datetick
ylabel('rainfall [mm/day]')
title(['SM2RAIN-ASCAT lon;lat=',num2str(lonlat_stat(1),'%3.2f'),';',num2str(lonlat_stat(2),'%3.2f')])
