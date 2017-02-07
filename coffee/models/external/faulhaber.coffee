########################################################################################################################
#                                                                                                                      #
# Model containing products by Faulhaber                      .                                                        #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"

REQUIRE "models/external/various.coffee"

MODEL "http://www.mercator.iac.es/onto/models/external/faulhaber" : "faulhaber"

# import the metamodels
faulhaber.IMPORT man
faulhaber.IMPORT elec
faulhaber.IMPORT various


########################################################################################################################
# Company
########################################################################################################################

faulhaber.ADD MANUFACTURER(
        shortName : "Faulhaber"
        longName  : "Dr. Fritz Faulhaber GmbH & Co. KG"
        comment   : "Produces miniature motors, drives, gearboxes, ...") "company"


########################################################################################################################
# Drives
########################################################################################################################

faulhaber.ADD DRIVE_TYPE(
    id              : "MCBL3006_S_CO"
    comment         : "MCBL3006 CANopen controller"
    manufacturer    : faulhaber.company
    terminals       :
        1  : -> symbol: "TxD"     , comment: "CANopen TxD"
        2  : -> symbol: "RxD"     , comment: "CANopen RxD"
        3  : -> symbol: "AGND"    , comment: "Analog input GND"
        4  : -> symbol: "Fault"   , comment: "Fault output"
        5  : -> symbol: "AnIn"    , comment: "Analog Input"
        6  : -> symbol: "Ub"      , comment: "+24V supply"
        7  : -> symbol: "GND"     , comment: "GND"
        8  : -> symbol: "3.In"    , comment: "Third input"
        9  : -> symbol: "Hall A"  , comment: "Motor hall sensor A"
        10 : -> symbol: "Hall B"  , comment: "Motor hall sensor B"
        11 : -> symbol: "Hall C"  , comment: "Motor hall sensor C"
        12 : -> symbol: "Ucc"     , comment: "Motor hall sensor supply +5V"
        13 : -> symbol: "SGND"    , comment: "Motor hall sensor signal GND"
        14 : -> symbol: "Phase A" , comment: "Motor phase A"
        15 : -> symbol: "Phase B" , comment: "Motor phase B"
        16 : -> symbol: "Phase C" , comment: "Motor phase C"
    connectors      :
        db9 : -> symbol: "db9"  , type: various.Dsub9MS , comment: "CANopen communication Dsub-9 male connector"
    ) "MCBL3006_S_CO"


########################################################################################################################
# Write the model to file
########################################################################################################################

faulhaber.WRITE "models/external/faulhaber.jsonld"
