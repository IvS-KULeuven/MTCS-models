########################################################################################################################
#                                                                                                                      #
# Model importing all common utility models.                                                                           #
#                                                                                                                      #
########################################################################################################################


require "ontoscript"


REQUIRE "models/mtcs/common/software.coffee"
REQUIRE "models/mtcs/common/roles.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/common/all" : "common_all"

common_all.IMPORT common_soft
common_all.IMPORT roles


########################################################################################################################
# Write the model to file
########################################################################################################################

common_all.WRITE "models/mtcs/common/all.jsonld"
