########################################################################################################################
#                                                                                                                      #
# Model containing the system design of the telescope hydraulics.                                                      #
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

MODEL "http://www.mercator.iac.es/onto/models/mtcs/hydraulics/system" : "hydraulics_sys"

# import the dependencies
hydraulics_sys.IMPORT systemfactories
hydraulics_sys.IMPORT roles
hydraulics_sys.IMPORT mech
hydraulics_sys.IMPORT elec


########################################################################################################################
# The project
########################################################################################################################

hydraulics_sys.ADD MTCS_PROJECT "project",
    label: "Hydraulics"
    comment: "The hydraulics system. VERY INCOMPLETE SYSTEM DESCRIPTION --> see cover_sys:project for inspiration"


########################################################################################################################
# The concept
########################################################################################################################

hydraulics_sys.ADD MTCS_CONCEPT "concept",
    partOf: hydraulics_sys.project
    requirements:
        software            : -> { comment: "Hydraulics shall be controlled by the PLC software"           , isRequiredBy: roles.tech                  }
        opcua               : -> { comment: "Hydraulics shall be remotely monitorable by OPC UA"           , isRequiredBy: roles.tech                  }
        reliability         : -> { comment: "Hydraulics shall have a high reliability"                     , isRequiredBy: [roles.tech,roles.observer] }
        availability        : -> { comment: "Hydraulics shall have a high availability"                    , isRequiredBy: [roles.tech,roles.observer] }
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

hydraulics_sys.ADD MTCS_DESIGN "system",
    realizes: hydraulics_sys.concept
    parts:
        cabinet: ->
            comment: "Electrical cabinet"
    properties:
        {}
    states:
        {}

########################################################################################################################
# The cabinet design
########################################################################################################################

hydraulics_sys.ADD MTCS_DESIGN "cabinet",
    realizes: hydraulics_sys.system.parts.cabinet
    parts:
        panel : -> { comment: "Alu panel"     }
        io    : -> { comment: "I/O terminals" }
        power : -> { comment: "Power supply"  }


########################################################################################################################
# The I/O design
########################################################################################################################

hydraulics_sys.ADD MTCS_DESIGN "io",
    realizes: hydraulics_sys.cabinet.parts.io
    parts:
        slot0   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot1   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot2   : -> CONSTRUCT IO_MODULE_INSTANCE()


########################################################################################################################
# Write the model to file
########################################################################################################################

hydraulics_sys.WRITE "models/mtcs/hydraulics/system.jsonld"


