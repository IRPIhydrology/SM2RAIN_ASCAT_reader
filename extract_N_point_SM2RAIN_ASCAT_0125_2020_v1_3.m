clc,clear,close all
lonlat_ext=load('lonlat.txt');

dirdata='';
lon_=ncread([dirdata,'SM2RAIN_ASCAT_0125_2007_v1.3.nc'],'Longitude');
lat_=ncread([dirdata,'SM2RAIN_ASCAT_0125_2007_v1.3.nc'],'Latitude');

ID1=knnsearch([lon_],lonlat_ext(:,1));
ID2=knnsearch([lat_],lonlat_ext(:,2));

D=(datenum('1-jan-2007'):datenum('30-june-2020'))';
Psim_SM2RASC=[];
for ii=2007:2020
    ii
    if ii<2020
        P=NaN(yeardays(ii),length(ID1));
        for jj=1:length(ID1)
            P(:,jj)=ncread([dirdata,'SM2RAIN_ASCAT_0125_',num2str(ii),'_v1.3.nc'],...
                'Rainfall',[1 ID1(jj) ID2(jj)],[yeardays(ii) 1 1]);
        end
    else
        P=NaN(182,length(ID1));
        for jj=1:length(ID1)
            P(:,jj)=ncread([dirdata,'SM2RAIN_ASCAT_0125_',num2str(ii),'_v1.3.nc'],...
                'Rainfall',[1 ID1(jj) ID2(jj)],[182 1 1]);
        end
    end
    Psim_SM2RASC=[Psim_SM2RASC;P];
end
%%
set(gcf,'Position',[50 50 1400 400],'Paperpositionmode','manual','Papersize',[28 16],'Color','white')
subplot(2,1,1)
plot(D,nanmean(Psim_SM2RASC,2),'linew',2)
grid on, box on
datetick('x','keeplimits')
ylabel('rainfall [mm/day]')
title(['SM2RAIN-ASCAT v1.3 lon;lat=',num2str(lonlat_ext(1,1),'%3.2f'),';',num2str(lonlat_ext(1,2),'%3.2f')])

h = axes('Position',[0.15 0.75 0.15 0.25]);
hold on
load coast
plot(long,lat,'k')
plot(lonlat_ext(1,1),lonlat_ext(1,2),'o','MarkerFacecolor','y')
axis equal, grid on, box on
axis([-180 180 -60 80])
set(gca,'Xticklabel','','Yticklabel','')

subplot(2,1,2)
plot(calc_mens_min([D,D]),calc_mens_sum([D,nanmean(Psim_SM2RASC,2)]),'r','linew',3)
grid on, box on
datetick('x','keeplimits')
ylabel('rainfall [mm/month]')

export_fig(gcf,['TS_NP_SM2RASC_v1.3_',num2str(lonlat_ext(1),'%3.2f'),'_',num2str(lonlat_ext(2),'%3.2f')],'-png','-q60','-r150');