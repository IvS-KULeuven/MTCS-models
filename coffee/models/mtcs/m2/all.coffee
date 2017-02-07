########################################################################################################################
#                                                                                                                      #
# Model importing all models related to M2.                                                                            #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

REQUIRE "models/mtcs/m2/system.coffee"
REQUIRE "models/mtcs/m2/mechanics.coffee"
REQUIRE "models/mtcs/m1/electricity.coffee" # defined at M1 electricity model !!!
REQUIRE "models/mtcs/m2/software.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/m2/all" : "m2_all"

# import the dependencies
m2_all.IMPORT m2_sys
m2_all.IMPORT m2_mech
m2_all.IMPORT m1_elec # see m1/electricity.coffee
m2_all.IMPORT m2_soft


########################################################################################################################
# Write the model to file
########################################################################################################################

m2_all.WRITE "models/mtcs/m2/all.jsonld"
