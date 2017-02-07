########################################################################################################################
#                                                                                                                      #
# Model importing all models related to the hydraulics.                                                                #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


REQUIRE "models/mtcs/hydraulics/system.coffee"
REQUIRE "models/mtcs/hydraulics/mechanics.coffee"
REQUIRE "models/mtcs/hydraulics/electricity.coffee"
REQUIRE "models/mtcs/hydraulics/software.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/hydraulics/all" : "hydraulics_all"

# import the dependencies
hydraulics_all.IMPORT hydraulics_sys
hydraulics_all.IMPORT hydraulics_mech
hydraulics_all.IMPORT hydraulics_elec
hydraulics_all.IMPORT hydraulics_soft


########################################################################################################################
# Write the model to file
########################################################################################################################

hydraulics_all.WRITE "models/mtcs/hydraulics/all.jsonld"