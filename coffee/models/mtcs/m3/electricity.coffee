########################################################################################################################
#                                                                                                                      #
# Model of the M3 electricity.                                                                                         #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "models/import_all.coffee"

# models
REQUIRE "models/external/all.coffee"
REQUIRE "models/mtcs/m3/system.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/m3/electricity" : "m3_elec"

m3_elec.IMPORT external_all
m3_elec.IMPORT m3_sys


########################################################################################################################
# M3 panel
########################################################################################################################


# Mechanical parts =====================================================================================================

m3_elec.ADD mech.PART(comment: "The M3 panel") "panel"


# Terminals ============================================================================================================

m3_elec.panel.ADD CONTAINER(
    items:
        [
            TERMINAL(symbol: "PE"   ) "PE"
            TERMINAL(symbol: "+24V" ) "DC" , label:'24V'
            TERMINAL(symbol: "GND"  ) "GND"
        ]
    ) "terminals"


# Connectors ===========================================================================================================

m3_elec.panel.ADD CONTAINER(
    items:
        [
            CONNECTOR_INSTANCE(
                type: various.DIN6FS
                symbol: "M3:24V"
                terminals:
                    1: -> symbol: "+24V", isConnectedTo: m3_elec.panel.DC
                    2: -> symbol: "+24V", isConnectedTo: m3_elec.panel.DC
                    4: -> symbol: "0V"  , isConnectedTo: m3_elec.panel.GND
                    5: -> symbol: "0V"  , isConnectedTo: m3_elec.panel.GND
                    6: -> symbol: "PE"  , isConnectedTo: m3_elec.panel.PE
            ) "24V"

            CONNECTOR_INSTANCE(type: harting.RJ45F , symbol: "M3:ECAT") "ECAT"

            CONNECTOR_INSTANCE(
                type    : itt.Dsub25FS
                symbol  : "LINSIG"
                terminals:
                    1 : -> symbol: "M3:LINSIG:EncS"     , comment: "Translation encoder shield"                                 , isConnectedTo: m3_elec.panel.terminals.GND
                    2 : -> symbol: "M3:LINSIG:EncA"     , comment: "Translation encoder signal A"
                    4 : -> symbol: "M3:LINSIG:EncB"     , comment: "Translation encoder signal B"
                    10: -> symbol: "M3:LINSIG:EncC"     , comment: "Translation encoder signal C (reference)"
                    7 : -> symbol: "M3:LINSIG:EncAi"    , comment: "Translation encoder signal A inverted"
                    8 : -> symbol: "M3:LINSIG:EncBi"    , comment: "Translation encoder signal B inverted"
                    6 : -> symbol: "M3:LINSIG:EncCi"    , comment: "Translation encoder signal C inverted (reference inverted)"
                    5 : -> symbol: "M3:LINSIG:Enc5V"    , comment: "Translation encoder +5V power supply"
                    3 : -> symbol: "M3:LINSIG:Enc0V"    , comment: "Translation encoder GND"
                    9 : -> symbol: "M3:LINSIG:EncSts"   , comment: "Translation encoder status signal"
                    18: -> symbol: "M3:LINSIG:LS24V"    , comment: "Translation limit switch +24V supply"
                    17: -> symbol: "M3:LINSIG:LS0V"     , comment: "Translation limit switch 0V supply"
                    19: -> symbol: "M3:LINSIG:LS+"      , comment: "Translation limit switch + output"
                    20: -> symbol: "M3:LINSIG:LS-"      , comment: "Translation limit switch - output"
                    21: -> symbol: "M3:LINSIG:HallA"    , comment: "Translation motor Hall sensor A"
                    22: -> symbol: "M3:LINSIG:HallB"    , comment: "Translation motor Hall sensor B"
                    23: -> symbol: "M3:LINSIG:HallC"    , comment: "Translation motor Hall sensor C"
                    24: -> symbol: "M3:LINSIG:Hall+5V"  , comment: "Translation motor Hall sensor voltage +5V"
                    25: -> symbol: "M3:LINSIG:HallGND"  , comment: "Translation motor Hall sensor GND"
            ) "LINSIG"

            CONNECTOR_INSTANCE(
                type    : itt.Dsub15FS
                symbol  : "LINPHA"
                terminals:
                    1 : -> symbol: "M3:LINPHA:A1"   , comment: "Translation motor phase A"
                    2 : -> symbol: "M3:LINPHA:A2"   , comment: "Translation motor phase A"
                    4 : -> symbol: "M3:LINPHA:B1"   , comment: "Translation motor phase B"
                    5 : -> symbol: "M3:LINPHA:B2"   , comment: "Translation motor phase B"
                    7 : -> symbol: "M3:LINPHA:C1"   , comment: "Translation motor phase C"
                    8 : -> symbol: "M3:LINPHA:C2"   , comment: "Translation motor phase C"
            ) "LINPHA"

            CONNECTOR_INSTANCE(
                type    : itt.Dsub25FS
                symbol  : "ROTSIG"
                terminals:
                    25: -> symbol: "M3:ROTSIG:EncS"         , comment: "Rotation encoder shield"                                 , isConnectedTo: m3_elec.panel.terminals.GND
                    4 : -> symbol: "M3:ROTSIG:EncD+"        , comment: "Rotation encoder Data +"
                    1 : -> symbol: "M3:ROTSIG:Enc24V"       , comment: "Rotation encoder +24V supply"
                    6 : -> symbol: "M3:ROTSIG:Enc0V"        , comment: "Rotation encoder GND"
                    2 : -> symbol: "M3:ROTSIG:EncC+"        , comment: "Rotation encoder Clock +"
                    5 : -> symbol: "M3:ROTSIG:EncD-"        , comment: "Rotation encoder Data -"
                    3 : -> symbol: "M3:ROTSIG:EncC-"        , comment: "Rotation encoder Clock -"
                    10: -> symbol: "M3:ROTSIG:LS24V"        , comment: "Rotation limit switch +24V supply"
                    9 : -> symbol: "M3:ROTSIG:LS0V"         , comment: "Rotation limit switch 0V supply"
                    11: -> symbol: "M3:ROTSIG:LS+"          , comment: "Rotation limit switch + output"
                    12: -> symbol: "M3:ROTSIG:LS-"          , comment: "Rotation limit switch - output"
                    21: -> symbol: "M3:ROTSIG:AblHallA"     , comment: "Rotation anti-backlash motor Hall sensor A"
                    22: -> symbol: "M3:ROTSIG:AblHallB"     , comment: "Rotation anti-backlash motor Hall sensor B"
                    23: -> symbol: "M3:ROTSIG:AblHallC"     , comment: "Rotation anti-backlash motor Hall sensor C"
                    17: -> symbol: "M3:ROTSIG:PosHall+5V"   , comment: "Rotation positioning motor Hall sensor voltage +5V"
                    18: -> symbol: "M3:ROTSIG:PosHallGND"   , comment: "Rotation positioning motor Hall sensor signal GND"
                    14: -> symbol: "M3:ROTSIG:PosHallA"     , comment: "Rotation positioning motor Hall sensor A"
                    15: -> symbol: "M3:ROTSIG:PosHallB"     , comment: "Rotation positioning motor Hall sensor B"
                    16: -> symbol: "M3:ROTSIG:PosHallC"     , comment: "Rotation positioning motor Hall sensor C"
            ) "ROTSIG"

            CONNECTOR_INSTANCE(
                type    : itt.Dsub15FS
                symbol  : "ROTPHA"
                terminals:
                    1 : -> symbol: "M3:ROTPHA:POSA1"   , comment: "Rotation positioning motor phase A"
                    2 : -> symbol: "M3:ROTPHA:POSA2"   , comment: "Rotation positioning motor phase A"
                    3 : -> symbol: "M3:ROTPHA:POSB1"   , comment: "Rotation positioning motor phase B"
                    4 : -> symbol: "M3:ROTPHA:POSB2"   , comment: "Rotation positioning motor phase B"
                    5 : -> symbol: "M3:ROTPHA:POSC1"   , comment: "Rotation positioning motor phase C"
                    6 : -> symbol: "M3:ROTPHA:POSC2"   , comment: "Rotation positioning motor phase C"
                    7 : -> symbol: "M3:ROTPHA:ABL+5V"  , comment: "Rotation anti-backlash motor Hall sensor voltage +5V"
                    8 : -> symbol: "M3:ROTPHA:ABLSGND" , comment: "Rotation anti-backlash motor Hall sensor signal GND"
                    9 : -> symbol: ""                  , comment: "(not used)"
                    10: -> symbol: "M3:ROTPHA:ABLA1"   , comment: "Rotation anti-backlash motor phase A"
                    11: -> symbol: "M3:ROTPHA:ABlA2"   , comment: "Rotation anti-backlash motor phase A"
                    12: -> symbol: "M3:ROTPHA:ABLB1"   , comment: "Rotation anti-backlash motor phase B"
                    13: -> symbol: "M3:ROTPHA:ABLB2"   , comment: "Rotation anti-backlash motor phase B"
                    14: -> symbol: "M3:ROTPHA:ABLC1"   , comment: "Rotation anti-backlash motor phase C"
                    15: -> symbol: "M3:ROTPHA:ABLC2"   , comment: "Rotation anti-backlash motor phase C"
            ) "ROTPHA"
        ]
    ) "connectors"


########################################################################################################################
# I/O modules
########################################################################################################################

m3_elec.panel.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EK1101
    terminals:
            X1  : -> comment: "From EtherCAT switch"
            1   : -> comment: "Coupler power 24V DC"    , isConnectedTo: m3_elec.panel.terminals.DC
            2   : -> comment: "Bus power 24V DC"        , isConnectedTo: m3_elec.panel.terminals.DC
            3   : -> comment: "Coupler GND"             , isConnectedTo: m3_elec.panel.terminals.GND
            4   : -> comment: "Earth"                   , isConnectedTo: m3_elec.panel.terminals.PE
            5   : -> comment: "Bus GND"                 , isConnectedTo: m3_elec.panel.terminals.GND
    ) "slot0"


m3_elec.panel.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EL1088
    terminals:
            1: -> symbol: "M3:LinLS+"       , comment: "Translation stage Limit switch +"      , isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[19]
            3: -> symbol: "M3:LinLS-"       , comment: "Translation stage Limit switch -"      , isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[20]
            2: -> symbol: "M3:RotLS+"       , comment: "Rotation stage Limit switch +"         , isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[11]
            4: -> symbol: "M3:RotLS-"       , comment: "Rotation stage Limit switch -"         , isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[12]
    ) "slot1"


m3_elec.panel.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EL5101
    terminals:
            1 : -> symbol: "M3:LinEncA"     , comment: "Translation stage encoder signal A"             , isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[2]
            2 : -> symbol: "M3:LinEncB"     , comment: "Translation stage encoder signal B"             , isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[4]
            3 : -> symbol: "M3:LinEncC"     , comment: "Translation stage encoder signal C"             , isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[10]
            5 : -> symbol: "M3:LinEncAi"    , comment: "Translation stage encoder signal A-inverted"    , isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[7]
            6 : -> symbol: "M3:LinEncBi"    , comment: "Translation stage encoder signal B-inverted"    , isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[8]
            7 : -> symbol: "M3:LinEncCi"    , comment: "Translation stage encoder signal C-inverted"    , isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[6]
            _1: -> symbol: "M3:LinEnc+5V"   , comment: "Translation stage encoder +5V"                  , isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[5]
            _2: -> symbol: "M3:LinLS+24V"   , comment: "Translation stage Limit switch +24V"            , isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[18]
            _3: -> symbol: "M3:LinLS0V"     , comment: "Translation stage Limit switch 0V"              , isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[17]
            _4: -> symbol: "M3:LinEncSts"   , comment: "Translation stage encoder status signal"        , isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[9]
            _5: -> symbol: "M3:LinEnc0V"    , comment: "Translation stage encoder GND"                  , isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[3]
    ) "slot2"


m3_elec.panel.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EL5001
    terminals:
            1: -> symbol: "M3:RotEncD+"     , comment: "Rotation encoder Data +"            , isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[4]
            2: -> symbol: "M3:RotEnc24V"    , comment: "Rotation encoder +24V"              , isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[1]
            3: -> symbol: "M3:RotEnc0V"     , comment: "Rotation encoder GND"               , isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[6]
            4: -> symbol: "M3:RotEncC+"     , comment: "Rotation encoder Clock +"           , isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[2]
            5: -> symbol: "M3:RotEncD-"     , comment: "Rotation encoder Data -"            , isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[5]
            6: -> symbol: "M3:RotLS24V"     , comment: "Rotation limit switch +24V"         , isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[10]
            7: -> symbol: "M3:RotLS0V"      , comment: "Rotation limit switch GND"          , isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[9]
            8: -> symbol: "M3:RotEncC-"     , comment: "Rotation encoder Clock -"           , isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[3]
    ) "slot3"


m3_elec.panel.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EL6751
    ) "slot4"


m3_elec.panel.ADD  DRIVE_INSTANCE(
    type: faulhaber.MCBL3006_S_CO
    comment: "Controls the motor of the translation stage"
    terminals:
        1 : -> isConnectedTo: m3_elec.panel.slot4.terminals[7]       # REPLACE BY CONNECTOR
        2 : -> isConnectedTo: m3_elec.panel.slot4.terminals[2]       # REPLACE BY CONNECTOR
        3 : -> isConnectedTo: m3_elec.panel.terminals.GND
        4 : -> isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[20]
        5 : -> isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[10]
        6 : -> isConnectedTo: m3_elec.panel.terminals.DC
        7 : -> isConnectedTo: m3_elec.panel.terminals.GND
        8 : -> comment: '(not used)'
        9 : -> isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[21]
        10: -> isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[22]
        11: -> isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[23]
        12: -> isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[24]
        13: -> isConnectedTo: m3_elec.panel.connectors.LINSIG.terminals[25]
        14: -> isConnectedTo: [ m3_elec.panel.connectors.LINPHA.terminals[1], m3_elec.panel.connectors.LINPHA.terminals[2] ]
        15: -> isConnectedTo: [ m3_elec.panel.connectors.LINPHA.terminals[4], m3_elec.panel.connectors.LINPHA.terminals[5] ]
        16: -> isConnectedTo: [ m3_elec.panel.connectors.LINPHA.terminals[7], m3_elec.panel.connectors.LINPHA.terminals[8] ]
    ) "linMotDrive"


m3_elec.panel.ADD  DRIVE_INSTANCE(
    type: faulhaber.MCBL3006_S_CO
    comment: "Controls the positioning motor of the rotation stage"
    terminals:
        1 : -> isConnectedTo: m3_elec.panel.slot4.terminals[7]       # REPLACE BY CONNECTOR
        2 : -> isConnectedTo: m3_elec.panel.slot4.terminals[2]       # REPLACE BY CONNECTOR
        3 : -> isConnectedTo: m3_elec.panel.terminals.GND
        4 : -> isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[12]
        5 : -> isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[11]
        6 : -> isConnectedTo: m3_elec.panel.terminals.DC
        7 : -> isConnectedTo: m3_elec.panel.terminals.GND
        8 : -> comment: '(not used)'
        9 : -> isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[14]
        10: -> isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[15]
        11: -> isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[16]
        12: -> isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[17]
        13: -> isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[18]
        14: -> isConnectedTo: [ m3_elec.panel.connectors.ROTPHA.terminals[1], m3_elec.panel.connectors.ROTPHA.terminals[2] ]
        15: -> isConnectedTo: [ m3_elec.panel.connectors.ROTPHA.terminals[3], m3_elec.panel.connectors.ROTPHA.terminals[4] ]
        16: -> isConnectedTo: [ m3_elec.panel.connectors.ROTPHA.terminals[5], m3_elec.panel.connectors.ROTPHA.terminals[6] ]
    ) "rotPosDrive"


m3_elec.panel.ADD  DRIVE_INSTANCE(
    type: faulhaber.MCBL3006_S_CO
    comment: "Controls the anti-backlash motor of the rotation stage"
    terminals:
        1 : -> isConnectedTo: m3_elec.panel.slot4.terminals[7]       # REPLACE BY CONNECTOR
        2 : -> isConnectedTo: m3_elec.panel.slot4.terminals[2]       # REPLACE BY CONNECTOR
        3 : -> isConnectedTo: m3_elec.panel.terminals.GND
        4 : -> isConnectedTo: m3_elec.panel.rotPosDrive.terminals[4]
        5 : -> isConnectedTo: m3_elec.panel.rotPosDrive.terminals[5]
        6 : -> isConnectedTo: m3_elec.panel.terminals.DC
        7 : -> isConnectedTo: m3_elec.panel.terminals.GND
        8 : -> comment: '(not used)'
        9 : -> isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[21]
        10: -> isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[22]
        11: -> isConnectedTo: m3_elec.panel.connectors.ROTSIG.terminals[23]
        12: -> isConnectedTo: m3_elec.panel.connectors.ROTPHA.terminals[7]
        13: -> isConnectedTo: m3_elec.panel.connectors.ROTPHA.terminals[8]
        14: -> isConnectedTo: [ m3_elec.panel.connectors.ROTPHA.terminals[10], m3_elec.panel.connectors.ROTPHA.terminals[11] ]
        15: -> isConnectedTo: [ m3_elec.panel.connectors.ROTPHA.terminals[12], m3_elec.panel.connectors.ROTPHA.terminals[13] ]
        16: -> isConnectedTo: [ m3_elec.panel.connectors.ROTPHA.terminals[14], m3_elec.panel.connectors.ROTPHA.terminals[15] ]
    ) "rotAblDrive"


m3_elec.panel.ADD CONTAINER(
        items:
            m3_elec.panel["slot#{i}"] for i in [0..4]
        ) "io"


########################################################################################################################
# M3 configuration
########################################################################################################################

m3_elec.panel.ADD elec.Configuration "M3" : [

    LABEL "M3"
    COMMENT "The tertiary mirror (M3) of the telescope"

    cont.contains m3_elec.panel.connectors
    cont.contains m3_elec.panel.terminals
    cont.contains m3_elec.panel.linMotDrive
    cont.contains m3_elec.panel.rotPosDrive
    cont.contains m3_elec.panel.rotAblDrive
    cont.contains m3_elec.panel.io

    [ elec.hasConnector item for item in PATHS(m3_elec.panel.connectors , cont.contains) ]
    [ elec.hasTerminal  item for item in PATHS(m3_elec.panel.terminals  , cont.contains) ]
    [ cont.contains     item for item in PATHS(m3_elec.panel.io         , cont.contains) ]
]


########################################################################################################################
# Write the model to file
########################################################################################################################

m3_elec.WRITE "models/mtcs/m3/electricity.jsonld"
