########################################################################################################################
#                                                                                                                      #
# Model importing all models related to the services.                                                                  #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

REQUIRE "models/mtcs/services/system.coffee"
REQUIRE "models/mtcs/services/mechanics.coffee"
REQUIRE "models/mtcs/services/electricity.coffee"
REQUIRE "models/mtcs/services/software.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/services/all" : "services_all"

# import the dependencies
services_all.IMPORT services_sys
services_all.IMPORT services_mech
services_all.IMPORT services_elec
services_all.IMPORT services_soft


########################################################################################################################
# Write the model to file
########################################################################################################################

services_all.WRITE "models/mtcs/services/all.jsonld"