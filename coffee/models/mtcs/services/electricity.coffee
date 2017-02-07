########################################################################################################################
#                                                                                                                      #
# Model of the services electricity.                                                                                   #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "models/import_all.coffee"

# models
REQUIRE "models/external/all.coffee"
REQUIRE "models/mtcs/services/system.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/services/electricity" : "services_elec"

services_elec.IMPORT external_all
services_elec.IMPORT services_sys


########################################################################################################################
# TI panel
########################################################################################################################

# Power input ==========================================================================================================

services_elec.ADD CIRCUIT_BREAKER_INSTANCE(
    type: schneider.CircuitBreaker2Ph6A
    symbol: "TI:CB"
    comment: "Circuit breaker immediately after 230V input"
    terminals:
        1: -> comment: "L in"
        2: -> comment: "L out"
        3: -> comment: "N in"
        4: -> comment: "N out"
    ) "circuitBreaker"


# Power distribution ===================================================================================================

services_elec.ADD CONTAINER(
    items:
        [
            TERMINAL(symbol: "PE"   , comment: "Protective Earth") "PE"
            TERMINAL(symbol: "+24V" , comment: "+24VDC") "DC"
            TERMINAL(symbol: "GND"  , comment: "GND")  "GND"
        ]
    ) "terminals"


# DC supply ============================================================================================================

services_elec.ADD POWER_SUPPLY_INSTANCE(
    type: phoenix.trio_ps_1AC_24VDC_10
    symbol: "TI:PS24"
    comment: "24V power supply to power the I/O modules"
    terminals:
        PE      : -> symbol: "PE", comment: "From PE terminals"     , isConnectedTo: services_elec.terminals.PE
        L       : -> symbol: "L", comment: "From circuit breaker"   , isConnectedTo: services_elec.circuitBreaker.terminals[2]
        N       : -> symbol: "N", comment: "From circuit breaker"   , isConnectedTo: services_elec.circuitBreaker.terminals[4]
        plus    : -> symbol: "+", comment: "To +24V terminals"      , isConnectedTo: services_elec.terminals.DC
        minus   : -> symbol: "-", comment: "To GND terminals"       , isConnectedTo: services_elec.terminals.GND
    ) "power24V"


# Connectors ===========================================================================================================

# TODO: Model time server!!!

services_elec.ADD CONTAINER(
    items:
        [
            CONNECTOR_INSTANCE(type: harting.RJ45F , symbol: "TIMESVR:PTP") "PTP"
            CONNECTOR_INSTANCE(
                type    : itt.Dsub9FS
                symbol  : "TI:COM0"
                comment : "COM 0 serial port of the time server"
                terminals:
                    2 : -> symbol: "TIMESVR:COM0:TxD"   , comment: "COM0: Transmit"
                    3 : -> symbol: "TIMESVR:COM0:RxD"   , comment: "COM0: Receive"
                    5 : -> symbol: "TIMESVR:COM0:GND"   , comment: "COM0: GND"
            ) "COM0"
        ]
    ) "connectors"


# I/O modules ==========================================================================================================

services_elec.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EK1101
    terminals:
            X1  : -> comment: "From EtherCAT switch"
            1   : -> comment: "Coupler power 24V DC"    , isConnectedTo: services_elec.terminals.DC
            2   : -> comment: "Bus power 24V DC"        , isConnectedTo: services_elec.terminals.DC
            3   : -> comment: "Coupler GND"             , isConnectedTo: services_elec.terminals.GND
            4   : -> comment: "Earth"                   , isConnectedTo: services_elec.terminals.PE
            5   : -> comment: "Bus GND"                 , isConnectedTo: services_elec.terminals.GND
    ) "slot0"


services_elec.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EL6001
    terminals:
            1: -> isConnectedTo: services_elec.connectors.COM0.terminals[3]
            3: -> isConnectedTo: services_elec.connectors.COM0.terminals[5]
            5: -> isConnectedTo: services_elec.connectors.COM0.terminals[2]
    ) "slot1"


services_elec.ADD IO_MODULE_INSTANCE(
    type: beckhoff.EL6688
    terminals:
            1: -> isConnectedTo: services_elec.connectors.PTP.terminals[1]
            2: -> isConnectedTo: services_elec.connectors.PTP.terminals[2]
            3: -> isConnectedTo: services_elec.connectors.PTP.terminals[3]
            4: -> isConnectedTo: services_elec.connectors.PTP.terminals[4]
            5: -> isConnectedTo: services_elec.connectors.PTP.terminals[5]
            6: -> isConnectedTo: services_elec.connectors.PTP.terminals[6]
            7: -> isConnectedTo: services_elec.connectors.PTP.terminals[7]
            8: -> isConnectedTo: services_elec.connectors.PTP.terminals[8]
    ) "slot2"

services_elec.ADD CONTAINER(
        items:
            services_elec["slot#{i}"] for i in [0..2]
        ) "io"


########################################################################################################################
# TI Configuration
########################################################################################################################

services_elec.ADD elec.Configuration "Timing" : [

    LABEL "TI: Timing"
    COMMENT "The timing system"

    cont.contains services_elec.circuitBreaker
    cont.contains services_elec.power24V
    cont.contains services_elec.connectors
    cont.contains services_elec.terminals
    cont.contains services_elec.io

    [ elec.hasTerminal t for t in PATHS(services_elec.terminals, cont.contains) ]
    [ elec.hasConnector c for c in PATHS(services_elec.connectors, cont.contains) ]
    [ cont.contains item for item in PATHS(services_elec.io, cont.contains) ]
]

services_elec.ADD elec.Configuration "Services" : [

    LABEL "SER: Services"
    COMMENT "The common services"

    CONTAINS services_elec.Timing
]
########################################################################################################################
# Write the model to file
########################################################################################################################

services_elec.WRITE "models/mtcs/services/electricity.jsonld"
