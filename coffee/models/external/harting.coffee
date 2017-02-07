########################################################################################################################
#                                                                                                                      #
# Model containing products by Harting                        .                                                        #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"


MODEL "http://www.mercator.iac.es/onto/models/external/harting" : "harting"

harting.IMPORT man
harting.IMPORT elec

########################################################################################################################
# Company
########################################################################################################################

harting.ADD MANUFACTURER(
        shortName : "Harting"
        longName  : "Harting"
        comment   : "Produces connectors, network components, ...") "company"


########################################################################################################################
# Power supplies
########################################################################################################################

harting.ADD CONNECTOR_TYPE(
    id              : "RJ45 F"
    comment         : "RJ45 female socket"
    manufacturer    : harting.company
    gender          : elec.female
    terminals:
        1  : -> { symbol: "white/green" , comment: "Pin 1" }
        2  : -> { symbol: "green"       , comment: "Pin 2" }
        3  : -> { symbol: "white/orange", comment: "Pin 3" }
        4  : -> { symbol: "blue"        , comment: "Pin 4" }
        5  : -> { symbol: "white/blue"  , comment: "Pin 5" }
        6  : -> { symbol: "orange"      , comment: "Pin 6" }
        7  : -> { symbol: "white/brown" , comment: "Pin 7" }
        8  : -> { symbol: "brown"       , comment: "Pin 8" }) "RJ45F"

harting.ADD CONNECTOR_TYPE(
    id              : "RJ45 M"
    comment         : "RJ45 male plug"
    manufacturer    : harting.company
    gender          : elec.male
    joinedWith      : harting.RJ45F
    terminals:
        1  : -> { symbol: "white/green" , comment: "Pin 1" }
        2  : -> { symbol: "green"       , comment: "Pin 2" }
        3  : -> { symbol: "white/orange", comment: "Pin 3" }
        4  : -> { symbol: "blue"        , comment: "Pin 4" }
        5  : -> { symbol: "white/blue"  , comment: "Pin 5" }
        6  : -> { symbol: "orange"      , comment: "Pin 6" }
        7  : -> { symbol: "white/brown" , comment: "Pin 7" }
        8  : -> { symbol: "brown"       , comment: "Pin 8" }) "RJ45M"


########################################################################################################################
# Write the model to file
########################################################################################################################

harting.WRITE "models/external/harting.jsonld"

