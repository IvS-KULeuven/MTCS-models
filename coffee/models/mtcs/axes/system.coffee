########################################################################################################################
#                                                                                                                      #
# Model containing the system design of the telescope axes.                                                            #
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

MODEL "http://www.mercator.iac.es/onto/models/mtcs/axes/system" : "axes_sys"

# import the dependencies
axes_sys.IMPORT systemfactories
axes_sys.IMPORT roles
axes_sys.IMPORT mech
axes_sys.IMPORT elec


########################################################################################################################
# The project
########################################################################################################################

axes_sys.ADD MTCS_PROJECT "project",
    label: "Axes"
    comment: "The axes of the telescope. VERY INCOMPLETE SYSTEM DESCRIPTION --> see cover_sys:project for inspiration"


########################################################################################################################
## The concept
########################################################################################################################

axes_sys.ADD MTCS_CONCEPT "concept",
    partOf: axes_sys.project
    requirements:
        software            : -> { comment: "Axes shall be controlled by software"                   , isRequiredBy: roles.tech                  }
        opcua               : -> { comment: "Axes shall be remotely monitorable by OPC UA"           , isRequiredBy: roles.tech                  }
        reliability         : -> { comment: "Axes shall have a high reliability"                     , isRequiredBy: [roles.tech,roles.observer] }
        availability        : -> { comment: "Axes shall have a high availability"                    , isRequiredBy: [roles.tech,roles.observer] }
        # TODO
    properties:
        {}
        # TODO
    states:
        {}
        # TODO
    constraints:
        {}
        # TODO
    tests:
        {}
        # TODO


########################################################################################################################
# The system design
########################################################################################################################

axes_sys.ADD MTCS_DESIGN "system",
    realizes: axes_sys.concept
    parts:
        panel: ->
            comment         : "Electrical panel"
    properties:
        {}
        # TODO
    states:
        {}
        # TODO


########################################################################################################################
# The cabinet design
########################################################################################################################

axes_sys.ADD MTCS_DESIGN "panel",
    realizes: axes_sys.system.parts.panel
    parts:
        panel : -> { comment: "Alu panel"     }
        io    : -> { comment: "I/O terminals" }
        power : -> { comment: "Power supply"  }


########################################################################################################################
# Write the model to file
########################################################################################################################

axes_sys.WRITE "models/mtcs/axes/system.jsonld"


