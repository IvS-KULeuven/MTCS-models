require "ontoscript"

REQUIRE "metamodels/mechanics.coffee"

REQUIRE "metamodels/colors.coffee"
REQUIRE "metamodels/iec61131.coffee"

METAMODEL "http://www.mercator.iac.es/onto/metamodels/electricity" : "elec"

elec.READ "metamodels/electricity.jsonld"



elec.ADD elec.Configuration "CONFIGURATION" : ( args = {} ) -> [
    CHECK_ARGS("CONFIGURATION", args, ["comment", "label"])
    if args.comment?
        COMMENT args.comment
    if args.label
        LABEL args.label
]


# Channel
# ==============

elec.ADD elec.Channel "CHANNEL" : (args={}) -> [
    CHECK_ARGS("CHANNEL", args, ["comment", "symbol", "terminals"])
    if args.comment?
        COMMENT args.comment
    if args.symbol?
        [
            elec.hasSymbol args.symbol
        ]
    if args.terminals?
        for t in args.terminals
            elec.hasTerminal t
]
root.CHANNEL = elec.CHANNEL


#elec.ADD elec.Connector "CONNECTOR" : ( args = {} ) -> [
#    CHECK_ARGS("CONNECTOR", args, ["comment", "symbol", "gender"])
#
#    if args.comment?
#        COMMENT args.comment
#    if args.symbol?
#        elec.hasSymbol args.symbol
#    if args.gender?
#        elec.hasGender args.gender
#]
#root.CONNECTOR = elec.CONNECTOR



elec.ADD elec.Terminal "TERMINAL" : ( args = {} ) -> [
    CHECK_ARGS("TERMINAL", args, ["comment", "symbol", "isConnectedTo"])
    if args.comment?
        COMMENT args.comment
    if args.symbol?
        [
            elec.hasSymbol args.symbol
        ]
    if args.isConnectedTo?
        elec.isConnectedTo args.isConnectedTo
]
root.TERMINAL = elec.TERMINAL

handleTerminals = (terminals) ->
    ret = [ sys.hasPart LIST() "terminals" ]
    if terminals?
        i = 0
        for name, detailsFunction of terminals
            self.terminals.ADD CONTAINS TERMINAL(detailsFunction()) name

            self.terminals.ADD cont.hasContainment CONTAINMENT(number: i) "containment#{i}"
            self.terminals["containment#{i}"].ADD cont.hasItem self.terminals[name]

            ret.push elec.hasTerminal self.terminals[name]
            i = i + 1
    return ret


handleChannels = (channels) ->
    ret = [ sys.hasPart LIST() "channels" ]
    if channels?
        i = 0
        for name, detailsFunction of channels
            self.channels.ADD CONTAINS CHANNEL(detailsFunction()) name

            self.channels.ADD cont.hasContainment CONTAINMENT(number: i) "containment#{i}"
            self.channels["containment#{i}"].ADD cont.hasItem self.channels[name]

            ret.push elec.hasChannel self.channels[name]
            i = i + 1
    return ret

handleSoftInterface = (args) ->
    ret = [ sys.hasInterface SOFT_INTERFACE(args) "soft_interface" ]
    return ret





elec.ADD elec.Wire "WIRE" : ( args = {} ) -> [
    CHECK_ARGS("WIRE", args, ["comment", "symbol", "color", "label", "from", "to"])
    if args.comment?
        COMMENT args.comment
    if args.label?
        LABEL args.label
    if args.symbol?
        [
            elec.hasSymbol args.symbol
        ]
    if args.color?
        if IS_ARRAY(args.color)
            [ colors.hasColor c for c in args.color ]
        else
            [ colors.hasColor args.color ]
    if args.from?
        elec.connectsFrom args.from
    if args.to?
        elec.connectsTo args.to
    if args.from? and args.to?
        args.from.ADD elec.isConnectedTo args.to
]
root.WIRE = elec.WIRE


handleWires = (wires, containerName="wires") ->
    ret = [ sys.hasPart LIST() containerName ]
    if wires?
        i = 0
        for name, detailsFunction of wires
            self[containerName].ADD CONTAINS WIRE(detailsFunction()) name

            self[containerName].ADD cont.hasContainment CONTAINMENT(number: i) "containment#{i}"
            self[containerName]["containment#{i}"].ADD cont.hasItem self[containerName][name]

            ret.push elec.hasWire self[containerName][name]
            i = i + 1
    return ret




elec.ADD elec.Device "ENCODER" : ( args = {} ) -> [
    CHECK_ARGS("elec.ENCODER", args, ARGS_mech_PART.concat [])
    #APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )

    #mech.hasPart mech.PART() "shaft"

    APPLY mech.ROTARY_LOAD(FILTER_ARGS(args, keep: ARGS_mech_PART))
]





elec.ADD elec.ConnectorType "CONNECTOR_TYPE" : ( args = {} ) -> [
    CHECK_ARGS("CONNECTOR_TYPE", args, ARGS_mech_PART.concat ["terminals", "gender", "joinedWith" ])
    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )

    if args.gender?
        elec.hasGender args.gender

    if args.joinedWith?
        elec.isJoinedWith args.joinedWith

    handleTerminals(args.terminals)
]
root.CONNECTOR_TYPE = elec.CONNECTOR_TYPE


elec.ADD elec.ConnectorInstance "CONNECTOR_INSTANCE" : ( args = {} ) -> [
    CHECK_ARGS("CONNECTOR_INSTANCE", args, ARGS_mech_PART.concat ["type", "terminals", "symbol", "wires" ,  "joinedWith"])
    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )

    # define the newly created features as terminals:
    if args.type?
        for terminal in PATHS(args.type, elec.hasTerminal)
            self.terminals[terminal._name].ADD rdf.type elec.TerminalInstance
            [
                elec.hasTerminal self.terminals[terminal._name]
            ]

    if args.joinedWith?
        elec.isJoinedWith args.joinedWith

    if args.symbol?
        [
            LABEL args.symbol
            elec.hasSymbol args.symbol
        ]

    # add some details to the terminals
    if args.terminals?
        for name, detailsFunction of args.terminals
            details = detailsFunction()
            if details.comment?
                self.terminals[name].ADD COMMENT details.comment
            if details.symbol?
                self.terminals[name].ADD elec.hasSymbol details.symbol
            if details.isConnectedTo?
                if IS_ARRAY(details.isConnectedTo)
                    for item in details.isConnectedTo
                        self.terminals[name].ADD elec.isConnectedTo item
                else
                    self.terminals[name].ADD elec.isConnectedTo details.isConnectedTo


    handleWires(args.wires)
]
root.CONNECTOR_INSTANCE = elec.CONNECTOR_INSTANCE



handleConnectors = (connectors) ->
    ret = [ sys.hasPart LIST() "connectors" ]
    if connectors?
        i = 0
        for name, detailsFunction of connectors
            self.connectors.ADD CONTAINS CONNECTOR_INSTANCE(detailsFunction()) name

            self.connectors.ADD cont.hasContainment CONTAINMENT(number: i) "containment#{i}"
            self.connectors["containment#{i}"].ADD cont.hasItem self.connectors[name]

            ret.push elec.hasConnector self.connectors[name]
            i = i + 1
    return ret

elec.ADD elec.CableType "CABLE_TYPE" : ( args = {} ) -> [
    CHECK_ARGS("CABLE_TYPE", args, ARGS_mech_PART.concat ["wires" ])
    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )

    handleWires(args.wires)
]
root.CABLE_TYPE = elec.CABLE_TYPE




elec.ADD elec.CableInstance "CABLE_INSTANCE" : ( args = {} ) -> [
    CHECK_ARGS("CABLE_INSTANCE", args, ARGS_mech_PART.concat ["type", "wires", "symbol" ])
    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )

    # define the newly created wire features as wires:
    if args.type?
        for wire in PATHS(args.type, elec.hasWire)
            self.wires[wire._name].ADD rdf.type elec.WireInstance
            #for color in PATHS(wire, colors.hasColor)
            #    self.wires[wire._name].ADD colors.hasColor color
            [
                elec.hasWire self.wires[wire._name]
            ]


    # add some details to the wires
    if args.wires?
        for wireName, wireDetailsFunction of args.wires
            wireDetails = wireDetailsFunction()
            CHECK_ARGS("WIRE_INSTANCE : wires", wireDetails, ["comment", "from", "to", "symbol", "label", "color"])
            if wireDetails.comment?         then self.wires[wireName].ADD COMMENT wireDetails.comment
            if wireDetails.label?           then self.wires[wireName].ADD LABEL wireDetails.label
            if wireDetails.from?
                self.wires[wireName].ADD elec.connectsFrom wireDetails.from
            if wireDetails.to?
                self.wires[wireName].ADD elec.connectsTo wireDetails.to
            if wireDetails.from? and wireDetails.to?
                wireDetails.from.ADD elec.isConnectedTo wireDetails.to
            if wireDetails.symbol
                self.wires[wireName].ADD elec.hasSymbol wireDetails.symbol
            if wireDetails.color
                if IS_ARRAY(wireDetails.color)
                    for c in wireDetails.color
                        self.wires[wireName].ADD colors.hasColor c
                else
                    self.wires[wireName].ADD colors.hasColor wireDetails.color


    if args.symbol?
        [
            elec.hasSymbol args.symbol
            LABEL args.symbol
        ]
]
root.CABLE_INSTANCE = elec.CABLE_INSTANCE



handleCables = (cables) ->
    ret = [ sys.hasPart LIST() "cables" ]
    if cables?
        i = 0
        for name, detailsFunction of cables
            self.cables.ADD CONTAINS CABLE_INSTANCE(detailsFunction()) name

            self.cables.ADD cont.hasContainment CONTAINMENT(number: i) "containment#{i}"
            self.cables["containment#{i}"].ADD cont.hasItem self.cables[name]

            ret.push elec.hasCable self.cables[name]
            i = i + 1
    return ret





elec.ADD elec.CableAssemblyType "CABLE_ASSEMBLY_TYPE" : ( args = {} ) -> [
    CHECK_ARGS("CABLE_ASSEMBLY_TYPE", args, ARGS_mech_PART.concat ["cables", "connectors" ])

    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )

    handleConnectors(args.connectors)
    handleCables(args.cables)
]
root.CABLE_ASSEMBLY_TYPE = elec.CABLE_ASSEMBLY_TYPE




elec.ADD elec.CableAssemblyInstance "CABLE_ASSEMBLY_INSTANCE" : ( args = {} ) -> [
    CHECK_ARGS("CABLE_ASSEMBLY_INSTANCE", args, ARGS_mech_PART.concat ["type", "symbol", "joined" ])

    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )

    if args.symbol?
        [
            elec.hasSymbol args.symbol
            LABEL args.symbol
        ]

    for name, detailsFunction of args.joined
        self.connectors[name].ADD elec.isJoinedWith detailsFunction()
]
root.CABLE_ASSEMBLY_INSTANCE = elec.CABLE_ASSEMBLY_INSTANCE




handleCableAssemblies = (cable_assemblies) ->
    ret = [ sys.hasPart LIST() "cable_assemblies" ]
    if cable_assemblies?
        i = 0
        for name, detailsFunction of cable_assemblies
            self.cable_assemblies.ADD CONTAINS CABLE_ASSEMBLY_INSTANCE(detailsFunction()) name

            self.cable_assemblies.ADD cont.hasContainment CONTAINMENT(number: i) "containment#{i}"
            self.cable_assemblies["containment#{i}"].ADD cont.hasItem self.cable_assemblies[name]

            ret.push elec.hasCableAssembly self.cable_assemblies[name]
            i = i + 1
    return ret


elec.ADD elec.DeviceType "DEVICE_TYPE" : ( args = {} ) -> [
    CHECK_ARGS("DEVICE_TYPE", args, ARGS_mech_PART.concat ["terminals", "channels", "cables", "connectors", "wires", "cable_assemblies", "soft_interface" ])

    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )

    handleTerminals(args.terminals)
    handleChannels(args.channels)
    handleSoftInterface(args.soft_interface)
    handleConnectors(args.connectors)
    handleCables(args.cables)
    handleCableAssemblies(args.cable_assemblies)
    handleWires(args.wires)
]
root.DEVICE_TYPE = elec.DEVICE_TYPE



elec.ADD elec.IoModuleType "IO_MODULE_TYPE" : ( args = {} ) -> [
    APPLY DEVICE_TYPE(args)
]
root.IO_MODULE_TYPE = elec.IO_MODULE_TYPE

elec.ADD elec.DriveType "DRIVE_TYPE" : ( args = {} ) -> [
    APPLY DEVICE_TYPE(args)
]
root.DRIVE_TYPE = elec.DRIVE_TYPE


# **********************************************************************************************************************
# DEVICE_INSTANCE
# **********************************************************************************************************************
elec.ADD elec.DeviceInstance "DEVICE_INSTANCE" : ( args = {} ) -> [
    CHECK_ARGS("DEVICE_INSTANCE", args, ARGS_mech_PART.concat ["type", "terminals", "symbol", "wires", "cables", "add_wires" ])

    # create a mechanical part
    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )

    # define the newly created features as terminals:
    if args.type?
        for terminal in PATHS(args.type, elec.hasTerminal)
            self.terminals[terminal._name].ADD rdf.type elec.TerminalInstance
            [
                elec.hasTerminal self.terminals[terminal._name]
            ]

    # define the newly created Interface feature as Interface:
    if args.type?
        interf = PATH(args.type, sys.hasInterface)
        if interf?
            self[interf._name].ADD rdf.type soft.InterfaceInstance
            for member in PATHS(interf, soft.hasVariable)
                self[interf._name][member._name].ADD rdf.type soft.Variable
            [
                sys.hasInterface self[interf._name]
            ]

    # define the newly created features as channels:
    if args.type?
        for terminal in PATHS(args.type, elec.hasChannel)
            elec.hasChannel self.channels[terminal._name]

    # add some details to the terminals
    if args.terminals?
        for terminalName, terminalDetailsFunction of args.terminals
            terminalDetails = terminalDetailsFunction()
            CHECK_ARGS("DEVICE_INSTANCE : terminals", terminalDetails, ["comment", "isConnectedTo", "symbol" ])
            if terminalDetails.comment?
                self.terminals[terminalName].ADD COMMENT terminalDetails.comment
            if terminalDetails.symbol?
                self.terminals[terminalName].ADD elec.hasSymbol terminalDetails.symbol
            if terminalDetails.isConnectedTo?
                # isConnectedTo may be a single item, or an array of items
                if IS_ARRAY(terminalDetails.isConnectedTo)
                    for item in terminalDetails.isConnectedTo
                        self.terminals[terminalName].ADD elec.isConnectedTo item
                else
                    self.terminals[terminalName].ADD elec.isConnectedTo terminalDetails.isConnectedTo

    # add some details to the cables
    if args.cables?
        for cableName, cableDetailsFunction of args.cables
            cableDetails = cableDetailsFunction()
            CHECK_ARGS("DEVICE_INSTANCE : cables", cableDetails, ["comment", "wires", "symbol" ])
            if cableDetails.comment?
                self.cables[cableName].ADD COMMENT cableDetails.comment
            if cableDetails.symbol?
                self.cables[cableName].ADD elec.hasSymbol cableDetails.symbol
            if cableDetails.wires?
                for wireName, wireDetailsFunction of cableDetails.wires
                    wireDetails = wireDetailsFunction()
                    CHECK_ARGS("DEVICE_INSTANCE : cables : wires", wireDetails, ["comment", "from", "to", "symbol", "label", "color"])
                    if wireDetails.comment?         then self.cables[cableName].wires[wireName].ADD COMMENT wireDetails.comment
                    if wireDetails.label?           then self.cables[cableName].wires[wireName].ADD LABEL wireDetails.label
                    if wireDetails.from?
                        self.cables[cableName].wires[wireName].ADD elec.connectsFrom wireDetails.from
                    if wireDetails.to?
                        self.cables[cableName].wires[wireName].ADD elec.connectsTo wireDetails.to
                    if wireDetails.from? and wireDetails.to?
                        wireDetails.from.ADD elec.isConnectedTo wireDetails.to
                    if wireDetails.symbol
                        self.cables[cableName].wires[wireName].ADD elec.hasSymbol wireDetails.symbol
                    if wireDetails.color
                        if IS_ARRAY(wireDetails.color)
                            for c in wireDetails.color
                                self.cables[cableName].wires[wireName].ADD colors.hasColor c
                        else
                            self.cables[cableName].wires[wireName].ADD colors.hasColor wireDetails.color

    # add some details to the existing wires
    if args.wires?
        for wireName, wireDetailsFunction of args.wires
            wireDetails = wireDetailsFunction()
            CHECK_ARGS("WIRE_INSTANCE : wires", wireDetails, ["comment", "from", "to", "symbol", "label", "color"])
            # if the wire already exists, add details
            if wireDetails.comment?         then self.wires[wireName].ADD COMMENT wireDetails.comment
            if wireDetails.label?           then self.wires[wireName].ADD LABEL wireDetails.label
            if wireDetails.from?
                self.wires[wireName].ADD elec.connectsFrom wireDetails.from
            if wireDetails.to?
                self.wires[wireName].ADD elec.connectsTo wireDetails.to
            if wireDetails.from? and wireDetails.to?
                wireDetails.from.ADD elec.isConnectedTo wireDetails.to
            if wireDetails.symbol
                self.wires[wireName].ADD elec.hasSymbol wireDetails.symbol
            if wireDetails.color
                if IS_ARRAY(wireDetails.color)
                    for c in wireDetails.color
                        self.wires[wireName].ADD colors.hasColor c
                else
                    self.wires[wireName].ADD colors.hasColor wireDetails.color

    if args.add_wires?
        handleWires(args.add_wires, "add_wires")

    # add the symbol and change the label
    if args.symbol?
        [
            elec.hasSymbol args.symbol
            LABEL args.symbol
        ]
]
root.DEVICE_INSTANCE = elec.DEVICE_INSTANCE


# **********************************************************************************************************************
# CIRCUIT_BREAKER_TYPE
# **********************************************************************************************************************
elec.ADD elec.CircuitBreakerType "CIRCUIT_BREAKER_TYPE" : ( args =refines {} ) -> [
    APPLY DEVICE_TYPE(args)
]
root.CIRCUIT_BREAKER_TYPE = elec.CIRCUIT_BREAKER_TYPE


# **********************************************************************************************************************
# CIRCUIT_BREAKER_INSTANCE
# **********************************************************************************************************************
elec.ADD elec.CircuitBreakerInstance "CIRCUIT_BREAKER_INSTANCE" : ( args = {} ) -> [
    APPLY DEVICE_INSTANCE(args)
]
root.CIRCUIT_BREAKER_INSTANCE = elec.CIRCUIT_BREAKER_INSTANCE


# **********************************************************************************************************************
# IO_MODULE_INSTANCE
# **********************************************************************************************************************
elec.ADD elec.IoModuleInstance "IO_MODULE_INSTANCE" : ( args = {} ) -> [
    APPLY DEVICE_INSTANCE(args)
]
root.IO_MODULE_INSTANCE = elec.IO_MODULE_INSTANCE


# **********************************************************************************************************************
# DEVICE_INSTANCE
# **********************************************************************************************************************
elec.ADD elec.DriveInstance "DRIVE_INSTANCE" : ( args = {} ) -> [
    APPLY DEVICE_INSTANCE(args)
]
root.DRIVE_INSTANCE = elec.DRIVE_INSTANCE


# **********************************************************************************************************************
# POWER_SUPPLY
# **********************************************************************************************************************
elec.ADD elec.PowerSupply "POWER_SUPPLY" : ( args = {} ) -> [
    CHECK_ARGS("IO_MODULE", args, ARGS_mech_PART.concat ["terminals" ])

    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )

    handleTerminals(args.terminals)

]
root.POWER_SUPPLY = elec.POWER_SUPPLY


elec.ADD elec.PowerSupplyType "POWER_SUPPLY_TYPE" : ( args = {} ) -> [
    APPLY DEVICE_TYPE(args)
]
root.POWER_SUPPLY_TYPE = elec.POWER_SUPPLY_TYPE

elec.ADD elec.PowerSupplyInstance "POWER_SUPPLY_INSTANCE" : ( args = {} ) -> [
    APPLY DEVICE_INSTANCE(args)
]
root.POWER_SUPPLY_INSTANCE = elec.POWER_SUPPLY_INSTANCE


elec.ADD elec.ActuatorType "ACTUATOR_TYPE" : ( args = {} ) -> [
    APPLY DEVICE_TYPE(args)
]
root.ACTUATOR_TYPE = elec.ACTUATOR_TYPE

elec.ADD elec.ActuatorInstance "ACTUATOR_INSTANCE" : ( args = {} ) -> [
    APPLY DEVICE_INSTANCE(args)
]
root.ACTUATOR_INSTANCE = elec.ACTUATOR_INSTANCE


elec.ADD elec.SensorType "SENSOR_TYPE" : ( args = {} ) -> [
    APPLY DEVICE_TYPE(args)
]
root.SENSOR_TYPE = elec.SENSOR_TYPE

elec.ADD elec.SensorInstance "SENSOR_INSTANCE" : ( args = {} ) -> [
    APPLY DEVICE_INSTANCE(args)
]
root.SENSOR_INSTANCE = elec.SENSOR_INSTANCE

elec.ADD elec.SwitchType "SWITCH_TYPE" : ( args = {} ) -> [
    APPLY DEVICE_TYPE(args)
]
root.SWITCH_TYPE = elec.SWITCH_TYPE

elec.ADD elec.SwitchInstance "SWITCH_INSTANCE" : ( args = {} ) -> [
    APPLY DEVICE_INSTANCE(args)
]
root.SWITCH_INSTANCE = elec.SWITCH_INSTANCE


elec.ADD elec.MotorType "MOTOR_TYPE" : ( args = {} ) -> [
    APPLY ROTARY_MOTOR(FILTER_ARGS(args, keep: ARGS_mech_PART) )
    APPLY DEVICE_TYPE(args)
]
elec.ADD elec.MotorInstance "MOTOR_INSTANCE" : ( args = {} ) -> [
    APPLY DEVICE_INSTANCE(args)
]
