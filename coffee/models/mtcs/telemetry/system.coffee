########################################################################################################################
#                                                                                                                      #
# Model containing the system design of the telemetry acquisition.                                                     #
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

MODEL "http://www.mercator.iac.es/onto/models/mtcs/telemetry/system" : "telemetry_sys"

# import the dependencies
telemetry_sys.IMPORT systemfactories
telemetry_sys.IMPORT tube
telemetry_sys.IMPORT roles
telemetry_sys.IMPORT mech
telemetry_sys.IMPORT elec


########################################################################################################################
# The project
########################################################################################################################
telemetry_sys.ADD MTCS_PROJECT "project",
    label: "Telemetry"
    comment: "The telemetry (temperatures, pressures, ...). VERY INCOMPLETE SYSTEM DESCRIPTION --> see cover_sys:project for inspiration"


#########################################################################################################################
## The concept
#########################################################################################################################

telemetry_sys.ADD MTCS_CONCEPT "concept",
    partOf: telemetry_sys.project
    requirements:
        software            : -> { comment: "Telemetry shall available in software"                         , isRequiredBy: roles.tech                  }
        opcua               : -> { comment: "Telemetry shall be remotely monitorable by OPC UA"             , isRequiredBy: roles.tech                  }
        safety              : -> { comment: "Telemetry shall be safe to use under all circumstances"        , isRequiredBy: [roles.tech,roles.observer] }
        reliability         : -> { comment: "Telemetry shall have a high reliability"                       , isRequiredBy: [roles.tech,roles.observer] }
        availability        : -> { comment: "Telemetry shall have a high availability"                      , isRequiredBy: [roles.tech,roles.observer] }
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

telemetry_sys.ADD MTCS_DESIGN "system",
    realizes: telemetry_sys.concept
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

telemetry_sys.ADD MTCS_DESIGN "cabinet",
    realizes: telemetry_sys.system.parts.cabinet
    parts:
        panel : -> { comment: "Alu panel"     }
        io    : -> { comment: "I/O terminals" }
        power : -> { comment: "Power supply"  }


########################################################################################################################
# The I/O design
########################################################################################################################

telemetry_sys.ADD MTCS_DESIGN "io",
    realizes: telemetry_sys.cabinet.parts.io
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


########################################################################################################################
# Write the model to file
########################################################################################################################

telemetry_sys.WRITE "models/mtcs/telemetry/system.jsonld"


