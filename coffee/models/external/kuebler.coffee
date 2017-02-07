########################################################################################################################
#                                                                                                                      #
# Model containing products by Kuebler.                                                                                #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"
REQUIRE "models/external/itt.coffee"

MODEL "http://www.mercator.iac.es/onto/models/external/kuebler" : "kuebler"

kuebler.IMPORT man
kuebler.IMPORT elec
kuebler.IMPORT itt


########################################################################################################################
# Company
########################################################################################################################

kuebler.ADD MANUFACTURER(
        shortName : "Kuebler"
        longName  : "Kuebler"
        comment   : "Produces encoders") "company"


########################################################################################################################
# Cables
########################################################################################################################

kuebler.ADD CABLE_TYPE(
    id              : "Cable9CoreScreen"
    comment         : "Kubler SSI encoder cable"
    manufacturer    : kuebler.company
    wires:
        white   : -> { symbol: "WH" , comment: "White wire"    , color: colors.white }
        brown   : -> { symbol: "BN" , comment: "Brown wire"    , color: colors.brown }
        green   : -> { symbol: "GN" , comment: "Green wire"    , color: colors.green }
        yellow  : -> { symbol: "YE" , comment: "Yellow wire"   , color: colors.yellow }
        gray    : -> { symbol: "GY" , comment: "Gray wire"     , color: colors.gray }
        pink    : -> { symbol: "PK" , comment: "Pink wire"     , color: colors.pink }
        blue    : -> { symbol: "BU" , comment: "Blue wire"     , color: colors.blue }
        red     : -> { symbol: "RD" , comment: "Red wire"      , color: colors.red }
        black   : -> { symbol: "BK" , comment: "Black wire"      , color: colors.black }
        screen  : -> { symbol: "S"  , comment: "Shield of the cable" }) "Cable9CoreScreen"

kuebler.ADD CABLE_TYPE(
    id              : "Cable9CoreScreen2"
    comment         : "Kubler SSI encoder cable"
    manufacturer    : kuebler.company
    wires:
        white   : -> { symbol: "WH" , comment: "White wire"    , color: colors.white }
        brown   : -> { symbol: "BN" , comment: "Brown wire"    , color: colors.brown }
        green   : -> { symbol: "GN" , comment: "Green wire"    , color: colors.green }
        yellow  : -> { symbol: "YE" , comment: "Yellow wire"   , color: colors.yellow }
        gray    : -> { symbol: "GY" , comment: "Gray wire"     , color: colors.gray }
        pink    : -> { symbol: "PK" , comment: "Pink wire"     , color: colors.pink }
        blue    : -> { symbol: "BU" , comment: "Blue wire"     , color: colors.blue }
        red     : -> { symbol: "RD" , comment: "Red wire"      , color: colors.red }
        violet  : -> { symbol: "BK" , comment: "Violet wire"   , color: colors.violet }
        screen  : -> { symbol: "S"  , comment: "Shield of the cable" }) "Cable9CoreScreen2"


########################################################################################################################
# Encoders
########################################################################################################################

kuebler.ADD SENSOR_TYPE(
    id              : "F5863-1222-G321"
    comment         : "SSI encoder ST=13-bit MT=12-bit"
    manufacturer    : kuebler.company
    connectors:
        plug        : ->
            type    : itt.Dsub9MP
            comment : "DSub-9 male connector attached to the cable"
            terminals    :
                1   : -> symbol: "0V"           , comment: "GND"
                2   : -> symbol: "+V"           , comment: "10..30VDC"
                3   : -> symbol: "+C"           , comment: "Clock +"
                4   : -> symbol: "-C"           , comment: "Clock -"
                5   : -> symbol: "+D"           , comment: "Data +"
                6   : -> symbol: "-D"           , comment: "Data -"
                7   : -> symbol: "SET"          , comment: "Set zero or predefined value"
                8   : -> symbol: "DIR"          , comment: "Set direction"
                9   : -> symbol: "STAT"         , comment: "Status"
                chassis: -> symbol: "SHLD"   , comment: "Shield"
    cables:
        cable       : ->
            type: kuebler.Cable9CoreScreen
            comment: "Cable coming out of the encoder"
            wires:
                white   : -> comment: "0V"                                      , to: $.connectors.plug.terminals[1]
                brown   : -> comment: "+V (10..30VDC)"                          , to: $.connectors.plug.terminals[2]
                green   : -> comment: "Clock +"                                 , to: $.connectors.plug.terminals[3]
                yellow  : -> comment: "Clock -"                                 , to: $.connectors.plug.terminals[4]
                gray    : -> comment: "Data +"                                  , to: $.connectors.plug.terminals[5]
                pink    : -> comment: "Data -"                                  , to: $.connectors.plug.terminals[6]
                blue    : -> comment: "SET (set zero or a predefined value)"    , to: $.connectors.plug.terminals[7]
                red     : -> comment: "DIR (set counting direction)"            , to: $.connectors.plug.terminals[8]
                black   : -> comment: "STAT (status, +V=OK, 0V=Fault)"          , to: $.connectors.plug.terminals[9]
                screen  : -> comment: "Shield"                                  , to: $.connectors.plug.terminals.chassis
    ) "F5863_1222_G321"

kuebler.ADD SENSOR_TYPE(
    id              : "F3673.1421.G412"
    comment         : "SSI encoder ST=14-bit"
    manufacturer    : kuebler.company
    cables:
        cable       : ->
            type: kuebler.Cable9CoreScreen2
            comment: "Cable coming out of the encoder"
            wires:
                white   : -> comment: "0V"
                brown   : -> comment: "+V (10..30VDC)"
                green   : -> comment: "Clock +"
                yellow  : -> comment: "Clock -"
                gray    : -> comment: "Data +"
                pink    : -> comment: "Data -"
                blue    : -> comment: "SET (set zero or a predefined value)"
                red     : -> comment: "DIR (set counting direction)"
                violet  : -> comment: "STAT (status, +V=OK, 0V=Fault)"
                screen  : -> comment: "Shield"
    ) "F3673_1421_G412"

########################################################################################################################
# Write the model to file
########################################################################################################################

kuebler.WRITE "models/external/kuebler.jsonld"

