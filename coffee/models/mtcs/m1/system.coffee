########################################################################################################################
#                                                                                                                      #
# Model containing the system design of the primary mirror M1.                                                         #
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

MODEL "http://www.mercator.iac.es/onto/models/mtcs/m1/system" : "m1_sys"

# import the dependencies
m1_sys.IMPORT systemfactories
m1_sys.IMPORT tube
m1_sys.IMPORT roles
m1_sys.IMPORT mech
m1_sys.IMPORT elec


########################################################################################################################
# The project
########################################################################################################################

m1_sys.ADD MTCS_PROJECT "project",
    label: "M1"
    comment: "The primary mirror (M1). VERY INCOMPLETE SYSTEM DESCRIPTION --> see cover_sys:project for inspiration"


#########################################################################################################################
## The concept
#########################################################################################################################

m1_sys.ADD MTCS_CONCEPT "concept",
    partOf: m1_sys.project
    requirements:
        radialSupport       : -> { comment: "M1 control system shall support the primrary mirror evenly in radial direction"            , isRequiredBy: roles.tech                   }
        axialSupport        : -> { comment: "M1 control system shall support the primrary mirror evenly in axial direction"             , isRequiredBy: roles.tech                   }
        plc                 : -> { comment: "M1 control system shall be implemented on a PLC"                                           , isRequiredBy: roles.tech                   }
        opcua               : -> { comment: "M1 control system shall be remotely controlled and monitored by OPC UA"                    , isRequiredBy: roles.tech                   }
        safety              : -> { comment: "M1 control system shall be safe to use under all circumstances"                            , isRequiredBy: [roles.tech,roles.observer]  }
        reliability         : -> { comment: "M1 control system shall have a high reliability"                                           , isRequiredBy: [roles.tech,roles.observer]  }
        availability        : -> { comment: "M1 control system shall have a very high availability"                                     , isRequiredBy: [roles.tech,roles.observer]  }
        autoMode            : -> { comment: "M1 control system shall have an auto mode for normal (i.e. open or closed loop) operation" , isRequiredBy: roles.tech                   }
        manualMode          : -> { comment: "M1 control system shall have a manual mode to adjust the support manually"                 , isRequiredBy: roles.tech , isDerivedFrom: $.requirements.availability }
        shutdown            : -> { comment: "M1 control system shall operate also when the software is not initialized"                 , isDerivedFrom: $.requirements.availability }
        initialized         : -> { comment: "M1 control system shall operate in manual or auto mode when initialized"                   , isDerivedFrom: [ $.requirements.autoMode, $.requirements.manualMode ] }
    states:
        auto                : -> { comment: "In auto mode, M1 is being radially and axially supported with optimal setpoint"            , isDerivedFrom: $.requirements.autoMode }
        manual              : -> { comment: "In manual mode, M1 may be radially and/or axially supported with manual setpoint"          , isDerivedFrom: $.requirements.manualMode }
        initialized         : -> { comment: "When initialized, M1 control can be operated in auto and manual mode"}
        shutdown            : -> { comment: "When shutdown, M1  supported"}
    constraints:
        {}
    tests:
        {}


########################################################################################################################
# The system design
########################################################################################################################

m1_sys.ADD MTCS_DESIGN "system",
    realizes: m1_sys.concept
    parts:
        axialSupport: ->
            comment         : "The axial support"
            states:
                auto        : -> {}
                manual      : -> {}
        radialSupport: ->
            comment         : "The radial support"
            states:
                auto        : -> {}
                manual      : -> {}
        cabinet: ->
            comment         : "Electrical cabinet"
        inclinometer: ->
            comment         : "Inclinometer to measure the tube/M1 angle"
    properties:
        {}
    states:
        auto                : -> { sameAs: AND($.parts.axialSupport.states.auto, $.parts.radialSupport.states.auto) }
        manual              : -> { sameAs: NOT($.states.auto)                                                       }

########################################################################################################################
# The cabinet design
########################################################################################################################

m1_sys.ADD MTCS_DESIGN "cabinet",
    realizes: m1_sys.system.parts.cabinet
    parts:
        panel : -> { comment: "Alu panel"     }
        io    : -> { comment: "I/O terminals" }
        power : -> { comment: "Power supply"  }


########################################################################################################################
# The I/O design
########################################################################################################################

m1_sys.ADD MTCS_DESIGN "io",
    realizes: m1_sys.cabinet.parts.io
    parts:
        slot0   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot1   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot2   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot3   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot4   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot5   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot6   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot7   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot8   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot9   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot10  : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot11  : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot12  : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot13  : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot1415: -> CONSTRUCT IO_MODULE_INSTANCE()
        slot15  : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot16  : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot17  : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot18  : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot19  : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot20  : -> CONSTRUCT IO_MODULE_INSTANCE()


########################################################################################################################
# Axial support
########################################################################################################################

m1_sys.ADD MTCS_DESIGN "axialSupport",
    realizes: m1_sys.system.parts.axialSupport
    parts:
        fixedSupportSouth       : -> CONSTRUCT mech.PART(fixedTo: tube.concept)
        fixedSupportNorthEast   : -> CONSTRUCT mech.PART(fixedTo: tube.concept)
        fixedSupportNorthWest   : -> CONSTRUCT mech.PART(fixedTo: tube.concept)
    properties:
        southForce              : -> CONSTRUCT NEWTON()
        northEastForce          : -> CONSTRUCT NEWTON()
        northWestForce          : -> CONSTRUCT NEWTON()
        maxForceDifference      : -> CONSTRUCT NEWTON(20.0)
        regulatorPressure       : -> CONSTRUCT BAR()
        actualPressureSetpoint  : -> CONSTRUCT BAR()
        maxPressureDifference   : -> CONSTRUCT BAR(0.5)
#    states:
#        auto                    : -> { realizes: m1_sys.system.parts.axialSupport.states.auto   }
#        manual                  : -> { realizes: m1_sys.system.parts.axialSupport.states.manual }
    constraints:
        forceDistribution: ->
            always:
               if      : $.states.auto
               then    : LT( DIV(SUM($.properties.southForce,
                                     $.properties.northEastForce,
                                     $.properties.northWestForce), UNITLESS(3) "noOfForces"),
                                 $.properties.maxForceDifference)
            represents : m1_sys.concept.requirements.axialSupport
        pressureControl: ->
            always      : LT( ABS( $.properties.regulatorPressure, $.properties.actualPressureSetpoint ), $.properties.maxPressureDifference)
            represents  : m1_sys.concept.requirements.axialSupport


########################################################################################################################
# Radial support
########################################################################################################################

m1_sys.ADD MTCS_DESIGN "radialSupport",
    realizes: m1_sys.system.parts.radialSupport
    parts:
        {}
    properties:
        regulatorPressure       : -> CONSTRUCT BAR()
        actualPressureSetpoint  : -> CONSTRUCT BAR()
        maxPressureDifference   : -> CONSTRUCT BAR(0.5)
#    states:
#        auto                    : -> { realizes: m1_sys.system.parts.radialSupport.states.auto   }
#        manual                  : -> { realizes: m1_sys.system.parts.radialSupport.states.manual }
    constraints:
        pressureControl: ->
            always      : LT( ABS( $.properties.regulatorPressure, $.properties.actualPressureSetpoint ), $.properties.maxPressureDifference)
            represents  : m1_sys.concept.requirements.radialSupport


########################################################################################################################
# Write the model to file
########################################################################################################################

m1_sys.WRITE "models/mtcs/m1/system.jsonld"


