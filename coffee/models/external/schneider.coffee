########################################################################################################################
#                                                                                                                      #
# Model containing products by Schneider Electric.                                                                     #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"
REQUIRE "metamodels/colors.coffee"

MODEL "http://www.mercator.iac.es/onto/models/external/schneider" : "schneider"

schneider.IMPORT man
schneider.IMPORT elec
schneider.IMPORT colors


########################################################################################################################
# Company
########################################################################################################################

schneider.ADD MANUFACTURER(
        shortName : "Schneider Electric"
        longName  : "Schneider Electric"
        comment   : "Our supplier of e.g. circuit breakers") "company"


########################################################################################################################
# Circuit breakers
########################################################################################################################

schneider.ADD CIRCUIT_BREAKER_TYPE(
    id              : "A9F79206"
    comment         : "2 Phase 6 Amps circuit breaker (IC60N 2P C6)"
    manufacturer    : schneider.company
    terminals:
        1  : -> { symbol: "1", comment: "Phase 1 IN" }
        2  : -> { symbol: "2", comment: "Phase 1 OUT" }
        3  : -> { symbol: "3", comment: "Phase 2 IN" }
        4  : -> { symbol: "4", comment: "Phase 2 OUT" }
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[2] ]
        2  : -> terminals: [ self.terminals[3], self.terminals[4] ]) "CircuitBreaker2Ph6A"

schneider.ADD CIRCUIT_BREAKER_TYPE(
    id              : "A9F79210"
    comment         : "2 Phase 10 Amps circuit breaker (IC60N 2P C10)"
    manufacturer    : schneider.company
    terminals:
        1  : -> { symbol: "1", comment: "Phase 1 IN" }
        2  : -> { symbol: "2", comment: "Phase 1 OUT" }
        3  : -> { symbol: "3", comment: "Phase 2 IN" }
        4  : -> { symbol: "4", comment: "Phase 2 OUT" }
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[2] ]
        2  : -> terminals: [ self.terminals[3], self.terminals[4] ]) "CircuitBreaker2Ph10A"

schneider.ADD CIRCUIT_BREAKER_TYPE(
    id              : "A9F79216"
    comment         : "2 Phase 16 Amps circuit breaker (IC60N 2P C16)"
    manufacturer    : schneider.company
    terminals:
        1  : -> { symbol: "1", comment: "Phase 1 IN" }
        2  : -> { symbol: "2", comment: "Phase 1 OUT" }
        3  : -> { symbol: "3", comment: "Phase 2 IN" }
        4  : -> { symbol: "4", comment: "Phase 2 OUT" }
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[2] ]
        2  : -> terminals: [ self.terminals[3], self.terminals[4] ]) "CircuitBreaker2Ph16A"


########################################################################################################################
# Write the model to file
########################################################################################################################

schneider.WRITE "models/external/schneider.jsonld"

