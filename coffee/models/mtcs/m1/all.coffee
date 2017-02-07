########################################################################################################################
#                                                                                                                      #
# Model importing all models related to M1.                                                                            #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


REQUIRE "models/mtcs/m1/system.coffee"
REQUIRE "models/mtcs/m1/mechanics.coffee"
REQUIRE "models/mtcs/m1/electricity.coffee"
REQUIRE "models/mtcs/m1/software.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/m1/all" : "m1_all"

# import the dependencies
m1_all.IMPORT m1_sys
m1_all.IMPORT m1_mech
m1_all.IMPORT m1_elec
m1_all.IMPORT m1_soft


########################################################################################################################
# Write the model to file
########################################################################################################################

m1_all.WRITE "models/mtcs/m1/all.jsonld"