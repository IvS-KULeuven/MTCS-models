########################################################################################################################
#                                                                                                                      #
# Model importing all models related to M1.                                                                            #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

REQUIRE "models/mtcs/telemetry/system.coffee"
REQUIRE "models/mtcs/telemetry/mechanics.coffee"
REQUIRE "models/mtcs/telemetry/electricity.coffee"
REQUIRE "models/mtcs/telemetry/software.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/telemetry/all" : "telemetry_all"

# import the dependencies
telemetry_all.IMPORT telemetry_sys
telemetry_all.IMPORT telemetry_mech
telemetry_all.IMPORT telemetry_elec
telemetry_all.IMPORT telemetry_soft


########################################################################################################################
# Write the model to file
########################################################################################################################

telemetry_all.WRITE "models/mtcs/telemetry/all.jsonld"