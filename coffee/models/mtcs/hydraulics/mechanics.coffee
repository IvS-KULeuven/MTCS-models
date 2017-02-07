########################################################################################################################
#                                                                                                                      #
# Model of the telescope hydraulics mechanics.                                                                              #
#                                                                                                                      #
# Still TODO! Model is just a placeholder for now.                                                                     #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# models
REQUIRE "models/mtcs/hydraulics/system.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/hydraulics/mechanics" : "hydraulics_mech"

hydraulics_mech.IMPORT hydraulics_sys


########################################################################################################################
# Develop the mechanical model below
########################################################################################################################

# TODO

########################################################################################################################
# Write the model to file
########################################################################################################################


hydraulics_mech.WRITE "models/mtcs/hydraulics/mechanics.jsonld"