require "ontoscript"

REQUIRE "metamodels/finitestatemachines.coffee"
REQUIRE "metamodels/geometry.coffee"
REQUIRE "metamodels/controlsystems.coffee"


METAMODEL "http://www.mercator.iac.es/onto/metamodels/mechanics" : "mech"

mech.READ "metamodels/mechanics.jsonld"


mech.ADD mech.Power "POWER" : (args = {}) -> [
    if args.watt?
        qudt.quantityValue WATT(args.watt) "watt"
    else
        qudt.quantityValue WATT() "watt"
]


mech.ADD mech.TransmissionRatio "TRANSMISSION_RATIO" : (value) -> [
    qudt.quantityValue UNITLESS(value) "quantityValue"
]
root.TRANSMISSION_RATIO = mech.TRANSMISSION_RATIO


mech.ADD mech.TransmissionEfficiency "TRANSMISSION_EFFICIENCY" : (value) -> [
    qudt.quantityValue UNITLESS(value) "quantityValue"
]


root.ARGS_mech_PART = ["comment", "realizes", "satisfies", "fixedTo", "type", "id", "manufacturer", "coordinateSystem", "label"]

mech.ADD mech.Part "PART" : (args = {}) -> [
    CHECK_ARGS("mech.PART", args, ARGS_mech_PART)

    if args.realizes?
        sys.realizes args.realizes

    if args.label?
        LABEL args.label

    if args.satisfies?
        dev.satisfies args.satisfies

    if args.comment?
        COMMENT args.comment

    if args.fixedTo?
        mech.isFixedTo args.fixedTo

    # realize the type (and all its features)
    if args.type?
        APPLY sys.REALIZATION(realizes : args.type)

    if args.type?
        man.hasType args.type

    if self.coordinateSystem is undefined
        if args.coordinateSystem?
            geom.hasCoordinateSystem args.coordinateSystem
        else
            geom.hasCoordinateSystem COORDINATE_SYSTEM() "coordinateSystem" # default=x,y,z


    if args.id?
        man.hasId args.id

    if args.manufacturer?
        man.isManufacturedBy args.manufacturer
]

mech.ADD mech.Assembly "ASSEMBLY" : (args = {}) -> [
   APPLY mech.PART(args)
]
root.ASSEMBLY = mech.ASSEMBLY



mech.ADD mech.Rotor "ROTOR"  : (args = {}) -> [
    CHECK_ARGS("ROTOR", args, ARGS_mech_PART.concat [])

    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )
]

mech.ADD mech.Rotor "STATOR"  : (args = {}) -> [
    CHECK_ARGS("STATOR", args, ARGS_mech_PART.concat [])

    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )
]


handleRotor = (args) ->
    if args.rotor?
        rotorArgs = args.rotor()
    else
        rotorArgs = undefined

    if (self.rotor?)
        self.rotor.ADD APPLY mech.ROTOR(rotorArgs)
    else
        return mech.hasRotor mech.ROTOR(rotorArgs) "rotor"

handleInputRotor = (args) ->
    if args.inputRotor?
        rotorArgs = args.inputRotor()
    else
        rotorArgs = undefined

    if (self.inputRotor?)
        self.inputRotor.ADD APPLY mech.ROTOR(rotorArgs)
    else
        return mech.hasInputRotor mech.ROTOR(rotorArgs) "inputRotor"

handleOutputRotor = (args) ->
    if args.outputRotor?
        rotorArgs = args.outputRotor()
    else
        rotorArgs = undefined

    if (self.outputRotor?)
        self.outputRotor.ADD APPLY mech.ROTOR(rotorArgs)
    else
        return mech.hasOutputRotor mech.ROTOR(rotorArgs) "outputRotor"

handleStator = (args) ->
    if args.stator?
        statorArgs = args.stator()
    else
        statorArgs = undefined

    if (self.stator?)
        self.stator.ADD APPLY mech.STATOR(statorArgs)
    else
        return mech.hasStator mech.STATOR(statorArgs) "stator"


mech.ADD mech.RotaryMotor "ROTARY_MOTOR" : (args = {}) -> [
    CHECK_ARGS("ROTARY_MOTOR", args, ARGS_mech_PART.concat ["rotor", "stator"])

    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )

    handleStator(args)
    handleRotor(args)
]
root.ROTARY_MOTOR = mech.ROTARY_MOTOR

mech.ADD mech.RotaryLoad "ROTARY_LOAD" : (args = {}) -> [
    CHECK_ARGS("ROTARY_LOAD", args, ARGS_mech_PART.concat ["rotor", "stator"])

    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )

    handleStator(args)
    handleRotor(args)
]
root.ROTARY_LOAD = mech.ROTARY_LOAD


mech.ADD mech.RotaryTransmission "ROTARY_TRANSMISSION" : (args = {}) -> [
    CHECK_ARGS("ROTARY_TRANSMISSION", args, ARGS_mech_PART.concat ["fixedTo", "inputRotor", "outputRotor", "stator", "ratio"])

    APPLY mech.PART( FILTER_ARGS(args, keep: ARGS_mech_PART) )

    handleStator(args)
    handleInputRotor(args)
    handleOutputRotor(args)

    if (self.ratio?)
        self.ratio.quantityValue.ADD APPLY UNITLESS(args.ratio)
    else
        mech.hasTransmissionRatio mech.TRANSMISSION_RATIO(args.ratio) "ratio"
]
root.ROTARY_TRANSMISSION = mech.ROTARY_TRANSMISSION
