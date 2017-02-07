##########################################################################
#                                                                        #
# Model of the telescope cover mechanics.                                #
#                                                                        #
##########################################################################

require "ontoscript"

# models
REQUIRE "models/mtcs/cover/system.coffee"
REQUIRE "models/external/maxon.coffee"
REQUIRE "models/external/kuebler.coffee"
REQUIRE "models/external/magnetschultz.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/cover/mechanics" : "cover_mech"

cover_mech.IMPORT cover_sys
cover_mech.IMPORT mech
cover_mech.IMPORT maxon
cover_mech.IMPORT kuebler
cover_mech.IMPORT magnetschultz


##########################################################################
# Custom-built parts
##########################################################################

cover_mech.ADD mech.PART(
    comment  : "Aluminum petal, anodized",
    realizes : cover_sys.panelDesign.parts.petal
    ) "petal"

cover_mech.ADD mech.PART(
    comment  : "Shaft of the petal",
    realizes : cover_sys.panelDesign.parts.shaft,
    fixedTo  : cover_mech.petal
    ) "shaft"

cover_mech.ADD mech.PART(
    comment  : "Bracket",
    realizes : cover_sys.panelDesign.parts.bracket
    ) "bracket"


##########################################################################
# Motor, encoder and magnet
##########################################################################

cover_mech.ADD ROTARY_MOTOR(
    comment       : "Actuator of the petal",
    realizes      : cover_sys.panelDesign.parts.motor,
    type          : maxon.motor_370418,
    stator: ->
        fixedTo   : cover_mech.bracket
    ) "motor"

cover_mech.ADD ROTARY_TRANSMISSION(
    comment       : "Planetary reduction fixed onto the motor",
    type          : maxon.reduction_166960
    stator: ->
        fixedTo   : cover_mech.motor
    inputRotor: ->
        fixedTo   : cover_mech.motor.rotor
    ) "motorReduction"


cover_mech.ADD ROTARY_LOAD(
    comment       : "External encoder",
    realizes      : cover_sys.panelDesign.parts.encoder,
    type          : kuebler.F3673_1421_G412,
    stator: ->
        fixedTo   : cover_mech.bracket
    ) "encoder"

cover_mech.ADD mech.PART(
    comment  : "Magnet",
    realizes : cover_sys.panelDesign.parts.magnet,
    type     : magnetschultz.G_MH_x025
    ) "magnet"


##########################################################################
# Transmissions
##########################################################################

cover_mech.ADD ROTARY_TRANSMISSION(
    comment       : "Transmission from motor shaft to petal shaft",
    realizes      : cover_sys.panelDesign.parts.mot_to_shaft,
    stator: ->
        fixedTo   : cover_mech.bracket
    inputRotor: ->
        fixedTo   : cover_mech.motor.rotor
    outputRotor: ->
        fixedTo   : cover_mech.shaft
    ) "mot_to_shaft"

cover_mech.ADD ROTARY_TRANSMISSION(
    comment       : "Transmission from motor reduction to slip clutch",
    ratio         : 1/8
    stator: ->
        fixedTo   : cover_mech.bracket
    inputRotor: ->
        fixedTo   : cover_mech.motorReduction.outputRotor
    ) "red_to_clutch"

cover_mech.ADD ROTARY_TRANSMISSION(
    comment       : "Slip clutch, mounted between petal shaft and the " +
                    "gear driven by the motor",
    realizes      : cover_sys.panelDesign.parts.slipClutch,
    ratio         : 1/1
    inputRotor: ->
        fixedTo   : cover_mech.red_to_clutch.outputRotor
    outputRotor: ->
        fixedTo   : cover_mech.shaft
    ) "slipClutch"

cover_mech.ADD ROTARY_TRANSMISSION(
    comment       : "Transmission from encoder shaft to petal shaft",
    realizes      : cover_sys.panelDesign.parts.enc_to_shaft,
    ratio         : 1/1
    stator: ->
        fixedTo   : cover_mech.bracket
    inputRotor: ->
        fixedTo   : cover_mech.encoder.rotor
    outputRotor: ->
        fixedTo   : cover_mech.shaft
    ) "enc_to_shaft"


########################################################################################################################
# Write the model to file
########################################################################################################################


cover_mech.WRITE "models/mtcs/cover/mechanics.jsonld"