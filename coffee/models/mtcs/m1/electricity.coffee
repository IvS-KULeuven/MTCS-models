########################################################################################################################
#                                                                                                                      #
# Model of the M1 and M2 electricity.                                                                                  #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "models/import_all.coffee"

# models
REQUIRE "models/external/all.coffee"
REQUIRE "models/mtcs/m1/system.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/m1/electricity" : "m1_elec"

m1_elec.IMPORT external_all
m1_elec.IMPORT m1_sys


########################################################################################################################
# M1 & M2 panel
########################################################################################################################


# Mechanical parts =====================================================================================================

m1_elec.ADD mech.PART(comment: "The M1 & M2 panel") "M1M2"


# Power input ==========================================================================================================

m1_elec.M1M2.ADD CONNECTOR_INSTANCE(
    type: phoenix.SC25_1L_SocketAssembly
    comment: "230V input power"
    symbol: "TE:230VAC-A"
    ) "socket230VAC"


m1_elec.M1M2.ADD CIRCUIT_BREAKER_INSTANCE(
    type: schneider.CircuitBreaker2Ph6A
    symbol: "M1M2:CB"
    comment: "Circuit breaker immediately after 230V input"
    terminals:
        1: -> comment: "L in", isConnectedTo: m1_elec.M1M2.socket230VAC.terminals.L
        2: -> comment: "L out"
        3: -> comment: "N in", isConnectedTo: m1_elec.M1M2.socket230VAC.terminals.N
        4: -> comment: "N out"
    ) "circuitBreaker"


# Power distribution ===================================================================================================

m1_elec.M1M2.ADD CONTAINER(
    items:
        [
            TERMINAL(symbol: "PE"   , comment: "Protective Earth", isConnectedTo: m1_elec.M1M2.socket230VAC.terminals.PE) "PE"
            TERMINAL(symbol: "+24V" , comment: "+24VDC") "DC"
            TERMINAL(symbol: "+12V" , comment: "+12VDC") "DC12"
            TERMINAL(symbol: "GND"  , comment: "GND")  "GND"
        ]
    ) "terminals"


# DC supplies ==========================================================================================================

m1_elec.M1M2.ADD POWER_SUPPLY_INSTANCE(
    type: phoenix.trio_ps_1AC_24VDC_10
    symbol: "M1M2:PS24"
    comment: "24V power supply to power the I/O modules"
    terminals:
        PE      : -> symbol: "PE", comment: "From PE terminals"     , isConnectedTo: m1_elec.M1M2.terminals.PE
        L       : -> symbol: "L", comment: "From circuit breaker"   , isConnectedTo: m1_elec.M1M2.circuitBreaker.terminals[2]
        N       : -> symbol: "N", comment: "From circuit breaker"   , isConnectedTo: m1_elec.M1M2.circuitBreaker.terminals[4]
        plus    : -> symbol: "+", comment: "To +24V terminals"      , isConnectedTo: m1_elec.M1M2.terminals.DC
        minus   : -> symbol: "-", comment: "To GND terminals"       , isConnectedTo: m1_elec.M1M2.terminals.GND
    ) "power24V"

m1_elec.M1M2.ADD POWER_SUPPLY_INSTANCE(
    type: phoenix.mini_ps_12_24VDC_5_15VDC_2A
    symbol: "M1M2:PS12"
    comment: "12V power supply to power the M2 field electricity"
    terminals:
        inplus  : -> symbol: "+", comment: "From 24V PS"            , isConnectedTo: m1_elec.M1M2.power24V.terminals.plus2
        inminus : -> symbol: "-", comment: "From 24V PS"            , isConnectedTo: m1_elec.M1M2.power24V.terminals.minus2
        outplus : -> symbol: "+", comment: "12V output to relay"
        outminus: -> symbol: "-", comment: "To GND of 24V PS"       , isConnectedTo: m1_elec.M1M2.power24V.terminals.minus3
    ) "power12V"


# Connectors ===========================================================================================================

m1_elec.M1M2.ADD CONTAINER(
    items:
        [
            CONNECTOR_INSTANCE(type: harting.RJ45F , symbol: "TC:ECAT") "ECAT"

            CONNECTOR_INSTANCE(
                type: itt.Dsub9FS
                symbol: "M1:INCL"
                comment: "M1 Inclinometer connector"
                terminals:
                    1 : -> symbol: "M1:INCL:Shield"     , comment: "M1 inclinometer shield"
                    2 : -> symbol: "M1:INCL:GND"        , comment: "M1 inclinometer GND"
                    3 : -> symbol: ""                   , comment: "(not connected)"
                    4 : -> symbol: ""                   , comment: "(not connected)"
                    5 : -> symbol: "M1:INCL:+24V"       , comment: "M1 inclinometer +24V"
                    6 : -> symbol: "M1:INCL:INCL-"      , comment: "M1 inclinometer - signal"
                    7 : -> symbol: ""                   , comment: "(not connected)"
                    8 : -> symbol: "M1:INCL:INCL+"      , comment: "M1 inclinometer + signal"
                    9 : -> symbol: "M1:INCL:Shield"     , comment: "M1 inclinometer shield"
                ) "INCL"

            CONNECTOR_INSTANCE(
                type: itt.Dsub25FS
                symbol: "M1:FSP"
                comment: "M1 Force and Pressure sensor"
                terminals:
                    1 : -> symbol: "M1:FSP:Shield"      , comment: "M1 Force and Pressure sensor: shield"
                    2 : -> symbol: "M1:FSP:+MEAS_SO"    , comment: "M1 Force and Pressure sensor: South force sensor measurement +"
                    3 : -> symbol: "M1:FSP:+EXCIT_SO"   , comment: "M1 Force and Pressure sensor: South force sensor excitation +"
                    4 : -> symbol: "M1:FSP:+SENSE_SO"   , comment: "M1 Force and Pressure sensor: South force sensor sense +"
                    5 : -> symbol: "M1:FSP:+MEAS_NE"    , comment: "M1 Force and Pressure sensor: NorthEast force sensor measurement +"
                    6 : -> symbol: "M1:FSP:+EXCIT_NE"   , comment: "M1 Force and Pressure sensor: NorthEast force sensor excitation +"
                    7 : -> symbol: "M1:FSP:+SENSE_NE"   , comment: "M1 Force and Pressure sensor: NorthEast force sensor sense +"
                    8 : -> symbol: "M1:FSP:+MEAS_NW"    , comment: "M1 Force and Pressure sensor: NorthWest force sensor measurement +"
                    9 : -> symbol: "M1:FSP:+EXCIT_NW"   , comment: "M1 Force and Pressure sensor: NorthWest force sensor excitation +"
                    10: -> symbol: "M1:FSP:+SENSE_NW"   , comment: "M1 Force and Pressure sensor: NorthWest force sensor sense +"
                    11: -> symbol: "M1:FSP:APSM+"       , comment: "M1 Force and Pressure sensor: axial pressure sensor measurement +"
                    12: -> symbol: "M1:FSP:RPSM+"       , comment: "M1 Force and Pressure sensor: radial pressure sensor measurement +"
                    13: -> symbol: "M1:FSP:Shield"      , comment: "M1 Force and Pressure sensor: shield"
                    14: -> symbol: "M1:FSP:-MEAS_SO"    , comment: "M1 Force and Pressure sensor: South force sensor measurement -"
                    15: -> symbol: "M1:FSP:-EXCIT_SO"   , comment: "M1 Force and Pressure sensor: South force sensor excitation -"
                    16: -> symbol: "M1:FSP:-SENSE_SO"   , comment: "M1 Force and Pressure sensor: South force sensor sense -"
                    17: -> symbol: "M1:FSP:-MEAS_NE"    , comment: "M1 Force and Pressure sensor: NorthEast force sensor measurement -"
                    18: -> symbol: "M1:FSP:-EXCIT_NE"   , comment: "M1 Force and Pressure sensor: NorthEast force sensor excitation -"
                    19: -> symbol: "M1:FSP:-SENSE_NE"   , comment: "M1 Force and Pressure sensor: NorthEast force sensor sense -"
                    20: -> symbol: "M1:FSP:-MEAS_NW"    , comment: "M1 Force and Pressure sensor: NorthWest force sensor measurement -"
                    21: -> symbol: "M1:FSP:-EXCIT_NW"   , comment: "M1 Force and Pressure sensor: NorthWest force sensor excitation -"
                    22: -> symbol: "M1:FSP:-SENSE_NW"   , comment: "M1 Force and Pressure sensor: NorthWest force sensor sense -"
                    23: -> symbol: "M1:FSP:APSM-"       , comment: "M1 Force and Pressure sensor: axial pressure sensor measurement -"
                    24: -> symbol: "M1:FSP:RPSM-"       , comment: "M1 Force and Pressure sensor: radial pressure sensor measurement -"
                    25: -> symbol: "M1:FSP:Shield"      , comment: "M1 Force and Pressure sensor: shield"
                ) "FSP"

            CONNECTOR_INSTANCE(
                type: itt.Dsub15FS
                symbol: "M1:PNP"
                comment: "M1 Pressure regulator and sensor"
                terminals:
                    1 : -> symbol: "M1:PNP:Shield"      , comment: "M1 Pressure regulator and sensor: shield"
                    2 : -> symbol: "M1:PNP:APR+"        , comment: "M1 Pressure regulator and sensor: axial pressure regulator + signal"
                    3 : -> symbol: "M1:PNP:RPR+"        , comment: "M1 Pressure regulator and sensor: radial pressure regulator + signal"
                    4 : -> symbol: "M1:PNP:RVV+"        , comment: "M1 Pressure regulator and sensor: radial vacuum valve +"
                    5 : -> symbol: "M1:PNP:APS+"        , comment: "M1 Pressure regulator and sensor: axial pressure sensor + signal"
                    6 : -> symbol: "M1:PNP:RPS+"        , comment: "M1 Pressure regulator and sensor: radial pressure sensor + signal"
                    7 : -> symbol: "M1:PNP:PSPS+"       , comment: "M1 Pressure regulator and sensor: pressure sensor power +"
                    8 : -> symbol: ""                   , comment: "(not connected)"
                    9 : -> symbol: "M1:PNP:APR-"        , comment: "M1 Pressure regulator and sensor: axial pressure regulator - signal"
                    10: -> symbol: "M1:PNP:RPR-"        , comment: "M1 Pressure regulator and sensor: radial pressure regulator - signal"
                    11: -> symbol: "M1:PNP:RVV-"        , comment: "M1 Pressure regulator and sensor: radial vacuum valve -"
                    12: -> symbol: "M1:PNP:APS-"        , comment: "M1 Pressure regulator and sensor: axial pressure sensor - signal"
                    13: -> symbol: "M1:PNP:RPS-"        , comment: "M1 Pressure regulator and sensor: radial pressure sensor - signal"
                    14: -> symbol: "M1:PNP:PSPS-"       , comment: "M1 Pressure regulator and sensor: pressure sensor power -"
                    15: -> symbol: ""                   , comment: "(not connected)"
                ) "PNP"

            CONNECTOR_INSTANCE(
                type: itt.Dsub9FS
                symbol: "M2:PS"
                comment: "M2 power supply"
                terminals:
                    1 : -> symbol: "M2:PS:HTR GND"      , comment: "M2 power supply: heater GND"
                    2 : -> symbol: "M2:PS:HTR +24V"     , comment: "M2 power supply: heater +24V"
                    3 : -> symbol: "M2:PS:GND"          , comment: "M2 power supply: GND"
                    4 : -> symbol: "M2:PS:+12VM2"       , comment: "M2 power supply: +12V M2"
                    5 : -> symbol: ""                   , comment: "(not connected)"
                    6 : -> symbol: "M2:PS:GND"          , comment: "M2 power supply: GND"
                    7 : -> symbol: "M2:PS:GND"          , comment: "M2 power supply: GND"
                    8 : -> symbol: "M2:PS:+12VM2"       , comment: "M2 power supply: +12V M2"
                    9 : -> symbol: "M2:PS:GND"          , comment: "M2 power supply: GND"
                ) "PS"

            CONNECTOR_INSTANCE(
                type: itt.Dsub9FS
                symbol: "M2:POT"
                comment: "M2 potentiometers"
                terminals:
                    1 : -> symbol: "M2:POT:+PTX"      , comment: "M2 potentiometers: + potentiometer tilt X"
                    2 : -> symbol: "M2:POT:+PTY"      , comment: "M2 potentiometers: + potentiometer tilt Y"
                    3 : -> symbol: "M2:POT:+PX"       , comment: "M2 potentiometers: + potentiometer X"
                    4 : -> symbol: "M2:POT:+PY"       , comment: "M2 potentiometers: + potentiometer Y"
                    5 : -> symbol: "M2:POT:GND"       , comment: "M2 potentiometers: GND"
                    6 : -> symbol: "M2:POT:-PTX"      , comment: "M2 potentiometers: - potentiometer tilt X"
                    7 : -> symbol: "M2:POT:-PTY"      , comment: "M2 potentiometers: - potentiometer tilt Y"
                    8 : -> symbol: "M2:POT:-PX"       , comment: "M2 potentiometers: - potentiometer X"
                    9 : -> symbol: "M2:POT:-PY"       , comment: "M2 potentiometers: - potentiometer Y"
                ) "POT"

            CONNECTOR_INSTANCE(
                type: itt.Dsub9FS
                symbol: "M2:SSIZ"
                comment: "M2 SSI encoder Z-axis"
                terminals:
                    1 : -> symbol: "M2:SSIZ:+24V"     , comment: "M2 SSI encoder Z-axis: +24V"
                    2 : -> symbol: "M2:SSIZ:D+"       , comment: "M2 SSI encoder Z-axis: Data +"
                    3 : -> symbol: "M2:SSIZ:CLK+"     , comment: "M2 SSI encoder Z-axis: Clock +"
                    4 : -> symbol: ""                 , comment: "(not connected)"
                    5 : -> symbol: "M2:SSIZ:GND"      , comment: "M2 SSI encoder Z-axis: GND"
                    6 : -> symbol: "M2:SSIZ:D-"       , comment: "M2 SSI encoder Z-axis: Data -"
                    7 : -> symbol: "M2:SSIZ:CLK-"     , comment: "M2 SSI encoder Z-axis: Clock -"
                    8 : -> symbol: ""                 , comment: "(not connected)"
                    9 : -> symbol: ""                 , comment: "(not connected)"
                ) "SSIZ"

            CONNECTOR_INSTANCE(
                type: itt.Dsub25FS
                symbol: "M2:MOT"
                comment: "M2 motors"
                terminals:
                    1 : -> symbol: "M2:MOT:GVZ"         , comment: "M2 motors: High speed (Grand Vitesse GV) Z"
                    2 : -> symbol: "M2:MOT:BRAKE"       , comment: "M2 motors: Brake"
                    3 : -> symbol: "M2:MOT:A"           , comment: "M2 motors: motor select A"
                    4 : -> symbol: "M2:MOT:C"           , comment: "M2 motors: motor select C"
                    5 : -> symbol: ""                   , comment: "(not connected)"
                    6 : -> symbol: ""                   , comment: "(not connected)"
                    7 : -> symbol: "M2:MOT:CP"          , comment: "M2 motors: motor rotation pulse"
                    8 : -> symbol: "M2:MOT:GND"         , comment: "M2 motors: GND"
                    9 : -> symbol: "M2:MOT:GND"         , comment: "M2 motors: GND"
                    10: -> symbol: "M2:MOT:GND"         , comment: "M2 motors: GND"
                    11: -> symbol: ""                   , comment: "(not connected)"
                    12: -> symbol: ""                   , comment: "(not connected)"
                    13: -> symbol: "M2:MOT:CPi"         , comment: "M2 motors: motor rotation pulse-inverted"
                    14: -> symbol: "M2:MOT:ENABLE"      , comment: "M2 motors: drive enable"
                    15: -> symbol: "M2:MOT:CCW"         , comment: "M2 motors: counter-clockwise"
                    16: -> symbol: "M2:MOT:B"           , comment: "M2 motors: motor select B"
                    17: -> symbol: ""                   , comment: "(not connected)"
                    18: -> symbol: "M2:MOT:FAULT"       , comment: "M2 motors: drive fault"
                    19: -> symbol: ""                   , comment: "(not connected)"
                    20: -> symbol: ""                   , comment: "(not connected)"
                    21: -> symbol: "M2:MOT:0V"          , comment: "M2 motors: 0V"
                    22: -> symbol: "M2:MOT:0V"          , comment: "M2 motors: 0V"
                    23: -> symbol: "M2:MOT:GND"         , comment: "M2 motors: GND"
                    24: -> symbol: "M2:MOT:GND"         , comment: "M2 motors: GND"
                    25: -> symbol: "M2:MOT:GND"         , comment: "M2 motors: GND"
                ) "MOT"
        ]
    ) "connectors"


# I/O modules ==========================================================================================================


m1_elec.M1M2.ADD CONTAINER() "io"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EK1101
    terminals:
            X1  : -> comment: "From EtherCAT switch"
            1   : -> comment: "Coupler power 24V DC"    , isConnectedTo: m1_elec.M1M2.terminals.DC
            2   : -> comment: "Bus power 24V DC"        , isConnectedTo: m1_elec.M1M2.terminals.DC
            3   : -> comment: "Coupler GND"             , isConnectedTo: m1_elec.M1M2.terminals.GND
            4   : -> comment: "Earth"                   , isConnectedTo: m1_elec.M1M2.terminals.PE
            5   : -> comment: "Bus GND"                 , isConnectedTo: m1_elec.M1M2.terminals.GND
    ) "COU"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL9187
    terminals:
            1: -> isConnectedTo: m1_elec.M1M2.connectors.PS.terminals[9]
            2: -> isConnectedTo: m1_elec.M1M2.connectors.PS.terminals[3]
            3: -> isConnectedTo: m1_elec.M1M2.connectors.PS.terminals[7]
            4: -> isConnectedTo: m1_elec.M1M2.connectors.PS.terminals[6]
            5: -> isConnectedTo: m1_elec.M1M2.connectors.POT.terminals[5]
    ) "GND1"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL9187
    ) "GND2"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL9186
    terminals:
            1: -> isConnectedTo: m1_elec.M1M2.connectors.INCL.terminals[5]
            2: -> isConnectedTo: m1_elec.M1M2.connectors.PNP.terminals[5]
            3: -> isConnectedTo: m1_elec.M1M2.connectors.PNP.terminals[6]
            4: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[11]
            5: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[12]
            6: -> isConnectedTo: m1_elec.M1M2.connectors.PNP.terminals[7]
    ) "24V1"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL3102
    terminals:
            1: -> isConnectedTo: m1_elec.M1M2.connectors.INCL.terminals[8]
            2: -> isConnectedTo: m1_elec.M1M2.connectors.INCL.terminals[6]
            3: -> isConnectedTo: m1_elec.M1M2.connectors.INCL.terminals[2]
            4: -> isConnectedTo: m1_elec.M1M2.connectors.INCL.terminals[1]
            8: -> isConnectedTo: m1_elec.M1M2.connectors.INCL.terminals[9]
    ) "AI1"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL3024
    terminals:
            1: -> isConnectedTo: m1_elec.M1M2.connectors.PNP.terminals[12]
            2: -> isConnectedTo: m1_elec.M1M2.io.GND1.terminals[1]
            3: -> isConnectedTo: m1_elec.M1M2.connectors.PNP.terminals[13]
            4: -> isConnectedTo: m1_elec.M1M2.io.GND1.terminals[2]
            5: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[23]
            6: -> isConnectedTo: m1_elec.M1M2.io.GND1.terminals[3]
            7: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[24]
            8: -> isConnectedTo: m1_elec.M1M2.io.GND1.terminals[4]
    ) "AI2"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL3024
    terminals:
            1: -> isConnectedTo: m1_elec.M1M2.connectors.PNP.terminals[14]
            2: -> isConnectedTo: m1_elec.M1M2.io.GND1.terminals[5]
    ) "AI3"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL4022
    terminals:
            1: -> isConnectedTo: m1_elec.M1M2.connectors.PNP.terminals[2]
            3: -> isConnectedTo: m1_elec.M1M2.connectors.PNP.terminals[9]
            5: -> isConnectedTo: m1_elec.M1M2.connectors.PNP.terminals[3]
            7: -> isConnectedTo: m1_elec.M1M2.connectors.PNP.terminals[10]
            8: -> isConnectedTo: m1_elec.M1M2.connectors.PNP.terminals[1]
    ) "AO1"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL2024
    terminals:
            1: -> isConnectedTo: m1_elec.M1M2.connectors.PNP.terminals[4]
            2: -> isConnectedTo: m1_elec.M1M2.connectors.PNP.terminals[11]
            5: -> isConnectedTo: m1_elec.M1M2.connectors.PS.terminals[2]
            6: -> isConnectedTo: m1_elec.M1M2.connectors.PS.terminals[1]
    ) "DO1"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL3351
    terminals:
            1: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[2]
            2: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[14]
            3: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[15]
            5: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[4]
            6: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[16]
            7: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[3]
            8: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[1]
    ) "RES1"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL3351
    terminals:
            1: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[5]
            2: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[17]
            3: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[18]
            5: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[7]
            6: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[19]
            7: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[6]
            8: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[13]
    ) "RES2"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL3351
    terminals:
            1: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[8]
            2: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[20]
            3: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[21]
            5: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[10]
            6: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[22]
            7: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[9]
            8: -> isConnectedTo: m1_elec.M1M2.connectors.FSP.terminals[25]
    ) "RES3"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL9410
    terminals:
            1 : -> isConnectedTo: m1_elec.M1M2.io['24V1'].terminals[7]
            5 : -> isConnectedTo: m1_elec.M1M2.io.GND1.terminals[7]
    ) "PWR1"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL5001
    terminals:
            1: -> isConnectedTo: m1_elec.M1M2.connectors.SSIZ.terminals[2]
            2: -> isConnectedTo: m1_elec.M1M2.connectors.SSIZ.terminals[1]
            3: -> isConnectedTo: m1_elec.M1M2.connectors.SSIZ.terminals[5]
            4: -> isConnectedTo: m1_elec.M1M2.connectors.SSIZ.terminals[3]
            5: -> isConnectedTo: m1_elec.M1M2.connectors.SSIZ.terminals[6]
            8: -> isConnectedTo: m1_elec.M1M2.connectors.SSIZ.terminals[7]
    ) "SSI1"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL3164
    terminals:
            1: -> isConnectedTo: m1_elec.M1M2.connectors.POT.terminals[1]
            2: -> isConnectedTo: m1_elec.M1M2.connectors.POT.terminals[6]
            3: -> isConnectedTo: m1_elec.M1M2.connectors.POT.terminals[2]
            4: -> isConnectedTo: m1_elec.M1M2.connectors.POT.terminals[7]
            5: -> isConnectedTo: m1_elec.M1M2.connectors.POT.terminals[3]
            6: -> isConnectedTo: m1_elec.M1M2.connectors.POT.terminals[8]
            7: -> isConnectedTo: m1_elec.M1M2.connectors.POT.terminals[4]
            8: -> isConnectedTo: m1_elec.M1M2.connectors.POT.terminals[9]
    ) "AI4"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL5101
    terminals:
            1 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[7]
            5 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[13]
            _3: -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[21]
            _4: -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[18]
            _7: -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[22]
    ) "INC1"



m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL9505
    terminals:
            1 : -> isConnectedTo: m1_elec.M1M2.io['24V1'].terminals[8]
            3 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[8]
            5 : -> isConnectedTo: m1_elec.M1M2.io.GND1.terminals[8]
            7 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[9]
    ) "P5V1"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL2124
    terminals:
            1 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[14]
            3 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[10]
            4 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[3]
            5 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[16]
            7 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[23]
            8 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[4]
    ) "DO2"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL2124
    terminals:
            1 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[15]
            3 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[24]
            4 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[2]
            5 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[1]
            7 : -> isConnectedTo: m1_elec.M1M2.connectors.MOT.terminals[25]
    ) "DO3"


m1_elec.M1M2.io.ADD CONTAINS IO_MODULE_INSTANCE(
    type: beckhoff.EL2622
    terminals:
            1 : -> isConnectedTo: m1_elec.M1M2.power12V.terminals.outplus
            2 : -> isConnectedTo: [ m1_elec.M1M2.connectors.PS.terminals[4], m1_elec.M1M2.connectors.PS.terminals[8] ]
    ) "RE1"


########################################################################################################################
# M1M2 Configuration
########################################################################################################################

m1_elec.M1M2.ADD elec.Configuration "configuration" : [

    LABEL "M1 & M2"
    COMMENT "The primary mirror (M1) and secondary mirror (M2) of the telescope"

    cont.contains m1_elec.M1M2.socket230VAC
    cont.contains m1_elec.M1M2.circuitBreaker
    cont.contains m1_elec.M1M2.power24V
    cont.contains m1_elec.M1M2.power12V
    cont.contains m1_elec.M1M2.connectors
    cont.contains m1_elec.M1M2.terminals
    cont.contains m1_elec.M1M2.io

    [ elec.hasTerminal  item for item in PATHS(m1_elec.M1M2.terminals   , cont.contains) ]
    [ elec.hasConnector item for item in PATHS(m1_elec.M1M2.connectors  , cont.contains) ]

]


########################################################################################################################
# Write the model to file
########################################################################################################################

m1_elec.WRITE "models/mtcs/m1/electricity.jsonld"
