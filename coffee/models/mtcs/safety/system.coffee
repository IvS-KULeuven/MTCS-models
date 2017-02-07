########################################################################################################################
#                                                                                                                      #
# Model containing the system design of the telescope safety.                                                          #
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
REQUIRE "models/mtcs/common/roles.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/safety/system" : "safety_sys"

# import the dependencies
safety_sys.IMPORT systemfactories
safety_sys.IMPORT roles
safety_sys.IMPORT mech
safety_sys.IMPORT elec


########################################################################################################################
# The project
########################################################################################################################

safety_sys.ADD MTCS_PROJECT "project",
    label: "Safety"
    comment: "The safety system.  VERY INCOMPLETE SYSTEM DESCRIPTION --> see cover_sys:project for inspiration"


########################################################################################################################
# The concept
########################################################################################################################

safety_sys.ADD MTCS_CONCEPT "concept",
    partOf: safety_sys.project
    requirements:
        software            : -> { comment: "Safety shall be controlled by the PLC software"                , isRequiredBy: roles.tech                  }
        opcua               : -> { comment: "Safety shall remotely monitorable by OPC UA"                   , isRequiredBy: roles.tech                  }
        reliability         : -> { comment: "Safety shall have a high reliability"                          , isRequiredBy: [roles.tech,roles.observer] }
        availability        : -> { comment: "Safety shall have a high availability"                         , isRequiredBy: [roles.tech,roles.observer] }
    properties:
        {}
    states:
        {}
    constraints:
        {}
    tests:
        {}


########################################################################################################################
# The system design
########################################################################################################################

safety_sys.ADD MTCS_DESIGN "system",
    realizes: safety_sys.concept
    parts:
        cabinet: ->
            comment         : "Electrical cabinet"
    properties:
        {}
    states:
        {}


########################################################################################################################
# The cabinet design
########################################################################################################################

safety_sys.ADD MTCS_DESIGN "cabinet",
    realizes: safety_sys.system.parts.cabinet
    parts:
        panel : -> { comment: "Alu panel"     }
        io    : -> { comment: "I/O terminals" }
        power : -> { comment: "Power supply"  }


########################################################################################################################
# The I/O design
########################################################################################################################

safety_sys.ADD MTCS_DESIGN "io",
    realizes: safety_sys.cabinet.parts.io
    parts:
        slot0   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot1   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot2   : -> CONSTRUCT IO_MODULE_INSTANCE()


########################################################################################################################
# Write the model to file
########################################################################################################################

safety_sys.WRITE "models/mtcs/safety/system.jsonld"


