########################################################################################################################
#                                                                                                                      #
# Model just defining the IvS                                                                                          #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"


MODEL "http://www.mercator.iac.es/onto/models/external/ivs" : "ivs"

ivs.IMPORT man
ivs.IMPORT elec


########################################################################################################################
# Organization
########################################################################################################################

ivs.ADD ORGANIZATION(
        shortName : "IvS"
        longName  : "Institute of Astronomy"
        comment   : "That's us!") "organization"


########################################################################################################################
# Write the model to file
########################################################################################################################

ivs.WRITE "models/external/ivs.jsonld"

