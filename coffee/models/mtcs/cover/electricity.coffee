##########################################################################
#                                                                        #
# Model of the telescope cover electric system.                          #
#                                                                        #
##########################################################################

require "ontoscript"

# models
REQUIRE "models/external/all.coffee"
REQUIRE "models/mtcs/cover/system.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/cover/electricity" : "cover_elec"

cover_elec.IMPORT external_all
cover_elec.IMPORT cover_sys

##########################################################################
# Configuration
##########################################################################

cover_elec.ADD elec.CONFIGURATION(
  label: "TC: Telescope Cover"
  comment:  "The dust cover of the telescope"
) "TC"

##########################################################################
# TC panel
##########################################################################

# Power input ============================================================

cover_elec.TC.ADD cont.contains CONNECTOR_INSTANCE(
  type: phoenix.SC25_1L_SocketAssembly
  comment: "230V input power"
  symbol: "TC:230VAC-A"
  ) "socket230VAC"


cover_elec.TC.ADD cont.contains CIRCUIT_BREAKER_INSTANCE(
  type: schneider.CircuitBreaker2Ph6A
  symbol: "TC:CB"
  comment: "Circuit breaker immediately after 230V input"
  terminals:
    1: ->
      comment: "L in"
      isConnectedTo: cover_elec.TC.socket230VAC.terminals.L
    2: ->
      comment: "L out"
    3: ->
      comment: "N in"
      isConnectedTo: cover_elec.TC.socket230VAC.terminals.N
    4: ->
      comment: "N out"
  ) "circuitBreaker"


# Power distribution =====================================================

cover_elec.TC.ADD cont.contains CONTAINER(
  items:
    [
      TERMINAL(
        symbol: "PE"
        comment: "Protective Earth"
        isConnectedTo: cover_elec.TC.socket230VAC.terminals.PE) "PE"
      TERMINAL(
        symbol: "+24V"
        comment: "+24VDC") "DC"
      TERMINAL(
        symbol: "GND"
        comment: "GND") "GND"
    ]
  ) "terminals"


# DC supply ==============================================================

cover_elec.TC.ADD cont.contains POWER_SUPPLY_INSTANCE(
  type: phoenix.trio_ps_1AC_24VDC_10
  symbol: "TC:PS24"
  comment: "24V power supply to power the I/O modules"
  terminals:
    PE: ->
      symbol: "PE"
      comment: "From PE terminals"
      isConnectedTo: cover_elec.TC.terminals.PE
    L: ->
      symbol: "L"
      comment: "From circuit breaker"
      isConnectedTo: cover_elec.TC.circuitBreaker.terminals[2]
    N: ->
      symbol: "N"
      comment: "From circuit breaker"
      isConnectedTo: cover_elec.TC.circuitBreaker.terminals[4]
    plus: ->
      symbol: "+"
      comment: "To +24V terminals"
      isConnectedTo: cover_elec.TC.terminals.DC
    minus: ->
      symbol: "-"
      comment: "To GND terminals"
      isConnectedTo: cover_elec.TC.terminals.GND
  ) "power"


# Connectors ==============================================================

createConnector = (connectorName, petalName) ->
  CONNECTOR_INSTANCE(
    type: itt.Dsub15FS
    symbol: "TC:#{connectorName}"
    comment: "Connector to #{petalName}"
    terminals:
      1 : ->
        symbol: "TC:#{connectorName}:GND HM"
        comment: "#{petalName} GND of holding magnet"
        isConnectedTo: cover_elec.TC.terminals.GND
      2 : ->
        symbol: "TC:#{connectorName}:GND MOT"
        comment: "#{petalName} GND of motor"
        isConnectedTo: cover_elec.TC.terminals.GND
      3 : ->
        symbol: "TC:#{connectorName}:MMON"
        comment: "#{petalName} motor monitor"
      4 : ->
        symbol: "TC:#{connectorName}:MDIR"
        comment: "#{petalName} motor direction"
      5 : ->
        symbol: "TC:#{connectorName}:GND ENC"
        comment: "#{petalName} GND of encoder"
        isConnectedTo: cover_elec.TC.terminals.GND
      6 : ->
        symbol: "TC:#{connectorName}:SSID+"
        comment: "#{petalName} SSI Data +"
      7 : ->
        symbol: "TC:#{connectorName}:SSIC+"
        comment: "#{petalName} SSI Clock +"
      8 : ->
        symbol: "TC:#{connectorName}:PE"
        comment: "#{petalName} Earth"
        isConnectedTo: cover_elec.TC.terminals.PE
      9 : ->
        symbol: "TC:#{connectorName}:+24V HM"
        comment: "#{petalName} +24V of holding magnet"
      10: ->
        symbol: "TC:#{connectorName}:+24V MOT"
        comment: "#{petalName} +24V of motor"
      11: ->
        symbol: "TC:#{connectorName}:MSPEED"
        comment: "#{petalName} motor speed"
      12: ->
        symbol: "TC:#{connectorName}:+24V ENC"
        comment: "#{petalName} +24V of encoder"
        isConnectedTo: cover_elec.TC.terminals.DC
      13: ->
        symbol: "TC:#{connectorName}:SSISTS"
        comment: "#{petalName} SSI status"
      14: ->
        symbol: "TC:#{connectorName}:SSID-"
        comment: "#{petalName} SSI Data -"
      15: ->
        symbol: "TC:#{connectorName}:SSIC-"
        comment: "#{petalName} SSI Clock -"
    ) connectorName


cover_elec.TC.ADD cont.contains CONTAINER(
  items:
    [
      CONNECTOR_INSTANCE(
        type: harting.RJ45F
        symbol: "TC:ECAT"
        comment: "EtherCAT input, from junction"
      ) "ECAT"
      createConnector("T1", "Top 1")
      createConnector("T2", "Top 2")
      createConnector("T3", "Top 3")
      createConnector("T4", "Top 4")
      createConnector("B1", "Bottom 1")
      createConnector("B2", "Bottom 2")
      createConnector("B3", "Bottom 3")
      createConnector("B4", "Bottom 4")
    ]
  ) "connectors"


# I/O modules =============================================================


createSSIModule = (connector1, connector2, panel1, panel2) ->
  IO_MODULE_INSTANCE(
    comment   : "SSI module for #{panel1} and #{panel2} encoders"
    type      : beckhoff.EL5002
    terminals :
      1: ->
        symbol: "TC:#{connector1}:SSID+"
        comment: "#{panel1} SSI encoder Data +"
        isConnectedTo: cover_elec.TC.connectors[connector1].terminals[6]
      2: ->
        symbol: "TC:#{connector1}:SSIC+"
        comment: "#{panel1} SSI encoder Clock +"
        isConnectedTo: cover_elec.TC.connectors[connector1].terminals[7]
      3: ->
        symbol: "TC:#{connector2}:SSID+"
        comment: "#{panel2} SSI encoder Data +"
        isConnectedTo: cover_elec.TC.connectors[connector2].terminals[6]
      4: ->
        symbol: "TC:#{connector2}:SSIC+"
        comment: "#{panel2} SSI encoder Clock +"
        isConnectedTo: cover_elec.TC.connectors[connector2].terminals[7]
      5: ->
        symbol: "TC:#{connector1}:SSID-"
        comment: "#{panel1} SSI encoder Data -"
        isConnectedTo: cover_elec.TC.connectors[connector1].terminals[14]
      6: ->
        symbol: "TC:#{connector1}:SSIC-"
        comment: "#{panel1} SSI encoder Clock -"
        isConnectedTo: cover_elec.TC.connectors[connector1].terminals[15]
      7: ->
        symbol: "TC:#{connector2}:SSID-"
        comment: "#{panel2} SSI encoder Data -"
        isConnectedTo: cover_elec.TC.connectors[connector2].terminals[14]
      8: ->
        symbol: "TC:#{connector2}:SSIC-"
        comment: "#{panel2} SSI encoder Clock -"
        isConnectedTo: cover_elec.TC.connectors[connector2].terminals[15]
  )


createRelayModule = (connector1, connector2, panel1, panel2) ->
  IO_MODULE_INSTANCE(
    type: beckhoff.EL2622
    comment: "Relay module for the #{panel1} and #{panel2} motors"
    terminals:
      1: ->
        symbol: "+24V"
        comment: "#{panel1} Motor +24V relay: from multimeter"
      2: ->
        symbol: "TC:#{connector1}:+24VMOT"
        comment: "#{panel1} Motor +24V relay: to motor"
        isConnectedTo: cover_elec.TC.connectors[connector1].terminals[10]
      5: ->
        symbol: "+24V"
        comment: "#{panel2} Motor +24V relay: from multimeter"
      6: ->
        symbol: "TC:#{connector2}:+24VMOT"
        comment: "#{panel2} Motor +24V relay: to motor"
        isConnectedTo: cover_elec.TC.connectors[connector2].terminals[10]
  )


cover_elec.TC.ADD cont.contains CONTAINER(
  items:
    slot0: ->
      IO_MODULE_INSTANCE(
        type: beckhoff.EK1101
        comment: "EtherCAT in, from junction"
        terminals:
          X1: ->
            comment: "From EtherCAT switch"
          1: ->
            comment: "Coupler power 24V DC"
            isConnectedTo: cover_elec.TC.terminals.DC
          2: ->
            comment: "Bus power 24V DC"
            isConnectedTo: cover_elec.TC.terminals.DC
          3: ->
            comment: "Coupler GND"
            isConnectedTo: cover_elec.TC.terminals.GND
          4: ->
            comment: "Earth"
            isConnectedTo: cover_elec.TC.terminals.PE
          5: ->
            comment: "Bus GND"
            isConnectedTo: cover_elec.TC.terminals.GND
        )
    slot1: ->
      IO_MODULE_INSTANCE(
        type: beckhoff.EL2008
        comment: "Direction signals of the 8 motors"
        terminals:
          1: ->
            symbol: "TC:T1:MDIR"
            comment: "Top 1 motor direction"
            isConnectedTo: cover_elec.TC.connectors.T1.terminals[4]
          2: ->
            symbol: "TC:T2:MDIR"
            comment: "Top 2 motor direction"
            isConnectedTo: cover_elec.TC.connectors.T2.terminals[4]
          3: ->
            symbol: "TC:T3:MDIR"
            comment: "Top 3 motor direction"
            isConnectedTo: cover_elec.TC.connectors.T3.terminals[4]
          4: ->
            symbol: "TC:T4:MDIR"
            comment: "Top 4 motor direction"
            isConnectedTo: cover_elec.TC.connectors.T4.terminals[4]
          5: ->
            symbol: "TC:B1:MDIR"
            comment: "Bottom 1 motor direction"
            isConnectedTo: cover_elec.TC.connectors.B1.terminals[4]
          6: ->
            symbol: "TC:B2:MDIR"
            comment: "Bottom 2 motor direction"
            isConnectedTo: cover_elec.TC.connectors.B2.terminals[4]
          7: ->
            symbol: "TC:B3:MDIR"
            comment: "Bottom 3 motor direction"
            isConnectedTo: cover_elec.TC.connectors.B3.terminals[4]
          8: ->
            symbol: "TC:B4:MDIR"
            comment: "Bottom 4 motor direction"
            isConnectedTo: cover_elec.TC.connectors.B4.terminals[4]
      )
    slot2: ->
      IO_MODULE_INSTANCE(
        type: beckhoff.EL4008
        comment: "Analog velocity setpoints of the 8 motors"
        terminals:
          1: ->
            symbol: "TC:T1:MSPEED"
            comment: "Top 1 motor speed"
            isConnectedTo: cover_elec.TC.connectors.T1.terminals[11]
          2: ->
            symbol: "TC:T2:MSPEED"
            comment: "Top 2 motor speed"
            isConnectedTo: cover_elec.TC.connectors.T2.terminals[11]
          3: ->
            symbol: "TC:T3:MSPEED"
            comment: "Top 3 motor speed"
            isConnectedTo: cover_elec.TC.connectors.T3.terminals[11]
          4: ->
            symbol: "TC:T4:MSPEED"
            comment: "Top 4 motor speed"
            isConnectedTo: cover_elec.TC.connectors.T4.terminals[11]
          5: ->
            symbol: "TC:B1:MSPEED"
            comment: "Bottom 1 motor speed"
            isConnectedTo: cover_elec.TC.connectors.B1.terminals[11]
          6: ->
            symbol: "TC:B2:MSPEED"
            comment: "Bottom 2 motor speed"
            isConnectedTo: cover_elec.TC.connectors.B2.terminals[11]
          7: ->
            symbol: "TC:B3:MSPEED"
            comment: "Bottom 3 motor speed"
            isConnectedTo: cover_elec.TC.connectors.B3.terminals[11]
          8: ->
            symbol: "TC:B4:MSPEED"
            comment: "Bottom 4 motor speed"
            isConnectedTo: cover_elec.TC.connectors.B4.terminals[11]
        )
    slot3: ->
      IO_MODULE_INSTANCE(
        type    : beckhoff.EL1088
        comment   : "Digital input terminal to read the status of the SSI encoders of all 8 cover panels"
        satisfies : cover_sys.panelDesign.requirements.absFeedbackStatus
        terminals :
          1: ->
            symbol: "TC:T1:SSISTS"
            comment: "Top 1 SSI status"
            isConnectedTo: cover_elec.TC.connectors.T1.terminals[13]
          2: ->
            symbol: "TC:T2:SSISTS"
            comment: "Top 2 SSI status"
            isConnectedTo: cover_elec.TC.connectors.T2.terminals[13]
          3: ->
            symbol: "TC:T3:SSISTS"
            comment: "Top 3 SSI status"
            isConnectedTo: cover_elec.TC.connectors.T3.terminals[13]
          4: ->
            symbol: "TC:T4:SSISTS"
            comment: "Top 4 SSI status"
            isConnectedTo: cover_elec.TC.connectors.T4.terminals[13]
          5: ->
            symbol: "TC:B1:SSISTS"
            comment: "Bottom SSI status"
            isConnectedTo: cover_elec.TC.connectors.B1.terminals[13]
          6: ->
            symbol: "TC:B2:SSISTS"
            comment: "Bottom SSI status"
            isConnectedTo: cover_elec.TC.connectors.B2.terminals[13]
          7: ->
            symbol: "TC:B3:SSISTS"
            comment: "Bottom SSI status"
            isConnectedTo: cover_elec.TC.connectors.B3.terminals[13]
          8: ->
            symbol: "TC:B4:SSISTS"
            comment: "Bottom SSI status"
            isConnectedTo: cover_elec.TC.connectors.B4.terminals[13]
      )
    slot4: -> createSSIModule('T1', 'T2', 'Top 1', 'Top 2')
    slot5: -> createSSIModule('T3', 'T4', 'Top 3', 'Top 4')
    slot6: -> createSSIModule('B1', 'B2', 'Bottom 1', 'Bottom 2')
    slot7: -> createSSIModule('B3', 'B4', 'Bottom 3', 'Bottom 4')
    slot8: -> createRelayModule('T1', 'T2', 'Top 1', 'Top 2')
    slot9: -> createRelayModule('T3', 'T4', 'Top 3', 'Top 4')
    slot10: -> createRelayModule('B1', 'B2', 'Bottom 1', 'Bottom 2')
    slot11: -> createRelayModule('B3', 'B4', 'Bottom 3', 'Bottom 4')
    slot12: ->
      IO_MODULE_INSTANCE(
        type: beckhoff.EL2622
        comment: "Top and bottom holding magnet relays"
        terminals:
          1: ->
            symbol: "+24V"
            comment: "Top Holding Magnet relay: from supply"
            isConnectedTo: cover_elec.TC.terminals.DC
          2: ->
            symbol: "TC:T:HM"
            comment: "Top Holding Magnet relay: to magnet"
            isConnectedTo: cover_elec.TC.connectors["T#{i}"].terminals[9] for i in [1..4]
          5: ->
            symbol: "+24V"
            comment: "Bottom Holding Magnet relay: from supply"
            isConnectedTo: cover_elec.TC.terminals.DC
          6: ->
            symbol: "TC:B:HM"
            comment: "Bottom Holding Magnet relay: to magnet"
            isConnectedTo: cover_elec.TC.connectors["B#{i}"].terminals[9] for i in [1..4]
        )
    slot13: ->
      IO_MODULE_INSTANCE(
        type: beckhoff.EL3681
        comment: "Multimeter current measurement"
        terminals:
          2: ->
            symbol: "TC:T:HM"
            comment: "Multimeter 24V to motors"
            isConnectedTo: [
              $.slot8.terminals[1]
              $.slot9.terminals[1]
              $.slot10.terminals[1]
              $.slot11.terminals[1]
              $.slot8.terminals[5]
              $.slot9.terminals[5]
              $.slot10.terminals[5]
              $.slot11.terminals[5]
            ]
          3: ->
            symbol: "GND"
            comment: "Multimeter common 24V input"
            isConnectedTo: cover_elec.TC.terminals.DC
        )
  ) "io"


###########################################################################
# Field
###########################################################################

cover_elec.TC.ADD cont.contains elec.CONFIGURATION(
  label: "field"
  comment: "Contains everything outside the cabinet"
  ) "field"

# cable assembly (=connector+cable+connector) common to all panels
cover_elec.ADD CABLE_ASSEMBLY_TYPE(
  comment : "Cable assembly between cabinet and field"
  id        : "CoverCableAssembly"
  manufacturer  : ivs.organization
  connectors:
    cabinetSide: ->
      type: itt.Dsub15MP
      comment: "Plug on the cabinet side"
    petalSide: ->
      type: phoenix.MCVU_16_plug
      comment: "Plug on the petal side"
  cables:
    cable     : ->
      type: various.Cable15x034S
      comment: "Cable between both plugs"
      wires:
        white: ->
          from: $.connectors.cabinetSide.terminals[1]
          to  : $.connectors.petalSide.terminals[1]
        black: ->
          from: $.connectors.cabinetSide.terminals[9]
          to  : $.connectors.petalSide.terminals[2]
        brown: ->
          from: $.connectors.cabinetSide.terminals[2]
          to  : $.connectors.petalSide.terminals[3]
        violet: ->
          from: $.connectors.cabinetSide.terminals[10]
          to  : $.connectors.petalSide.terminals[4]
        green: ->
          from: $.connectors.cabinetSide.terminals[3]
          to  : $.connectors.petalSide.terminals[5]
        grayPink: ->
          from: $.connectors.cabinetSide.terminals[11]
          to  : $.connectors.petalSide.terminals[6]
        yellow: ->
          from: $.connectors.cabinetSide.terminals[4]
          to  : $.connectors.petalSide.terminals[7]
        redBlue: ->
          from: $.connectors.cabinetSide.terminals[12]
          to  : $.connectors.petalSide.terminals[8]
        gray: ->
          from: $.connectors.cabinetSide.terminals[5]
          to  : $.connectors.petalSide.terminals[9]
        whiteGreen: ->
          from: $.connectors.cabinetSide.terminals[13]
          to  : $.connectors.petalSide.terminals[10]
        pink: ->
          from: $.connectors.cabinetSide.terminals[6]
          to  : $.connectors.petalSide.terminals[11]
        brownGreen: ->
          from: $.connectors.cabinetSide.terminals[14]
          to  : $.connectors.petalSide.terminals[12]
        blue: ->
          from: $.connectors.cabinetSide.terminals[7]
          to  : $.connectors.petalSide.terminals[13]
        whiteYellow: ->
          from: $.connectors.cabinetSide.terminals[15]
          to  : $.connectors.petalSide.terminals[14]
        shield: ->
          from: $.connectors.cabinetSide.terminals[8]
          to  : $.connectors.petalSide.terminals[16]
  ) "CableAssembly"


for panel in ["T1", "T2", "T3", "T4", "B1", "B2", "B3", "B4"]

  # create a configuration for the panel
  cover_elec.TC.field.ADD cont.contains elec.CONFIGURATION() "#{panel}"

  # create the cable assembly
  cover_elec.TC.field[panel].ADD cont.contains CABLE_ASSEMBLY_INSTANCE(
    comment  :  "Cable assembly of panel #{panel}"
    type   : cover_elec.CableAssembly
    joined:
      cabinetSide: -> cover_elec.TC.connectors[panel]
  ) "cableAssembly"

  # create the socket on the petal-side
  cover_elec.TC.field[panel].ADD cont.contains CONNECTOR_INSTANCE(
    comment     : "Field socket of #{panel}"
    type      : phoenix.MCVU_16_socket
    joinedWith:
      cover_elec.TC.field[panel].cableAssembly.connectors.petalSide
  ) "socket"

  # create the SSI encoder and wire it to the socket
  cover_elec.TC.field[panel].ADD cont.contains SENSOR_INSTANCE(
    comment     : "External encoder of panel #{panel}"
    realizes    : cover_sys.panelDesign.parts.encoder
    type      : kuebler.F3673_1421_G412
    cables:
      cable: ->
        wires:
          white  : -> to: cover_elec.TC.field[panel].socket.terminals[8]
          red  : -> to: cover_elec.TC.field[panel].socket.terminals[8]
          blue   : -> to: cover_elec.TC.field[panel].socket.terminals[8]
          brown  : -> to: cover_elec.TC.field[panel].socket.terminals[9]
          violet : -> to: cover_elec.TC.field[panel].socket.terminals[10]
          gray   : -> to: cover_elec.TC.field[panel].socket.terminals[11]
          pink   : -> to: cover_elec.TC.field[panel].socket.terminals[12]
          green  : -> to: cover_elec.TC.field[panel].socket.terminals[13]
          yellow : -> to: cover_elec.TC.field[panel].socket.terminals[14]
          screen : -> to: cover_elec.TC.field[panel].socket.terminals[16]
  ) "encoder"

  # create the motor and wire it to the socket
  cover_elec.TC.field[panel].ADD cont.contains elec.MOTOR_INSTANCE(
    comment   : "Motor of panel #{panel}",
    realizes  : cover_sys.panelDesign.parts.motor
    type      : maxon.motor_370418
    wires:
      black: -> to: cover_elec.TC.field[panel].socket.terminals[3]
      red  : -> to: cover_elec.TC.field[panel].socket.terminals[4]
      green: -> to: cover_elec.TC.field[panel].socket.terminals[5]
      white: -> to: cover_elec.TC.field[panel].socket.terminals[6]
      gray : -> to: cover_elec.TC.field[panel].socket.terminals[7]
  ) "motor"

  # create the magnet and wire it to the socket
  cover_elec.TC.field[panel].ADD cont.contains elec.ACTUATOR_INSTANCE(
    comment  : "Magnet"
    realizes : cover_sys.panelDesign.parts.magnet
    type   : magnetschultz.G_MH_x025
    terminals:
      GND: -> isConnectedTo: cover_elec.TC.field[panel].socket.terminals[1]
      VCC: -> isConnectedTo: cover_elec.TC.field[panel].socket.terminals[2]
  ) "magnet"


########################################################################################################################
# Add the connectors, terminals and I/O modules to the Configurations
########################################################################################################################

cover_elec.TC.ADD cont.contains i for i in PATHS(cover_elec.TC.terminals, cont.contains)
cover_elec.TC.ADD cont.contains i for i in PATHS(cover_elec.TC.connectors, cont.contains)
cover_elec.TC.ADD cont.contains i for i in PATHS(cover_elec.TC.io, cont.contains)



########################################################################################################################
# Write the model to file
########################################################################################################################

cover_elec.WRITE "models/mtcs/cover/electricity.jsonld"

