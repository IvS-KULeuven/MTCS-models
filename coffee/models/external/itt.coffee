########################################################################################################################
#                                                                                                                      #
# Model containing products by ITT       .                                                                             #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/electricity.coffee"

MODEL "http://www.mercator.iac.es/onto/models/external/itt" : "itt"

itt.IMPORT man
itt.IMPORT elec


########################################################################################################################
# Company
########################################################################################################################

itt.ADD MANUFACTURER(
        shortName : "ITT"
        longName  : "ITT Corporation"
        comment   : "Produces connectors and other electrical components") "company"


########################################################################################################################
# Connectors
########################################################################################################################

itt.ADD CONNECTOR_TYPE(
    id              : "D-sub 9 M socket"
    comment         : "D-sub 9 male socket"
    manufacturer    : itt.company
    gender          : elec.male
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        7  : -> { symbol: "7" , comment: "Pin 7" }
        8  : -> { symbol: "8" , comment: "Pin 8" }
        9  : -> { symbol: "9" , comment: "Pin 9" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub9MS"

itt.ADD CONNECTOR_TYPE(
    id              : "D-sub 9 M plug"
    comment         : "D-sub 9 male plug"
    manufacturer    : itt.company
    gender          : elec.male
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        7  : -> { symbol: "7" , comment: "Pin 7" }
        8  : -> { symbol: "8" , comment: "Pin 8" }
        9  : -> { symbol: "9" , comment: "Pin 9" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub9MP"

itt.ADD CONNECTOR_TYPE(
    id              : "D-sub 9 F plug"
    comment         : "D-sub 9 female plug"
    manufacturer    : itt.company
    gender          : elec.female
    joinedWith      : itt.Dsub9MS
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        7  : -> { symbol: "7" , comment: "Pin 7" }
        8  : -> { symbol: "8" , comment: "Pin 8" }
        9  : -> { symbol: "9" , comment: "Pin 9" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub9FP"

itt.ADD CONNECTOR_TYPE(
    id              : "D-sub 9 F socket"
    comment         : "D-sub 9 female socket"
    manufacturer    : itt.company
    gender          : elec.female
    joinedWith      : itt.Dsub9MS
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        7  : -> { symbol: "7" , comment: "Pin 7" }
        8  : -> { symbol: "8" , comment: "Pin 8" }
        9  : -> { symbol: "9" , comment: "Pin 9" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub9FS"

itt.ADD CONNECTOR_TYPE(
    id              : "D-sub 15 M plug"
    comment         : "D-sub 15 male plug"
    manufacturer    : itt.company
    gender          : elec.male
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        7  : -> { symbol: "7" , comment: "Pin 7" }
        8  : -> { symbol: "8" , comment: "Pin 8" }
        9  : -> { symbol: "9" , comment: "Pin 9" }
        10 : -> { symbol: "10" , comment: "Pin 10" }
        11 : -> { symbol: "11" , comment: "Pin 11" }
        12 : -> { symbol: "12" , comment: "Pin 12" }
        13 : -> { symbol: "13" , comment: "Pin 13" }
        14 : -> { symbol: "14" , comment: "Pin 14" }
        15 : -> { symbol: "15" , comment: "Pin 15" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub15MP"

itt.ADD CONNECTOR_TYPE(
    id              : "D-sub 15 M socket"
    comment         : "D-sub 15 male socket"
    manufacturer    : itt.company
    gender          : elec.male
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        7  : -> { symbol: "7" , comment: "Pin 7" }
        8  : -> { symbol: "8" , comment: "Pin 8" }
        9  : -> { symbol: "9" , comment: "Pin 9" }
        10 : -> { symbol: "10" , comment: "Pin 10" }
        11 : -> { symbol: "11" , comment: "Pin 11" }
        12 : -> { symbol: "12" , comment: "Pin 12" }
        13 : -> { symbol: "13" , comment: "Pin 13" }
        14 : -> { symbol: "14" , comment: "Pin 14" }
        15 : -> { symbol: "15" , comment: "Pin 15" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub15MS"

itt.ADD CONNECTOR_TYPE(
    id              : "D-sub 15 F plug"
    comment         : "D-sub 15 female plug"
    manufacturer    : itt.company
    gender          : elec.female
    joinedWith      : itt.Dsub15MS
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        7  : -> { symbol: "7" , comment: "Pin 7" }
        8  : -> { symbol: "8" , comment: "Pin 8" }
        9  : -> { symbol: "9" , comment: "Pin 9" }
        10 : -> { symbol: "10" , comment: "Pin 10" }
        11 : -> { symbol: "11" , comment: "Pin 11" }
        12 : -> { symbol: "12" , comment: "Pin 12" }
        13 : -> { symbol: "13" , comment: "Pin 13" }
        14 : -> { symbol: "14" , comment: "Pin 14" }
        15 : -> { symbol: "15" , comment: "Pin 15" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub15FP"

itt.ADD CONNECTOR_TYPE(
    id              : "D-sub 15 F socket"
    comment         : "D-sub 15 female socket"
    manufacturer    : itt.company
    gender          : elec.female
    joinedWith      : itt.Dsub15MS
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        7  : -> { symbol: "7" , comment: "Pin 7" }
        8  : -> { symbol: "8" , comment: "Pin 8" }
        9  : -> { symbol: "9" , comment: "Pin 9" }
        10 : -> { symbol: "10" , comment: "Pin 10" }
        11 : -> { symbol: "11" , comment: "Pin 11" }
        12 : -> { symbol: "12" , comment: "Pin 12" }
        13 : -> { symbol: "13" , comment: "Pin 13" }
        14 : -> { symbol: "14" , comment: "Pin 14" }
        15 : -> { symbol: "15" , comment: "Pin 15" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub15FS"

itt.ADD CONNECTOR_TYPE(
    id              : "D-sub 25 M plug"
    comment         : "D-sub 25 male plug"
    manufacturer    : itt.company
    gender          : elec.male
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        7  : -> { symbol: "7" , comment: "Pin 7" }
        8  : -> { symbol: "8" , comment: "Pin 8" }
        9  : -> { symbol: "9" , comment: "Pin 9" }
        10 : -> { symbol: "10" , comment: "Pin 10" }
        11 : -> { symbol: "11" , comment: "Pin 11" }
        12 : -> { symbol: "12" , comment: "Pin 12" }
        13 : -> { symbol: "13" , comment: "Pin 13" }
        14 : -> { symbol: "14" , comment: "Pin 14" }
        15 : -> { symbol: "15" , comment: "Pin 15" }
        16 : -> { symbol: "16" , comment: "Pin 16" }
        17 : -> { symbol: "17" , comment: "Pin 17" }
        18 : -> { symbol: "18" , comment: "Pin 18" }
        19 : -> { symbol: "19" , comment: "Pin 19" }
        20 : -> { symbol: "20" , comment: "Pin 20" }
        21 : -> { symbol: "21" , comment: "Pin 21" }
        22 : -> { symbol: "22" , comment: "Pin 22" }
        23 : -> { symbol: "23" , comment: "Pin 23" }
        24 : -> { symbol: "24" , comment: "Pin 24" }
        25 : -> { symbol: "25" , comment: "Pin 25" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub25MP"

itt.ADD CONNECTOR_TYPE(
    id              : "D-sub 25 M socket"
    comment         : "D-sub 25 male socket"
    manufacturer    : itt.company
    gender          : elec.male
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        7  : -> { symbol: "7" , comment: "Pin 7" }
        8  : -> { symbol: "8" , comment: "Pin 8" }
        9  : -> { symbol: "9" , comment: "Pin 9" }
        10 : -> { symbol: "10" , comment: "Pin 10" }
        11 : -> { symbol: "11" , comment: "Pin 11" }
        12 : -> { symbol: "12" , comment: "Pin 12" }
        13 : -> { symbol: "13" , comment: "Pin 13" }
        14 : -> { symbol: "14" , comment: "Pin 14" }
        15 : -> { symbol: "15" , comment: "Pin 15" }
        16 : -> { symbol: "16" , comment: "Pin 16" }
        17 : -> { symbol: "17" , comment: "Pin 17" }
        18 : -> { symbol: "18" , comment: "Pin 18" }
        19 : -> { symbol: "19" , comment: "Pin 19" }
        20 : -> { symbol: "20" , comment: "Pin 20" }
        21 : -> { symbol: "21" , comment: "Pin 21" }
        22 : -> { symbol: "22" , comment: "Pin 22" }
        23 : -> { symbol: "23" , comment: "Pin 23" }
        24 : -> { symbol: "24" , comment: "Pin 24" }
        25 : -> { symbol: "25" , comment: "Pin 25" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub25MS"

itt.ADD CONNECTOR_TYPE(
    id              : "D-sub 25 F plug"
    comment         : "D-sub 25 female plug"
    manufacturer    : itt.company
    gender          : elec.female
    joinedWith      : itt.Dsub25MS
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        7  : -> { symbol: "7" , comment: "Pin 7" }
        8  : -> { symbol: "8" , comment: "Pin 8" }
        9  : -> { symbol: "9" , comment: "Pin 9" }
        10 : -> { symbol: "10" , comment: "Pin 10" }
        11 : -> { symbol: "11" , comment: "Pin 11" }
        12 : -> { symbol: "12" , comment: "Pin 12" }
        13 : -> { symbol: "13" , comment: "Pin 13" }
        14 : -> { symbol: "14" , comment: "Pin 14" }
        15 : -> { symbol: "15" , comment: "Pin 15" }
        16 : -> { symbol: "16" , comment: "Pin 16" }
        17 : -> { symbol: "17" , comment: "Pin 17" }
        18 : -> { symbol: "18" , comment: "Pin 18" }
        19 : -> { symbol: "19" , comment: "Pin 19" }
        20 : -> { symbol: "20" , comment: "Pin 20" }
        21 : -> { symbol: "21" , comment: "Pin 21" }
        22 : -> { symbol: "22" , comment: "Pin 22" }
        23 : -> { symbol: "23" , comment: "Pin 23" }
        24 : -> { symbol: "24" , comment: "Pin 24" }
        25 : -> { symbol: "25" , comment: "Pin 25" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub25FP"

itt.ADD CONNECTOR_TYPE(
    id              : "D-sub 25 F socket"
    comment         : "D-sub 25 female socket"
    manufacturer    : itt.company
    gender          : elec.female
    joinedWith      : itt.Dsub25MS
    terminals:
        1  : -> { symbol: "1" , comment: "Pin 1" }
        2  : -> { symbol: "2" , comment: "Pin 2" }
        3  : -> { symbol: "3" , comment: "Pin 3" }
        4  : -> { symbol: "4" , comment: "Pin 4" }
        5  : -> { symbol: "5" , comment: "Pin 5" }
        6  : -> { symbol: "6" , comment: "Pin 6" }
        7  : -> { symbol: "7" , comment: "Pin 7" }
        8  : -> { symbol: "8" , comment: "Pin 8" }
        9  : -> { symbol: "9" , comment: "Pin 9" }
        10 : -> { symbol: "10" , comment: "Pin 10" }
        11 : -> { symbol: "11" , comment: "Pin 11" }
        12 : -> { symbol: "12" , comment: "Pin 12" }
        13 : -> { symbol: "13" , comment: "Pin 13" }
        14 : -> { symbol: "14" , comment: "Pin 14" }
        15 : -> { symbol: "15" , comment: "Pin 15" }
        16 : -> { symbol: "16" , comment: "Pin 16" }
        17 : -> { symbol: "17" , comment: "Pin 17" }
        18 : -> { symbol: "18" , comment: "Pin 18" }
        19 : -> { symbol: "19" , comment: "Pin 19" }
        20 : -> { symbol: "20" , comment: "Pin 20" }
        21 : -> { symbol: "21" , comment: "Pin 21" }
        22 : -> { symbol: "22" , comment: "Pin 22" }
        23 : -> { symbol: "23" , comment: "Pin 23" }
        24 : -> { symbol: "24" , comment: "Pin 24" }
        25 : -> { symbol: "25" , comment: "Pin 25" }
        chassis  : -> { symbol: "Chassis" , comment: "Chassis (to connect screen)" }) "Dsub25FS"


itt.WRITE "models/external/itt.jsonld"

