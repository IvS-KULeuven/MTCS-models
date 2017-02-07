########################################################################################################################
#                                                                                                                      #
# Model containing products by SICK.                                                                                   #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"


MODEL "http://www.mercator.iac.es/onto/models/external/sick" : "sick"

sick.IMPORT man
sick.IMPORT elec


########################################################################################################################
# Company
########################################################################################################################

sick.ADD MANUFACTURER(
        shortName : "SICK"
        longName  : "SICK"
        comment   : "Produces safety components") "company"


########################################################################################################################
# Safety relays
########################################################################################################################

sick.ADD ACTUATOR_TYPE(
    id              : "UE10-2FG2DO"
    comment         : "Safety relay UE10, 2 contact outputs"
    manufacturer    : sick.company
    terminals:
        B1 : -> { symbol: "B1"          , comment: "Relay channel 1 input" }
        B2 : -> { symbol: "B2"          , comment: "Relay channel 2 input" }
        A2 : -> { symbol: "A2"          , comment: "Relay input common" }
        Y1 : -> { symbol: "Y1"          , comment: "Monitoring contact 1" }
        Y2 : -> { symbol: "Y2"          , comment: "Monitoring contact 2" }
        13 : -> { symbol: "13"          , comment: "Channel 1 Normally Open IN" }
        14 : -> { symbol: "14"          , comment: "Channel 1 Normally Open OUT" }
        23 : -> { symbol: "23"          , comment: "Channel 2 Normally Open IN" }
        24 : -> { symbol: "24"          , comment: "Channel 2 Normally Open OUT" }) "UE10_2FG2DO"


########################################################################################################################
# Write the model to file
########################################################################################################################

sick.WRITE "models/external/sick.jsonld"

