########################################################################################################################
#                                                                                                                      #
# Model importing all models related to M3.                                                                            #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

REQUIRE "models/mtcs/m3/system.coffee"
REQUIRE "models/mtcs/m3/mechanics.coffee"
REQUIRE "models/mtcs/m3/electricity.coffee"
REQUIRE "models/mtcs/m3/software.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/m3/all" : "m3_all"

# import the dependencies
m3_all.IMPORT m3_sys
m3_all.IMPORT m3_mech
m3_all.IMPORT m3_elec
m3_all.IMPORT m3_soft


########################################################################################################################
# Write the model to file
########################################################################################################################

m3_all.WRITE "models/mtcs/m3/all.jsonld"