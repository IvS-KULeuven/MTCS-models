########################################################################################################################
#                                                                                                                      #
# Model importing all axes-related models.                                                                             #
#                                                                                                                      #
########################################################################################################################


require "ontoscript"


REQUIRE "models/mtcs/axes/system.coffee"
REQUIRE "models/mtcs/axes/mechanics.coffee"
REQUIRE "models/mtcs/axes/electricity.coffee"
REQUIRE "models/mtcs/axes/software.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/axes/all" : "axes_all"

# import the dependencies
axes_all.IMPORT axes_sys
axes_all.IMPORT axes_mech
axes_all.IMPORT axes_elec
axes_all.IMPORT axes_soft


########################################################################################################################
# Write the model to file
########################################################################################################################

axes_all.WRITE "models/mtcs/axes/all.jsonld"