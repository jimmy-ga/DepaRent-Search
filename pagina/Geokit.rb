require 'rubygems'
require 'geokit'

def buscar_ubicacion(nombre)
	a=Geokit::Geocoders::GoogleGeocoder.geocode nombre
	return a.ll.split(",")
	#return a.to_s
end

#a=buscar_ubicacion('kfc,cartago,costa rica')
#puts a.split(",")
