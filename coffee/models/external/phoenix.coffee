########################################################################################################################
#                                                                                                                      #
# Model containing products by Phoenix Contact.                                                                        #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"

MODEL "http://www.mercator.iac.es/onto/models/external/phoenix" : "phoenix"

phoenix.IMPORT man
phoenix.IMPORT elec


########################################################################################################################
# Company
########################################################################################################################

phoenix.ADD MANUFACTURER(
        shortName : "Phoenix Contact"
        longName  : "Phoenix Contact"
        comment   : "Produces electrical and automation components") "company"


########################################################################################################################
# Power supplies
########################################################################################################################

phoenix.ADD POWER_SUPPLY_TYPE(
    id              : "TRIO-PS/1AC/24VDC/10"
    comment         : "Primary-switched TRIO POWER power supply for DIN rail mounting, input: 1-phase, output: 24 V DC/10 A"
    manufacturer    : phoenix.company
    terminals       :
        "L"     : -> { symbol: "L"   , comment: "230VAC Line"    }
        "N"     : -> { symbol: "N"   , comment: "230VAC Neutral" }
        "PE"    : -> { symbol: "PE"  , comment: "Earth"          }
        "plus"  : -> { symbol: "+"   , comment: "+24VDC"         }
        "plus2" : -> { symbol: "+"   , comment: "+24VDC"         }
        "minus" : -> { symbol: "-"   , comment: "GND"            }
        "minus2": -> { symbol: "-"   , comment: "GND"            }
        "minus3": -> { symbol: "-"   , comment: "GND"            }
    ) "trio_ps_1AC_24VDC_10"


phoenix.ADD POWER_SUPPLY_TYPE(
    id              : "MINI-PS-12-24DC/5-15DC/2"
    comment         : "Primary-switched MINI DC/DC converter for DIN rail mounting, input: 1-phase, output: 5 - 15 V DC/2 A"
    manufacturer    : phoenix.company
    terminals       :
        "inplus"    : -> { symbol: "+"       , comment: "Input +24VDC"    }
        "inminus"   : -> { symbol: "-"       , comment: "Input 0VDC"      }
        "outplus"   : -> { symbol: "+"       , comment: "Output +5..+15V DC"    }
        "outplus2"  : -> { symbol: "+"       , comment: "Output +5..+15V DC"    }
        "outplus3"  : -> { symbol: "+"       , comment: "Output +5..+15V DC"    }
        "outminus"  : -> { symbol: "-"       , comment: "Output 0V DC"    }
        "outminus2" : -> { symbol: "-"       , comment: "Output 0V DC"    }
        "outminus3" : -> { symbol: "-"       , comment: "Output 0V DC"    }
        "outminus4" : -> { symbol: "-"       , comment: "Output 0V DC"    }
        "DCOK"      : -> { symbol: "DCOK"    , comment: "DC OK"    }
    ) "mini_ps_12_24VDC_5_15VDC_2A"


########################################################################################################################
# Other
########################################################################################################################

phoenix.ADD CONNECTOR_TYPE(
    id              : "SC 2,5 L+N+PE"
    comment         : "Assembly of SC 2,5/ 1-L sockets: 2 gray + 1 green/yellow"
    manufacturer    : phoenix.company
    gender          : elec.male
    terminals:
        L  : -> { symbol: "L" , comment: "Line" }
        N  : -> { symbol: "N" , comment: "Neutral" }
        PE : -> { symbol: "PE" , comment: "Protective Earth" }) "SC25_1L_SocketAssembly"


phoenix.ADD CONNECTOR_TYPE(
    id              : "Plug MCVU 1,5/16-GFD-3,81"
    comment         : "Plug MCVU 1,5/16-GFD-3,81"
    manufacturer    : phoenix.company
    terminals:
        1  : -> { symbol: "1" }
        2  : -> { symbol: "2" }
        3  : -> { symbol: "3" }
        4  : -> { symbol: "4" }
        5  : -> { symbol: "5" }
        6  : -> { symbol: "6" }
        7  : -> { symbol: "7" }
        8  : -> { symbol: "8" }
        9  : -> { symbol: "9" }
        10 : -> { symbol: "10" }
        11 : -> { symbol: "11" }
        12 : -> { symbol: "12" }
        13 : -> { symbol: "13" }
        14 : -> { symbol: "14" }
        15 : -> { symbol: "15" }
        16 : -> { symbol: "16" }) "MCVU_16_plug"

phoenix.ADD CONNECTOR_TYPE(
    id              : "Socket MCVU 1,5/16-GFD-3,81"
    comment         : "Socket MCVU 1,5/16-GFD-3,81"
    manufacturer    : phoenix.company
    terminals:
        1  : -> { symbol: "1" }
        2  : -> { symbol: "2" }
        3  : -> { symbol: "3" }
        4  : -> { symbol: "4" }
        5  : -> { symbol: "5" }
        6  : -> { symbol: "6" }
        7  : -> { symbol: "7" }
        8  : -> { symbol: "8" }
        9  : -> { symbol: "9" }
        10 : -> { symbol: "10" }
        11 : -> { symbol: "11" }
        12 : -> { symbol: "12" }
        13 : -> { symbol: "13" }
        14 : -> { symbol: "14" }
        15 : -> { symbol: "15" }
        16 : -> { symbol: "16" }) "MCVU_16_socket"

########################################################################################################################
# Write the model to file
########################################################################################################################

phoenix.WRITE "models/external/phoenix.jsonld"

