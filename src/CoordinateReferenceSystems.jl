module CoordinateReferenceSystems

using CoordinateReferenceSystemsBase, GDAL
using CoordinateReferenceSystemsBase: EPSG_PREFIX

export AbstractCRSdefinition, Proj4string, WellKnownText, EPSGcode, GeoJSONdictCRS


refs() = GDAL.newspatialreference(C_NULL), Ref(Cstring(C_NULL))

# convert between CRS definitions
"Get the WKT of an Integer EPSG code"
Base.convert(::Type{WellKnownText}, input::EPSGcode) = begin
    srs, ptr = refs()
    GDAL.importfromepsg(srs, input.data)
    GDAL.exporttowkt(srs, ptr)
    return WellKnownText(unsafe_string(ptr[]))
end

"Get the WKT of a Proj string"
Base.convert(::Type{WellKnownText}, input::Proj4string) = begin
    srs, ptr = refs()
    GDAL.importfromproj4(srs, input.data)
    GDAL.exporttowkt(srs, ptr)
    return WellKnownText(unsafe_string(ptr[]))
end

"Reformat WKT"
Base.convert(::Type{WellKnownText}, input::WellKnownText) = begin
    srs, ptr = refs()
    GDAL.importfromwkt(srs, [input.data])
    GDAL.exporttowkt(srs, ptr)
    return WellKnownText(unsafe_string(ptr[]))
end


"Get a Proj4 string from WKT"
Base.convert(::Type{Proj4string}, input::WellKnownText) = begin
    srs, ptr = refs()
    GDAL.importfromwkt(srs, [input.data])
    GDAL.exporttoproj4(srs, ptr)
    return Proj4string(unsafe_string(ptr[]))
end

"Reformat a Proj4 string"
Base.convert(::Type{Proj4string}, input::Proj4string) = begin
    srs, ptr = refs()
    GDAL.importfromproj4(srs, input.data)
    GDAL.exporttoproj4(srs, ptr)
    return Proj4string(unsafe_string(ptr[]))
end

"Get a Proj4 string from an EPSG code"
Base.convert(::Type{Proj4string}, input::EPSGcode) = begin
    srs, ptr = refs()
    GDAL.importfromepsg(srs, input.data)
    GDAL.exporttoproj4(srs, ptr)
    return Proj4string(unsafe_string(ptr[]))
end

# convert to String
Base.convert(::Type{String}, input::WellKnownText) = input.data 
Base.convert(::Type{String}, input::Proj4string) = input.data
Base.convert(::Type{String}, input::EPSGcode) = string(EPSG_PREFIX, input.data)

# convert to Int
Base.convert(::Type{Int}, input::EPSGcode) = input.data

# convert from String
Base.convert(::Type{WellKnownText}, input::AbstractString) = WellKnownText(input)
Base.convert(::Type{Proj4string}, input::AbstractString) = Proj4string(input)
Base.convert(::Type{EPSGcode}, input::AbstractString) = EPSGcode(input)

# convert from Int
Base.convert(::Type{EPSGcode}, input::Int) = EPSGcode(input)

end # module
