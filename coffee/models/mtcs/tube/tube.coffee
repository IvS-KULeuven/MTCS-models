########################################################################################################################
#                                                                                                                      #
# Temporary model : the tube needs to be integrated in a general telescope system model.                               #
#                                                                                                                      #
########################################################################################################################


require "ontoscript"


REQUIRE "models/util/systemfactories.coffee"

MODEL "http://www.mercator.iac.es/onto/models/tube" : "tube"

# import the dependencies
tube.IMPORT systemfactories

########################################################################################################################
# Define the tube concept
########################################################################################################################

# define a concept
tube.ADD MTCS_CONCEPT "concept",
    states:
        sealed       : -> { comment: "The tube is sealed"       }
        unobstructed : -> { comment: "The tube is unobstructed" }


########################################################################################################################
# Write the model to file
########################################################################################################################

tube.WRITE "models/mtcs/tube/tube.jsonld"