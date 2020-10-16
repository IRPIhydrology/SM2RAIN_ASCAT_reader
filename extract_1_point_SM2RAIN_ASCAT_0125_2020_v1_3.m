clc,clear,close all
lonlat_ext=[12.5,43];

dirdata='';
lon_=ncread([dirdata,'SM2RAIN_ASCAT_0125_2007_v1.3.nc'],'Longitude');
lat_=ncread([dirdata,'SM2RAIN_ASCAT_0125_2007_v1.3.nc'],'Latitude');

ID1=knnsearch([lon_],lonlat_ext(1));
ID2=knnsearch([lat_],lonlat_ext(2));

D=(datenum('1-jan-2007'):datenum('30-june-2020'))';
Psim_SM2RASC=[];
for ii=2007:2020
    ii
    if ii<2020
        Psim_SM2RASC=[Psim_SM2RASC;...
            ncread([dirdata,'SM2RAIN_ASCAT_0125_',num2str(ii),'_v1.3.nc'],...
            'Rainfall',[1 ID1 ID2],[yeardays(ii) 1 1])];
    else
        Psim_SM2RASC=[Psim_SM2RASC;...
            ncread([dirdata,'SM2RAIN_ASCAT_0125_',num2str(ii),'_v1.3.nc'],...
            'Rainfall',[1 ID1 ID2],[182 1 1])];
    end
end
%%
set(gcf,'Position',[50 50 1400 400],'Paperpositionmode','manual','Papersize',[28 16],'Color','white')
subplot(2,1,1)
plot(D,Psim_SM2RASC,'linew',2)
grid on, box on
axis([D(1) D(end)+1 0 max(Psim_SM2RASC)*1.05])
datetick('x','keeplimits')
ylabel('rainfall [mm/day]')
title(['SM2RAIN-ASCAT v1.3 lon;lat=',num2str(lonlat_ext(1),'%3.2f'),';',num2str(lonlat_ext(2),'%3.2f')])

h = axes('Position',[0.15 0.75 0.15 0.25]);
hold on
load coast
plot(long,lat,'k')
plot(lonlat_ext(1),lonlat_ext(2),'o','MarkerFacecolor','y')
axis equal, grid on, box on
axis([-180 180 -60 80])
set(gca,'Xticklabel','','Yticklabel','')

subplot(2,1,2)
plot(calc_mens_min([D,D]),calc_mens_sum([D,Psim_SM2RASC]),'r','linew',3)
grid on, box on
axis([D(1) D(end)+1 0 max(calc_mens_sum([D,Psim_SM2RASC]))*1.05])
datetick('x','keeplimits')
ylabel('rainfall [mm/month]')

export_fig(gcf,['TS_SM2RASC_v1.3_',num2str(lonlat_ext(1),'%3.2f'),'_',num2str(lonlat_ext(2),'%3.2f')],'-png','-q60','-r150');

save(['Psim_SM2RAIN_ASCAT_v1.3_',num2str(lonlat_ext(1)*100,'%3.0f'),'_',num2str(lonlat_ext(2)*100,'%3.0f')],'Psim_SM2RASC','lonlat_ext','D')

