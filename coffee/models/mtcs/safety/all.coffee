########################################################################################################################
#                                                                                                                      #
# Model importing all models related to the safety.                                                                    #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


REQUIRE "models/mtcs/safety/system.coffee"
REQUIRE "models/mtcs/safety/mechanics.coffee"
REQUIRE "models/mtcs/safety/electricity.coffee"
REQUIRE "models/mtcs/safety/software.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/safety/all" : "safety_all"

# import the dependencies
safety_all.IMPORT safety_sys
safety_all.IMPORT safety_mech
safety_all.IMPORT safety_elec
safety_all.IMPORT safety_soft


########################################################################################################################
# Write the model to file
########################################################################################################################

safety_all.WRITE "models/mtcs/safety/all.jsonld"
