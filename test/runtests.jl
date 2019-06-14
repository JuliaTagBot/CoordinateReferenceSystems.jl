using Test, CoordinateReferenceSystems

@testset "CoordinateReferenceSystems.jl" begin

    epsg_nl_code = EPSGcode(28992)
    epsg_nl_wkt = WellKnownText("PROJCS[\"Amersfoort / RD New\",GEOGCS[\"Amersfoort\",DATUM[\"Amersfoort\",SPHEROID[\"Bessel 1841\",6377397.155,299.1528128,AUTHORITY[\"EPSG\",\"7004\"]],TOWGS84[565.2369,50.0087,465.658,-0.406857,0.350733,-1.87035,4.0812],AUTHORITY[\"EPSG\",\"6289\"]],PRIMEM[\"Greenwich\",0,AUTHORITY[\"EPSG\",\"8901\"]],UNIT[\"degree\",0.0174532925199433,AUTHORITY[\"EPSG\",\"9122\"]],AUTHORITY[\"EPSG\",\"4289\"]],PROJECTION[\"Oblique_Stereographic\"],PARAMETER[\"latitude_of_origin\",52.15616055555555],PARAMETER[\"central_meridian\",5.38763888888889],PARAMETER[\"scale_factor\",0.9999079],PARAMETER[\"false_easting\",155000],PARAMETER[\"false_northing\",463000],UNIT[\"metre\",1,AUTHORITY[\"EPSG\",\"9001\"]],AXIS[\"X\",EAST],AXIS[\"Y\",NORTH],AUTHORITY[\"EPSG\",\"28992\"]]")
    epsg_nl_proj4 = Proj4string("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857,0.350733,-1.87035,4.0812 +units=m +no_defs ")

    merc_proj_string = Proj4string("+proj=merc +lat_ts=56.5 +ellps=GRS80  +units=m")
    merc_proj_string_out = Proj4string("+proj=merc +lon_0=0 +lat_ts=56.5 +x_0=0 +y_0=0 +ellps=GRS80 +units=m +no_defs ")
    merc_wkt = WellKnownText("PROJCS[\"unnamed\",GEOGCS[\"GRS 1980(IUGG, 1980)\",DATUM[\"unknown\",SPHEROID[\"GRS80\",6378137,298.257222101]],PRIMEM[\"Greenwich\",0],UNIT[\"degree\",0.0174532925199433]],PROJECTION[\"Mercator_2SP\"],PARAMETER[\"standard_parallel_1\",56.5],PARAMETER[\"central_meridian\",0],PARAMETER[\"false_easting\",0],PARAMETER[\"false_northing\",0],UNIT[\"Meter\",1]]")

    @testset "convert between crs definitions" begin
        # Proj4 > WKT > Proj4
        result = convert(WellKnownText, merc_proj_string)
        @test result == merc_wkt
        result = convert(Proj4string, result)
        @test result == merc_proj_string_out

        # EPSG > WKT
        result = convert(WellKnownText, epsg_nl_code)
        @test result == epsg_nl_wkt

        # WKT > WKT
        result = convert(WellKnownText, merc_wkt)
        @test result == merc_wkt

        # WKT > Proj4 > WKT
        result = convert(Proj4string, merc_wkt)
        @test result == merc_proj_string_out
        result = convert(WellKnownText, result)
        @test result == merc_wkt

        # EPSG > Proj4
        result = convert(Proj4string, epsg_nl_code)
        @test result == epsg_nl_proj4

        # Proj4 > Proj4
        result = convert(Proj4string, merc_proj_string)
        @test result == merc_proj_string_out

    
        # convert to String
        result = convert(String, merc_proj_string)
        @test result == merc_proj_string.data
        result = convert(String, merc_wkt)
        @test result == merc_wkt.data
        result = convert(String, epsg_nl_code)
        @test result == "EPSG:28992"

        # convert to Int
        result = convert(Int, epsg_nl_code)
        @test result == 28992
    end

end
