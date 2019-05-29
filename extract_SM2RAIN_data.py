import netCDF4
import numpy as np
from scipy import spatial
import matplotlib.pyplot as plt
from datetime import datetime, timedelta
nc_f='path/to/the/data/SM2RAIN_ASCAT_0125_2007.nc'
nc_fid = netCDF4.Dataset(nc_f, 'r')
# Coordinates of the station you want to extract
stat=[11.88,44.31]
lat_ = nc_fid.variables['Latitude'][:]
lon_ = nc_fid.variables['Longitude'][:]
tree=spatial.KDTree(zip(lon_.ravel(),lat_.ravel()))
[d,ID]=tree.query(stat)
# Extraction of SM2RAIN-ASCAT rainfall from 2007 to 2018
datahub=[]
for ii in np.arange(2007,2019):
    nc_f='path/to/the/data/SM2RAIN_ASCAT_0125_'+str(ii)+'.nc'
    nc_fid = netCDF4.Dataset(nc_f, 'r')
    Rain=nc_fid.variables['Rainfall'][ID]
    # np.concatenate does not preserve masking of MaskedArray inputs, here np.ma.concatenate is used
    datahub=np.ma.concatenate((datahub,Rain), axis=0)

DD = np.arange(datetime(2007,1,1), datetime(2019,1,1), timedelta(days=1)).astype(datetime)
plt.plot(DD,datahub)
plt.ylabel('rainfall [mm/day]')
plt.title('SM2RAIN-ASCAT lon;lat='+str(stat[0])+';'+str(stat[1]))
plt.show()




