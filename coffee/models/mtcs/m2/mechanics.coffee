########################################################################################################################
#                                                                                                                      #
# Model of the telescope M2 mechanics.                                                                              #
#                                                                                                                      #
# Still TODO! Model is just a placeholder for now.                                                                     #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# models
REQUIRE "models/mtcs/m2/system.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/m2/mechanics" : "m2_mech"

m2_mech.IMPORT m2_sys


########################################################################################################################
# Develop the mechanical model below
########################################################################################################################

# TODO

########################################################################################################################
# Write the model to file
########################################################################################################################


m2_mech.WRITE "models/mtcs/m2/mechanics.jsonld"