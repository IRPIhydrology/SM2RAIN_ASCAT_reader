clc,clear,close all
lonlat_ext=load('lonlat_ext.txt');

lon_=ncread(['SM2RAIN_ASCAT_0125_2018.nc'],'Longitude');
lat_=ncread(['SM2RAIN_ASCAT_0125_2018.nc'],'Latitude');

ID=knnsearch([lon_,lat_],lonlat_ext);
D=(datenum('1-jan-2007'):datenum('31-dec-2018'))';
Psim_SM2RASC=[];
for ii=2007:2018
    ii
    PP=ncread(['SM2RAIN_ASCAT_0125_',num2str(ii),'.nc'],'Rainfall');
    Psim_SM2RASC=[Psim_SM2RASC,PP(:,ID)'];
end

% Plotting the figure
plot(D,Psim_SM2RASC)
grid on, box on
datetick
ylabel('rainfall [mm/day]')
title(['SM2RAIN-ASCAT ',num2str(size(lonlat_ext,1)),' points'])