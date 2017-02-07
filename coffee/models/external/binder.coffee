########################################################################################################################
#                                                                                                                      #
# Model containing products by Binder                         .                                                        #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"


MODEL "http://www.mercator.iac.es/onto/models/external/binder" : "binder"

binder.IMPORT man
binder.IMPORT elec


########################################################################################################################
# Company
########################################################################################################################

binder.ADD MANUFACTURER(
        shortName : "Binder"
        longName  : "Binder"
        comment   : "Produces connectors") "company"


########################################################################################################################
# Connectors
########################################################################################################################

binder.ADD CONNECTOR_TYPE(
    id              : "09-0304-00-02"
    comment         : "2-way panel socket circular connector (female)"
    gender          : elec.female
    manufacturer    : binder.company
    terminals:
        1     : -> { symbol: "1"      , comment: "Pin 1" }
        2     : -> { symbol: "2"      , comment: "Pin 2" }
        shell : -> { symbol: "SH"  , comment: "Shell connection" }) "circular2WayFemalePanelSocket"


binder.ADD CONNECTOR_TYPE(
    id              : "09-0303-00-02"
    comment         : "2-way panel socket circular connector (male)"
    gender          : elec.male
    manufacturer    : binder.company
    terminals:
        1     : -> { symbol: "1"      , comment: "Pin 1" }
        2     : -> { symbol: "2"      , comment: "Pin 2" }
        shell : -> { symbol: "SH"  , comment: "Shell connection" }) "circular2WayMalePanelSocket"


binder.ADD CONNECTOR_TYPE(
    id              : "09-???"
    comment         : "3-way panel socket circular connector"
    gender          : elec.female
    manufacturer    : binder.company
    terminals:
        1  : -> { symbol: "1"   , comment: "Pin 1" }
        2  : -> { symbol: "2"   , comment: "Pin 2" }
        3  : -> { symbol: "3"   , comment: "Pin 3" }) "circular3WayPanelSocket"


binder.ADD CONNECTOR_TYPE(
    id              : "09-0328-00-07"
    comment         : "7-way panel socket circular connector"
    gender          : elec.female
    manufacturer    : binder.company
    terminals:
        1  : -> { symbol: "1"   , comment: "Pin 1" }
        2  : -> { symbol: "2"   , comment: "Pin 2" }
        3  : -> { symbol: "3"   , comment: "Pin 2" }
        4  : -> { symbol: "4"   , comment: "Pin 2" }
        5  : -> { symbol: "5"   , comment: "Pin 2" }
        6  : -> { symbol: "6"   , comment: "Pin 2" }
        7  : -> { symbol: "7"   , comment: "Pin 2" }) "circular7WayPanelSocket"


########################################################################################################################
# Write the model to file
########################################################################################################################

binder.WRITE "models/external/binder.jsonld"

