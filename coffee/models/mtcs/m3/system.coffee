########################################################################################################################
#                                                                                                                      #
# Model containing the system design of the tertiary mirror M3.                                                        #
#                                                                                                                      #
# VERY INCOMPLETE !!! TODO !!!                                                                                         #
# See cover/system.coffee for inspiration...                                                                           #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


# metamodels
REQUIRE "models/import_all.coffee"

REQUIRE "models/util/systemfactories.coffee"
REQUIRE "models/mtcs/common/roles.coffee"
REQUIRE "models/mtcs/tube/tube.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/m3/system" : "m3_sys"

# import the dependencies
m3_sys.IMPORT systemfactories
m3_sys.IMPORT tube
m3_sys.IMPORT roles
m3_sys.IMPORT mech
m3_sys.IMPORT elec


########################################################################################################################
# The project
########################################################################################################################
m3_sys.ADD MTCS_PROJECT "project",
    label: "M3"
    comment: "The tertiary mirror (M3). VERY INCOMPLETE SYSTEM DESCRIPTION --> see cover_sys:project for inspiration"


#########################################################################################################################
## The concept
#########################################################################################################################
m3_sys.ADD MTCS_CONCEPT "concept",
    partOf: m3_sys.project
    requirements:
        switching           : -> { comment: "M3 shall be able to move between any focal station within 90s"        , isRequiredBy: roles.observer              }
        standstill          : -> { comment: "M3 shall be able to hold its position"                                , isRequiredBy: roles.observer              }
        stopping            : -> { comment: "M3 shall be able to stop quickly on request when switching"           , isRequiredBy: roles.observer              }
        software            : -> { comment: "M3 shall have its logic implemented in software"                      , isRequiredBy: roles.tech                  }
        opcua               : -> { comment: "M3 shall be remotely controllable and monitorable by OPC UA"          , isRequiredBy: roles.tech                  }
        safety              : -> { comment: "M3 shall be safe to use under all circumstances"                      , isRequiredBy: [roles.tech,roles.observer] }
        reliability         : -> { comment: "M3 shall have a high reliability"                                     , isRequiredBy: [roles.tech,roles.observer] }
        availability        : -> { comment: "M3 shall have a very high availability"                               , isRequiredBy: [roles.tech,roles.observer] }
    properties:
        maxSwitchingTime    : -> CONSTRUCT SEC(double(90.0),"Maximum switching time")
    states:
        switching           : -> { comment: "M3 is switching"                          , isDerivedFrom: $.requirements.switching    }
        aborted             : -> { comment: "M3 switching has been aborted"            , isDerivedFrom: $.requirements.stopping     }
        standstill          : -> { comment: "M3 is standing still"                     , isDerivedFrom: $.requirements.standstill      }
    constraints:
        switching           : ->
            always:
                            if   : $.states.switching
                            then : EVENTUALLY( OR($.states.standstill, $.states.aborted), from: 0, to: $.properties.maxSwitchingTime )
            represents      : $.requirements.switching
    tests: {}


########################################################################################################################
# The system design
########################################################################################################################

m3_sys.ADD MTCS_DESIGN "system",
    realizes: m3_sys.concept
    parts:
        rotation: ->
            comment         : "The rotation mechanism"
            states:
                moving      : -> {}
                standstill  : -> {}
        translation: ->
            comment         : "The translation mechanism"
            states:
                moving      : -> {}
                standstill  : -> {}
        cabinet: ->
            comment         : "Electrical cabinet"
    properties:
        {}
    states:
        switching           : -> { sameAs: OR($.parts.rotation.states.moving        , $.parts.translation.states.moving     ) }
        standstill          : -> { sameAs: AND($.parts.rotation.states.standstill   , $.parts.translation.states.standstill ) }


########################################################################################################################
# The cabinet design
########################################################################################################################

m3_sys.ADD MTCS_DESIGN "cabinet",
    realizes: m3_sys.system.parts.cabinet
    parts:
        panel : -> { comment: "Alu panel"     }
        io    : -> { comment: "I/O terminals" }
        power : -> { comment: "Power supply"  }


########################################################################################################################
# The I/O design
########################################################################################################################

m3_sys.ADD MTCS_DESIGN "io",
    realizes: m3_sys.cabinet.parts.io
    parts:
        slot0   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot1   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot2   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot3   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot4   : -> CONSTRUCT IO_MODULE_INSTANCE()


########################################################################################################################
# The rotation mechanism
########################################################################################################################

m3_sys.ADD MTCS_DESIGN "rotation",
    realizes: m3_sys.system.parts.rotation
    parts:
        bracket             : -> CONSTRUCT mech.PART(fixedTo: tube.concept)
        encoder             : -> CONSTRUCT elec.ENCODER(fixedTo: $.parts.bracket)
        platform            : -> CONSTRUCT mech.PART()
        positioningMotor    : -> CONSTRUCT mech.ROTARY_MOTOR()
        antiBacklashMotor   : -> CONSTRUCT mech.ROTARY_MOTOR()
        pos_to_platform     : -> CONSTRUCT mech.ROTARY_TRANSMISSION(
                                                inputRotor: ->
                                                    fixedTo: $.positioningMotor.rotor
                                                outputRotor: ->
                                                    fixedTo: $.platform)
        abl_to_platform     : -> CONSTRUCT mech.ROTARY_TRANSMISSION(
                                                inputRotor: ->
                                                    fixedTo: $.antiBacklashMotor.rotor
                                                outputRotor: ->
                                                    fixedTo: $.platform )
        enc_to_platform     : -> CONSTRUCT mech.ROTARY_TRANSMISSION(
                                                inputRotor: ->
                                                    fixedTo: $.encoder.rotor
                                                outputRotor: ->
                                                    fixedTo: $.platform)



########################################################################################################################
# The translation mechanism
########################################################################################################################

m3_sys.ADD MTCS_DESIGN "translation",
    realizes: m3_sys.system.parts.translation
    parts:
        bracket             : -> CONSTRUCT mech.PART(fixedTo: m3_sys.rotation.parts.platform )
        encoder             : -> CONSTRUCT elec.ENCODER(fixedTo: $.parts.bracket)
        platform            : -> CONSTRUCT mech.PART()
        motor               : -> CONSTRUCT mech.ROTARY_MOTOR()
        mot_to_platform     : -> CONSTRUCT mech.ROTARY_TRANSMISSION(
                                                inputRotor: ->
                                                    fixedTo: $.motor.rotor
                                                outputRotor: ->
                                                    fixedTo: $.platform)
        enc_to_platform     : -> CONSTRUCT mech.ROTARY_TRANSMISSION(
                                                inputRotor: ->
                                                    fixedTo: $.encoder.rotor
                                                outputRotor: ->
                                                    fixedTo: $.platform)
    properties:
        {}


########################################################################################################################
# Write the model to file
########################################################################################################################

m3_sys.WRITE "models/mtcs/m3/system.jsonld"


