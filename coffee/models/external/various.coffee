########################################################################################################################
#                                                                                                                      #
# Model containing various components of various companies.                                                            #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"
REQUIRE "metamodels/colors.coffee"

MODEL "http://www.mercator.iac.es/onto/models/external/various" : "various"

various.IMPORT man
various.IMPORT elec
various.IMPORT colors


########################################################################################################################
# Company
########################################################################################################################

various.ADD MANUFACTURER(
        shortName : "Various"
        longName  : "Various companies (unspecified)"
        comment   : "Components of various manufacturers") "company"



########################################################################################################################
# Switches
########################################################################################################################

various.ADD SWITCH_TYPE(
    id              : "NOSwitch"
    comment         : "Normally Open switch"
    manufacturer    : various.company
    terminals:
        1 : -> { symbol: "1"          , comment: "Normally Open contact 1" }
        2 : -> { symbol: "2"          , comment: "Normally Open contact 2" }) "NOSwitch"


various.ADD SWITCH_TYPE(
    id              : "NCSwitch"
    comment         : "Normally Closed switch"
    manufacturer    : various.company
    terminals:
        1 : -> { symbol: "1"          , comment: "Normally Closed contact 1" }
        2 : -> { symbol: "2"          , comment: "Normally Closed contact 2" }) "NCSwitch"


various.ADD SWITCH_TYPE(
    id              : "PNP_NCSwitch"
    comment         : "PNP Normally Closed switch"
    manufacturer    : various.company
    terminals:
        1 : -> { symbol: "1"          , comment: "+24VDC" }
        3 : -> { symbol: "3"          , comment: "GND" }
        4 : -> { symbol: "4"          , comment: "Output" }) "PNP_NCSwitch"


various.ADD SWITCH_TYPE(
    id              : "PNP_NOSwitch"
    comment         : "PNP Normally Open switch"
    manufacturer    : various.company
    terminals:
        1 : -> { symbol: "1"          , comment: "+24VDC" }
        3 : -> { symbol: "3"          , comment: "GND" }
        4 : -> { symbol: "4"          , comment: "Output" }) "PNP_NOSwitch"


various.ADD SWITCH_TYPE(
    id              : "OilLevelSwitch"
    comment         : "Oil level switch"
    manufacturer    : various.company
    terminals:
        1 : -> { symbol: "1"          , comment: "Normally Open contact 1" }
        2 : -> { symbol: "2"          , comment: "Normally Open contact 2" }) "OilLevelSwitch"


various.ADD SWITCH_TYPE(
    id              : "OilReturnOverpressureSwitch"
    comment         : "Oil return overpressure switch"
    manufacturer    : various.company
    terminals:
        1 : -> { symbol: "1"          , comment: "Connect to +24V" }
        2 : -> { symbol: "2"          , comment: "Connect to GND" }
        3 : -> { symbol: "3"          , comment: "NO contact" }) "OilReturnOverpressureSwitch"


various.ADD SWITCH_TYPE(
    id              : "OverpressureSwitch"
    comment         : "Overpressure switch"
    manufacturer    : various.company
    terminals:
        MA1 : -> { symbol: "MA1"          , comment: "Maximum switch: Normally Open contact" }
        MA2 : -> { symbol: "MA2"          , comment: "Maximum switch: Common" }
        MA3 : -> { symbol: "MA3"          , comment: "Maximum switch: Normally Closed contact" }
        MI1 : -> { symbol: "MI1"          , comment: "Minimum switch: Normally Open contact" }
        MI2 : -> { symbol: "MI2"          , comment: "Minimum switch: Common" }
        MI3 : -> { symbol: "MI3"          , comment: "Minimum switch: Normally Closed contact" }) "OverpressureSwitch"


various.ADD SWITCH_TYPE(
    id              : "UnderpressureSwitch"
    comment         : "Underpressure switch"
    manufacturer    : various.company
    terminals:
        1 : -> { symbol: "1"          , comment: "Normally Open contact" }
        2 : -> { symbol: "2"          , comment: "Common" }
        3 : -> { symbol: "3"          , comment: "Normally Closed contact" }) "UnderpressureSwitch"


various.ADD SWITCH_TYPE(
    id              : "FilterSwitch"
    comment         : "Filter overpressure switch"
    manufacturer    : various.company
    terminals:
        1 : -> { symbol: "1"          , comment: "Normally Open contact 1" }
        2 : -> { symbol: "2"          , comment: "Normally Open contact 2" }) "FilterSwitch"


various.ADD SWITCH_TYPE(
    id              : "EStop_NO_NC"
    comment         : "Emergency stop"
    manufacturer    : various.company
    terminals:
        NO1 : -> { symbol: "NO1"          , comment: "Normally Open contact 1" }
        NC1 : -> { symbol: "NC1"          , comment: "Normally Closed contact 1" }
        NO2 : -> { symbol: "NO2"          , comment: "Normally Open contact 2" }
        NC2 : -> { symbol: "NC2"          , comment: "Normally Closed contact 2" }
        chassis: -> { symbol: "chassis"   , comment: "Chassis" }
    ) "EStop_NO_NC"


various.ADD SWITCH_TYPE(
    id              : "Keypad"
    comment         : "Keypad"
    manufacturer    : various.company
    terminals:
        1    : -> { symbol: "1" , comment: "Key 1" }
        2    : -> { symbol: "2" , comment: "Key 2" }
        3    : -> { symbol: "3" , comment: "Key 3" }
        4    : -> { symbol: "4" , comment: "Key 4" }
        5    : -> { symbol: "5" , comment: "Key 5" }
        6    : -> { symbol: "6" , comment: "Key 6" }
        7    : -> { symbol: "7" , comment: "Key 7" }
        8    : -> { symbol: "8" , comment: "Key 8" }
        9    : -> { symbol: "9" , comment: "Key 9" }
        star : -> { symbol: "*" , comment: "Key *" }
        '24V': -> { symbol: "24V" , comment: "24V" }
    ) "Keypad"


########################################################################################################################
# Sensors
########################################################################################################################


various.ADD SENSOR_TYPE(
    id              : "PressureSensor"
    comment         : "Generic pressure sensor"
    manufacturer    : various.company
    terminals:
        DC: -> { symbol: "+24V"      , comment: "+24VDC supply" }
        OUT: -> { symbol: "OUT"       , comment: "Output signal 4..20mA"}) "PressureSensor"


various.ADD SENSOR_TYPE(
    id              : "Pt100"
    comment         : "Generic Pt100 sensor"
    manufacturer    : various.company
    terminals:
        pR   : -> symbol: "+R"   , comment: "+ sensor wire"
        pRL  : -> symbol: "+RL"  , comment: "+ line wire"
        mR   : -> symbol: "-R"   , comment: "- sensor wire"
        mRL  : -> symbol: "-RL"  , comment: "- line wire") "Pt100Sensor"


########################################################################################################################
# Actuators
########################################################################################################################

various.ADD ACTUATOR_TYPE(
    id              : "Buzzer"
    comment         : "Buzzer"
    manufacturer    : various.company
    terminals:
        2  : -> { symbol: "+" , comment: "+ contact" }
        3  : -> { symbol: "-" , comment: "- contact" }) "Buzzer"


various.ADD ACTUATOR_TYPE(
    id              : "LED"
    comment         : "LED"
    manufacturer    : various.company
    terminals:
        a : -> { symbol: "a"          , comment: "Anode (+)" }
        k : -> { symbol: "k"          , comment: "Cathode (-)" }) "LED"


various.ADD ACTUATOR_TYPE(
    id              : "Lamp (230VAC)"
    comment         : "Lamp230VAC"
    manufacturer    : various.company
    terminals:
        L  : -> { symbol: "L"          , comment: "L" }
        N  : -> { symbol: "N"          , comment: "N" }
        PE : -> { symbol: "PE"          , comment: "Protective Earth" }) "Lamp230VAC"


########################################################################################################################
# Cables
########################################################################################################################

various.ADD CABLE_TYPE(
    id              : "Cable 4x0.25+S UC"
    comment         : "Cable 4x0.25 + shield (unspecified colors!)"
    manufacturer    : various.company
    wires:
        1  : -> { symbol: "1", comment: "Wire 1" }
        2  : -> { symbol: "2", comment: "Wire 2" }
        3  : -> { symbol: "3", comment: "Wire 3" }
        4  : -> { symbol: "4", comment: "Wire 4" }
        shield : -> { symbol: "SH", comment: "Shield of the cable" }) "Cable4x025S_NoColors"


various.ADD CABLE_TYPE(
    id              : "Cable 2x0.5+S UC"
    comment         : "Cable 2x0.5 + shield (unspecified colors!)"
    manufacturer    : various.company
    wires:
        1  : -> { symbol: "1", comment: "Wire 1" }
        2  : -> { symbol: "2", comment: "Wire 2" }
        shield : -> { symbol: "SH", comment: "Shield of the cable" }) "Cable2x05S_NoColors"


various.ADD CABLE_TYPE(
    id              : "Cable 3x0.75+S UC"
    comment         : "Cable 3x0.55 + shield (unspecified colors!)"
    manufacturer    : various.company
    wires:
        1  : -> { symbol: "1", comment: "Wire 1" }
        2  : -> { symbol: "2", comment: "Wire 2" }
        3  : -> { symbol: "3", comment: "Wire 3" }
        shield : -> { symbol: "SH", comment: "Shield of the cable" }) "Cable3x075S_NoColors"


various.ADD CABLE_TYPE(
    id              : "Cable 3x1.5"
    comment         : "Cable 3x1.5 mm2"
    manufacturer    : various.company
    wires:
        L  : -> { symbol: "L", comment: "Line"                  , color: colors.brown }
        N  : -> { symbol: "N", comment: "Neutral"               , color: colors.blue }
        PE : -> { symbol: "PE", comment: "Protective Earth"     , color: [ colors.yellow, colors.green ] }) "Cable3x15"


various.ADD CABLE_TYPE(
    id              : "Cable 3x2.5"
    comment         : "Cable 3x2.5 mm2"
    manufacturer    : various.company
    wires:
        L  : -> { symbol: "L", comment: "Line"                  , color: colors.brown }
        N  : -> { symbol: "N", comment: "Neutral"               , color: colors.blue }
        PE : -> { symbol: "PE", comment: "Protective Earth"     , color: [ colors.yellow, colors.green ] }) "Cable3x25"


various.ADD CABLE_TYPE(
    id              : "Cable 4x2x0.25+S"
    comment         : "Cable 4x2x0.25 + shield"
    manufacturer    : various.company
    wires:
        white  : -> { symbol: "WH", comment: "Twisted pair with brown wire" }
        brown  : -> { symbol: "BN", comment: "Twisted pair with white wire" }
        blue   : -> { symbol: "BU", comment: "Twisted pair with red wire" }
        red    : -> { symbol: "RD", comment: "Twisted pair with blue wire" }
        green  : -> { symbol: "GN", comment: "Twisted pair with yellow wire" }
        yellow : -> { symbol: "YE", comment: "Twisted pair with green wire" }
        gray   : -> { symbol: "GY", comment: "Twisted pair with pink wire" }
        pink   : -> { symbol: "PK", comment: "Twisted pair with gray wire" }
        shield : -> { symbol: "SH", comment: "Shield of the cable" }) "Cable4x2x025S"


various.ADD CABLE_TYPE(
    id              : "Cable 15x0.34+S"
    comment         : "Cable 15x0.34 + shield"
    manufacturer    : various.company
    wires:
        white      : -> { symbol: "WH"   , comment: "White wire"        , color: [colors.white] }
        black      : -> { symbol: "BK"   , comment: "Black wire"        , color: [colors.black] }
        brown      : -> { symbol: "BN"   , comment: "Brown wire"        , color: [colors.brown] }
        violet     : -> { symbol: "VT"   , comment: "Violet wire"       , color: [colors.violet] }
        green      : -> { symbol: "GN"   , comment: "Green wire"        , color: [colors.green] }
        grayPink   : -> { symbol: "GY/PK", comment: "Gray/pink wire"    , color: [colors.gray, colors.pink] }
        yellow     : -> { symbol: "YE"   , comment: "Yellow wire"       , color: [colors.yellow] }
        redBlue    : -> { symbol: "RD/BU", comment: "Red/blue wire"     , color: [colors.red, colors.blue] }
        gray       : -> { symbol: "GY"   , comment: "Gray wire"         , color: [colors.gray] }
        whiteGreen : -> { symbol: "WH/GN", comment: "White/green wire"  , color: [colors.white, colors.green] }
        pink       : -> { symbol: "PK"   , comment: "Pink wire"         , color: [colors.pink] }
        brownGreen : -> { symbol: "BN/GN", comment: "Brown/green wire"  , color: [colors.brown, colors.green] }
        blue       : -> { symbol: "BU"   , comment: "Blue wire"         , color: [colors.blue] }
        whiteYellow: -> { symbol: "WH/YE", comment: "White/yellow wire" , color: [colors.white, colors.yellow] }
        shield     : -> { symbol: "SH"   , comment: "Shield of the cable" }
    ) "Cable15x034S"

########################################################################################################################
# Connectors
########################################################################################################################

various.ADD CONNECTOR_TYPE(
    id              : "DIN6FS"
    comment         : "DIN 6-pole female panel socket"
    manufacturer    : various.company
    gender          : elec.female
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "DIN6FS"

various.ADD CONNECTOR_TYPE(
    id              : "D-sub 9 M socket"
    comment         : "D-sub 9 male socket"
    manufacturer    : various.company
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
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub9MS"

########################################################################################################################
# Write the model to file
########################################################################################################################

various.WRITE "models/external/various.jsonld"

