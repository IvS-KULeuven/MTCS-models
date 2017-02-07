########################################################################################################################
#                                                                                                                      #
# Model containing the system design of the secondary mirror M2.                                                       #
#                                                                                                                      #
# VERY INCOMPLETE !!! TODO !!!                                                                                         #
# See cover/system.coffee for inspiration...                                                                           #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "models/import_all.coffee"

# models
REQUIRE "models/util/systemfactories.coffee"
REQUIRE "models/mtcs/tube/tube.coffee"
REQUIRE "models/mtcs/common/roles.coffee"
REQUIRE "models/mtcs/m1/system.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/m2/system" : "m2_sys"

# import the dependencies
m2_sys.IMPORT systemfactories
m2_sys.IMPORT tube
m2_sys.IMPORT roles
m2_sys.IMPORT mech
m2_sys.IMPORT elec
m2_sys.IMPORT m1_sys


########################################################################################################################
# The project
########################################################################################################################

m2_sys.ADD MTCS_PROJECT "project",
    label: "M2"
    comment: "The secondary mirror (M2). VERY INCOMPLETE SYSTEM DESCRIPTION --> see cover_sys:project for inspiration"


########################################################################################################################
# The concept
########################################################################################################################

m2_sys.ADD MTCS_CONCEPT "concept",
    partOf: m2_sys.project
    requirements:
        directionX          : -> { comment: "M2 control system shall be able to translate the mirror in X direction"                         , isRequiredBy: roles.tech                  }
        directionY          : -> { comment: "M2 control system shall be able to translate the mirror in X direction"                         , isRequiredBy: roles.tech                  }
        directionZ          : -> { comment: "M2 control system shall be able to translate the mirror in X direction"                         , isRequiredBy: [roles.tech,roles.observer] }
        directionTX         : -> { comment: "M2 control system shall be able to tip the mirror in X direction"                               , isRequiredBy: roles.tech                  }
        directionTY         : -> { comment: "M2 control system shall be able to tip the mirror in Y direction"                               , isRequiredBy: roles.tech                  }
        plc                 : -> { comment: "M2 control system shall be implemented on a PLC"                                                , isRequiredBy: roles.tech                   }
        opcua               : -> { comment: "M2 control system shall be remotely controlled and monitored by OPC UA"                         , isRequiredBy: roles.tech                   }
        safety              : -> { comment: "M2 control system shall be safe to use under all circumstances"                                 , isRequiredBy: [roles.tech,roles.observer]  }
        reliability         : -> { comment: "M2 control system shall have a high reliability"                                                , isRequiredBy: [roles.tech,roles.observer]  }
        availability        : -> { comment: "M2 control system shall have a very high availability"                                          , isRequiredBy: [roles.tech,roles.observer]  }
        autoMode            : -> { comment: "M2 control system shall have an auto mode for adjusting Z"                                      , isRequiredBy: [roles.tech,roles.observer] }
        manualMode          : -> { comment: "M2 control system shall have a manual mode to adjusting all M2 controls"                        , isRequiredBy: roles.tech , isDerivedFrom: $.requirements.availability }
        shutdown            : -> { comment: "M2 control system shall operate also when the software is not initialized"                      , isDerivedFrom: $.requirements.availability }
        initialized         : -> { comment: "M2 control system shall operate in manual or auto mode when initialized"                        , isDerivedFrom: [ $.requirements.autoMode, $.requirements.manualMode ] }
    states:
        auto                : -> { comment: "In auto mode, M2 can only be positioned in Z direction using a high-level interface"              , isDerivedFrom: $.requirements.autoMode }
        manual              : -> { comment: "In manual mode, M2 can be fully controlled using a low-level interface"                          , isDerivedFrom: $.requirements.manualMode }
        initialized         : -> { comment: "When initialized, M2 control can be operated in auto and manual mode"}
        shutdown            : -> { comment: "When shutdown, M2 cannot be moved"}
    constraints:
        {}
    tests:
        {}


########################################################################################################################
# The system design
########################################################################################################################

m2_sys.ADD MTCS_DESIGN "systemDesign",
    realizes: m2_sys.concept
    parts:
        support: ->
            comment         : "Mechanical support"
        cabinet: ->
            comment         : "Electrical cabinet"
            realizedBy      : m1_sys.cabinet
    properties:
        {}


########################################################################################################################
# Mechanical support
########################################################################################################################

m2_sys.ADD MTCS_DESIGN "support",
    realizes: m2_sys.systemDesign.parts.support
    parts:
        spider              : -> CONSTRUCT mech.PART(fixedTo: tube.concept)
        x: ->
            comment         : "The X translation system"
        y: ->
            comment         : "The Y translation system"
        z: ->
            comment         : "The Z translation system"
        tiltX: ->
            comment         : "The X tilt system"
        tiltY: ->
            comment         : "The Y tilt system"


########################################################################################################################
# Y translation
########################################################################################################################

m2_sys.ADD MTCS_DESIGN "z",
    comment: "The z axis"
    realizes: m2_sys.support.parts.z
    parts:
        nut                     : -> CONSTRUCT mech.PART(comment: "Moveable part")
        screw                   : -> CONSTRUCT mech.PART()
        encoder                 : -> CONSTRUCT mech.PART()
        motor                   : -> CONSTRUCT mech.ROTARY_MOTOR(fixedTo: m2_sys.support.parts.spider)
        motToRed                : -> CONSTRUCT mech.ROTARY_TRANSMISSION(
                                                    inputRotor: ->
                                                        fixedTo: $.motor
                                                    ratio: 134
                                                    comment: "Motor reduction")
        redToScrew              : -> CONSTRUCT mech.ROTARY_TRANSMISSION(
                                                    inputRotor: ->
                                                        fixedTo: $.motToRed
                                                    outputRotor: ->
                                                        fixedTo: $.screw
                                                    ratio: 2
                                                    comment: "Transmission between motor reduction and screw")
        screwToEnc              : -> CONSTRUCT mech.ROTARY_TRANSMISSION(
                                                    inputRotor: ->
                                                        fixedTo: $.screw
                                                    outputRotor: ->
                                                        fixedTo: $.encoder
                                                    ratio: 1
                                                    comment: "Transmission between screw and encoder")
    properties:
        minPosition             : -> CONSTRUCT MICROMETER(     0  , "Minimum position of the nut")
        maxPosition             : -> CONSTRUCT MICROMETER( 50000  , "Maximum position of the nut")
        screwPitch              : -> CONSTRUCT MICROMETER(  2000  , "Screw pitch")
        feedbackResolution      : -> CONSTRUCT BIT(           32  , "Pulses per revolution (coming from the Hall sensor feedback)")


########################################################################################################################
# X, Y, TiltX, TiltY
########################################################################################################################

addAxis = (name, fixedTo, motToRedRatio, redToScrewRatio, screwToPotRatio, minPos, maxPos, pitch, feedbackRes, potRev) ->

    m2_sys.ADD MTCS_DESIGN name,
        comment: "The #{name.capitalize()} axis"
        realizes: m2_sys.support.parts[name]
        parts:
            nut                     : -> CONSTRUCT mech.PART(comment: "Moveable part")
            screw                   : -> CONSTRUCT mech.PART()
            potentiometer           : -> CONSTRUCT mech.PART()
            motor                   : -> CONSTRUCT mech.ROTARY_MOTOR(fixedTo: fixedTo)
            motToRed                : -> CONSTRUCT mech.ROTARY_TRANSMISSION(
                                                            inputRotor: ->
                                                                fixedTo: $.motor
                                                            ratio: motToRedRatio
                                                            comment: "Motor reduction")
            redToScrew              : -> CONSTRUCT mech.ROTARY_TRANSMISSION(
                                                            inputRotor: ->
                                                                fixedTo: $.motToRed
                                                            outputRotor: ->
                                                                fixedTo: $.screw
                                                            ratio: redToScrewRatio
                                                            comment: "Transmission between motor reduction and screw")
            screwToPot              : -> CONSTRUCT mech.ROTARY_TRANSMISSION(
                                                            inputRotor: ->
                                                                fixedTo: $.screw
                                                            outputRotor: ->
                                                                fixedTo: $.potentiometer
                                                            ratio: screwToPotRatio
                                                            comment: "Transmission between screw and potentiometer")
        properties:
            minPosition             : -> CONSTRUCT MICROMETER(  minPos      , "Minimum position of the nut")
            maxPosition             : -> CONSTRUCT MICROMETER(  maxPos      , "Maximum position of the nut")
            screwPitch              : -> CONSTRUCT MICROMETER(  pitch       , "Screw pitch")
            feedbackResolution      : -> CONSTRUCT BIT(         feedbackRes , "Pulses per revolution (coming from the Hall sensor feedback)")
            potentiometerRevolutions: -> CONSTRUCT REVOLUTION(  potRev      , "Max number of revolutions of the potentiometer")


addAxis(name="x"    , fixedTo=m2_sys.z.parts.nut    , motToRedRatio= 415, redToScrewRatio=2, screwToPotRatio=0.5, minPos=400, maxPos=4700, pitch=1000, feedbackRes=3, potRev=10)
addAxis(name="y"    , fixedTo=m2_sys.x.parts.nut    , motToRedRatio= 415, redToScrewRatio=2, screwToPotRatio=0.5, minPos=400, maxPos=4700, pitch=1000, feedbackRes=3, potRev=10)
addAxis(name="tiltX", fixedTo=m2_sys.y.parts.nut    , motToRedRatio=1526, redToScrewRatio=2, screwToPotRatio=0.5, minPos=260, maxPos=1200, pitch=1000, feedbackRes=3, potRev=3)
addAxis(name="tiltY", fixedTo=m2_sys.tiltX.parts.nut, motToRedRatio=1526, redToScrewRatio=2, screwToPotRatio=0.5, minPos=180, maxPos=1200, pitch=1000, feedbackRes=3, potRev=3)


########################################################################################################################
# Write the model to file
########################################################################################################################

m2_sys.WRITE "models/mtcs/m2/system.jsonld"


