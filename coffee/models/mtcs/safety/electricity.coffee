########################################################################################################################
#                                                                                                                      #
# Model of the telescope safety.                                                                                       #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "models/import_all.coffee"

# models
REQUIRE "models/external/all.coffee"
REQUIRE "models/mtcs/safety/system.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/safety/electricity" : "safety_elec"

safety_elec.IMPORT external_all
safety_elec.IMPORT safety_sys


# see hydraulics for the Safety and Hydraulics panel!


########################################################################################################################
# DA cabinet
########################################################################################################################


# Mechanical parts =====================================================================================================

safety_elec.ADD mech.PART(comment: "The Dome Access control cabinet") "cabinet"


# Power input ==========================================================================================================

safety_elec.cabinet.ADD CIRCUIT_BREAKER_INSTANCE(
    type: schneider.CircuitBreaker2Ph10A
    symbol: "DA:CBIN"
    comment: "Circuit breaker for 230VAC input power"
    terminals:
        1 : -> comment: "L in"
        2 : -> comment: "L out"
        3 : -> comment: "N in"
        4 : -> comment: "N out"
    ) "CBIN"

safety_elec.cabinet.ADD POWER_SUPPLY_INSTANCE(
    type: phoenix.trio_ps_1AC_24VDC_10
    comment: "24V power supply to power the I/O modules"
    symbol: "DA:PS"
    terminals:
        L       : -> symbol: "L", comment: "From L terminals"
        N       : -> symbol: "N", comment: "From N terminals"
        PE      : -> symbol: "PE", comment: "From PE terminals"
        plus    : -> symbol: "+", comment: "To +24V terminals"
        minus   : -> symbol: "-", comment: "To GND terminals"
    ) "PS"


# Power distribution ===================================================================================================

safety_elec.cabinet.ADD CONTAINER(
    items:
        PE  : -> TERMINAL(symbol: "PE"   , comment: "Protective Earth"                                  , isConnectedTo: safety_elec.cabinet.PS.terminals.PE)
        L   : -> TERMINAL(symbol: "L"    , comment: "230VAC L after the input circuit breaker DA:CBIN"  , isConnectedTo: [ safety_elec.cabinet.CBIN.terminals[2], safety_elec.cabinet.PS.terminals.L ])
        N   : -> TERMINAL(symbol: "N"    , comment: "230VAC N after the input circuit breaker DA:CBIN"  , isConnectedTo: [ safety_elec.cabinet.CBIN.terminals[4], safety_elec.cabinet.PS.terminals.N ])
        DC  : -> TERMINAL(symbol: "+24V" , comment: "+24VDC"                                            , isConnectedTo: safety_elec.cabinet.PS.terminals.plus)
        GND : -> TERMINAL(symbol: "GND"  , comment: "GND"                                               , isConnectedTo: [ safety_elec.cabinet.PS.terminals.minus, self.PE] )
    ) "powerTerminals"


# Lamp circuit breakers ================================================================================================

addLampCircuitBreaker = (symbol, name) ->
    safety_elec.cabinet.ADD CIRCUIT_BREAKER_INSTANCE(
        type: schneider.CircuitBreaker2Ph6A
        symbol: "DA:#{symbol}"
        comment: "Circuit breaker for #{name}"
        terminals:
            1: -> comment: "From relay I/O module for #{name}"
            2: -> comment: "To #{name} L"
            3: -> comment: "From N terminals (which are behind the input circuit breaker DA:CBIN!)", isConnectedTo: safety_elec.cabinet.powerTerminals.N
            4: -> comment: "To #{name} N"
        ) "#{symbol}"

addLampCircuitBreaker("CBL1", "Lamp 1")
addLampCircuitBreaker("CBL2", "Lamp 2")
addLampCircuitBreaker("CBL3", "Lamp 3")
addLampCircuitBreaker("CBL4", "Lamp 4")


# Field terminals ======================================================================================================

safety_elec.cabinet.ADD CONTAINER(
    items:
        X1 : -> TERMINAL(symbol: "X1"  , comment: "Door 1 switch NO contact (NO, circuit closed if door is closed)")
        X2 : -> TERMINAL(symbol: "X2"  , comment: "Door 1 switch +24V"                                              , isConnectedTo: safety_elec.cabinet.powerTerminals.DC)
        X3 : -> TERMINAL(symbol: "X3"  , comment: "Door 1 switch GND"                                               , isConnectedTo: safety_elec.cabinet.powerTerminals.GND)

        X4 : -> TERMINAL(symbol: "X4"  , comment: "Door 2 switch NO contact (NO, circuit closed if door is closed)")
        X5 : -> TERMINAL(symbol: "X5"  , comment: "Door 2 switch +24V"                                              , isConnectedTo: safety_elec.cabinet.powerTerminals.DC)
        X6 : -> TERMINAL(symbol: "X6"  , comment: "Door 2 switch GND"                                               , isConnectedTo: safety_elec.cabinet.powerTerminals.GND)

        X7 : -> TERMINAL(symbol: "X7"  , comment: "Return from dome area switch NO contact (NO, circuit closed = button pushed = someone wants to pass through the door, coming from the dome area)")
        X8 : -> TERMINAL(symbol: "X8"  , comment: "Return from dome area switch +24V"                               , isConnectedTo: safety_elec.cabinet.powerTerminals.DC)
    ) "fieldTerminals"


# I/O modules ==========================================================================================================

safety_elec.cabinet.ADD CONTAINER(
    items:
        COU: ->
            IO_MODULE_INSTANCE(
                type: beckhoff.EK1101
                symbol: "DA:COU"
                comment: "Coupler of the hydraulics cabinet"
                terminals:
                    X1  : -> comment: "From EtherCAT switch"
                    1   : -> comment: "Coupler power 24V DC"    , isConnectedTo: safety_elec.cabinet.powerTerminals.DC
                    2   : -> comment: "Bus power 24V DC"        , isConnectedTo: safety_elec.cabinet.powerTerminals.DC
                    3   : -> comment: "Coupler GND"             , isConnectedTo: safety_elec.cabinet.powerTerminals.GND
                    4   : -> comment: "Earth"                   , isConnectedTo: safety_elec.cabinet.powerTerminals.PE
                    5   : -> comment: "Bus GND"                 , isConnectedTo: safety_elec.cabinet.powerTerminals.GND)
        DI1: ->
            IO_MODULE_INSTANCE(
                type: beckhoff.EL1008
                symbol: "DA:DI1"
                comment: "Digital inputs for keypad buttons 1-8")
        DI2: ->
            IO_MODULE_INSTANCE(
                type: beckhoff.EL1008
                symbol: "DA:DI2"
                comment: "Digital inputs for keypad buttons 9 and * for the unlock-button, for the 2 door switches, and for the returm button"
                terminals:
                    2   : -> isConnectedTo: safety_elec.cabinet.fieldTerminals.X1
                    3   : -> isConnectedTo: safety_elec.cabinet.fieldTerminals.X7
                    6   : -> isConnectedTo: safety_elec.cabinet.fieldTerminals.X4)
        DO1: ->
            IO_MODULE_INSTANCE(
                type: beckhoff.EL2008
                symbol: "DA:DO1"
                comment: "Digital outputs for the blocked-LED, moving/awake/sleeping-LEDs, buzzer, and to trigger the safety"
                terminals: {})
        SI1: ->
            IO_MODULE_INSTANCE(
                type: beckhoff.EL1904
                symbol: "DA:SI1"
                comment: "Safe inputs for receiving the trigger from the non-safe doors, and for the emergency stop "
                terminals:
                    3   : -> comment: "Not connected (because internally conntected to +24V)"
                    4   : -> comment: "Connection between standard output and safety input")
        RE1: ->
            IO_MODULE_INSTANCE(
                type: beckhoff.EL2622
                symbol: "DA:RE1"
                comment: "Relay outputs for lamps 1 and 2"
                terminals:
                    1   : -> isConnectedTo: safety_elec.cabinet.powerTerminals.L
                    2   : -> isConnectedTo: safety_elec.cabinet.CBL1.terminals[1]
                    5   : -> isConnectedTo: safety_elec.cabinet.powerTerminals.L
                    6   : -> isConnectedTo: safety_elec.cabinet.CBL2.terminals[1])
        RE2: ->
            IO_MODULE_INSTANCE(
                type: beckhoff.EL2622
                symbol: "DA:RE2"
                comment: "Relay outputs for lamps 3 and 4"
                terminals:
                    1   : -> isConnectedTo: safety_elec.cabinet.powerTerminals.L
                    2   : -> isConnectedTo: safety_elec.cabinet.CBL3.terminals[1]
                    5   : -> isConnectedTo: safety_elec.cabinet.powerTerminals.L
                    6   : -> isConnectedTo: safety_elec.cabinet.CBL4.terminals[1])
    ) "io"

# add a connection between the standard output and safety input
safety_elec.cabinet.io.DO1.terminals[7].ADD elec.isConnectedTo safety_elec.cabinet.io.SI1.terminals[4]


# Switches =============================================================================================================

safety_elec.cabinet.ADD CONTAINER(
    items:
        KEY: ->
            SWITCH_INSTANCE(
                    type    : various.Keypad
                    symbol  : "DA:KEY"
                    comment : "Keypad (1 GND contact + 9 contacts for numbers 1..9 + 1 contact for button *)"
                    terminals:
                        1    : -> symbol: "1", comment: "Keypad (to enter staff password) button 1", isConnectedTo: safety_elec.cabinet.io.DI1.terminals[1]
                        2    : -> symbol: "2", comment: "Keypad (to enter staff password) button 2", isConnectedTo: safety_elec.cabinet.io.DI1.terminals[5]
                        3    : -> symbol: "3", comment: "Keypad (to enter staff password) button 3", isConnectedTo: safety_elec.cabinet.io.DI1.terminals[2]
                        4    : -> symbol: "4", comment: "Keypad (to enter staff password) button 4", isConnectedTo: safety_elec.cabinet.io.DI1.terminals[6]
                        5    : -> symbol: "5", comment: "Keypad (to enter staff password) button 5", isConnectedTo: safety_elec.cabinet.io.DI1.terminals[3]
                        6    : -> symbol: "6", comment: "Keypad (to enter staff password) button 6", isConnectedTo: safety_elec.cabinet.io.DI1.terminals[7]
                        7    : -> symbol: "7", comment: "Keypad (to enter staff password) button 7", isConnectedTo: safety_elec.cabinet.io.DI1.terminals[4]
                        8    : -> symbol: "8", comment: "Keypad (to enter staff password) button 8", isConnectedTo: safety_elec.cabinet.io.DI1.terminals[8]
                        9    : -> symbol: "9", comment: "Keypad (to enter staff password) button 9", isConnectedTo: safety_elec.cabinet.io.DI2.terminals[1]
                        star : -> symbol: "*", comment: "Keypad (to enter staff password) button *", isConnectedTo: safety_elec.cabinet.io.DI2.terminals[5]
                        '24V': -> symbol: "24V", comment: "Keypad (to enter staff password) 24V"   , isConnectedTo: safety_elec.cabinet.powerTerminals.DC)
        UB: ->
            SWITCH_INSTANCE(
                    type    : various.NOSwitch
                    symbol  : "DA:UB"
                    comment : "Unblock button (NO, monostable)"
                    terminals:
                        1: -> symbol: "1", comment: "Unblock button +24V"          , isConnectedTo: safety_elec.cabinet.powerTerminals.DC
                        2: -> symbol: "2"  , comment: "Unblock button digital input" , isConnectedTo: safety_elec.cabinet.io.DI2.terminals[7])
        ES: ->
            SWITCH_INSTANCE(
                    type    : various.EStop_NO_NC
                    symbol  : "DA:ES"
                    comment : "ESTOP (1 NC channel and 1 NO channel)"
                    terminals:
                        NC1: -> symbol: "NC1", comment: "Emergency stop NC contact 1"          , isConnectedTo: safety_elec.cabinet.io.SI1.terminals[1]
                        NC2: -> symbol: "NC2", comment: "Emergency stop NC contact 2"          , isConnectedTo: safety_elec.cabinet.io.SI1.terminals[2]
                        NO1: -> symbol: "NO1", comment: "Emergency stop NO contact 1"          , isConnectedTo: safety_elec.cabinet.io.SI1.terminals[5]
                        NO2: -> symbol: "NO2", comment: "Emergency stop NO contact 2"          , isConnectedTo: safety_elec.cabinet.io.SI1.terminals[6])

    ) "switches"


# Connectors ===========================================================================================================

safety_elec.cabinet.ADD CONTAINER(
    items:
        ECAT: ->
            CONNECTOR_INSTANCE(
                type: harting.RJ45F
                symbol: "DA:ECAT"
                comment: "RJ-45 connector, to connect the coupler to the EtherCAT network")
    ) "connectors"


# LEDs =================================================================================================================

safety_elec.cabinet.ADD CONTAINER(
    items:
        LEDY: ->
            ACTUATOR_INSTANCE(
                type: various.LED
                comment: "Blue LED"
                symbol: "DA:LEDB"
                terminals:
                    a: -> symbol: "a", comment: "Blue LED anode"  , isConnectedTo: safety_elec.cabinet.io.DO1.terminals[1]
                    k: -> symbol: "k", comment: "Blue LED cathode", isConnectedTo: safety_elec.cabinet.powerTerminals.GND)
        LEDR: ->
            ACTUATOR_INSTANCE(
                type: various.LED
                comment: "Red LED"
                symbol: "DA:LEDR"
                terminals:
                    a: -> symbol: "a", comment: "Red LED anode"     , isConnectedTo: safety_elec.cabinet.io.DO1.terminals[5]
                    k: -> symbol: "k", comment: "Red LED cathode"   , isConnectedTo: safety_elec.cabinet.powerTerminals.GND)
        LEDO: ->
            ACTUATOR_INSTANCE(
                type: various.LED
                comment: "Orange LED"
                symbol: "DA:LEDO"
                terminals:
                    a: -> symbol: "a", comment: "Orange LED anode"  , isConnectedTo: safety_elec.cabinet.io.DO1.terminals[2]
                    k: -> symbol: "k", comment: "Orange LED cathode", isConnectedTo: safety_elec.cabinet.powerTerminals.GND)
        LEDG: ->
            ACTUATOR_INSTANCE(
                type: various.LED
                comment: "Green LED"
                symbol: "DA:LEDG"
                terminals:
                    a: -> symbol: "a", comment: "Green LED anode"   , isConnectedTo: safety_elec.cabinet.io.DO1.terminals[6]
                    k: -> symbol: "k", comment: "Green LED cathode" , isConnectedTo: safety_elec.cabinet.powerTerminals.GND)

    ) "leds"


# buzzer ===============================================================================================================

safety_elec.cabinet.ADD ACTUATOR_INSTANCE(
    type: various.Buzzer
    comment: "Buzzer for warning signals"
    symbol: "DA:BUZ"
    terminals:
        2: -> symbol: "+", comment: "Buzzer +24VDC", isConnectedTo: safety_elec.cabinet.io.DO1.terminals[3]
        3: -> symbol: "-", comment: "Buzzer -"    , isConnectedTo: safety_elec.cabinet.powerTerminals.GND
    ) "buzzer"


########################################################################################################################
# DA / Field
########################################################################################################################

safety_elec.cabinet.ADD CONTAINS elec.Configuration "field" : [ COMMENT "The field (= everything outside the cabinet)." ]


# lamps ================================================================================================================

safety_elec.cabinet.field.ADD CONTAINS CONTAINER(
    items:
        LAMP1: ->
            ACTUATOR_INSTANCE(
                type: various.Lamp230VAC
                comment: "Lamp 1"
                symbol: "DA:LAMP1"
                terminals:
                    L : -> symbol: "L"  , comment: "Lamp 1 L"
                    N : -> symbol: "N"  , comment: "Lamp 1 N"
                    PE: -> symbol: "PE" , comment: "Lamp 1 PE")
        LAMP2: ->
            ACTUATOR_INSTANCE(
                type: various.Lamp230VAC
                comment: "Lamp 2"
                symbol: "DA:LAMP2"
                terminals:
                    L : -> symbol: "L"  , comment: "Lamp 2 L"
                    N : -> symbol: "N"  , comment: "Lamp 2 N"
                    PE: -> symbol: "PE" , comment: "Lamp 2 PE")
        LAMP3: ->
            ACTUATOR_INSTANCE(
                type: various.Lamp230VAC
                comment: "Lamp 3"
                symbol: "DA:LAMP3"
                terminals:
                    L : -> symbol: "L"  , comment: "Lamp 3 L"
                    N : -> symbol: "N"  , comment: "Lamp 3 N"
                    PE: -> symbol: "PE" , comment: "Lamp 3 PE" )
        LAMP4: ->
            ACTUATOR_INSTANCE(
                type: various.Lamp230VAC
                comment: "Lamp 4"
                symbol: "DA:LAMP4"
                terminals:
                    L : -> symbol: "L"  , comment: "Lamp 4 L"
                    N : -> symbol: "N"  , comment: "Lamp 4 N"
                    PE: -> symbol: "PE" , comment: "Lamp 4 PE")

    ) "lamps"


# Switches =============================================================================================================

safety_elec.cabinet.field.ADD CONTAINS CONTAINER(
    items:
        D1: ->
            SWITCH_INSTANCE(
                    type    : various.PNP_NOSwitch
                    symbol  : "DA:D1"
                    comment : "Door 1 inductive switch (NO, circuit open = door open)"
                    terminals:
                        1: -> symbol: "1", comment: "Door 1 switch +24V"
                        3: -> symbol: "3", comment: "Door 1 switch GND"
                        4: -> symbol: "4", comment: "Door 1 switch NO contact")
        D2: ->
            SWITCH_INSTANCE(
                    type    : various.PNP_NOSwitch
                    symbol  : "DA:D2"
                    comment : "Door 2 inductive switch (NO, circuit open = door open)"
                    terminals:
                        1: -> symbol: "1", comment: "Door 2 switch +24V"
                        3: -> symbol: "3" , comment: "Door 2 switch GND"
                        4: -> symbol: "4"  , comment: "Door 2 switch NO contact")
        RET: ->
            SWITCH_INSTANCE(
                    type    : various.NOSwitch
                    symbol  : "DA:RET"
                    comment : "Return switch (NO, circuit closed = button pushed = someone wants to pass through the door, coming from the dome area)"
                    terminals:
                        1: -> symbol: "1", comment: "Return switch contact 1"
                        2: -> symbol: "2", comment: "Return switch contact 2" )

    ) "switches"


# Cables ===============================================================================================================

safety_elec.cabinet.field.ADD CONTAINS CONTAINER(
    items:
        PWR: ->
            CABLE_INSTANCE(
                type: various.Cable3x25
                comment:  "Power cable, from UPS, to supply 230VAC power to the cabinet"
                wires:
                    L : -> to: safety_elec.cabinet.CBIN.terminals[1]
                    N : -> to: safety_elec.cabinet.CBIN.terminals[3]
                    PE: -> to: safety_elec.cabinet.powerTerminals.PE)
        D1: ->
            CABLE_INSTANCE(
                type: propower.Cable3CoreScreen
                comment:  "Cable from the Door 1 switch to the cabinet"
                wires:
                    1: -> from: safety_elec.cabinet.field.switches.D1.terminals[1], to: safety_elec.cabinet.fieldTerminals.X2, color: colors.red
                    2: -> from: safety_elec.cabinet.field.switches.D1.terminals[3], to: safety_elec.cabinet.fieldTerminals.X3, color: colors.black
                    3: -> from: safety_elec.cabinet.field.switches.D1.terminals[4], to: safety_elec.cabinet.fieldTerminals.X1, color: colors.white)
        D2: ->
            CABLE_INSTANCE(
                type: propower.Cable3CoreScreen
                comment:  "Cable from the Door 2 switch to the cabinet"
                wires:
                    1: -> from: safety_elec.cabinet.field.switches.D2.terminals[1], to: safety_elec.cabinet.fieldTerminals.X5, color: colors.red
                    2: -> from: safety_elec.cabinet.field.switches.D2.terminals[3], to: safety_elec.cabinet.fieldTerminals.X6, color: colors.black
                    3: -> from: safety_elec.cabinet.field.switches.D2.terminals[4], to: safety_elec.cabinet.fieldTerminals.X4, color: colors.white)
        RET: ->
            CABLE_INSTANCE(
                type: propower.Cable3CoreScreen
                comment:  "Cable from the 'Return from dome area' switch to the cabinet"
                wires:
                    1: -> from: safety_elec.cabinet.field.switches.RET.terminals[1], to: safety_elec.cabinet.fieldTerminals.X7
                    2: -> from: safety_elec.cabinet.field.switches.RET.terminals[2], to: safety_elec.cabinet.fieldTerminals.X8
                    3: -> comment: "Not used")
        LAMP1: ->
            CABLE_INSTANCE(
                type: various.Cable3x15
                comment:  "Cable from Lamp 1 to the cabinet"
                wires:
                    L : -> from: safety_elec.cabinet.field.lamps.LAMP1.terminals.L,  to: safety_elec.cabinet.CBL1.terminals[2]
                    N : -> from: safety_elec.cabinet.field.lamps.LAMP1.terminals.N,  to: safety_elec.cabinet.CBL1.terminals[4]
                    PE: -> from: safety_elec.cabinet.field.lamps.LAMP1.terminals.PE, to: safety_elec.cabinet.powerTerminals.PE)
        LAMP2: ->
            CABLE_INSTANCE(
                type: various.Cable3x15
                comment:  "Cable from Lamp 2 to the cabinet"
                wires:
                    L : -> from: safety_elec.cabinet.field.lamps.LAMP2.terminals.L,  to: safety_elec.cabinet.CBL2.terminals[2]
                    N : -> from: safety_elec.cabinet.field.lamps.LAMP2.terminals.N,  to: safety_elec.cabinet.CBL2.terminals[4]
                    PE: -> from: safety_elec.cabinet.field.lamps.LAMP2.terminals.PE, to: safety_elec.cabinet.powerTerminals.PE)
        LAMP3: ->
            CABLE_INSTANCE(
                type: various.Cable3x15
                comment:  "Cable from Lamp 3 to the cabinet"
                wires:
                    L : -> from: safety_elec.cabinet.field.lamps.LAMP3.terminals.L,  to: safety_elec.cabinet.CBL3.terminals[2]
                    N : -> from: safety_elec.cabinet.field.lamps.LAMP3.terminals.N,  to: safety_elec.cabinet.CBL3.terminals[4]
                    PE: -> from: safety_elec.cabinet.field.lamps.LAMP3.terminals.PE, to: safety_elec.cabinet.powerTerminals.PE)
        LAMP4: ->
            CABLE_INSTANCE(
                type: various.Cable3x15
                comment:  "Cable from Lamp 4 to the cabinet"
                wires:
                    L : -> from: safety_elec.cabinet.field.lamps.LAMP4.terminals.L,  to: safety_elec.cabinet.CBL4.terminals[2]
                    N : -> from: safety_elec.cabinet.field.lamps.LAMP4.terminals.N,  to: safety_elec.cabinet.CBL4.terminals[4]
                    PE: -> from: safety_elec.cabinet.field.lamps.LAMP4.terminals.PE, to: safety_elec.cabinet.powerTerminals.PE)
    ) "cables"


########################################################################################################################
# DA Configuration
########################################################################################################################

safety_elec.ADD elec.Configuration "DAconfig" : [

    LABEL "DA: Dome Access"
    COMMENT "The Dome Access control cabinet configuration."

    cont.contains safety_elec.cabinet.PS
    cont.contains safety_elec.cabinet.connectors
    cont.contains safety_elec.cabinet.powerTerminals
    cont.contains safety_elec.cabinet.fieldTerminals
    cont.contains safety_elec.cabinet.CBIN
    cont.contains safety_elec.cabinet.CBL1
    cont.contains safety_elec.cabinet.CBL2
    cont.contains safety_elec.cabinet.CBL3
    cont.contains safety_elec.cabinet.CBL4
    cont.contains safety_elec.cabinet.io
    cont.contains safety_elec.cabinet.leds
    cont.contains safety_elec.cabinet.buzzer
    cont.contains safety_elec.cabinet.switches
    cont.contains safety_elec.cabinet.field

    [ cont.contains item for item in PATHS(safety_elec.cabinet.connectors       , cont.contains) ]
    [ elec.hasTerminal t for t    in PATHS(safety_elec.cabinet.powerTerminals   , cont.contains) ]
    [ elec.hasTerminal t for t    in PATHS(safety_elec.cabinet.fieldTerminals   , cont.contains) ]
    [ cont.contains item for item in PATHS(safety_elec.cabinet.leds             , cont.contains) ]
    [ cont.contains item for item in PATHS(safety_elec.cabinet.io               , cont.contains) ]
    [ cont.contains item for item in PATHS(safety_elec.cabinet.switches         , cont.contains) ]
]

for item in PATHS(safety_elec.cabinet.field.switches, cont.contains)
    safety_elec.cabinet.field.ADD CONTAINS item
for item in PATHS(safety_elec.cabinet.field.lamps, cont.contains)
    safety_elec.cabinet.field.ADD CONTAINS item
for item in PATHS(safety_elec.cabinet.field.cables, cont.contains)
    safety_elec.cabinet.field.ADD CONTAINS item


########################################################################################################################
# Write the model to file
########################################################################################################################

safety_elec.WRITE "models/mtcs/safety/electricity.jsonld"
