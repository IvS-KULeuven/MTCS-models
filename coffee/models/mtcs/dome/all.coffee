########################################################################################################################
#                                                                                                                      #
# Model importing all models related to the dome.                                                                      #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


#REQUIRE "models/mtcs/dome/electricity.coffee"
REQUIRE "models/mtcs/dome/software.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/dome/all" : "dome_all"

# import the dependencies
#dome_all.IMPORT dome_elec
dome_all.IMPORT dome_soft


########################################################################################################################
# Write the model to file
########################################################################################################################

dome_all.WRITE "models/mtcs/dome/all.jsonld"

