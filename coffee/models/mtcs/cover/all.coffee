########################################################################################################################
#                                                                                                                      #
# Model importing all models related to the telescope cover.                                                           #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


REQUIRE "models/mtcs/cover/system.coffee"
REQUIRE "models/mtcs/cover/mechanics.coffee"
REQUIRE "models/mtcs/cover/electricity.coffee"
REQUIRE "models/mtcs/cover/software.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/cover/all" : "cover_all"

# import the dependencies
cover_all.IMPORT cover_sys
cover_all.IMPORT cover_mech
cover_all.IMPORT cover_elec
cover_all.IMPORT cover_soft


########################################################################################################################
# Write the model to file
########################################################################################################################

cover_all.WRITE "models/mtcs/cover/all.jsonld"

