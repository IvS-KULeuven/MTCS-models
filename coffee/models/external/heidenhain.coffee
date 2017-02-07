########################################################################################################################
#                                                                                                                      #
# Model containing products by Heidenhain.                                                                             #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"

MODEL "http://www.mercator.iac.es/onto/models/external/heidenhain" : "heidenhain"

heidenhain.IMPORT man
heidenhain.IMPORT elec


########################################################################################################################
# Company
########################################################################################################################

heidenhain.ADD MANUFACTURER(
        shortName : "Heidenhain"
        longName  : "Heidenhain"
        comment   : "Produces encoders") "company"


########################################################################################################################
# Connectors
########################################################################################################################

heidenhain.ADD CONNECTOR_TYPE(
    id              : "M23-9pin-FS"
    comment         : "M23 flange socket (female) with 9 terminals"
    manufacturer    : heidenhain.company
    gender          : elec.female
    terminals:
        1        : -> { symbol: "1"         , comment: "Pin 1" }
        2        : -> { symbol: "2"         , comment: "Pin 2" }
        3        : -> { symbol: "3"         , comment: "Pin 3" }
        4        : -> { symbol: "4"         , comment: "Pin 4" }
        5        : -> { symbol: "5"         , comment: "Pin 5" }
        6        : -> { symbol: "7"         , comment: "Pin 6" }
        7        : -> { symbol: "7"         , comment: "Pin 7" }
        8        : -> { symbol: "8"         , comment: "Pin 8" }
        9        : -> { symbol: "9"         , comment: "Pin 9" }
        chassis  : -> { symbol: "CHASSIS"   , comment: "Housing" }) "M23FemaleSocket9Pins"


heidenhain.ADD CONNECTOR_TYPE(
    id              : "M23-9pin-MP"
    comment         : "M23 cable plug (male) with 9 terminals"
    manufacturer    : heidenhain.company
    gender          : elec.male
    terminals:
        1        : -> { symbol: "1"         , comment: "Pin 1" }
        2        : -> { symbol: "2"         , comment: "Pin 2" }
        3        : -> { symbol: "3"         , comment: "Pin 3" }
        4        : -> { symbol: "4"         , comment: "Pin 4" }
        5        : -> { symbol: "5"         , comment: "Pin 5" }
        6        : -> { symbol: "7"         , comment: "Pin 6" }
        7        : -> { symbol: "7"         , comment: "Pin 7" }
        8        : -> { symbol: "8"         , comment: "Pin 8" }
        9        : -> { symbol: "9"         , comment: "Pin 9" }
        chassis  : -> { symbol: "CHASSIS"   , comment: "Housing" }) "M23MalePlug9Pins"


heidenhain.ADD CONNECTOR_TYPE(
    id              : "M23-9pin-FP"
    comment         : "M23 cable plug (female) with 9 terminals"
    manufacturer    : heidenhain.company
    gender          : elec.female
    terminals:
        1        : -> { symbol: "1"         , comment: "Pin 1" }
        2        : -> { symbol: "2"         , comment: "Pin 2" }
        3        : -> { symbol: "3"         , comment: "Pin 3" }
        4        : -> { symbol: "4"         , comment: "Pin 4" }
        5        : -> { symbol: "5"         , comment: "Pin 5" }
        6        : -> { symbol: "7"         , comment: "Pin 6" }
        7        : -> { symbol: "7"         , comment: "Pin 7" }
        8        : -> { symbol: "8"         , comment: "Pin 8" }
        9        : -> { symbol: "9"         , comment: "Pin 9" }
        chassis  : -> { symbol: "CHASSIS"   , comment: "Housing" }) "M23FemalePlug9Pins"


heidenhain.ADD CONNECTOR_TYPE(
    id              : "M23-12pin-MS"
    comment         : "M23 flange socket (male) with 12 terminals"
    manufacturer    : heidenhain.company
    gender          : elec.male
    terminals:
        1        : -> { symbol: "1"         , comment: "Pin 1" }
        2        : -> { symbol: "2"         , comment: "Pin 2" }
        3        : -> { symbol: "3"         , comment: "Pin 3" }
        4        : -> { symbol: "4"         , comment: "Pin 4" }
        5        : -> { symbol: "5"         , comment: "Pin 5" }
        6        : -> { symbol: "7"         , comment: "Pin 6" }
        7        : -> { symbol: "7"         , comment: "Pin 7" }
        8        : -> { symbol: "8"         , comment: "Pin 8" }
        9        : -> { symbol: "9"         , comment: "Pin 9" }
        10       : -> { symbol: "10"        , comment: "Pin 10" }
        11       : -> { symbol: "11"        , comment: "Pin 11" }
        12       : -> { symbol: "12"        , comment: "Pin 12" }
        chassis  : -> { symbol: "CHASSIS"   , comment: "Housing" }) "M23MaleSocket12Pins"


heidenhain.ADD CONNECTOR_TYPE(
    id              : "M23-12pin-FP"
    comment         : "M23 cable plug (female) with 12 terminals"
    manufacturer    : heidenhain.company
    gender          : elec.female
    terminals:
        1        : -> { symbol: "1"         , comment: "Pin 1" }
        2        : -> { symbol: "2"         , comment: "Pin 2" }
        3        : -> { symbol: "3"         , comment: "Pin 3" }
        4        : -> { symbol: "4"         , comment: "Pin 4" }
        5        : -> { symbol: "5"         , comment: "Pin 5" }
        6        : -> { symbol: "7"         , comment: "Pin 6" }
        7        : -> { symbol: "7"         , comment: "Pin 7" }
        8        : -> { symbol: "8"         , comment: "Pin 8" }
        9        : -> { symbol: "9"         , comment: "Pin 9" }
        10       : -> { symbol: "10"        , comment: "Pin 10" }
        11       : -> { symbol: "11"        , comment: "Pin 11" }
        12       : -> { symbol: "12"        , comment: "Pin 12" }
        chassis  : -> { symbol: "CHASSIS"   , comment: "Housing" }) "M23FemalePlug12Pins"


heidenhain.ADD CONNECTOR_TYPE(
    id              : "D-sub 15 M plug"
    comment         : "D-sub 15 male plug"
    manufacturer    : heidenhain.company
    gender          : elec.male
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        7  : -> { symbol: "7" , comment: "Pin 7" }
        8  : -> { symbol: "8" , comment: "Pin 8" }
        9  : -> { symbol: "9" , comment: "Pin 9" }
        10 : -> { symbol: "10" , comment: "Pin 10" }
        11 : -> { symbol: "11" , comment: "Pin 11" }
        12 : -> { symbol: "12" , comment: "Pin 12" }
        13 : -> { symbol: "13" , comment: "Pin 13" }
        14 : -> { symbol: "14" , comment: "Pin 14" }
        15 : -> { symbol: "15" , comment: "Pin 15" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub15MP"


########################################################################################################################
# Cables
########################################################################################################################

heidenhain.ADD CABLE_TYPE(
    id              : "Cable8CoreScreen"
    comment         : "Heidenhain cable"
    manufacturer    : heidenhain.company
    wires:
        brown   : -> { symbol: "BR" , comment: "Brown wire"    , color: colors.brown }
        white   : -> { symbol: "WH" , comment: "White wire"    , color: colors.white }
        green   : -> { symbol: "GN" , comment: "Green wire"    , color: colors.green }
        yellow  : -> { symbol: "YE" , comment: "Yellow wire"   , color: colors.yellow }
        blue    : -> { symbol: "BL" , comment: "Blue wire"     , color: colors.blue }
        red     : -> { symbol: "RE" , comment: "Red wire"      , color: colors.red }
        gray    : -> { symbol: "GY" , comment: "Gray wire"     , color: colors.gray }
        pink    : -> { symbol: "PN" , comment: "Pink wire"     , color: colors.pink }
        screen  : -> { symbol: "S"  , comment: "Screen of the cable", color: [colors.white, colors.brown] }) "Cable8CoreScreen"



heidenhain.ADD CABLE_TYPE(
    id              : "Cable12CoreScreen"
    comment         : "Heidenhain cable"
    manufacturer    : heidenhain.company
    wires:
        gray        : -> { symbol: "GY"     , comment: "Gray wire"                  , color: colors.gray }
        pink        : -> { symbol: "PN"     , comment: "Pink wire"                  , color: colors.pink }
        violet      : -> { symbol: "VI"     , comment: "Violet wire"                , color: colors.violet }
        yellow      : -> { symbol: "YE"     , comment: "Yellow wire"                , color: colors.yellow }
        brown       : -> { symbol: "BR"     , comment: "Brown wire"                 , color: colors.brown }
        green       : -> { symbol: "GN"     , comment: "Green wire"                 , color: colors.green }
        whitegreen  : -> { symbol: "WH/GN"  , comment: "White/green wire: 0.5 mm2"  , color: [colors.white, colors.green] , label: "white/green"}
        browngreen  : -> { symbol: "BR/GN"  , comment: "Brown/green wire: 0.5 mm2"  , color: [colors.brown, colors.green] , label: "brown/green" }
        white       : -> { symbol: "WH"     , comment: "White wire: 0.5 mm2"        , color: [colors.white] }
        blue        : -> { symbol: "BU"     , comment: "Blue wire: 0.5 mm2"         , color: [colors.blue] }
        red         : -> { symbol: "RE"     , comment: "Red wire"                   , color: colors.red }
        black       : -> { symbol: "BK"     , comment: "Black wire"                 , color: colors.black }
        screen      : -> { symbol: "S"      , comment: "Screen of the cable" }) "Cable12CoreScreen"


########################################################################################################################
# Cable assemblies
########################################################################################################################


heidenhain.ADD CABLE_ASSEMBLY_TYPE(
    comment : "Cable assembly from EXE 12-pole connector to DSub15 connector"
    id              : "CableAssemblyExeToD15"
    manufacturer    : heidenhain.company
    connectors:
        exeSide     : -> type: heidenhain.M23FemalePlug12Pins , comment: "Plug on the EXE side"
        d15Side     : -> type: heidenhain.Dsub15MP            , comment: "Plug to connect to readout electricity"
    cables:
        cable       : ->
            type: heidenhain.Cable12CoreScreen
            comment: "Cable between both plugs"
            wires:
                yellow      : -> from:  $.connectors.exeSide.terminals[1], to: $.connectors.d15Side.terminals[10]
                whitegreen  : -> from:  $.connectors.exeSide.terminals[2], to: $.connectors.d15Side.terminals[11]
                brown       : -> from:  $.connectors.exeSide.terminals[3], to: $.connectors.d15Side.terminals[3]
                green       : -> from:  $.connectors.exeSide.terminals[4], to: $.connectors.d15Side.terminals[12]
                gray        : -> from:  $.connectors.exeSide.terminals[5], to: $.connectors.d15Side.terminals[1]
                pink        : -> from:  $.connectors.exeSide.terminals[6], to: $.connectors.d15Side.terminals[4]
                red         : -> from:  $.connectors.exeSide.terminals[7], to: $.connectors.d15Side.terminals[14]
                violet      : -> from:  $.connectors.exeSide.terminals[8], to: $.connectors.d15Side.terminals[2]
                black       : -> from:  $.connectors.exeSide.terminals[9], to: $.connectors.d15Side.terminals[15]
                browngreen  : -> from:  $.connectors.exeSide.terminals[10], to: $.connectors.d15Side.terminals[5]
                blue        : -> from:  $.connectors.exeSide.terminals[11], to: $.connectors.d15Side.terminals[6]
                white       : -> from:  $.connectors.exeSide.terminals[12], to: $.connectors.d15Side.terminals[13]
                screen      : -> from:  $.connectors.exeSide.terminals.chassis, to: $.connectors.d15Side.terminals[8]
    ) "CableAssemblyExeToD15"

heidenhain.ADD CABLE_ASSEMBLY_TYPE(
    comment : "Cable assembly to extend a LIDA cable (i.e. a simple straight cable)"
    id              : "CableAssemblyLidaExtension"
    manufacturer    : heidenhain.company
    connectors:
        lidaSide    : -> type: heidenhain.M23FemalePlug9Pins  , comment: "Plug on the LIDA side"
        exeSide     : -> type: heidenhain.M23MalePlug9Pins , comment: "Plug on the EXE side"
    cables:
        cable       : ->
            type: heidenhain.Cable8CoreScreen
            comment: "Straight cable between both plugs"
            wires:
                green  : -> from: $.connectors.lidaSide.terminals[1], to: $.connectors.exeSide.terminals[1]
                yellow : -> from: $.connectors.lidaSide.terminals[2], to: $.connectors.exeSide.terminals[2]
                brown  : -> from: $.connectors.lidaSide.terminals[3], to: $.connectors.exeSide.terminals[3]
                white  : -> from: $.connectors.lidaSide.terminals[4], to: $.connectors.exeSide.terminals[4]
                blue   : -> from: $.connectors.lidaSide.terminals[5], to: $.connectors.exeSide.terminals[5]
                red    : -> from: $.connectors.lidaSide.terminals[6], to: $.connectors.exeSide.terminals[6]
                gray   : -> from: $.connectors.lidaSide.terminals[7], to: $.connectors.exeSide.terminals[7]
                pink   : -> from: $.connectors.lidaSide.terminals[8], to: $.connectors.exeSide.terminals[8]
                screen : -> from: $.connectors.lidaSide.terminals[9], to: $.connectors.exeSide.terminals[9]
    ) "CableAssemblyLidaExtension"


########################################################################################################################
# LIPs/LIDAs
########################################################################################################################

heidenhain.ADD SENSOR_TYPE(
    id              : "LIDA360"
    comment         : "LIDA 360 scanning head"
    manufacturer    : heidenhain.company
    connectors:
        plug        : ->
            type    : heidenhain.M23MalePlug9Pins
            comment : "9-terminals connector attached to the cable"
            terminals    :
                1   : -> symbol: "I1+"          , comment: "Sin/cos signal 0 degrees +"
                2   : -> symbol: "I1-"          , comment: "Sin/cos signal 0 degrees -"
                3   : -> symbol: "Up"           , comment: "5V power supply of light source"
                4   : -> symbol: "0V"           , comment: "0V power supply of light source"
                5   : -> symbol: "I2+"          , comment: "Sin/cos signal 90 degrees +"
                6   : -> symbol: "I2-"          , comment: "Sin/cos signal 90 degrees -"
                7   : -> symbol: "I0+"          , comment: "Reference signal +"
                8   : -> symbol: "I0-"          , comment: "Reference signal -"
                9   : -> symbol: "SHLD"         , comment: "Internal shield"
                chassis: -> symbol: "CHASSIS"   , comment: "External shield"
    cables:
        cable       : ->
            type: heidenhain.Cable8CoreScreen
            comment: "Cable coming out of the scanning head"
            wires:
                green  : -> to: $.connectors.plug.terminals[1]
                yellow : -> to: $.connectors.plug.terminals[2]
                brown  : -> to: $.connectors.plug.terminals[3]
                white  : -> to: $.connectors.plug.terminals[4]
                blue   : -> to: $.connectors.plug.terminals[5]
                red    : -> to: $.connectors.plug.terminals[6]
                gray   : -> to: $.connectors.plug.terminals[7]
                pink   : -> to: $.connectors.plug.terminals[8]
                screen : -> to: $.connectors.plug.terminals[9]
    ) "LIDA360"


########################################################################################################################
# Other electricity
########################################################################################################################

heidenhain.ADD DEVICE_TYPE(
    id              : "EXE660B"
    comment         : "Interpolation and digitizing electricity"
    manufacturer    : heidenhain.company
    connectors:
        inputConnector       : -> type: heidenhain.M23FemaleSocket9Pins  , comment: "Input signals (11 microamps peak-to-peak) and 5V power"
        outputConnector      : -> type: heidenhain.M23MaleSocket12Pins   , comment: "TTL output signals"
    ) "EXE660B"


########################################################################################################################
# Write the model to file
########################################################################################################################

heidenhain.WRITE "models/external/heidenhain.jsonld"

