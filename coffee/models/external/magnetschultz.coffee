########################################################################################################################
#                                                                                                                      #
# Model containing products by Kuebler.                                                                                #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"

MODEL "http://www.mercator.iac.es/onto/models/external/magnetschultz" : "magnetschultz"

magnetschultz.IMPORT man
magnetschultz.IMPORT mech
magnetschultz.IMPORT elec


########################################################################################################################
# Company
########################################################################################################################

magnetschultz.ADD MANUFACTURER(
        shortName : "Magnet Schultz"
        longName  : "Magnet Schultz GmbH & Co. KG"
        comment   : "Produces magnets") "company"


########################################################################################################################
# Magnets
########################################################################################################################

magnetschultz.ADD ACTUATOR_TYPE(
    id:   "G_MH_x025",
    comment: "Holding magnet, 25mm diameter, 3.2 Watt"
    manufacturer: magnetschultz.company
    terminals:
        GND  : -> { symbol: "GND"  , comment: "GND contact" }
        VCC  : -> { symbol: "+24V" , comment: "+24V DC contact" }) "G_MH_x025"

########################################################################################################################
# Write the model to file
########################################################################################################################

magnetschultz.WRITE "models/external/magnetschultz.jsonld"
