require 'forecast_io'
require 'yaml'

CONFIG = YAML.load_file('config.yaml')
ForecastIO.api_key = CONFIG['dark_sky_api_key']
