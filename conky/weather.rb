#!/usr/bin/ruby -w
require 'rubygems'
require 'xmlsimple'
require 'open-uri'

#TODO Check for NA, Drop °F if it is.
#TODO Grab forecast
#TODO use getoptlong for command line options

config = XmlSimple.xml_in(open('http://www.nws.noaa.gov/data/current_obs/KMLT.xml'), {'KeyAttr' => 'name'})

puts "Sky: #{config['weather']}
Temp: #{config['temp_f']}°F
Dewpoint: #{config['dewpoint_f']}°F
Humidity: #{config['relative_humidity']}%
Windchill: #{config['windchill_f']}°F
Visibility: #{config['visibility_mi']} Miles
Wind: #{config['wind_string']}"
