# Import packages
# For some reason, rasterio only works if you import gdal from osgeo

from osgeo import gdal
import xarray as xr
import rasterio
from rasterio.plot import show
import rioxarray as rio

# Open the netcdf you want to convert
nc_file = xr.open_dataset('/Users/student/Documents/VOD_Project/VOD_Summer_Data/MTDCA_201604_201606_9km_V4.nc')

# The netcdf is now a raster in the variable vod
VOD = nc_file["VOD"]

# Depending on what you want to convert, only uncomment one of the next 2 lines of code

path = '/Users/student/Documents/VOD_Project/vod_summer_geotiff/vod_june_2016_1.tiff'
i = 1

# If your netcdf file has a time variable, and you want one specific day,
# uncomment the next line and set the time to what you want
for x in range(61, 92):
    VOD_DATA = VOD.isel(time = x) # LINE TO UNCOMMENT!!!!!
    # If your netcdf file has a time variable, and you want to get an average over a
    # specific time period, uncomment the next line and set the time

    # VOD = VOD.resample(time = '1Y').mean(skipna= True) # LINE TO UNCOMMENT!!!!!

    # If your netcdf does not have a time variable, leave both of the previous lines of code commented

    # Setting geotiff x/y to the latitude/longitude
    VOD_DATA = VOD_DATA.rio.set_spatial_dims(x_dim='lon', y_dim='lat')

    # Adding the ease 2.0 projection
    VOD_DATA.rio.write_crs("epsg:6933", inplace=True)

    # Writing the raster to a file, change the name/directory if you would like
    VOD_DATA.rio.to_raster(path)

    i = str(i)
    path = '/Users/student/Documents/VOD_Project/vod_summer_geotiff/vod_june2016' + i + '.tiff'
    i = int(i)
    i += 1