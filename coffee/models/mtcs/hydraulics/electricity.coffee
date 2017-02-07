########################################################################################################################
#                                                                                                                      #
# Model of the hydraulics electricity.                                                                                 #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "models/import_all.coffee"

# models
REQUIRE "models/external/all.coffee"
REQUIRE "models/mtcs/hydraulics/system.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/hydraulics/electricity" : "hydraulics_elec"

hydraulics_elec.IMPORT external_all
hydraulics_elec.IMPORT hydraulics_sys


########################################################################################################################
# HY panel
########################################################################################################################

# Mechanical parts =====================================================================================================

hydraulics_elec.ADD mech.PART(comment: "The Hydraulics cabinet (with the pumps drives etc.)") "HY"


########################################################################################################################
# HY / Field
########################################################################################################################

# Configuration ========================================================================================================

hydraulics_elec.HY.ADD CONTAINS elec.Configuration "field" : [ COMMENT "The field (= everything not fixed to the panel)." ]

# PC cable assembly ====================================================================================================
# TODO: a concept CABLE_ASSEMBLY has been introduced --> replace the configuration below with this concept

hydraulics_elec.HY.field.ADD CONTAINS elec.Configuration "PC"

hydraulics_elec.HY.field.PC.ADD "Pumps Control cable assembly"

hydraulics_elec.HY.field.PC.ADD CONTAINS CONNECTOR_INSTANCE(
    type    : itt.Dsub25MP
    symbol  : "HS:PC-B"
    comment : "Plug, to connect to the HS panel"
    ) "hsPlug"

hydraulics_elec.HY.field.PC.ADD CONTAINS CONNECTOR_INSTANCE(
    type    : itt.Dsub25FP
    symbol  : "HY:PC-B"
    comment : "Plug, to connect to the HY panel"
    ) "hyPlug"

hydraulics_elec.HY.field.PC.ADD CONTAINS CABLE_INSTANCE(
    type    : propower.Cable25CoreScreen
    comment : "Cable containing the HY:PC-B male plug and HS:PC-B female plug"
    wires   :
        1 : -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[1], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[1] }
        2 : -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[2], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[2] }
        3 : -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[3], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[3] }
        4 : -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[4], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[4] }
        5 : -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[5], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[5] }
        6 : -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[6], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[6] }
        7 : -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[7], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[7] }
        8 : -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[8], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[8] }
        9 : -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[9], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[9] }
        10: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[10], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[10] }
        11: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[11], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[11] }
        12: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[12], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[12] }
        13: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[13], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[13] }
        14: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[14], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[14] }
        15: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[15], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[15] }
        16: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[16], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[16] }
        17: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[17], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[17] }
        18: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[18], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[18] }
        19: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[19], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[19] }
        20: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[20], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[20] }
        21: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[21], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[21] }
        22: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[22], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[22] }
        23: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[23], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[23] }
        24: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[24], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[24] }
        25: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals[25], to: hydraulics_elec.HY.field.PC.hyPlug.terminals[25] }
        screen: -> { from:  hydraulics_elec.HY.field.PC.hsPlug.terminals.chassis , comment: "Only connected on HS panel side to prevent current loops"}
    ) "cable"


########################################################################################################################
# HY configuration
########################################################################################################################

hydraulics_elec.ADD elec.Configuration "hydraulics" : [

    LABEL "HY: Hydraulics"
    COMMENT "The Hydraulics configuration (HY)."

    cont.contains hydraulics_elec.HY.field
]


########################################################################################################################
# HS configuration
########################################################################################################################

# Mechanical parts =====================================================================================================

hydraulics_elec.ADD mech.PART(comment: "The Hydraulics & Safety panel") "HS"


# Power input ==========================================================================================================

hydraulics_elec.HS.ADD CONNECTOR_INSTANCE(
    type: phoenix.SC25_1L_SocketAssembly
    symbol: "HS:230VAC-A"
    ) "socket230VAC"

hydraulics_elec.HS.ADD CIRCUIT_BREAKER_INSTANCE(
    type: schneider.CircuitBreaker2Ph6A
    symbol: "HS:CB"
    terminals:
        1: -> comment: "L in", isConnectedTo: hydraulics_elec.HS.socket230VAC.terminals.L
        2: -> comment: "L out"
        3: -> comment: "N in", isConnectedTo: hydraulics_elec.HS.socket230VAC.terminals.N
        4: -> comment: "N out"
    ) "circuitBreaker"


# Power distribution ===================================================================================================

hydraulics_elec.HS.ADD CONTAINER(
    items:
        [
            TERMINAL(symbol: "PE"   , comment: "Protective Earth", isConnectedTo: hydraulics_elec.HS.socket230VAC.terminals.PE)   "PE"
            TERMINAL(symbol: "+24V" , comment: "+24VDC") "DC"
            TERMINAL(symbol: "GND"  , comment: "GND")  "GND"
        ]
    ) "terminals"


# DC supply ============================================================================================================

hydraulics_elec.HS.ADD POWER_SUPPLY_INSTANCE(
    type: phoenix.trio_ps_1AC_24VDC_10
    symbol: "HS:PS"
    comment: "24V power supply to power the I/O modules and everything connected to the I/O (e.g. 24V power of the pumps drives)"
    terminals:
        PE      : -> symbol: "PE", comment: "From PE terminals"  , isConnectedTo: hydraulics_elec.HS.terminals.PE
        L       : -> symbol: "L", comment: "From circuit breaker", isConnectedTo: hydraulics_elec.HS.circuitBreaker.terminals[2]
        N       : -> symbol: "N", comment: "From circuit breaker", isConnectedTo: hydraulics_elec.HS.circuitBreaker.terminals[4]
        plus    : -> symbol: "+", comment: "To +24V terminals", isConnectedTo: hydraulics_elec.HS.terminals.DC
        minus   : -> symbol: "-", comment: "To GND terminals" , isConnectedTo: hydraulics_elec.HS.terminals.GND
    ) "power"


# I/O modules ==========================================================================================================

hydraulics_elec.HS.ADD CONTAINER(
    items:
        [
            IO_MODULE_INSTANCE(
                type: beckhoff.EK1101
                comment: "Coupler of the Hydraulics & Safety panel"
                symbol: "HS:COU"
                terminals:
                        X1  : -> comment: "From EtherCAT switch"
                        1   : -> comment: "Coupler power 24V DC"    , isConnectedTo: hydraulics_elec.HS.terminals.DC
                        2   : -> comment: "Bus power 24V DC"        , isConnectedTo: hydraulics_elec.HS.terminals.DC
                        3   : -> comment: "Coupler GND"             , isConnectedTo: hydraulics_elec.HS.terminals.GND
                        4   : -> comment: "Earth"                   , isConnectedTo: hydraulics_elec.HS.terminals.PE
                        5   : -> comment: "Bus GND"                 , isConnectedTo: hydraulics_elec.HS.terminals.GND
                ) "COU"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL2008
                symbol: "HS:DO1"
                comment: "Digital outputs for drives RESET and circulation pump contactor"
                ) "DO1"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL1904
                comment: "Safe inputs for the drives TRIP (2x) and QMin (2x) outputs"
                symbol: "HS:SI1"
                terminals:
                        1   : -> comment: "Not connected (because internally connected to +24V)"
                        3   : -> comment: "Not connected (because internally connected to +24V)"
                        5   : -> comment: "Not connected (because internally connected to +24V)"
                        7   : -> comment: "Not connected (because internally connected to +24V)"
                ) "SI1"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL1904
                comment: "Safe inputs for the Return Filter overpressure switch"
                symbol: "HS:SI2"
                terminals:
                        1   : -> comment: "Not connected (because internally connected to +24V)"
                ) "SI2"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL1904
                comment: "Safe inputs for dome and first-floor emergency stops"
                symbol: "HS:SI3"
                ) "SI3"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL1904
                comment: "Safe inputs for control-room and extra emergency stops"
                symbol: "HS:SI4"
                ) "SI4"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL6900
                comment: "Safety logic"
                symbol: "HS:SL"
                ) "SL"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL2904
                comment: "Safe outputs to release the top and bottom pumps, and to release/block the axes controlled by the old TCS"
                symbol: "HS:SO1"
                terminals:
                        2   : -> comment: "Not connected (because internally connected to GND)"
                        6   : -> comment: "Not connected (because internally connected to GND)"
                ) "SO1"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL3102
                comment: "-10..+10V inputs to monitor the frequency of the top and bottom pumps drives"
                symbol: "HS:AI1"
                terminals:
                        2   : -> comment: "GND connection, because differential module used for single-ended signal"    , isConnectedTo: self.terminals[3]
                        6   : -> comment: "GND connection, because differential module used for single-ended signal"    , isConnectedTo: self.terminals[7]
                ) "AI1"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL3152
                comment: "4..20mA inputs to measure the pressures in the top and bottom bearing rings"
                symbol: "HS:AI2"
                ) "AI2"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL3202_0010
                comment: "Pt-100 inputs to measure the bearing oil temperature"
                symbol: "HS:RTD1"
                ) "RTD1"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL9410
                comment: "Refresh E-bus"
                symbol: "HS:PWR1"
                terminals:
                        1   : -> comment: "+24V for E-bus"             , isConnectedTo: hydraulics_elec.HS.terminals.DC
                        5   : -> comment: "GND for E-bus"              , isConnectedTo: hydraulics_elec.HS.terminals.GND
                        2   : -> comment: "+24V for power contacts"    , isConnectedTo: hydraulics_elec.HS.terminals.DC
                        3   : -> comment: "GND for power contacts"     , isConnectedTo: hydraulics_elec.HS.terminals.GND
                ) "PWR1"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL4132
                comment: "-10..+10V outputs to control the speed of the top and bottom pumps"
                symbol: "HS:AO1"
                ) "AO1"

            IO_MODULE_INSTANCE(
                comment: "Shields of various connectors"
                symbol: "HS:SH1"
                type: beckhoff.EL9070
                ) "SH1"
        ]
    ) "io"


# Actuators ============================================================================================================

hydraulics_elec.HS.ADD ACTUATOR_INSTANCE(
    type: sick.UE10_2FG2DO
    comment: "Safety relay for releasing/blocking the azimuth axis of the old TCS"
    symbol: "HS:SR"
    terminals:
        B1: -> symbol: "HS:SR:B1", comment: "Actuated by PLC safety output", isConnectedTo: hydraulics_elec.HS.io.SO1.terminals[3]
        A2: -> symbol: "HS:SR:A1", comment: "Actuated by PLC safety output", isConnectedTo: hydraulics_elec.HS.io.SO1.terminals[4]
        13: -> symbol: "HS:SR:13", comment: "NO contact for releasing/blocking the axes (old TCS)"
        14: -> symbol: "HS:SR:14", comment: "NO contact for releasing/blocking the axes (old TCS)"
    ) "SR"


# Connectors ===========================================================================================================

hydraulics_elec.HS.ADD CONTAINER(
    items:
        ECAT: ->
            CONNECTOR_INSTANCE(type: harting.RJ45F , symbol: "HS:ECAT-A", comment: "Socket on the panel: RJ-45 connector, to connect the coupler to the EtherCAT network")
        PC: ->
            CONNECTOR_INSTANCE(
                type    : itt.Dsub25FS
                symbol  : "HS:PC-A"
                comment : "Socket on the panel: Pumps Control (PC) Dsub25 connector of the Hydraulics and Safety (HS) panel"
                terminals:
                    1 : -> symbol: "TopGND"    , comment: "Top drive Ground"                                          , isConnectedTo: hydraulics_elec.HS.terminals.GND
                    2 : -> symbol: "Top24V"    , comment: "Top drive +24V supply"                                     , isConnectedTo: hydraulics_elec.HS.terminals.DC
                    3 : -> symbol: "TopRESET"  , comment: "Top drive DiIn: RESET"                                     , isConnectedTo: hydraulics_elec.HS.io.DO1.terminals[1]
                    4 : -> symbol: "TopRFR"    , comment: "Top drive DiIn: Release (RFR=ReglerFreigabe)"              , isConnectedTo: hydraulics_elec.HS.io.SO1.terminals[1]
                    5 : -> symbol: "TopTRIP"   , comment: "Top drive DiOut: TRIP signal (high=OK, low=tripped)"       , isConnectedTo: hydraulics_elec.HS.io.SI1.terminals[2]
                    6 : -> symbol: "TopQMIN"   , comment: "Top drive DiOut: QMin (high = motorFreq < setpointFreq)"   , isConnectedTo: hydraulics_elec.HS.io.SI1.terminals[4]
                    7 : -> symbol: "TopSetp"   , comment: "Top drive AnIn: bipolar setpoint (-10..+10V)"              , isConnectedTo: hydraulics_elec.HS.io.AO1.terminals[1]
                    8 : -> symbol: "TopMon"    , comment: "Top drive AnOut: unipolar monitor signal (0..+10V)"        , isConnectedTo: hydraulics_elec.HS.io.AI1.terminals[1]
                    9 : -> symbol: "TopSetpGND", comment: "Top drive AnIn GND for bipolar setpoint signal (-10..+10V)", isConnectedTo: hydraulics_elec.HS.io.AO1.terminals[3]
                    10: -> symbol: "TopMonGND" , comment: "Top drive AnOut GND for unipolar monitor signal (0..+10V)" , isConnectedTo: hydraulics_elec.HS.io.AI1.terminals[2]
                    11: -> symbol: "PumpCon+"  , comment: "Pumps contactor +"                                         , isConnectedTo: hydraulics_elec.HS.io.DO1.terminals[6]
                    14: -> symbol: "BotGND"    , comment: "Bottom drive Ground"                                       , isConnectedTo: hydraulics_elec.HS.terminals.GND
                    15: -> symbol: "Bot24V"    , comment: "Bottom drive +24V supply"                                  , isConnectedTo: hydraulics_elec.HS.terminals.DC
                    16: -> symbol: "BotRESET"  , comment: "Bottom drive DiIn: RESET"                                  , isConnectedTo: hydraulics_elec.HS.io.DO1.terminals[5]
                    17: -> symbol: "BotRFR"    , comment: "Bottom drive DiIn: Release (RFR=ReglerFreigabe)"           , isConnectedTo: hydraulics_elec.HS.io.SO1.terminals[5]
                    18: -> symbol: "BotTRIP"   , comment: "Bottom drive DiOut: TRIP signal (high=OK, low=tripped)"    , isConnectedTo: hydraulics_elec.HS.io.SI1.terminals[6]
                    19: -> symbol: "BotQMIN"   , comment: "Bottom drive DiOut: QMin (high = motorFreq < setpointFreq)", isConnectedTo: hydraulics_elec.HS.io.SI1.terminals[8]
                    20: -> symbol: "BotSetp"   , comment: "Bottom drive AnIn: bipolar setpoint (-10..+10V)"           , isConnectedTo: hydraulics_elec.HS.io.AO1.terminals[5]
                    21: -> symbol: "BotMon"    , comment: "Bottom drive AnOut: unipolar monitor signal (0..+10V)"     , isConnectedTo: hydraulics_elec.HS.io.AI1.terminals[5]
                    9 : -> symbol: "BotSetpGND", comment: "Bottom drive AnIn GND for bipolar monitor signal (-10..+10V)", isConnectedTo: hydraulics_elec.HS.io.AO1.terminals[7]
                    23: -> symbol: "TopMonGND" , comment: "Bottom drive AnOut GND for unipolar monitor signal (0..+10V)", isConnectedTo: hydraulics_elec.HS.io.AI1.terminals[6]
                    12: -> symbol: "CirCon+"   , comment: "Circulation pump contactor terminal +"                     , isConnectedTo: hydraulics_elec.HS.io.DO1.terminals[2]
                    13: -> symbol: "CirCon-"   , comment: "Circulation pump contactor terminal -"                     , isConnectedTo: hydraulics_elec.HS.terminals.GND
                    24: -> symbol: "PumpCon-"  , comment: "Pumps contactor -"                                         , isConnectedTo: hydraulics_elec.HS.terminals.GND
                    25: -> symbol: "SHLD"      , comment: "Shield of Pumps Control connector"                         , isConnectedTo: hydraulics_elec.HS.io.SH1.terminals[1])
        ED1: ->
            CONNECTOR_INSTANCE(
                type    : itt.Dsub9FS
                symbol  : "HS:ED1-A"
                comment : "Socket on the panel: connects the Emergency Stop 1 in the dome"
                terminals:
                    1 : -> symbol: "NC1"   , comment: "Dome emergency stop 1: Normally Closed (NC) contact 1"        , isConnectedTo: hydraulics_elec.HS.io.SI3.terminals[1]
                    2 : -> symbol: "NC2"   , comment: "Dome emergency stop 1: Normally Closed (NC) contact 2"        , isConnectedTo: hydraulics_elec.HS.io.SI3.terminals[2]
                    3 : -> symbol: "NO1"   , comment: "Dome emergency stop 1: Normally Open (NO) contact 1"          , isConnectedTo: hydraulics_elec.HS.io.SI3.terminals[3]
                    4 : -> symbol: "NO2"   , comment: "Dome emergency stop 1: Normally Open (NO) contact 2"          , isConnectedTo: hydraulics_elec.HS.io.SI3.terminals[4]
                    9 : -> symbol: "SHLD"  , comment: "Dome emergency stop 1: shield"                                , isConnectedTo: hydraulics_elec.HS.io.SH1.terminals[2])
        ED2: ->
            CONNECTOR_INSTANCE(
                type    : itt.Dsub9FS
                symbol  : "HS:ED2-A"
                comment : "Socket on the panel: connects the Emergency Stop 2 in the dome"
                terminals:
                    1 : -> symbol: "NC1"   , comment: "Dome emergency stop 2: Normally Closed (NC) contact 1" , isConnectedTo: hydraulics_elec.HS.io.SI3.terminals[5]
                    2 : -> symbol: "NC2"   , comment: "Dome emergency stop 2: Normally Closed (NC) contact 2" , isConnectedTo: hydraulics_elec.HS.io.SI3.terminals[6]
                    3 : -> symbol: "NO1"   , comment: "Dome emergency stop 2: Normally Open (NO) contact 1"   , isConnectedTo: hydraulics_elec.HS.io.SI3.terminals[7]
                    4 : -> symbol: "NO2"   , comment: "Dome emergency stop 2: Normally Open (NO) contact 2"   , isConnectedTo: hydraulics_elec.HS.io.SI3.terminals[8]
                    9 : -> symbol: "SHLD"  , comment: "Dome emergency stop 2: shield"                         , isConnectedTo: hydraulics_elec.HS.io.SH1.terminals[3])
        ECR:->
            CONNECTOR_INSTANCE(
                type    : itt.Dsub9FS
                symbol  : "HS:ECR-A"
                comment : "Socket on the panel: connects the Emergency Stop on the control room"
                terminals:
                    1 : -> symbol: "NC1"   , comment: "Control room emergency stop: Normally Closed (NC) contact 1"  , isConnectedTo: hydraulics_elec.HS.io.SI4.terminals[1]
                    2 : -> symbol: "NC2"   , comment: "Control room emergency stop: Normally Closed (NC) contact 2"  , isConnectedTo: hydraulics_elec.HS.io.SI4.terminals[2]
                    3 : -> symbol: "NO1"   , comment: "Control room emergency stop: Normally Open (NO) contact 1"    , isConnectedTo: hydraulics_elec.HS.io.SI4.terminals[3]
                    4 : -> symbol: "NO2"   , comment: "Control room emergency stop: Normally Open (NO) contact 2"    , isConnectedTo: hydraulics_elec.HS.io.SI4.terminals[4]
                    9 : -> symbol: "SHLD"  , comment: "Control room emergency stop: shield"                          , isConnectedTo: hydraulics_elec.HS.io.SH1.terminals[4])
        EFF:->
            CONNECTOR_INSTANCE(
                type    : itt.Dsub9FS
                symbol  : "HS:EFF-A"
                comment : "Socket on the panel: connects the Emergency Stop on the first floor"
                terminals:
                    1 : -> symbol: "NC1"   , comment: "First floor emergency stop: Normally Closed (NC) contact 1"         , isConnectedTo: hydraulics_elec.HS.io.SI4.terminals[5]
                    2 : -> symbol: "NC2"   , comment: "First floor emergency stop: Normally Closed (NC) contact 2"         , isConnectedTo: hydraulics_elec.HS.io.SI4.terminals[6]
                    3 : -> symbol: "NO1"   , comment: "First floor emergency stop: Normally Open (NO) contact 1"           , isConnectedTo: hydraulics_elec.HS.io.SI4.terminals[7]
                    4 : -> symbol: "NO2"   , comment: "First floor emergency stop: Normally Open (NO) contact 2"           , isConnectedTo: hydraulics_elec.HS.io.SI4.terminals[8]
                    9 : -> symbol: "SHLD"  , comment: "First floor emergency stop: shield"                                 , isConnectedTo: hydraulics_elec.HS.io.SH1.terminals[5]
            )
        OLCTCS :->
            CONNECTOR_INSTANCE(
                type    : itt.Dsub9FS
                symbol  : "HS:OLDTCS-A"
                comment : "Socket on the panel: May be used to release/block the axes of the old TCS"
                terminals:
                    3 : -> symbol: "REL1" , comment: "Axes release relay contact 1 (was used to release/block the old TCS drives)", isConnectedTo: hydraulics_elec.HS.SR.terminals[13]
                    4 : -> symbol: "REL2" , comment: "Axes release relay contact 2 (was used to release/block the old TCS drives)", isConnectedTo: hydraulics_elec.HS.SR.terminals[14]
                    1 : -> symbol: "+24V" , comment: "+24V (was used to power part of the old TCS)"             , isConnectedTo: hydraulics_elec.HS.terminals.DC
                    6 : -> symbol: "GND"  , comment: "GND (was used to power part of the old TCS)"              , isConnectedTo: hydraulics_elec.HS.terminals.GND
                    9 : -> symbol: "SHLD" , comment: "Cable shield"                                             , isConnectedTo: hydraulics_elec.HS.io.SH1.terminals[6])
        TOPP:->
            CONNECTOR_INSTANCE(
                type    : itt.Dsub9FS
                symbol  : "HS:TOPP-A"
                comment : "Socket on the panel: connects the top bearing ring Pressure sensor"
                terminals:
                    3 : -> symbol: "OUT"  , comment: "Top Pressure sensor output"                               , isConnectedTo: hydraulics_elec.HS.io.AI2.terminals[1]
                    2 : -> symbol: "+24V" , comment: "Top Pressure sensor +24V"                                 , isConnectedTo: hydraulics_elec.HS.io.AI2.terminals[2]
                    1 : -> symbol: "GND"  , comment: "Top Pressure sensor GND"                                  , isConnectedTo: hydraulics_elec.HS.io.AI2.terminals[3])
        BOTP:->
            CONNECTOR_INSTANCE(
                type    : itt.Dsub9FS
                symbol  : "HS:BOTP-A"
                comment : "Socket on the panel: connects the bottom bearing ring Pressure sensor"
                terminals:
                    3 : -> symbol: "OUT"  , comment: "Bottom Pressure sensor output"                            , isConnectedTo: hydraulics_elec.HS.io.AI2.terminals[5]
                    2 : -> symbol: "+24V" , comment: "Bottom Pressure sensor +24V"                              , isConnectedTo: hydraulics_elec.HS.io.AI2.terminals[6]
                    1 : -> symbol: "GND"  , comment: "Bottom Pressure sensor GND"                               , isConnectedTo: hydraulics_elec.HS.io.AI2.terminals[7])
        BT :->
            CONNECTOR_INSTANCE(
                type    : itt.Dsub9FS
                symbol  : "HS:BT-A"
                comment : "Socket on the panel: connects the bearing oil temperature sensor"
                terminals:
                    1 : -> symbol: "+R"     , comment: "Bearing oil temperature sensor +R"                        , isConnectedTo: hydraulics_elec.HS.io.RTD1.terminals[1]
                    2 : -> symbol: "-R"     , comment: "Bearing oil temperature sensor -R"                        , isConnectedTo: hydraulics_elec.HS.io.RTD1.terminals[3]
                    3 : -> symbol: "+RL"    , comment: "Bearing oil temperature sensor +RL (line resistance)"     , isConnectedTo: hydraulics_elec.HS.io.RTD1.terminals[2]
                    4 : -> symbol: "-RL"    , comment: "Bearing oil temperature sensor -RL (line resistance)"     , isConnectedTo: hydraulics_elec.HS.io.RTD1.terminals[4]
                    5 : -> symbol: "SHLD"   , comment: "Bearing oil temperature sensor cable shield"              , isConnectedTo: hydraulics_elec.HS.io.SH1.terminals[7])
        RFOP :->
            CONNECTOR_INSTANCE(
                type    : itt.Dsub9FS
                symbol  : "HS:RFOP-A"
                comment : "Socket on the panel: connects the return filter overpressure switch"
                terminals:
                    1 : -> symbol: "+24V" , comment: "Return filter overpressure switch + 24V"                  , isConnectedTo: hydraulics_elec.HS.terminals.DC
                    3 : -> symbol: "NO"   , comment: "Return filter overpressure switch normally open contact"  , isConnectedTo: hydraulics_elec.HS.io.SI2.terminals[2]
                    2 : -> symbol: "GND"  , comment: "Return filter overpressure switch GND"                    , isConnectedTo: hydraulics_elec.HS.terminals.GND
                    9 : -> symbol: "SHLD" , comment: "Return filter overpressure switch Cable shield"           , isConnectedTo: hydraulics_elec.HS.io.SH1.terminals[8]
            )
        HBPWR :->
            CONNECTOR_INSTANCE(
                type: binder.circular2WayFemalePanelSocket
                symbol: "HS:HBPWR-A"
                comment: "Socket on the panel: power out to the Hydraulics Box"
                terminals:
                    1    : -> symbol: "+24V"
                    2    : -> symbol: "GND"
                    shell: -> symbol: "PE"
                wires:
                    1    : -> from: self.terminals[1], to: hydraulics_elec.HS.terminals.DC  , color: colors.brown
                    2    : -> from: self.terminals[2], to: hydraulics_elec.HS.terminals.GND , color: colors.blue
                    shell: -> from: self.terminals.shell, to: hydraulics_elec.HS.terminals.PE  , color: [colors.yellow, colors.green]
            )

    ) "connectors"



########################################################################################################################
# HS / Field
########################################################################################################################

hydraulics_elec.HS.ADD CONTAINS elec.Configuration "field"


# EStops ===============================================================================================================

addEStop = (name, symbol) ->

    hydraulics_elec.HS.field.ADD CONTAINS elec.Configuration "#{symbol}"

    hydraulics_elec.HS.field[symbol].ADD "Emergency stop configuration '#{name}'"

    hydraulics_elec.HS.field[symbol].ADD CONTAINS SWITCH_INSTANCE(
        type    : various.EStop_NO_NC
        symbol  : "HS:#{symbol}"
        comment : "Emergency button DOME 1"
        terminals:
            NC1: -> symbol: "NC1", comment: "#{name} NC contact 1"
            NC2: -> symbol: "NC2", comment: "#{name} NC contact 2"
            NO1: -> symbol: "NO1", comment: "#{name} NO contact 1"
            NO2: -> symbol: "NO2", comment: "#{name} NO contact 2"
        ) "button"

    hydraulics_elec.HS.field[symbol].ADD CONTAINS CONNECTOR_INSTANCE(
        type    : itt.Dsub9MP
        symbol  : "HS:#{symbol}-B"
        comment : "Plug, to connect the cable to the HS panel"
        ) "plug"

    hydraulics_elec.HS.field[symbol].ADD CONTAINS CABLE_INSTANCE(
        type    : various.Cable4x025S_NoColors
        comment : "Cable between button and plug"
        wires:
            1      : -> comment: "Color not specified", from:  hydraulics_elec.HS.field[symbol].plug.terminals[1], to: hydraulics_elec.HS.field[symbol].button.terminals.NC1
            2      : -> comment: "Color not specified", from:  hydraulics_elec.HS.field[symbol].plug.terminals[2], to: hydraulics_elec.HS.field[symbol].button.terminals.NC2
            3      : -> comment: "Color not specified", from:  hydraulics_elec.HS.field[symbol].plug.terminals[3], to: hydraulics_elec.HS.field[symbol].button.terminals.NO1
            4      : -> comment: "Color not specified", from:  hydraulics_elec.HS.field[symbol].plug.terminals[4], to: hydraulics_elec.HS.field[symbol].button.terminals.NO2
            shield : -> comment: "Cable shielding"    , from:  hydraulics_elec.HS.field[symbol].plug.terminals[9], to: hydraulics_elec.HS.field[symbol].button.terminals.chassis
        ) "cable"


addEStop('Dome 1'      , 'ED1')
addEStop('Dome 2'      , 'ED2')
addEStop('Control Room', 'ECR')
addEStop('First Floor' , 'EFF')


# Pressure sensors =====================================================================================================

addPressureSensor = (name, symbol) ->

    hydraulics_elec.HS.field.ADD CONTAINS elec.Configuration "#{symbol}"

    hydraulics_elec.HS.field[symbol].ADD "Pressure sensor '#{name}' + cable + connector"

    hydraulics_elec.HS.field[symbol].ADD CONTAINS SENSOR_INSTANCE(
        type    : various.PressureSensor
        symbol  : "HS:#{symbol}"
        comment : "Pressure sensor #{name}"
        terminals:
            DC : -> symbol: "+24V", comment: "Sensor +24V"
            OUT: -> symbol: "OUT", comment: "Sensor 4..20mA output signal"
        ) "sensor"

    hydraulics_elec.HS.field[symbol].ADD CONTAINS CONNECTOR_INSTANCE(
        type    : itt.Dsub9MP
        symbol  : "HS:#{symbol}-B"
        comment : "Plug, to connect the cable to the HS panel"
        ) "plug"

    hydraulics_elec.HS.field[symbol].ADD CONTAINS CABLE_INSTANCE(
        type    : various.Cable2x05S_NoColors
        comment : "Cable between sensor and plug"
        wires:
            1      : -> comment: "Color not specified", from:  hydraulics_elec.HS.field[symbol].plug.terminals[3], to: hydraulics_elec.HS.field[symbol].sensor.terminals.OUT
            2      : -> comment: "Color not specified", from:  hydraulics_elec.HS.field[symbol].plug.terminals[2], to: hydraulics_elec.HS.field[symbol].sensor.terminals.DC
            shield : -> comment: "Cable shielding (not connected on sensor side)", from:  hydraulics_elec.HS.field[symbol].plug.terminals[1]
        ) "cable"

addPressureSensor("Top", "TOPP")
addPressureSensor("Bottom", "BOTP")


# Temperature sensors ==================================================================================================

addTemperatureSensor = (name, symbol) ->

    hydraulics_elec.HS.field.ADD CONTAINS elec.Configuration "#{symbol}"

    hydraulics_elec.HS.field[symbol].ADD "Temperature sensor '#{name}' + cable + connector"

    hydraulics_elec.HS.field[symbol].ADD CONTAINS SENSOR_INSTANCE(
        type    : various.Pt100Sensor
        symbol  : "HS:#{symbol}"
        comment : "Temperature sensor #{name}"
        terminals:
            pR : -> symbol: "+R" , comment: "+ sensor"
            pRL: -> symbol: "+RL", comment: "+ line"
            mR : -> symbol: "-R" , comment: "- sensor"
            mRL: -> symbol: "-RL", comment: "- line"
        ) "sensor"

    hydraulics_elec.HS.field[symbol].ADD CONTAINS CONNECTOR_INSTANCE(
        type    : itt.Dsub9MP
        symbol  : "HS:#{symbol}-B"
        comment : "Plug, to connect the cable to the HS panel"
        ) "plug"

    hydraulics_elec.HS.field[symbol].ADD CONTAINS CABLE_INSTANCE(
        type    : various.Cable4x025S_NoColors
        comment : "Cable between sensor and plug"
        wires:
            1      : -> comment: "Color not specified", from:  hydraulics_elec.HS.field[symbol].plug.terminals[1], to: hydraulics_elec.HS.field[symbol].sensor.terminals.pR
            2      : -> comment: "Color not specified", from:  hydraulics_elec.HS.field[symbol].plug.terminals[2], to: hydraulics_elec.HS.field[symbol].sensor.terminals.pRL
            3      : -> comment: "Color not specified", from:  hydraulics_elec.HS.field[symbol].plug.terminals[3], to: hydraulics_elec.HS.field[symbol].sensor.terminals.mR
            4      : -> comment: "Color not specified", from:  hydraulics_elec.HS.field[symbol].plug.terminals[4], to: hydraulics_elec.HS.field[symbol].sensor.terminals.mRL
            shield : -> comment: "Cable shielding (not connected on sensor side)", from:  hydraulics_elec.HS.field[symbol].plug.terminals[5]
        ) "cable"

addTemperatureSensor("Bearing temperature", "BT")


# Switches =============================================================================================================

addSwitch = (name, symbol) ->

    hydraulics_elec.HS.field.ADD CONTAINS elec.Configuration "#{symbol}"

    hydraulics_elec.HS.field[symbol].ADD "Switch '#{name}' + cable + connector"

    hydraulics_elec.HS.field[symbol].ADD CONTAINS SWITCH_INSTANCE(
        type    : various.OilReturnOverpressureSwitch
        symbol  : "HS:#{symbol}"
        comment : "Switch #{name}"
        terminals:
            1 : -> symbol: "1" , comment: "+24V"
            2 : -> symbol: "2" , comment: "GND"
            3 : -> symbol: "3" , comment: "NO contact"
        ) "sensor"

    hydraulics_elec.HS.field[symbol].ADD CONTAINS CONNECTOR_INSTANCE(
        type    : itt.Dsub9MP
        symbol  : "HS:#{symbol}-B"
        comment : "Plug, to connect the cable to the HS panel"
        ) "plug"

    hydraulics_elec.HS.field[symbol].ADD CONTAINS CABLE_INSTANCE(
        type    : various.Cable3x075S_NoColors
        comment : "Cable between sensor and plug"
        wires:
            1      : -> comment: "Color not specified", from:  hydraulics_elec.HS.field[symbol].plug.terminals[1], to: hydraulics_elec.HS.field[symbol].sensor.terminals[1]
            2      : -> comment: "Color not specified", from:  hydraulics_elec.HS.field[symbol].plug.terminals[2], to: hydraulics_elec.HS.field[symbol].sensor.terminals[2]
            3      : -> comment: "Color not specified", from:  hydraulics_elec.HS.field[symbol].plug.terminals[3], to: hydraulics_elec.HS.field[symbol].sensor.terminals[3]
            shield : -> comment: "Cable shielding (not connected on sensor side)", from:  hydraulics_elec.HS.field[symbol].plug.terminals[5]
        ) "cable"

addSwitch("Oil return filter overpressure switch", "RFOP")


########################################################################################################################
# HS Configuration
########################################################################################################################

hydraulics_elec.ADD elec.Configuration "hydraulicsAndSafety" : [

    LABEL "HS: Hydraulics & Safety"
    COMMENT "The Hydraulics and Safety configuration."

    cont.contains hydraulics_elec.HS.socket230VAC
    cont.contains hydraulics_elec.HS.circuitBreaker
    cont.contains hydraulics_elec.HS.power
    cont.contains hydraulics_elec.HS.SR
    [ cont.contains c for c in PATHS(hydraulics_elec.HS.connectors, cont.contains) ]
    cont.contains hydraulics_elec.HS.terminals
    [ elec.hasTerminal t for t in PATHS(hydraulics_elec.HS.terminals, cont.contains) ]
    cont.contains hydraulics_elec.HS.io
    [ cont.contains item for item in PATHS(hydraulics_elec.HS.io, cont.contains) ]
    cont.contains hydraulics_elec.HS.field
]



########################################################################################################################
## Hydraulics box
########################################################################################################################


# Mechanical parts =====================================================================================================

hydraulics_elec.ADD mech.PART(comment: "The hydraulics box (mounted on the pumps group)") "box"


# Terminals ============================================================================================================

hydraulics_elec.box.ADD CONTAINER(
    items:
        DC  : -> TERMINAL(symbol: "+24V" , comment: "+24VDC")
        GND : -> TERMINAL(symbol: "GND"  , comment: "GND")
        PE  : -> TERMINAL(symbol: "PE"   , comment: "Protective Earth")

        X22 : -> TERMINAL(symbol: "X22"  , comment: "Oil level switch contact 1")
        X21 : -> TERMINAL(symbol: "X21"  , comment: "Oil level switch contact 2")

        X20 : -> TERMINAL(symbol: "X20"  , comment: "Circulation filter overpressure switch D contact 2")
        X19 : -> TERMINAL(symbol: "X19"  , comment: "Circulation filter overpressure switch D contact 1")

        X18 : -> TERMINAL(symbol: "X18"  , comment: "Circulation filter overpressure switch G contact 2")
        X17 : -> TERMINAL(symbol: "X17"  , comment: "Circulation filter overpressure switch G contact 1")

        X52 : -> TERMINAL(symbol: "X52"  , comment: "Bottom ring overpressure switch 'maxi' contact 3")
        X51 : -> TERMINAL(symbol: "X51"  , comment: "Bottom ring overpressure switch 'maxi' contact 2")
        X50 : -> TERMINAL(symbol: "X50"  , comment: "Bottom ring overpressure switch 'maxi' contact 1")
        X49 : -> TERMINAL(symbol: "X49"  , comment: "Bottom ring overpressure switch 'mini' contact 3")
        X48 : -> TERMINAL(symbol: "X48"  , comment: "Bottom ring overpressure switch 'mini' contact 2")
        X47 : -> TERMINAL(symbol: "X47"  , comment: "Bottom ring overpressure switch 'mini' contact 1")

        X46 : -> TERMINAL(symbol: "X46"  , comment: "Top ring overpressure switch 'maxi' contact 3")
        X45 : -> TERMINAL(symbol: "X45"  , comment: "Top ring overpressure switch 'maxi' contact 2")
        X44 : -> TERMINAL(symbol: "X44"  , comment: "Top ring overpressure switch 'maxi' contact 1")
        X43 : -> TERMINAL(symbol: "X43"  , comment: "Top ring overpressure switch 'mini' contact 3")
        X42 : -> TERMINAL(symbol: "X42"  , comment: "Top ring overpressure switch 'mini' contact 2")
        X41 : -> TERMINAL(symbol: "X41"  , comment: "Top ring overpressure switch 'mini' contact 1")

        X1  : -> TERMINAL(symbol: "X1"   , comment: "Top 1 underpressure switch contact 2")
        X2  : -> TERMINAL(symbol: "X2"   , comment: "Top 1 underpressure switch contact 1")
        US1 : -> TERMINAL(                 comment: "Top 1 underpressure switch contact 3")
        X3  : -> TERMINAL(symbol: "X3"   , comment: "Top 2 underpressure switch contact 2")
        X4  : -> TERMINAL(symbol: "X4"   , comment: "Top 2 underpressure switch contact 1")
        US2 : -> TERMINAL(                 comment: "Top 2 underpressure switch contact 3")
        X5  : -> TERMINAL(symbol: "X5"   , comment: "Top 3 underpressure switch contact 2")
        X6  : -> TERMINAL(symbol: "X6"   , comment: "Top 3 underpressure switch contact 1")
        US3 : -> TERMINAL(                 comment: "Top 3 underpressure switch contact 3")
        X7  : -> TERMINAL(symbol: "X7"   , comment: "Top 4 underpressure switch contact 2")
        X8  : -> TERMINAL(symbol: "X8"   , comment: "Top 4 underpressure switch contact 1")
        US4 : -> TERMINAL(                 comment: "Top 4 underpressure switch contact 3")

        X9  : -> TERMINAL(symbol: "X9"   , comment: "Bottom 5 underpressure switch contact 2")
        X10 : -> TERMINAL(symbol: "X10"  , comment: "Bottom 5 underpressure switch contact 1")
        US5 : -> TERMINAL(                 comment: "Bottom 5 underpressure switch contact 3")
        X11 : -> TERMINAL(symbol: "X11"  , comment: "Bottom 6 underpressure switch contact 2")
        X12 : -> TERMINAL(symbol: "X12"  , comment: "Bottom 6 underpressure switch contact 1")
        US6 : -> TERMINAL(                 comment: "Bottom 6 underpressure switch contact 3")
        X13 : -> TERMINAL(symbol: "X13"  , comment: "Bottom 7 underpressure switch contact 2")
        X14 : -> TERMINAL(symbol: "X14"  , comment: "Bottom 7 underpressure switch contact 1")
        US7 : -> TERMINAL(                 comment: "Bottom 7 underpressure switch contact 3")
        X15 : -> TERMINAL(symbol: "X15"  , comment: "Bottom 8 underpressure switch contact 2")
        X16 : -> TERMINAL(symbol: "X16"  , comment: "Bottom 8 underpressure switch contact 1")
        US8 : -> TERMINAL(                 comment: "Bottom 9 underpressure switch contact 3")

        X40 : -> TERMINAL(symbol: "X40"  , comment: "Top 1 filter overpressure switch contact 1")
        X39 : -> TERMINAL(symbol: "X39"  , comment: "Top 1 filter overpressure switch contact 2", isConnectedTo: self.DC)
        X38 : -> TERMINAL(symbol: "X38"  , comment: "Top 2 filter overpressure switch contact 1")
        X37 : -> TERMINAL(symbol: "X37"  , comment: "Top 2 filter overpressure switch contact 2", isConnectedTo: self.X39)
        X36 : -> TERMINAL(symbol: "X36"  , comment: "Top 3 filter overpressure switch contact 1")
        X35 : -> TERMINAL(symbol: "X35"  , comment: "Top 3 filter overpressure switch contact 2", isConnectedTo: self.X37)
        X34 : -> TERMINAL(symbol: "X34"  , comment: "Top 4 filter overpressure switch contact 1")
        X33 : -> TERMINAL(symbol: "X33"  , comment: "Top 4 filter overpressure switch contact 2", isConnectedTo: self.X35)

        X32 : -> TERMINAL(symbol: "X32"  , comment: "Bottom 5 filter overpressure switch contact 1")
        X31 : -> TERMINAL(symbol: "X31"  , comment: "Bottom 5 filter overpressure switch contact 2", isConnectedTo: self.X33)
        X30 : -> TERMINAL(symbol: "X30"  , comment: "Bottom 6 filter overpressure switch contact 1")
        X29 : -> TERMINAL(symbol: "X29"  , comment: "Bottom 6 filter overpressure switch contact 2", isConnectedTo: self.X31)
        X28 : -> TERMINAL(symbol: "X28"  , comment: "Bottom 7 filter overpressure switch contact 1")
        X27 : -> TERMINAL(symbol: "X27"  , comment: "Bottom 7 filter overpressure switch contact 2", isConnectedTo: self.X29)
        X26 : -> TERMINAL(symbol: "X26"  , comment: "Bottom 8 filter overpressure switch contact 1")
        X25 : -> TERMINAL(symbol: "X33"  , comment: "Bottom 8 filter overpressure switch contact 2", isConnectedTo: self.X27)
    ) "terminals"

hydraulics_elec.box.ADD CONTAINER(
    items:
        X17 : -> WIRE(from: hydraulics_elec.box.terminals.X17, to: hydraulics_elec.box.terminals.DC, color: colors.orange)
        X19 : -> WIRE(from: hydraulics_elec.box.terminals.X19, to: hydraulics_elec.box.terminals.DC, color: colors.orange)
        X21 : -> WIRE(from: hydraulics_elec.box.terminals.X21, to: hydraulics_elec.box.terminals.DC, color: colors.orange)
    ) "wires"

# I/O modules ==========================================================================================================

hydraulics_elec.box.ADD CONTAINER(
    items:
        COU: ->
            IO_MODULE_INSTANCE(
                type: beckhoff.EK1101
                symbol: "PG:COU"
                comment: "Coupler of the hydraulics box"
                terminals:
                    X1  : -> comment: "From EtherCAT switch"
                    1   : -> comment: "Coupler power 24V DC"
                    2   : -> comment: "Bus power 24V DC"
                    3   : -> comment: "Coupler GND"
                    4   : -> comment: "Earth"
                    5   : -> comment: "Bus GND"
                add_wires:
                    1   : -> from: self.terminals[1], to: hydraulics_elec.box.terminals.DC, color: colors.orange
                    2   : -> from: self.terminals[2], to: hydraulics_elec.box.terminals.DC, color: colors.orange
                    3   : -> from: self.terminals[3], to: hydraulics_elec.box.terminals.GND, color: colors.yellow
                    4   : -> from: self.terminals[4], to: hydraulics_elec.box.terminals.PE, color: [colors.yellow, colors.green]
                    5   : -> from: self.terminals[5], to: hydraulics_elec.box.terminals.GND, color: colors.yellow
            )
        DI1: ->
            IO_MODULE_INSTANCE(
                type: beckhoff.EL1008
                symbol: "PG:DI1"
                comment: "Digital inputs for oil level and return filters"
                add_wires:
                    1   : -> from: self.terminals[1], to: hydraulics_elec.box.terminals.X22, color: colors.white
                    5   : -> from: self.terminals[5], to: hydraulics_elec.box.terminals.X20, color: colors.violet
                    2   : -> from: self.terminals[2], to: hydraulics_elec.box.terminals.X18, color: colors.pink
            )
        SI1: ->
            IO_MODULE_INSTANCE(
                type: beckhoff.EL1904
                symbol: "PG:SI1"
                comment: "Safe inputs for the top and bottom overpressure switches"
                add_wires:
                    1   : -> from: self.terminals[1], to: hydraulics_elec.box.terminals.X52, color: colors.brown
                    2   : -> from: self.terminals[1], to: hydraulics_elec.box.terminals.X51, color: colors.green
                    5   : -> from: self.terminals[1], to: hydraulics_elec.box.terminals.X46, color: colors.brown
                    6   : -> from: self.terminals[1], to: hydraulics_elec.box.terminals.X45, color: colors.green )
        SI2: ->
            IO_MODULE_INSTANCE(
                type: beckhoff.EL1904
                symbol: "PG:SI2"
                comment: "Safe inputs for the top underpressure switches"
                terminals:
                    1   : -> isConnectedTo: hydraulics_elec.box.terminals.X1
                    2   : -> isConnectedTo: hydraulics_elec.box.terminals.X2
                    5   : -> isConnectedTo: hydraulics_elec.box.terminals.X3
                    6   : -> isConnectedTo: hydraulics_elec.box.terminals.X4
                    3   : -> isConnectedTo: hydraulics_elec.box.terminals.X5
                    4   : -> isConnectedTo: hydraulics_elec.box.terminals.X6
                    7   : -> isConnectedTo: hydraulics_elec.box.terminals.X7
                    8   : -> isConnectedTo: hydraulics_elec.box.terminals.X8)
        SI3: ->
            IO_MODULE_INSTANCE(
                type: beckhoff.EL1904
                symbol: "PG:SI3"
                comment: "Safe inputs for the bottom underpressure switches"
                terminals:
                    1   : -> isConnectedTo: hydraulics_elec.box.terminals.X9
                    2   : -> isConnectedTo: hydraulics_elec.box.terminals.X10
                    5   : -> isConnectedTo: hydraulics_elec.box.terminals.X11
                    6   : -> isConnectedTo: hydraulics_elec.box.terminals.X12
                    3   : -> isConnectedTo: hydraulics_elec.box.terminals.X13
                    4   : -> isConnectedTo: hydraulics_elec.box.terminals.X14
                    7   : -> isConnectedTo: hydraulics_elec.box.terminals.X15
                    8   : -> isConnectedTo: hydraulics_elec.box.terminals.X16)
        DI2: ->
            IO_MODULE_INSTANCE(
                type: beckhoff.EL1008
                symbol: "PG:DI2"
                comment: "Digital inputs for the bearing filters"
                terminals:
                    1   : -> isConnectedTo: hydraulics_elec.box.terminals.X40
                    5   : -> isConnectedTo: hydraulics_elec.box.terminals.X38
                    2   : -> isConnectedTo: hydraulics_elec.box.terminals.X36
                    6   : -> isConnectedTo: hydraulics_elec.box.terminals.X34
                    3   : -> isConnectedTo: hydraulics_elec.box.terminals.X32
                    7   : -> isConnectedTo: hydraulics_elec.box.terminals.X30
                    4   : -> isConnectedTo: hydraulics_elec.box.terminals.X28
                    8   : -> isConnectedTo: hydraulics_elec.box.terminals.X26)
    ) "io"


########################################################################################################################
# PG / Field
########################################################################################################################

hydraulics_elec.box.ADD CONTAINS elec.Configuration "field"


# Switches =============================================================================================================

hydraulics_elec.box.field.ADD CONTAINER(
    items:
        LVL: ->
            SWITCH_INSTANCE(
                    type    : various.OilLevelSwitch
                    symbol  : "PG:LVL"
                    comment : "Oil level switch (NO, open = oil level OK)"
                    terminals:
                        1: -> symbol: "1"
                        2: -> symbol: "2")
        CIFD: ->
            SWITCH_INSTANCE(
                    type    : various.FilterSwitch
                    symbol  : "PG:CIFD"
                    comment : "Circulation filter overpressure switch D (NC, closed = filter OK, no overpressure)"
                    terminals:
                        2: -> symbol: "2"
                        1: -> symbol: "1")
        CIFG: ->
            SWITCH_INSTANCE(
                    type    : various.FilterSwitch
                    symbol  : "PG:CIFG"
                    comment : "Circulation filter overpressure switch G (NC, closed = filter OK, no overpressure)"
                    terminals:
                        2: -> symbol: "2"
                        1: -> symbol: "1")
        TOPOP: ->
            SWITCH_INSTANCE(
                    type    : various.OverpressureSwitch
                    symbol  : "PG:TOPOP"
                    comment : "Top ring overpressure sensor (NC closed = NO open = OK, no overpressure)"
                    terminals:
                        MA3: -> symbol: "MA3", comment: "NC contact"
                        MA2: -> symbol: "MA2", comment: "NC contact"
                        MA1: -> symbol: "MA1", comment: "NO contact, not used by I/O"
                        MI3: -> symbol: "MI3", comment: "Not used by I/O"
                        MI2: -> symbol: "MI2", comment: "Not used by I/O"
                        MI1: -> symbol: "MI1", comment: "Not used by I/O")
        BOTOP: ->
            SWITCH_INSTANCE(
                    type    : various.OverpressureSwitch
                    symbol  : "PG:BOTOP"
                    comment : "Bottom ring overpressure switch (NC closed = NO open = OK, no overpressure)"
                    terminals:
                        MA3: -> symbol: "MA3", comment: "NC contact"
                        MA2: -> symbol: "MA2", comment: "NC contact"
                        MA1: -> symbol: "MA1", comment: "NO contact, not used by I/O"
                        MI3: -> symbol: "MI3", comment: "Not used by I/O"
                        MI2: -> symbol: "MI2", comment: "not used by I/O"
                        MI1: -> symbol: "MI1", comment: "not used by I/O")
        TOP1UP: ->
            SWITCH_INSTANCE(
                    type    : various.UnderpressureSwitch
                    symbol  : "PG:TOP1UP"
                    comment : "Top 1 underpressure switch (NC closed = NO open = OK, no underpressure)"
                    terminals:
                        2: -> symbol: "2", comment: "NC contact"
                        1: -> symbol: "1", comment: "NC contact"
                        3: -> symbol: "3", comment: "NO contact, not used by I/O")
        TOP2UP: ->
            SWITCH_INSTANCE(
                    type    : various.UnderpressureSwitch
                    symbol  : "PG:TOP2UP"
                    comment : "Top 2 underpressure switch (NC closed = NO open = OK, no underpressure)"
                    terminals:
                        2: -> symbol: "2", comment: "NC contact"
                        1: -> symbol: "1", comment: "NC contact"
                        3: -> symbol: "3", comment: "NO contact, not used by I/O")
        TOP3UP: ->
            SWITCH_INSTANCE(
                    type    : various.UnderpressureSwitch
                    symbol  : "PG:TOP3UP"
                    comment : "Top 3 underpressure switch (NC closed = NO open = OK, no underpressure)"
                    terminals:
                        2: -> symbol: "2", comment: "NC contact"
                        1: -> symbol: "1", comment: "NC contact"
                        3: -> symbol: "3", comment: "NO contact, not used by I/O")
        TOP4UP: ->
            SWITCH_INSTANCE(
                    type    : various.UnderpressureSwitch
                    symbol  : "PG:TOP4UP"
                    comment : "Top 4 underpressure switch (NC closed = NO open = OK, no underpressure)"
                    terminals:
                        2: -> symbol: "2", comment: "NC contact"
                        1: -> symbol: "1", comment: "NC contact"
                        3: -> symbol: "3", comment: "NO contact, not used by I/O")
        BOT5UP: ->
            SWITCH_INSTANCE(
                    type    : various.UnderpressureSwitch
                    symbol  : "PG:BOT5UP"
                    comment : "Bottom 5 underpressure switch (NC closed = NO open = OK, no underpressure)"
                    terminals:
                        2: -> symbol: "2", comment: "NC contact"
                        1: -> symbol: "1", comment: "NC contact"
                        3: -> symbol: "3", comment: "NO contact, not used by I/O")
        BOT6UP: ->
            SWITCH_INSTANCE(
                    type    : various.UnderpressureSwitch
                    symbol  : "PG:BOT6UP"
                    comment : "Bottom 6 underpressure switch (NC closed = NO open = OK, no underpressure)"
                    terminals:
                        2: -> symbol: "2", comment: "NC contact"
                        1: -> symbol: "1", comment: "NC contact"
                        3: -> symbol: "3", comment: "NO contact, not used by I/O")
        BOT7UP: ->
            SWITCH_INSTANCE(
                    type    : various.UnderpressureSwitch
                    symbol  : "PG:BOT7UP"
                    comment : "Bottom 7 underpressure switch (NC closed = NO open = OK, no underpressure)"
                    terminals:
                        2: -> symbol: "2", comment: "NC contact"
                        1: -> symbol: "1", comment: "NC contact"
                        3: -> symbol: "3", comment: "NO contact, not used by I/O")
        BOT8UP: ->
            SWITCH_INSTANCE(
                    type    : various.UnderpressureSwitch
                    symbol  : "PG:BOT8UP"
                    comment : "Bottom 8 underpressure switch (NC closed = NO open = OK, no underpressure)"
                    terminals:
                        2: -> symbol: "2"
                        1: -> symbol: "1"
                        3: -> symbol: "3")
        TOP1F: ->
            SWITCH_INSTANCE(
                    type    : various.FilterSwitch
                    symbol  : "PG:TOP1F"
                    comment : "Top 1 filter overpressure switch (NC, closed = filter OK, no overpressure)"
                    terminals:
                        1: -> symbol: "1"
                        2: -> symbol: "2")
        TOP2F: ->
            SWITCH_INSTANCE(
                    type    : various.FilterSwitch
                    symbol  : "PG:TOP2F"
                    comment : "Top 2 filter overpressure switch (NC, closed = filter OK, no overpressure)"
                    terminals:
                        1: -> symbol: "1"
                        2: -> symbol: "2")
        TOP3F: ->
            SWITCH_INSTANCE(
                    type    : various.FilterSwitch
                    symbol  : "PG:TOP3F"
                    comment : "Top 3 filter overpressure switch (NC, closed = filter OK, no overpressure)"
                    terminals:
                        1: -> symbol: "1"
                        2: -> symbol: "2")
        TOP4F: ->
            SWITCH_INSTANCE(
                    type    : various.FilterSwitch
                    symbol  : "PG:TOP4F"
                    comment : "Top 4 filter overpressure switch (NC, closed = filter OK, no overpressure)"
                    terminals:
                        1: -> symbol: "1"
                        2: -> symbol: "2")
        BOT5F: ->
            SWITCH_INSTANCE(
                    type    : various.FilterSwitch
                    symbol  : "PG:BOT5F"
                    comment : "Bottom 5 filter overpressure switch (NC, closed = filter OK, no overpressure)"
                    terminals:
                        1: -> symbol: "1"
                        2: -> symbol: "2")
        BOT6F: ->
            SWITCH_INSTANCE(
                    type    : various.FilterSwitch
                    symbol  : "PG:BOT6F"
                    comment : "Bottom 6 filter overpressure switch (NC, closed = filter OK, no overpressure)"
                    terminals:
                        1: -> symbol: "1"
                        2: -> symbol: "2")
        BOT7F: ->
            SWITCH_INSTANCE(
                    type    : various.FilterSwitch
                    symbol  : "PG:BOT7F"
                    comment : "Bottom 7 filter overpressure switch (NC, closed = filter OK, no overpressure)"
                    terminals:
                        1: -> symbol: "1"
                        2: -> symbol: "2")
        BOT8F: ->
            SWITCH_INSTANCE(
                    type    : various.FilterSwitch
                    symbol  : "PG:BOT8F"
                    comment : "Bottom 8 filter overpressure switch (NC, closed = filter OK, no overpressure)"
                    terminals:
                        1: -> symbol: "1"
                        2: -> symbol: "2")

    ) "switches"


# Cables ===============================================================================================================


# define some cable types
hydraulics_elec.ADD CABLE_TYPE(
    id              : "Cable2WCooling"
    comment         : "Cable with 2 wires, used for the cooling circuit"
    manufacturer    : various.company
    wires:
        1  : -> { symbol: "1", comment: "Wire 1" , color: colors.white }
        2  : -> { symbol: "2", comment: "Wire 2" , color: colors.green }) "Cable2WCooling"

hydraulics_elec.ADD CABLE_TYPE(
    id              : "Cable2WBearing"
    comment         : "Cable with 2 wires, used for the bearing pressure switches"
    manufacturer    : various.company
    wires:
        1  : -> { symbol: "1", comment: "Wire 1" , color: colors.brown }
        2  : -> { symbol: "2", comment: "Wire 2" , color: colors.white }) "Cable2WBearing"

hydraulics_elec.ADD CABLE_TYPE(
    id              : "Cable3WPressureSwitches"
    comment         : "Cable with 3 wires, used for the pressure switches"
    manufacturer    : various.company
    wires:
        1  : -> { symbol: "1", comment: "Wire 1" , color: colors.brown }
        2  : -> { symbol: "2", comment: "Wire 2" , color: colors.green }
        3  : -> { symbol: "3", comment: "Wire 3" , color: colors.white }) "Cable3WPressureSwitches"

# create cable instances
hydraulics_elec.box.field.ADD CONTAINER(
    items:
        LVL: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable2WCooling
                comment : "Cable of the Oil level switch (PG:LVL)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.LVL.terminals[1], to: hydraulics_elec.box.terminals.X22
                    2: -> from: hydraulics_elec.box.field.switches.LVL.terminals[2], to: hydraulics_elec.box.terminals.X21)
        CIFD: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable2WCooling
                comment : "Cable of the Circulation filter overpressure switch D (PG:CIFD)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.CIFD.terminals[2], to: hydraulics_elec.box.terminals.X20
                    2: -> from: hydraulics_elec.box.field.switches.CIFD.terminals[1], to: hydraulics_elec.box.terminals.X19)
        CIFG: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable2WCooling
                comment : "Cable of the Circulation filter overpressure switch G (PG:CIFG)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.CIFG.terminals[2], to: hydraulics_elec.box.terminals.X18
                    2: -> from: hydraulics_elec.box.field.switches.CIFG.terminals[1], to: hydraulics_elec.box.terminals.X17)
        TOPOPmaxi: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable3WPressureSwitches
                comment : "Cable of the Top ring overpressure sensor ('maximum' switch) (PG:TOPOP)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.TOPOP.terminals.MA3, to: hydraulics_elec.box.terminals.X52
                    2: -> from: hydraulics_elec.box.field.switches.TOPOP.terminals.MA2, to: hydraulics_elec.box.terminals.X51
                    3: -> from: hydraulics_elec.box.field.switches.TOPOP.terminals.MA1, to: hydraulics_elec.box.terminals.X50)
        TOPOPmini: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable3WPressureSwitches
                comment : "Cable of the Top ring overpressure sensor ('minimum' switch) (PG:TOPOP)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.TOPOP.terminals.MI3, to: hydraulics_elec.box.terminals.X49
                    2: -> from: hydraulics_elec.box.field.switches.TOPOP.terminals.MI2, to: hydraulics_elec.box.terminals.X48
                    3: -> from: hydraulics_elec.box.field.switches.TOPOP.terminals.MI1, to: hydraulics_elec.box.terminals.X47)
        BOTOPmaxi: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable3WPressureSwitches
                comment : "Cable of the Bottom ring overpressure sensor ('maximum' switch) (PG:BOTOP)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.BOTOP.terminals.MA3, to: hydraulics_elec.box.terminals.X46
                    2: -> from: hydraulics_elec.box.field.switches.BOTOP.terminals.MA2, to: hydraulics_elec.box.terminals.X45
                    3: -> from: hydraulics_elec.box.field.switches.BOTOP.terminals.MA1, to: hydraulics_elec.box.terminals.X44)
        BOTOPmini: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable3WPressureSwitches
                comment : "Cable of the Bottom ring overpressure sensor ('minimum' switch) (PG:BOTOP)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.BOTOP.terminals.MI3, to: hydraulics_elec.box.terminals.X43
                    2: -> from: hydraulics_elec.box.field.switches.BOTOP.terminals.MI2, to: hydraulics_elec.box.terminals.X42
                    3: -> from: hydraulics_elec.box.field.switches.BOTOP.terminals.MI1, to: hydraulics_elec.box.terminals.X41)
        TOP1UP: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable3WPressureSwitches
                comment : "Cable of the Top 1 underpressure switch (PG:TOP1UP)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.TOP1UP.terminals[2], to: hydraulics_elec.box.terminals.X1
                    2: -> from: hydraulics_elec.box.field.switches.TOP1UP.terminals[1], to: hydraulics_elec.box.terminals.X2
                    3: -> from: hydraulics_elec.box.field.switches.TOP1UP.terminals[3], to: hydraulics_elec.box.terminals.US1)
        TOP2UP: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable3WPressureSwitches
                comment : "Cable of the Top 2 underpressure switch (PG:TOP2UP)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.TOP2UP.terminals[2], to: hydraulics_elec.box.terminals.X3
                    2: -> from: hydraulics_elec.box.field.switches.TOP2UP.terminals[1], to: hydraulics_elec.box.terminals.X4
                    3: -> from: hydraulics_elec.box.field.switches.TOP2UP.terminals[3], to: hydraulics_elec.box.terminals.US2)
        TOP3UP: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable3WPressureSwitches
                comment : "Cable of the Top 3 underpressure switch (PG:TOP3UP)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.TOP3UP.terminals[2], to: hydraulics_elec.box.terminals.X5
                    2: -> from: hydraulics_elec.box.field.switches.TOP3UP.terminals[1], to: hydraulics_elec.box.terminals.X6
                    3: -> from: hydraulics_elec.box.field.switches.TOP3UP.terminals[3], to: hydraulics_elec.box.terminals.US3)
        TOP4UP: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable3WPressureSwitches
                comment : "Cable of the Top 4 underpressure switch (PG:TOP4UP)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.TOP4UP.terminals[2], to: hydraulics_elec.box.terminals.X7
                    2: -> from: hydraulics_elec.box.field.switches.TOP4UP.terminals[1], to: hydraulics_elec.box.terminals.X8
                    3: -> from: hydraulics_elec.box.field.switches.TOP4UP.terminals[3], to: hydraulics_elec.box.terminals.US4)
        BOT5UP: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable3WPressureSwitches
                comment : "Cable of the Bottom 5 underpressure switch (PG:BOT1UP)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.BOT5UP.terminals[2], to: hydraulics_elec.box.terminals.X9
                    2: -> from: hydraulics_elec.box.field.switches.BOT5UP.terminals[1], to: hydraulics_elec.box.terminals.X10
                    3: -> from: hydraulics_elec.box.field.switches.BOT5UP.terminals[3], to: hydraulics_elec.box.terminals.US5)
        BOT6UP: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable3WPressureSwitches
                comment : "Cable of the Bottom 6 underpressure switch (PG:BOT2UP)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.BOT6UP.terminals[2], to: hydraulics_elec.box.terminals.X11
                    2: -> from: hydraulics_elec.box.field.switches.BOT6UP.terminals[1], to: hydraulics_elec.box.terminals.X12
                    3: -> from: hydraulics_elec.box.field.switches.BOT6UP.terminals[3], to: hydraulics_elec.box.terminals.US6)
        BOT7UP: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable3WPressureSwitches
                comment : "Cable of the Bottom 7 underpressure switch (PG:BOT7UP)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.BOT7UP.terminals[2], to: hydraulics_elec.box.terminals.X13
                    2: -> from: hydraulics_elec.box.field.switches.BOT7UP.terminals[1], to: hydraulics_elec.box.terminals.X14
                    3: -> from: hydraulics_elec.box.field.switches.BOT7UP.terminals[3], to: hydraulics_elec.box.terminals.US7)
        BOT8UP: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable3WPressureSwitches
                comment : "Cable of the Bottom 8 underpressure switch (PG:BOT8UP)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.BOT8UP.terminals[2], to: hydraulics_elec.box.terminals.X15
                    2: -> from: hydraulics_elec.box.field.switches.BOT8UP.terminals[1], to: hydraulics_elec.box.terminals.X16
                    3: -> from: hydraulics_elec.box.field.switches.BOT8UP.terminals[3], to: hydraulics_elec.box.terminals.US8)
        TOP1F: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable2WBearing
                comment : "Cable of the Top 1 filter overpressure switch (PG:TOP1F)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.TOP1F.terminals[1], to: hydraulics_elec.box.terminals.X40
                    2: -> from: hydraulics_elec.box.field.switches.TOP1F.terminals[2], to: hydraulics_elec.box.terminals.X39)
        TOP2F: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable2WBearing
                comment : "Cable of the Top 2 filter overpressure switch (PG:TOP2F)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.TOP2F.terminals[1], to: hydraulics_elec.box.terminals.X38
                    2: -> from: hydraulics_elec.box.field.switches.TOP2F.terminals[2], to: hydraulics_elec.box.terminals.X37)
        TOP3F: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable2WBearing
                comment : "Cable of the Top 3 filter overpressure switch (PG:TOP3F)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.TOP3F.terminals[1], to: hydraulics_elec.box.terminals.X36
                    2: -> from: hydraulics_elec.box.field.switches.TOP3F.terminals[2], to: hydraulics_elec.box.terminals.X35)
        TOP4F: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable2WBearing
                comment : "Cable of the Top 4 filter overpressure switch (PG:TOP4F)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.TOP4F.terminals[1], to: hydraulics_elec.box.terminals.X34
                    2: -> from: hydraulics_elec.box.field.switches.TOP4F.terminals[2], to: hydraulics_elec.box.terminals.X33)
        BOT5F: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable2WBearing
                comment : "Cable of the Bottom 5 filter overpressure switch (PG:BOT5F)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.BOT5F.terminals[1], to: hydraulics_elec.box.terminals.X32
                    2: -> from: hydraulics_elec.box.field.switches.BOT5F.terminals[2], to: hydraulics_elec.box.terminals.X31)
        BOT6F: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable2WBearing
                comment : "Cable of the Bottom 6 filter overpressure switch (PG:BOT6F)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.BOT6F.terminals[1], to: hydraulics_elec.box.terminals.X30
                    2: -> from: hydraulics_elec.box.field.switches.BOT6F.terminals[2], to: hydraulics_elec.box.terminals.X29)
        BOT7F: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable2WBearing
                comment : "Cable of the Bottom 7 filter overpressure switch (PG:BOT7F)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.BOT7F.terminals[1], to: hydraulics_elec.box.terminals.X28
                    2: -> from: hydraulics_elec.box.field.switches.BOT7F.terminals[2], to: hydraulics_elec.box.terminals.X27)
        BOT8F: ->
            CABLE_INSTANCE(
                type    : hydraulics_elec.Cable2WBearing
                comment : "Cable of the Bottom 8 filter overpressure switch (PG:BOT8F)"
                wires:
                    1: -> from: hydraulics_elec.box.field.switches.BOT8F.terminals[1], to: hydraulics_elec.box.terminals.X26
                    2: -> from: hydraulics_elec.box.field.switches.BOT8F.terminals[2], to: hydraulics_elec.box.terminals.X25)
    ) "cables"


# Connectors ===========================================================================================================

hydraulics_elec.box.ADD CONTAINER(
    items:
        ECAT: ->
            CONNECTOR_INSTANCE(
                type: harting.RJ45F
                symbol: "PG:ECAT-A"
                comment: "RJ-45 connector, to connect the coupler to the EtherCAT network")
        PWR: ->
            CONNECTOR_INSTANCE(
                type: binder.circular2WayMalePanelSocket
                symbol: "PG:HBPWR-A"
                comment: "2-pole connector + shell with 24VDC, GND and PE, to power the hydraulics box on the Pumps Group"
                terminals:
                    1     : -> isConnectedTo: hydraulics_elec.box.terminals.DC
                    2     : -> isConnectedTo: hydraulics_elec.box.terminals.GND
                    shell : -> isConnectedTo: hydraulics_elec.box.terminals.PE)
    ) "connectors"


########################################################################################################################
# PG configuration
########################################################################################################################

hydraulics_elec.ADD elec.Configuration "pumpsGroup" : [

    LABEL "PG: Pumps Group"
    COMMENT "The Pumps Group configuration."

    cont.contains hydraulics_elec.box.connectors
    cont.contains hydraulics_elec.box.terminals
    cont.contains hydraulics_elec.box.wires
    cont.contains hydraulics_elec.box.io
    cont.contains hydraulics_elec.box.field

    [ cont.contains item for item in PATHS(hydraulics_elec.box.terminals  , cont.contains) ]
    [ cont.contains item for item in PATHS(hydraulics_elec.box.wires      , cont.contains) ]
    [ cont.contains item for item in PATHS(hydraulics_elec.box.connectors , cont.contains) ]
    [ cont.contains item for item in PATHS(hydraulics_elec.box.io         , cont.contains) ]
]

for item in PATHS(hydraulics_elec.box.field.switches, cont.contains)
    hydraulics_elec.box.field.ADD cont.contains item
for item in PATHS(hydraulics_elec.box.field.cables, cont.contains)
    hydraulics_elec.box.field.ADD cont.contains item


########################################################################################################################
# Write the model to file
########################################################################################################################

hydraulics_elec.WRITE "models/mtcs/hydraulics/electricity.jsonld"