########################################################################################################################
#                                                                                                                      #
# Model containing products by Kuebler.                                                                                #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/iec61131.coffee"
REQUIRE "metamodels/electricity.coffee"
REQUIRE "metamodels/colors.coffee"

MODEL "http://www.mercator.iac.es/onto/models/external/maxon" : "maxon"

maxon.IMPORT man
maxon.IMPORT mech
maxon.IMPORT elec
maxon.IMPORT colors

########################################################################################################################
# Company
########################################################################################################################

maxon.ADD MANUFACTURER(
        shortName : "Maxon"
        longName  : "Maxon motor"
        comment   : "Produces motors, drives, gearboxes, ...") "company"


########################################################################################################################
# Motors
########################################################################################################################

maxon.ADD elec.MOTOR_TYPE(
    id:   "370418",
    comment: "Motor, 32 mm diameter, brushless, 15 Watt, with integrated electronics, with cover"
    manufacturer: maxon.company
    wires:
        red: ->
            comment: "Supply voltage"
            symbol: "VCC"
            color: colors.red
        black: ->
            comment: "GND"
            symbol: "GND"
            color: colors.black
        white: ->
            comment: "Velocity setpoint input"
            symbol: "VEL"
            color: colors.white
        green: ->
            comment: "Speed monitor output"
            symbol: "MON"
            color: colors.green
        gray: ->
            comment: "Direction input"
            symbol: "DIR"
            color: colors.gray
    ) "motor_370418"


maxon.ADD ROTARY_TRANSMISSION(
    id      : "166960"
    comment : "Transmission from the motor to the petal shaft",
    ratio   : 913
    ) "reduction_166960"


########################################################################################################################
# Gearheads
########################################################################################################################


#maxon.ADD ROTARY_TRANSMISSION(
#    id              : "324954"
#    comment         : "8-channel digital input terminal 24V DC, negative switching"
#    manufacturer    : maxon.company
#    ratio           : TRANSMISSION_RATIO(36501:40)) "part_324954"


# 370418 w/ gear 166960
# 10V = 6000 rpm

########################################################################################################################
# Write the model to file
########################################################################################################################

maxon.WRITE "models/external/maxon.jsonld"
