import netCDF4
import numpy as np
from scipy import spatial
import matplotlib.pyplot as plt
from datetime import datetime, timedelta
nc_f='SM2RAIN_ASCAT_0125_2007_v1.3.nc'
nc_fid = netCDF4.Dataset(nc_f, 'r')
# Coordinates of the station you want to extract
stat=[21.125,-102.125]
lat_0 = nc_fid.variables['Latitude'][:]
lon_0 = nc_fid.variables['Longitude'][:]
[lon_,lat_]=np.meshgrid(lon_0,lat_0)
lon_=lon_.ravel()
lat_=lat_.ravel()


tree=spatial.KDTree(list(zip(lat_,lon_)))
[d,ID]=tree.query(stat)
IDlon=np.where(lon_0==lon_.ravel()[ID])[0]
IDlat=np.where(lat_0==lat_.ravel()[ID])[0]
# Extraction of SM2RAIN-ASCAT rainfall from 2007 to 2018
datahub=[]
for ii in np.arange(2007,2019):
    nc_f='SM2RAIN_ASCAT_0125_'+str(ii)+'_v1.3.nc'
    nc_fid = netCDF4.Dataset(nc_f, 'r')
    Rain=nc_fid.variables['Rainfall'][IDlat,IDlon,:]
    # np.concatenate does not preserve masking of MaskedArray inputs, here np.ma.concatenate is used
    datahub=np.ma.concatenate((datahub,Rain), axis=0)

DD = np.arange(datetime(2007,1,1), datetime(2019,1,1), timedelta(days=1)).astype(datetime)
plt.plot(DD,datahub)
plt.ylabel('rainfall [mm/day]')
plt.title('SM2RAIN-ASCAT lon;lat='+str(stat[0])+';'+str(stat[1]))
plt.show() 
