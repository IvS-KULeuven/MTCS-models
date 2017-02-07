########################################################################################################################
#                                                                                                                      #
# Model containing products by PrehKeyTec.                                                                             #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"

MODEL "http://www.mercator.iac.es/onto/models/external/prehkeytec" : "prehkeytec"

prehkeytec.IMPORT man
prehkeytec.IMPORT elec


########################################################################################################################
# Company
########################################################################################################################

prehkeytec.ADD MANUFACTURER(
        shortName : "PrehKeyTec"
        longName  : "PrehKeyTec"
        comment   : "Produces connectors") "company"


########################################################################################################################
# Connectors
########################################################################################################################

prehkeytec.ADD CONNECTOR_TYPE(
    id              : "71206-050-0800"
    comment         : "5-way panel jack"
    manufacturer    : prehkeytec.company
    gender          : elec.female
    terminals:
        1  : -> { symbol: "1"   , comment: "Pin 1" }
        2  : -> { symbol: "2"   , comment: "Pin 2" }
        3  : -> { symbol: "3"   , comment: "Pin 3" }
        4  : -> { symbol: "4"   , comment: "Pin 4" }
        5  : -> { symbol: "5"   , comment: "Pin 5" }) "circular5WayPanelJack"


########################################################################################################################
# Write the model to file
########################################################################################################################

prehkeytec.WRITE "models/external/prehkeytec.jsonld"

