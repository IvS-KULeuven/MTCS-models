########################################################################################################################
#                                                                                                                      #
# Model containing products by Pro-Power.                                                                              #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"
REQUIRE "metamodels/colors.coffee"

MODEL "http://www.mercator.iac.es/onto/models/external/propower" : "propower"

propower.IMPORT man
propower.IMPORT elec
propower.IMPORT colors


########################################################################################################################
# Company
########################################################################################################################

propower.ADD MANUFACTURER(
        shortName : "Pro-Power"
        longName  : "Pro-Power"
        comment   : "Produces cables") "company"


########################################################################################################################
# Cables
########################################################################################################################

propower.ADD CABLE_TYPE(
    id              : "PP000529"
    comment         : "3 Core + Screen, 0.22 mm2, 7 x 0.2mm"
    manufacturer    : propower.company
    wires:
        1  : -> { symbol: "1", comment: "Wire 1"    , color: colors.red }
        2  : -> { symbol: "2", comment: "Wire 2"    , color: colors.blue }
        3  : -> { symbol: "3", comment: "Wire 3"    , color: colors.green }
        screen : -> { symbol: "S", comment: "Screen of the cable" }) "Cable3CoreScreen"

propower.ADD CABLE_TYPE(
    id              : "PP000329"
    comment         : "25 Core + Screen, 0.22 mm², 7 x 0.2mm"
    manufacturer    : propower.company
    wires:
        1  : -> { symbol: "1", comment: "Wire 1"    , color: colors.red }
        2  : -> { symbol: "2", comment: "Wire 2"    , color: colors.blue }
        3  : -> { symbol: "3", comment: "Wire 3"    , color: colors.green }
        4  : -> { symbol: "4", comment: "Wire 4"    , color: colors.yellow }
        5  : -> { symbol: "5", comment: "Wire 5"    , color: colors.white }
        6  : -> { symbol: "6", comment: "Wire 6"    , color: colors.black }
        7  : -> { symbol: "7", comment: "Wire 7"    , color: colors.brown }
        8  : -> { symbol: "8", comment: "Wire 8"    , color: colors.violet }
        9  : -> { symbol: "9", comment: "Wire 9"    , color: colors.orange }
        10 : -> { symbol: "10", comment: "Wire 10"  , color: colors.pink }
        11 : -> { symbol: "11", comment: "Wire 11"  , color: colors.turquoise }
        12 : -> { symbol: "12", comment: "Wire 12"  , color: colors.gray }
        13 : -> { symbol: "13", comment: "Wire 13"  , color: [colors.red, colors.blue] }
        14 : -> { symbol: "14", comment: "Wire 14"  , color: [colors.green, colors.red] }
        15 : -> { symbol: "15", comment: "Wire 15"  , color: [colors.yellow, colors.red] }
        16 : -> { symbol: "16", comment: "Wire 16"  , color: [colors.white, colors.red] }
        17 : -> { symbol: "17", comment: "Wire 17"  , color: [colors.red, colors.black] }
        18 : -> { symbol: "18", comment: "Wire 18"  , color: [colors.red, colors.brown] }
        19 : -> { symbol: "19", comment: "Wire 19"  , color: [colors.yellow, colors.blue] }
        20 : -> { symbol: "20", comment: "Wire 20"  , color: [colors.white, colors.blue] }
        21 : -> { symbol: "21", comment: "Wire 21"  , color: [colors.blue, colors.black] }
        22 : -> { symbol: "22", comment: "Wire 22"  , color: [colors.orange, colors.blue] }
        23 : -> { symbol: "23", comment: "Wire 23"  , color: [colors.green, colors.blue] }
        24 : -> { symbol: "24", comment: "Wire 24"  , color: [colors.gray, colors.blue] }
        25 : -> { symbol: "25", comment: "Wire 25"  , color: [colors.yellow, colors.green] }
        screen : -> { symbol: "S", comment: "Screen of the cable" }) "Cable25CoreScreen"


########################################################################################################################
# Write the model to file
########################################################################################################################

propower.WRITE "models/external/propower.jsonld"

