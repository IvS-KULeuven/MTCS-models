########################################################################################################################
#                                                                                                                      #
# Model of the telescope axes electricity.                                                                             #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# models
REQUIRE "models/external/all.coffee"
REQUIRE "models/mtcs/axes/system.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/axes/electricity" : "axes_elec"

axes_elec.IMPORT external_all
axes_elec.IMPORT axes_sys



########################################################################################################################
# TE panel
########################################################################################################################


# Mechanical parts =====================================================================================================

axes_elec.ADD mech.PART(comment: "The Telescope Encoder panel") "TE"


# Power input ==========================================================================================================

axes_elec.TE.ADD CONNECTOR_INSTANCE(
    type: phoenix.SC25_1L_SocketAssembly
    comment: "230V input power"
    symbol: "TE:230VAC-A"
    ) "socket230VAC"


axes_elec.TE.ADD CIRCUIT_BREAKER_INSTANCE(
    type: schneider.CircuitBreaker2Ph6A
    symbol: "TE:CB"
    comment: "Circuit breaker immediately after 230V input"
    terminals:
        1: -> comment: "L in", isConnectedTo: axes_elec.TE.socket230VAC.terminals.L
        2: -> comment: "L out"
        3: -> comment: "N in", isConnectedTo: axes_elec.TE.socket230VAC.terminals.N
        4: -> comment: "N out"
    ) "circuitBreaker"


# Power distribution ===================================================================================================

axes_elec.TE.ADD CONTAINER(
    items:
        [
            TERMINAL(symbol: "PE"   , comment: "Protective Earth", isConnectedTo: axes_elec.TE.socket230VAC.terminals.PE) "PE"
            TERMINAL(symbol: "+24V" , comment: "+24VDC") "DC24"
            TERMINAL(symbol: "GND"  , comment: "GND")  "GND"
        ]
    ) "terminals"


# DC supply ============================================================================================================

axes_elec.TE.ADD POWER_SUPPLY_INSTANCE(
    type: phoenix.trio_ps_1AC_24VDC_10
    symbol: "TE:PS24"
    comment: "24V power supply to power the I/O modules"
    terminals:
        PE      : -> symbol: "PE", comment: "From PE terminals"     , isConnectedTo: axes_elec.TE.terminals.PE
        L       : -> symbol: "L", comment: "From circuit breaker"   , isConnectedTo: axes_elec.TE.circuitBreaker.terminals[2]
        N       : -> symbol: "N", comment: "From circuit breaker"   , isConnectedTo: axes_elec.TE.circuitBreaker.terminals[4]
        plus    : -> symbol: "+", comment: "To +24V terminals"      , isConnectedTo: axes_elec.TE.terminals.DC24
        minus   : -> symbol: "-", comment: "To GND terminals"       , isConnectedTo: axes_elec.TE.terminals.GND
    ) "power24V"



# I/O modules ==========================================================================================================

axes_elec.TE.ADD CONTAINER(
    items:
        [
            IO_MODULE_INSTANCE(
                type: beckhoff.EK1101
                comment: "Coupler of the Telescope Encoders panel"
                symbol: "TE:COU"
                terminals:
                    X1  : -> comment: "From EtherCAT switch"
                    1   : -> comment: "Coupler power 24V DC"    , isConnectedTo: axes_elec.TE.terminals.DC24
                    2   : -> comment: "Bus power 24V DC"        , isConnectedTo: axes_elec.TE.terminals.DC24
                    3   : -> comment: "Coupler GND"             , isConnectedTo: axes_elec.TE.terminals.GND
                    4   : -> comment: "Earth"                   , isConnectedTo: axes_elec.TE.terminals.PE
                    5   : -> comment: "Bus GND"                 , isConnectedTo: axes_elec.TE.terminals.GND
                ) "COU"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL5101
                symbol: "TE:EN1"
                comment: "Azimuth incremental encoder interface 1"
                ) "EN1"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL5101
                symbol: "TE:EN2"
                comment: "Azimuth incremental encoder interface 2"
                ) "EN2"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL5101
                symbol: "TE:EN3"
                comment: "Azimuth incremental encoder interface 3"
                ) "EN3"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL5101
                symbol: "TE:EN4"
                comment: "Azimuth incremental encoder interface 4"
                ) "EN4"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL5101
                symbol: "TE:EN5"
                comment: "Elevation incremental encoder interface 1"
                ) "EN5"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL5101
                symbol: "TE:EN6"
                comment: "Elevation incremental encoder interface 2"
                ) "EN6"

            IO_MODULE_INSTANCE(
                type: beckhoff.EL5002
                symbol: "TE:EN7"
                comment: "2-channel absolute encoder interface, for the azimuth and elevation SSI encoders"
                ) "EN7"
        ]
    ) "io"


# Connectors ===========================================================================================================

buildIncrementalEncoderConnector = (symbol, comment, exe, el5101) ->
    CONNECTOR_INSTANCE(
        type    : itt.Dsub15FS
        symbol  : "TE:#{symbol}-A"
        comment : comment
        terminals:
            1   : -> symbol: "A"    , comment: "Incremental signal A of #{exe}"                                                                             , isConnectedTo: el5101.terminals[1]
            4   : -> symbol: "\A"   , comment: "Incremental signal A-inverted of #{exe}"                                                                    , isConnectedTo: el5101.terminals[5]
            2   : -> symbol: "B"    , comment: "Incremental signal B of #{exe}"                                                                             , isConnectedTo: el5101.terminals[2]
            10  : -> symbol: "\B"   , comment: "Incremental signal B-inverted of #{exe}"                                                                    , isConnectedTo: el5101.terminals[6]
            3   : -> symbol: "C"    , comment: "Zero signal of #{exe}"                                                                                      , isConnectedTo: el5101.terminals[3]
            12  : -> symbol: "\C"   , comment: "Zero signal-inverted of #{exe}"                                                                             , isConnectedTo: el5101.terminals[7]
            11  : -> symbol: "+5V"  , comment: "Supply +5VDC of #{exe} (wired to +5V from I/O module, and soldered/wired to terminal 13 at the connector)"       , isConnectedTo: el5101.terminals._1
            13  : -> symbol: "+5V"  , comment: "Supply +5VDC of #{exe} (soldered/wired to terminal 11)"                                                          , isConnectedTo: self.terminals[13]
            5   : -> symbol: "GND"  , comment: "Supply GND of #{exe} (wired to GND from I/O module, and soldered/wired to terminals 6 and 15 at the connector)"  , isConnectedTo: el5101.terminals._5
            6   : -> symbol: "GND"  , comment: "Supply GND of #{exe} (soldered/wired to terminals 5 and 15 at the connector)"                                    , isConnectedTo: self.terminals[5]
            15  : -> symbol: "GND"  , comment: "Supply GND of #{exe} (soldered/wired to terminals 5 and 6 at the connector)"                                     , isConnectedTo: [self.terminals[5], self.terminals[6]]
            14  : -> symbol: "ERR"  , comment: "Status signal (5V high = OK) of #{exe}"                                                                     , isConnectedTo: el5101.terminals._4
            8   : -> symbol: "S"    , comment: "Shield of #{exe}"                                                                                           , isConnectedTo: el5101.terminals._8)


axes_elec.TE.ADD CONTAINER(
    items:
        ECAT: -> CONNECTOR_INSTANCE(type: harting.RJ45F , symbol: "TE:ECAT-A", comment: "Socket on the panel: RJ-45 connector, to connect the coupler to the EtherCAT network")
        EA1: ->
            buildIncrementalEncoderConnector("A1", "Azimuth EXE 1 socket", "TE:EXEA1", axes_elec.TE.io.EN1)
        EA2: ->
            buildIncrementalEncoderConnector("A2", "Azimuth EXE 2 socket", "TE:EXEA2", axes_elec.TE.io.EN2)
        EA3: ->
            buildIncrementalEncoderConnector("A3", "Azimuth EXE 3 socket", "TE:EXEA3", axes_elec.TE.io.EN3)
        EA4: ->
            buildIncrementalEncoderConnector("A4", "Azimuth EXE 4 socket", "TE:EXEA4", axes_elec.TE.io.EN4)
        EE1: ->
            buildIncrementalEncoderConnector("E1", "Elevation EXE 1 socket", "TE:EXEE1", axes_elec.TE.io.EN5)
        EE2: ->
            buildIncrementalEncoderConnector("E2", "Elevation EXE 2 socket", "TE:EXEE2", axes_elec.TE.io.EN6)
        SA:
            -> CONNECTOR_INSTANCE(
                type    : itt.Dsub9FS
                symbol  : "TE:SA-A"
                comment : "SSI encoder of the Azimuth axis"
                terminals:
                    1   : -> symbol: "GND"  , comment: "Azimuth SSI encoder power GND"                                    , isConnectedTo: axes_elec.TE.terminals.GND
                    2   : -> symbol: "24V"  , comment: "Azimuth SSI encoder power 24VDC"                                  , isConnectedTo: axes_elec.TE.terminals.DC24
                    3   : -> symbol: "CL+"  , comment: "Azimuth SSI encoder Clock +"                                      , isConnectedTo: axes_elec.TE.io.EN7.terminals[2]
                    4   : -> symbol: "CL-"  , comment: "Azimuth SSI encoder Clock -"                                      , isConnectedTo: axes_elec.TE.io.EN7.terminals[6]
                    5   : -> symbol: "D+"   , comment: "Azimuth SSI encoder Data +"                                       , isConnectedTo: axes_elec.TE.io.EN7.terminals[1]
                    6   : -> symbol: "D-"   , comment: "Azimuth SSI encoder Data -"                                       , isConnectedTo: axes_elec.TE.io.EN7.terminals[5]
                    7   : -> symbol: "SET"  , comment: "Azimuth SSI encoder set zero (not used, connected to GND)"        , isConnectedTo: axes_elec.TE.terminals.GND
                    8   : -> symbol: "DIR"  , comment: "Azimuth SSI encoder set direction (not used, connected to GND)"   , isConnectedTo: axes_elec.TE.terminals.GND
                    9   : -> symbol: "STAT" , comment: "Azimuth SSI encoder status (not used, not connected)")
        SE:
            -> CONNECTOR_INSTANCE(
                type    : itt.Dsub9FS
                symbol  : "TE:SE-A"
                comment : "SSI encoder of the Elevation axis"
                terminals:
                    1   : -> symbol: "GND"  , comment: "Elevation SSI encoder power GND"                                    , isConnectedTo: axes_elec.TE.terminals.GND
                    2   : -> symbol: "24V"  , comment: "Elevation SSI encoder power 24VDC"                                  , isConnectedTo: axes_elec.TE.terminals.DC24
                    3   : -> symbol: "CL+"  , comment: "Elevation SSI encoder Clock +"                                      , isConnectedTo: axes_elec.TE.io.EN7.terminals[4]
                    4   : -> symbol: "CL-"  , comment: "Elevation SSI encoder Clock -"                                      , isConnectedTo: axes_elec.TE.io.EN7.terminals[8]
                    5   : -> symbol: "D+"   , comment: "Elevation SSI encoder Data +"                                       , isConnectedTo: axes_elec.TE.io.EN7.terminals[3]
                    6   : -> symbol: "D-"   , comment: "Elevation SSI encoder Data -"                                       , isConnectedTo: axes_elec.TE.io.EN7.terminals[7]
                    7   : -> symbol: "SET"  , comment: "Elevation SSI encoder set zero (not used, connected to GND)"        , isConnectedTo: axes_elec.TE.terminals.GND
                    8   : -> symbol: "DIR"  , comment: "Elevation SSI encoder set direction (not used, connected to GND)"   , isConnectedTo: axes_elec.TE.terminals.GND
                    9   : -> symbol: "STAT" , comment: "Elevation SSI encoder status (not used, not connected)")

    ) "connectors"

########################################################################################################################
# TE / Field
########################################################################################################################

axes_elec.TE.ADD CONTAINS elec.Configuration "field"


# Incremental encoders =================================================================================================

addIncrementalEncoder = (name, symbol, length) ->

    axes_elec.TE.field.ADD CONTAINS elec.Configuration "#{symbol}"


    axes_elec.TE.field[symbol].ADD "Incremental encoder and EXE660B configuration '#{name}'"

    if symbol == 'E1' or symbol == 'E2'
        lidaComment = "#{name} Heidenhain LIDA 360 incremental encoder scanning head, connected to the EXE660B (TE:EXE#{symbol}) via the extension cable (TE:LIDA#{symbol} to TE:EXE#{symbol}-in)"
    else
        lidaComment = "#{name} Heidenhain LIDA 360 incremental encoder scanning head, connected directly to the EXE660B (TE:EXE#{symbol})"

    axes_elec.TE.field[symbol].ADD CONTAINS SENSOR_INSTANCE(
        type    : heidenhain.LIDA360
        symbol  : "TE:LID#{symbol}"
        comment : lidaComment
        ) "lida"


    axes_elec.TE.field[symbol].ADD CONTAINS DEVICE_INSTANCE(
        type    : heidenhain.EXE660B
        symbol  : "TE:EXE#{symbol}"
        comment : "#{name} Heidenhain EXE 660 B interpolation and digitizing electricity"
        ) "exe"

    axes_elec.TE.field[symbol].ADD CONTAINS CABLE_ASSEMBLY_INSTANCE(
        type    : heidenhain.CableAssemblyExeToD15
        label   : "TE:EXE#{symbol} to TE:E#{symbol}"
        comment : "Cable assembly between the EXE660B-out socket and the TE:E#{symbol} socket on the panel. Length=#{length}"
        ) "cableFromExeToPanel"


    if symbol == 'E1' or symbol == 'E2'
        axes_elec.TE.field[symbol].ADD CONTAINS CABLE_ASSEMBLY_INSTANCE(
            type    : heidenhain.CableAssemblyLidaExtension
            label   : "TE:LIDA#{symbol} to TE:EXE#{symbol}-in"
            comment : "Cable assembly to extend the elevation LIDA cables."
            ) "cableLidaExtension"


addIncrementalEncoder("Azimuth 1", "A1", "0.8m")
addIncrementalEncoder("Azimuth 2", "A2", "1m")
addIncrementalEncoder("Azimuth 3", "A3", "1m")
addIncrementalEncoder("Azimuth 4", "A4", "1m")
addIncrementalEncoder("Elevation 1", "E1", "0.8m")
addIncrementalEncoder("Elevation 2", "E2", "0.8m")


# Absolute encoders ====================================================================================================

axes_elec.ADD CABLE_ASSEMBLY_TYPE(
    comment : "Cable assembly to extend a Kuebler SSI cable (i.e. a simple straight cable)"
    id              : "CableAssemblySSIExtension"
    manufacturer    : ivs.organization
    connectors:
        encoderSide    : -> type: itt.Dsub9FP , comment: "Female cable connector on the encoder side"
        readoutSide    : -> type: itt.Dsub9MP , comment: "Male cable connector on the readout side"
    cables:
        cable       : ->
            type: various.Cable4x2x025S
            comment: "Straight cable between both plugs (4x twisted pairs)"
            wires:
                white  : -> from: $.connectors.encoderSide.terminals[1], to: $.connectors.readoutSide.terminals[1]
                brown  : -> from: $.connectors.encoderSide.terminals[2], to: $.connectors.readoutSide.terminals[2]
                green  : -> from: $.connectors.encoderSide.terminals[3], to: $.connectors.readoutSide.terminals[3]
                yellow : -> from: $.connectors.encoderSide.terminals[4], to: $.connectors.readoutSide.terminals[4]
                blue   : -> from: $.connectors.encoderSide.terminals[5], to: $.connectors.readoutSide.terminals[5]
                gray   : -> from: $.connectors.encoderSide.terminals[7], to: $.connectors.readoutSide.terminals[7]
                pink   : -> from: $.connectors.encoderSide.terminals[8], to: $.connectors.readoutSide.terminals[8]
                red    : -> from: $.connectors.encoderSide.terminals[9], to: $.connectors.readoutSide.terminals[9]
                shield : -> from: $.connectors.encoderSide.terminals.chassis, to: $.connectors.readoutSide.terminals.chassis
    ) "CableAssemblySSIExtension"


addAbsoluteEncoder = (name, configSymbol, symbol, length) ->

    axes_elec.TE.field.ADD CONTAINS elec.Configuration "#{configSymbol}"

    axes_elec.TE.field[configSymbol].ADD "Absolute SSI encoder configuration for #{name}"

    axes_elec.TE.field[configSymbol].ADD CONTAINS SENSOR_INSTANCE(
        type    : kuebler.F5863_1222_G321
        symbol  : "TE:SSI#{symbol}"
        comment : "#{name} Kuebler F5863.1222.G321 360 absolute SSI encoder (with cable and Dsub9 connector)"
        ) "encoder"

    axes_elec.TE.field[configSymbol].ADD CONTAINS CABLE_ASSEMBLY_INSTANCE(
        type    : axes_elec.CableAssemblySSIExtension
        label   : "TE:SSI#{symbol} to TE:S#{symbol}"
        comment : "Cable assembly to connect the SSI encoder with the TE:S#{symbol} socket on the panel. Length=#{length}"
        ) "cableFromExeToPanel"

addAbsoluteEncoder("Azimuth", "SA", "A", "2m")
addAbsoluteEncoder("Elevation", "SE", "E", "2m")


########################################################################################################################
# TE Configuration
########################################################################################################################

axes_elec.ADD elec.Configuration "telescopeEncoders" : [

    LABEL "TE: Telescope Encoders"
    COMMENT "The Telescope Encoders configuration."

    cont.contains axes_elec.TE

    cont.contains axes_elec.TE.socket230VAC
    cont.contains axes_elec.TE.circuitBreaker
    cont.contains axes_elec.TE.terminals
    cont.contains axes_elec.TE.power24V
    cont.contains axes_elec.TE.io
    cont.contains axes_elec.TE.connectors

    [ cont.contains item for item in PATHS(axes_elec.TE.terminals   , cont.contains) ]
    [ cont.contains item for item in PATHS(axes_elec.TE.io          , cont.contains) ]
    [ cont.contains item for item in PATHS(axes_elec.TE.connectors  , cont.contains) ]

    cont.contains axes_elec.TE.field
]


########################################################################################################################
# Write the model to file
########################################################################################################################

axes_elec.WRITE "models/mtcs/axes/electricity.jsonld"