########################################################################################################################
#                                                                                                                      #
# Model containing the system design of the services system.                                                             #
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

MODEL "http://www.mercator.iac.es/onto/models/mtcs/services/system" : "services_sys"

# import the dependencies
services_sys.IMPORT systemfactories
services_sys.IMPORT roles
services_sys.IMPORT mech
services_sys.IMPORT elec


########################################################################################################################
# The project
########################################################################################################################

services_sys.ADD MTCS_PROJECT "project",
    label: "Services"
    comment: "The common services.  VERY INCOMPLETE SYSTEM DESCRIPTION --> see cover_sys:project for inspiration"


########################################################################################################################
# The concept
########################################################################################################################

services_sys.ADD MTCS_CONCEPT "concept",
    partOf: services_sys.project
    requirements:
        software            : -> { comment: "Services info shall be available in software"                    , isRequiredBy: roles.tech                  }
        opcua               : -> { comment: "Services info shall be remotely monitorable by OPC UA"           , isRequiredBy: roles.tech                  }
        reliability         : -> { comment: "Services info shall have a high reliability"                     , isRequiredBy: [roles.tech,roles.observer] }
        availability        : -> { comment: "Services info shall have a high availability"                    , isRequiredBy: [roles.tech,roles.observer] }
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

services_sys.ADD MTCS_DESIGN "system",
    realizes: services_sys.concept
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

services_sys.ADD MTCS_DESIGN "cabinet",
    realizes: services_sys.system.parts.cabinet
    parts:
        panel : -> { comment: "Alu panel"     }
        io    : -> { comment: "I/O terminals" }
        power : -> { comment: "Power supply"  }


########################################################################################################################
# The I/O design
########################################################################################################################

services_sys.ADD MTCS_DESIGN "io",
    realizes: services_sys.cabinet.parts.io
    parts:
        slot0   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot1   : -> CONSTRUCT IO_MODULE_INSTANCE()
        slot2   : -> CONSTRUCT IO_MODULE_INSTANCE()


########################################################################################################################
# Write the model to file
########################################################################################################################

services_sys.WRITE "models/mtcs/services/system.jsonld"


