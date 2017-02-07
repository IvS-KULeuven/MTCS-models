########################################################################################################################
#                                                                                                                      #
# Model importing all models related to the Mercator TCS (MTCS).                                                       #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# subsystems
REQUIRE "models/mtcs/cover/all.coffee"
REQUIRE "models/mtcs/m1/all.coffee"
REQUIRE "models/mtcs/m2/all.coffee"
REQUIRE "models/mtcs/m3/all.coffee"
REQUIRE "models/mtcs/telemetry/all.coffee"
REQUIRE "models/mtcs/services/all.coffee"
REQUIRE "models/mtcs/safety/all.coffee"
REQUIRE "models/mtcs/hydraulics/all.coffee"
REQUIRE "models/mtcs/axes/all.coffee"

# MTCS main
REQUIRE "models/mtcs/software.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/all" : "mtcs_all"

# subsystems
mtcs_all.IMPORT cover_all
mtcs_all.IMPORT m1_all
mtcs_all.IMPORT m2_all
mtcs_all.IMPORT m3_all
mtcs_all.IMPORT telemetry_all
mtcs_all.IMPORT services_all
mtcs_all.IMPORT hydraulics_all
mtcs_all.IMPORT axes_all

# MTCS main
mtcs_all.IMPORT mtcs_soft


########################################################################################################################
# Write the model to file
########################################################################################################################

mtcs_all.WRITE "models/mtcs/all.jsonld"