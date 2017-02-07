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

MODEL "http://www.mercator.iac.es/onto/models/mtcs/dome/electricity" : "dome_elec"

dome_elec.IMPORT external_all



########################################################################################################################
# DO configuration
########################################################################################################################

dome_elec.ADD elec.Configuration "DO" : [

    LABEL "DO: Dome"
    COMMENT "The Dome configuration (DO)."
]

# Power input ==========================================================================================================

dome_elec.DO.ADD CONTAINS CONNECTOR_INSTANCE(
    type: phoenix.SC25_1L_SocketAssembly
    symbol: "DO:230VAC-A"
    ) "socket230VAC"

dome_elec.DO.ADD CONTAINS CIRCUIT_BREAKER_INSTANCE(
    type: schneider.CircuitBreaker2Ph6A
    symbol: "DO:CB"
    terminals:
        1: -> comment: "L in", isConnectedTo: dome_elec.DO.socket230VAC.terminals.L
        2: -> comment: "L out"
        3: -> comment: "N in", isConnectedTo: dome_elec.DO.socket230VAC.terminals.N
        4: -> comment: "N out"
    ) "circuitBreaker"


# Power distribution ===================================================================================================

dome_elec.DO.ADD CONTAINS CONTAINER(
    items:
        [
            TERMINAL(symbol: "PE"   , comment: "Protective Earth", isConnectedTo: dome_elec.DO.socket230VAC.terminals.PE)   "PE"
            TERMINAL(symbol: "+24V" , comment: "+24VDC") "DC"
            TERMINAL(symbol: "GND"  , comment: "GND")  "GND"
        ]
    ) "terminals"

# DC supply ============================================================================================================

dome_elec.DO.ADD CONTAINS POWER_SUPPLY_INSTANCE(
    type: phoenix.trio_ps_1AC_24VDC_10
    symbol: "DO:PS"
    comment: "24V power supply to power the I/O modules and everything connected to the I/O (e.g. 24V power of the pumps drives)"
    terminals:
        PE      : -> symbol: "PE", comment: "From PE terminals"  , isConnectedTo: dome_elec.DO.terminals.PE
        L       : -> symbol: "L", comment: "From circuit breaker", isConnectedTo: dome_elec.DO.circuitBreaker.terminals[2]
        N       : -> symbol: "N", comment: "From circuit breaker", isConnectedTo: dome_elec.DO.circuitBreaker.terminals[4]
        plus    : -> symbol: "+", comment: "To +24V terminals"   , isConnectedTo: dome_elec.DO.terminals.DC
        minus   : -> symbol: "-", comment: "To GND terminals"    , isConnectedTo: dome_elec.DO.terminals.GND
    ) "power"


# I/O modules ==========================================================================================================

dome_elec.DO.ADD CONTAINS CONTAINER(
    items:
        [
            IO_MODULE_INSTANCE(
                type: beckhoff.EK1101
                comment: "Coupler of the DO panel"
                symbol: "DO:COU"
                terminals:
                        X1  : -> comment: "From EtherCAT switch"
                        1   : -> comment: "Coupler power 24V DC"    , isConnectedTo: dome_elec.DO.terminals.DC
                        2   : -> comment: "Bus power 24V DC"        , isConnectedTo: dome_elec.DO.terminals.DC
                        3   : -> comment: "Coupler GND"             , isConnectedTo: dome_elec.DO.terminals.GND
                        4   : -> comment: "Earth"                   , isConnectedTo: dome_elec.DO.terminals.PE
                        5   : -> comment: "Bus GND"                 , isConnectedTo: dome_elec.DO.terminals.GND
                ) "COU"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL2008
                symbol: "DO:DO1"
                comment: "Digital outputs for ..."
                ) "DO1"
        ]
    ) "io"


# Connectors ===========================================================================================================

dome_elec.DO.ADD CONTAINS CONTAINER(
    items:
        ECAT: ->
            CONNECTOR_INSTANCE(type: harting.RJ45F , symbol: "DO:ECAT-A", comment: "Socket on the panel: RJ-45 connector, to connect the coupler to the EtherCAT network")

    ) "connectors"



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
# Write the model to file
########################################################################################################################

dome_elec.WRITE "models/mtcs/dome/electricity.jsonld"