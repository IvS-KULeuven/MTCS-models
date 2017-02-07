########################################################################################################################
#                                                                                                                      #
# Model of the telemetry electricity.                                                                                  #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "models/import_all.coffee"

# models
REQUIRE "models/external/all.coffee"
REQUIRE "models/mtcs/telemetry/system.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/telemetry/electricity" : "telemetry_elec"

telemetry_elec.IMPORT external_all
telemetry_elec.IMPORT telemetry_sys


########################################################################################################################
# TT panel
########################################################################################################################


# Mechanical parts =====================================================================================================

telemetry_elec.ADD mech.PART(comment: "The Telescope Telemetry (TT) panel") "TT"


# Power input ==========================================================================================================

telemetry_elec.TT.ADD CONNECTOR_INSTANCE(
    type: phoenix.SC25_1L_SocketAssembly
    comment: "230V input power"
    symbol: "TT:230VAC-A"
    ) "socket230VAC"


telemetry_elec.TT.ADD CIRCUIT_BREAKER_INSTANCE(
    type: schneider.CircuitBreaker2Ph6A
    symbol: "TT:CB"
    comment: "Circuit breaker immediately after 230V input"
    terminals:
        1: -> comment: "L in", isConnectedTo: telemetry_elec.TT.socket230VAC.terminals.L
        2: -> comment: "L out"
        3: -> comment: "N in", isConnectedTo: telemetry_elec.TT.socket230VAC.terminals.N
        4: -> comment: "N out"
    ) "circuitBreaker"


# Power distribution ===================================================================================================

telemetry_elec.TT.ADD CONTAINER(
    items:
        [
            TERMINAL(symbol: "PE"   , comment: "Protective Earth", isConnectedTo: telemetry_elec.TT.socket230VAC.terminals.PE) "PE"
            TERMINAL(symbol: "+24V" , comment: "+24VDC") "DC"
            TERMINAL(symbol: "GND"  , comment: "GND")  "GND"
        ]
    ) "terminals"


# DC supply ============================================================================================================

telemetry_elec.TT.ADD POWER_SUPPLY_INSTANCE(
    type: phoenix.trio_ps_1AC_24VDC_10
    symbol: "TT:PS24"
    comment: "24V power supply to power the I/O modules"
    terminals:
        PE      : -> symbol: "PE", comment: "From PE terminals"     , isConnectedTo: telemetry_elec.TT.terminals.PE
        L       : -> symbol: "L", comment: "From circuit breaker"   , isConnectedTo: telemetry_elec.TT.circuitBreaker.terminals[2]
        N       : -> symbol: "N", comment: "From circuit breaker"   , isConnectedTo: telemetry_elec.TT.circuitBreaker.terminals[4]
        plus    : -> symbol: "+", comment: "To +24V terminals"      , isConnectedTo: telemetry_elec.TT.terminals.DC
        minus   : -> symbol: "-", comment: "To GND terminals"       , isConnectedTo: telemetry_elec.TT.terminals.GND
    ) "power"


# Connectors ===========================================================================================================

telemetry_elec.TT.ADD CONTAINER(
    items:
        [
            CONNECTOR_INSTANCE(type: harting.RJ45F , symbol: "TC:ECAT") "ECAT"

            CONNECTOR_INSTANCE(
                type    : binder.circular2WayFemalePanelSocket
                symbol  : "TT:24V-A"
                terminals:
                    1 : -> symbol: "TT:24V-A:24V" , comment: "24V power A: 24V"
                    2 : -> symbol: "TT:24V-A:0V"  , comment: "24V power A: 0V"
            ) "24V-A"

            CONNECTOR_INSTANCE(
                type    : binder.circular2WayFemalePanelSocket
                symbol  : "TT:24V-B-1"
                terminals:
                    1 : -> symbol: "TT:24V-B:24V" , comment: "24V power B: 24V"
                    2 : -> symbol: "TT:24V-B:0V"  , comment: "24V power B: 0V"
            ) "24V-B"

            CONNECTOR_INSTANCE(
                type    : binder.circular2WayFemalePanelSocket
                symbol  : "TT:24V-C"
                terminals:
                    1 : -> symbol: "TT:24V-C:24V" , comment: "24V power C: 24V"
                    2 : -> symbol: "TT:24V-C:0V"  , comment: "24V power C: 0V"
            ) "24V-C"

            CONNECTOR_INSTANCE(
                type    : binder.circular2WayFemalePanelSocket
                symbol  : "TT:24V-D"
                terminals:
                    1 : -> symbol: "TT:24V-D:24V" , comment: "24V power D: 24V"
                    2 : -> symbol: "TT:24V-D:0V"  , comment: "24V power D: 0V"
            ) "24V-D"

            CONNECTOR_INSTANCE(
                type    : prehkeytec.circular5WayPanelJack
                symbol  : "TT:M1"
                comment : "M1 temperature"
                terminals:
                    1 : -> symbol: "TT:M1:-R1"      , comment: "M1 temperature: -R1"
                    2 : -> symbol: "TT:M1:-RL1"     , comment: "M1 temperature: -RL1"
                    3 : -> symbol: "TT:M1:Shield"   , comment: "M1 temperature: Shield"
                    4 : -> symbol: "TT:M1:+RL1"     , comment: "M1 temperature: +RL1"
                    5 : -> symbol: "TT:M1:+R1"      , comment: "M1 temperature: +R1"
            ) "M1"

            CONNECTOR_INSTANCE(
                type    : prehkeytec.circular5WayPanelJack
                symbol  : "TT:MC"
                comment : "Mirror Cell temperature"
                terminals:
                    1 : -> symbol: "TT:MC:-R2"      , comment: "Mirror Cell temperature: -R2"
                    2 : -> symbol: "TT:MC:-RL2"     , comment: "Mirror Cell temperature: -RL2"
                    3 : -> symbol: "TT:MC:Shield"   , comment: "Mirror Cell temperature: Shield"
                    4 : -> symbol: "TT:MC:+RL2"     , comment: "Mirror Cell temperature: +RL2"
                    5 : -> symbol: "TT:MC:+R2"      , comment: "Mirror Cell temperature: +R2"
            ) "MC"

            CONNECTOR_INSTANCE(
                type    : prehkeytec.circular5WayPanelJack
                symbol  : "TT:M2"
                comment : "M2 temperature"
                terminals:
                    1 : -> symbol: "TT:M2:-R1"      , comment: "M2 temperature: -R1"
                    2 : -> symbol: "TT:M2:-RL1"     , comment: "M2 temperature: -RL1"
                    3 : -> symbol: "TT:M2:Shield"   , comment: "M2 temperature: Shield"
                    4 : -> symbol: "TT:M2:+RL1"     , comment: "M2 temperature: +RL1"
                    5 : -> symbol: "TT:M2:+R1"      , comment: "M2 temperature: +R1"
            ) "M2"

            CONNECTOR_INSTANCE(
                type    : prehkeytec.circular5WayPanelJack
                symbol  : "TT:M2E"
                comment : "M2 Electronics temperature"
                terminals:
                    1 : -> symbol: "TT:M2E:-R2"      , comment: "M2 Electronics temperature: -R2"
                    2 : -> symbol: "TT:M2E:-RL2"     , comment: "M2 Electronics temperature: -RL2"
                    3 : -> symbol: "TT:M2E:Shield"   , comment: "M2 Electronics temperature: Shield"
                    4 : -> symbol: "TT:M2E:+RL2"     , comment: "M2 Electronics temperature: +RL2"
                    5 : -> symbol: "TT:M2E:+R2"      , comment: "M2 Electronics temperature: +R2"
            ) "M2E"

            CONNECTOR_INSTANCE(
                type    : prehkeytec.circular5WayPanelJack
                symbol  : "TT:TT"
                comment : "Top Tube temperature"
                terminals:
                    1 : -> symbol: "TT:TT:-R1"      , comment: "Top Tube temperature: -R1"
                    2 : -> symbol: "TT:TT:-RL1"     , comment: "Top Tube temperature: -RL1"
                    3 : -> symbol: "TT:TT:Shield"   , comment: "Top Tube temperature: Shield"
                    4 : -> symbol: "TT:TT:+RL1"     , comment: "Top Tube temperature: +RL1"
                    5 : -> symbol: "TT:TT:+R1"      , comment: "Top Tube temperature: +R1"
            ) "TT"

            CONNECTOR_INSTANCE(
                type    : prehkeytec.circular5WayPanelJack
                symbol  : "TT:CT"
                comment : "Center tube temperature"
                terminals:
                    1 : -> symbol: "TT:CT:-R2"      , comment: "Center Tube temperature: -R2"
                    2 : -> symbol: "TT:CT:-RL2"     , comment: "Center Tube temperature: -RL2"
                    3 : -> symbol: "TT:CT:Shield"   , comment: "Center Tube temperature: Shield"
                    4 : -> symbol: "TT:CT:+RL2"     , comment: "Center Tube temperature: +RL2"
                    5 : -> symbol: "TT:CT:+R2"      , comment: "Center Tube temperature: +R2"
            ) "CT"

            CONNECTOR_INSTANCE(
                type    : prehkeytec.circular5WayPanelJack
                symbol  : "TT:TF"
                comment : "Fork temperature"
                terminals:
                    1 : -> symbol: "TT:TF:-R1"      , comment: "Fork temperature: -R1"
                    2 : -> symbol: "TT:TF:-RL1"     , comment: "Fork temperature: -RL1"
                    3 : -> symbol: "TT:TF:Shield"   , comment: "Fork temperature: Shield"
                    4 : -> symbol: "TT:TF:+RL1"     , comment: "Fork temperature: +RL1"
                    5 : -> symbol: "TT:TF:+R1"      , comment: "Fork temperature: +R1"
            ) "TF"

            CONNECTOR_INSTANCE(
                type    : prehkeytec.circular5WayPanelJack
                symbol  : "TT:NA"
                comment : "Center tube temperature"
                terminals:
                    1 : -> symbol: "TT:NA:-R2"      , comment: "Nasmyth Air temperature: -R2"
                    2 : -> symbol: "TT:NA:-RL2"     , comment: "Nasmyth Air temperature: -RL2"
                    3 : -> symbol: "TT:NA:Shield"   , comment: "Nasmyth Air temperature: Shield"
                    4 : -> symbol: "TT:NA:+RL2"     , comment: "Nasmyth Air temperature: +RL2"
                    5 : -> symbol: "TT:NA:+R2"      , comment: "Nasmyth Air temperature: +R2"
            ) "NA"

            CONNECTOR_INSTANCE(
                type    : prehkeytec.circular5WayPanelJack
                symbol  : "TT:REM"
                comment : "REM temperature"
                terminals:
                    1 : -> symbol: "TT:REM:-R1"      , comment: "REM temperature: -R1"
                    2 : -> symbol: "TT:REM:-RL1"     , comment: "REM temperature: -RL1"
                    3 : -> symbol: "TT:REM:Shield"   , comment: "REM temperature: Shield"
                    4 : -> symbol: "TT:REM:+RL1"     , comment: "REM temperature: +RL1"
                    5 : -> symbol: "TT:REM:+R1"      , comment: "REM temperature: +R1"
            ) "REM"

            CONNECTOR_INSTANCE(
                type    : prehkeytec.circular5WayPanelJack
                symbol  : "TT:HTA"
                comment : "HERMES Telescope Adapter temperature"
                terminals:
                    1 : -> symbol: "TT:HTA:-R2"      , comment: "HERMES Telescope Adapter temperature: -R2"
                    2 : -> symbol: "TT:HTA:-RL2"     , comment: "HERMES Telescope Adapter temperature: -RL2"
                    3 : -> symbol: "TT:HTA:Shield"   , comment: "HERMES Telescope Adapter temperature: Shield"
                    4 : -> symbol: "TT:HTA:+RL2"     , comment: "HERMES Telescope Adapter temperature: +RL2"
                    5 : -> symbol: "TT:HTA:+R2"      , comment: "HERMES Telescope Adapter temperature: +R2"
            ) "HTA"

            CONNECTOR_INSTANCE(
                type    : prehkeytec.circular5WayPanelJack
                symbol  : "TT:TX"
                comment : "Spare temperature"
                terminals:
                    1 : -> symbol: "TT:TX:-R2"      , comment: "Spare temperature: -R2"
                    2 : -> symbol: "TT:TX:-RL2"     , comment: "Spare temperature: -RL2"
                    3 : -> symbol: "TT:TX:Shield"   , comment: "Spare temperature: Shield"
                    4 : -> symbol: "TT:TX:+RL2"     , comment: "Spare temperature: +RL2"
                    5 : -> symbol: "TT:TX:+R2"      , comment: "Spare temperature: +R2"
            ) "TX"

            CONNECTOR_INSTANCE(
                type    : binder.circular7WayPanelSocket
                symbol  : "TT:TA"
                comment : "Top Air temperature and relative humidity"
                terminals:
                    1 : -> symbol: "TT:TA:-R1"      , comment: "Top Air temperature: -R1"
                    2 : -> symbol: "TT:TA:-RL1"     , comment: "Top Air temperature: -RL1"
                    3 : -> symbol: "TT:TA:Shield"   , comment: "Top Air temperature: Shield"
                    4 : -> symbol: "TT:TA:+RL1"     , comment: "Top Air temperature: +RL1"
                    5 : -> symbol: "TT:TA:+R1"      , comment: "Top Air temperature: +R1"
                    6 : -> symbol: "TT:TA:+I1"      , comment: "Top Air relative humidity: +input"
                    7 : -> symbol: "TT:TA:24V"      , comment: "Top Air relative humidity: +24V"
            ) "TA"

            CONNECTOR_INSTANCE(
                type    : binder.circular7WayPanelSocket
                symbol  : "TT:IT"
                comment : "Inside Tube temperature and relative humidity"
                terminals:
                    1 : -> symbol: "TT:IT:-R2"      , comment: "Inside Tube temperature: -R2"
                    2 : -> symbol: "TT:IT:-RL2"     , comment: "Inside Tube temperature: -RL2"
                    3 : -> symbol: "TT:IT:Shield"   , comment: "Inside Tube temperature: Shield"
                    4 : -> symbol: "TT:IT:+RL2"     , comment: "Inside Tube temperature: +RL2"
                    5 : -> symbol: "TT:IT:+R2"      , comment: "Inside Tube temperature: +R2"
                    6 : -> symbol: "TT:IT:+I2"      , comment: "Inside Tube relative humidity: +input"
                    7 : -> symbol: "TT:IT:24V"      , comment: "Inside Tube relative humidity: +24V"
            ) "IT"

            CONNECTOR_INSTANCE(
                type    : itt.Dsub9FS
                symbol  : "TT:FFL"
                comment : "Flatfield leds"
                terminals:
                    1 : -> symbol: "TT:FFL:1"      , comment: "Flatfield leds: output 1"
                    2 : -> symbol: "TT:FFL:2"      , comment: "Flatfield leds: output 2"
                    3 : -> symbol: "TT:FFL:3"      , comment: "Flatfield leds: output 3"
                    4 : -> symbol: "TT:FFL:4"      , comment: "Flatfield leds: output 4"
                    5 : -> symbol: "TT:FFL:5"      , comment: "Flatfield leds: output 5"
                    6 : -> symbol: "TT:FFL:6"      , comment: "Flatfield leds: output 6"
                    7 : -> symbol: "TT:FFL:7"      , comment: "Flatfield leds: output 7"
                    8 : -> symbol: "TT:FFL:8"      , comment: "Flatfield leds: output 8"
                    9 : -> symbol: "TT:FFL:9"      , comment: "Flatfield leds: output 9"
            ) "FFL"
        ]
    ) "connectors"


# I/O modules ==========================================================================================================

telemetry_elec.TT.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EK1101
    terminals:
            X1  : -> comment: "From EtherCAT switch"
            1   : -> comment: "Coupler power 24V DC"    , isConnectedTo: telemetry_elec.TT.terminals.DC
            2   : -> comment: "Bus power 24V DC"        , isConnectedTo: telemetry_elec.TT.terminals.DC
            3   : -> comment: "Coupler GND"             , isConnectedTo: telemetry_elec.TT.terminals.GND
            4   : -> comment: "Earth"                   , isConnectedTo: telemetry_elec.TT.terminals.PE
            5   : -> comment: "Bus GND"                 , isConnectedTo: telemetry_elec.TT.terminals.GND
    ) "slot0"


telemetry_elec.TT.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EL9186
    terminals:
            1: -> isConnectedTo: telemetry_elec.TT.connectors['24V-A'].terminals[1]
            2: -> isConnectedTo: telemetry_elec.TT.connectors['24V-B'].terminals[1]
            3: -> isConnectedTo: telemetry_elec.TT.connectors['24V-C'].terminals[1]
            4: -> isConnectedTo: telemetry_elec.TT.connectors['24V-D'].terminals[1]
            5: -> isConnectedTo: telemetry_elec.TT.connectors.TA.terminals[7]
            6: -> isConnectedTo: telemetry_elec.TT.connectors.IT.terminals[7]
    ) "slot1"


telemetry_elec.TT.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EL9187
    terminals:
            1: -> isConnectedTo: telemetry_elec.TT.connectors['24V-A'].terminals[2]
            2: -> isConnectedTo: telemetry_elec.TT.connectors['24V-B'].terminals[2]
            3: -> isConnectedTo: telemetry_elec.TT.connectors['24V-C'].terminals[2]
            4: -> isConnectedTo: telemetry_elec.TT.connectors['24V-D'].terminals[2]
            8: -> isConnectedTo: telemetry_elec.TT.connectors.FFL.terminals[9]
    ) "slot2"


telemetry_elec.TT.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EL9070
    terminals:
            1: -> isConnectedTo: telemetry_elec.TT.connectors.M1.terminals[3]
            2: -> isConnectedTo: telemetry_elec.TT.connectors.MC.terminals[3]
            3: -> isConnectedTo: telemetry_elec.TT.connectors.M2.terminals[3]
            4: -> isConnectedTo: telemetry_elec.TT.connectors.M2E.terminals[3]
            5: -> isConnectedTo: telemetry_elec.TT.connectors.TT.terminals[3]
            6: -> isConnectedTo: telemetry_elec.TT.connectors.CT.terminals[3]
            7: -> isConnectedTo: telemetry_elec.TT.connectors.TF.terminals[3]
            8: -> isConnectedTo: telemetry_elec.TT.connectors.NA.terminals[3]
    ) "slot3"

telemetry_elec.TT.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EL9070
    terminals:
            1: -> isConnectedTo: telemetry_elec.TT.connectors.REM.terminals[3]
            2: -> isConnectedTo: telemetry_elec.TT.connectors.HTA.terminals[3]
            3: -> isConnectedTo: telemetry_elec.TT.connectors.TX.terminals[3]
            4: -> isConnectedTo: telemetry_elec.TT.connectors.TA.terminals[3]
            5: -> isConnectedTo: telemetry_elec.TT.connectors.IT.terminals[3]
    ) "slot4"

addTemperatureModule = (slotName, firstConnectorName, secondConnectorName) ->
    telemetry_elec.TT.ADD IO_MODULE_INSTANCE(
        type: beckhoff.EL3202_0010
        terminals:
                1: -> isConnectedTo: telemetry_elec.TT.connectors[firstConnectorName].terminals[5]
                2: -> isConnectedTo: telemetry_elec.TT.connectors[firstConnectorName].terminals[4]
                3: -> isConnectedTo: telemetry_elec.TT.connectors[firstConnectorName].terminals[1]
                4: -> isConnectedTo: telemetry_elec.TT.connectors[firstConnectorName].terminals[2]
                5: -> isConnectedTo: telemetry_elec.TT.connectors[secondConnectorName].terminals[5]
                6: -> isConnectedTo: telemetry_elec.TT.connectors[secondConnectorName].terminals[4]
                7: -> isConnectedTo: telemetry_elec.TT.connectors[secondConnectorName].terminals[1]
                8: -> isConnectedTo: telemetry_elec.TT.connectors[secondConnectorName].terminals[2]
        ) slotName

addTemperatureModule("slot5", "M1", "MC")
addTemperatureModule("slot6", "M2", "M2E")
addTemperatureModule("slot7", "TT", "CT")
addTemperatureModule("slot8", "TF", "NA")

telemetry_elec.TT.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EL3202_0010
    terminals:
            1: -> isConnectedTo: telemetry_elec.TT.connectors.REM.terminals[5]
            2: -> isConnectedTo: telemetry_elec.TT.connectors.REM.terminals[4]
            3: -> isConnectedTo: telemetry_elec.TT.connectors.REM.terminals[1]
            4: -> isConnectedTo: telemetry_elec.TT.connectors.REM.terminals[2]
    ) "slot9"

addTemperatureModule("slot10", "HTA", "TX")
addTemperatureModule("slot11", "TA", "IT")

telemetry_elec.TT.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EL3024
    terminals:
            1: -> isConnectedTo: telemetry_elec.TT.connectors.TA.terminals[6]
            2: -> isConnectedTo: telemetry_elec.TT.slot2.terminals[5]
            5: -> isConnectedTo: telemetry_elec.TT.connectors.IT.terminals[6]
            6: -> isConnectedTo: telemetry_elec.TT.slot2.terminals[6]
    ) "slot12"


telemetry_elec.TT.ADD CONTAINER(
        items:
            telemetry_elec.TT["slot#{i}"] for i in [0..12]
        ) "io"


########################################################################################################################
# TT Configuration
########################################################################################################################

telemetry_elec.ADD elec.Configuration "TTconfig" : [

    LABEL "TT: Telescope Telemetry"
    COMMENT "The telemetry of the telescope (TT) and environment"

    cont.contains telemetry_elec.TT.socket230VAC
    cont.contains telemetry_elec.TT.circuitBreaker
    cont.contains telemetry_elec.TT.power
    cont.contains telemetry_elec.TT.terminals
    cont.contains telemetry_elec.TT.connectors
    cont.contains telemetry_elec.TT.terminals
    cont.contains telemetry_elec.TT.io

    [ elec.hasConnector c for c in PATHS(telemetry_elec.TT.connectors , cont.contains) ]
    [ elec.hasTerminal  t for t in PATHS(telemetry_elec.TT.terminals  , cont.contains) ]
    [ cont.contains     m for m in PATHS(telemetry_elec.TT.io         , cont.contains) ]
]


########################################################################################################################
# Write the model to file
########################################################################################################################

telemetry_elec.WRITE "models/mtcs/telemetry/electricity.jsonld"
