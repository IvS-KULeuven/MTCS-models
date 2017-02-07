########################################################################################################################
#                                                                                                                      #
# Model of the telemetry mechanics.                                                                              #
#                                                                                                                      #
# Still TODO! Model is just a placeholder for now.                                                                     #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# models
REQUIRE "models/mtcs/telemetry/system.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/telemetry/mechanics" : "telemetry_mech"

telemetry_mech.IMPORT telemetry_sys


########################################################################################################################
# Develop the mechanical model below
########################################################################################################################

# TODO

########################################################################################################################
# Write the model to file
########################################################################################################################


telemetry_mech.WRITE "models/mtcs/telemetry/mechanics.jsonld"