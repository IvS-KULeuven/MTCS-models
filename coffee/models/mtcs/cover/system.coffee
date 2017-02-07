########################################################################################################################
#                                                                                                                      #
# Model containing the system design of the telescope cover.                                                           #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "models/import_all.coffee"

# models
REQUIRE "models/util/systemfactories.coffee"
REQUIRE "models/mtcs/common/roles.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/cover/system" : "cover_sys"

# import the dependencies
cover_sys.IMPORT systemfactories
cover_sys.IMPORT roles

########################################################################################################################
# The project
########################################################################################################################

cover_sys.ADD MTCS_PROJECT "project",
    label: "Cover"
    comment: "The cover of the telescope"

##########################################################################
# TC: Concept
##########################################################################

cover_sys.ADD MTCS_CONCEPT "concept",
  comment: "Concept of the Mercator telescope cover"
  partOf: cover_sys.project
  requirements:
    covered: ->
      comment: "Have a 'covered' state, protecting the tube against " +
               "small hazardous parts and falling water drops (IP32)"
      isRequiredBy: roles.tech
    uncovered: ->
      comment: "Have an 'uncovered' state which doesn't obstruct the beam"
      isRequiredBy: roles.observer
    heat: ->
      comment: "Dissipate max. 30 Watts inside the dome, when uncovered"
      isRequiredBy: roles.observer
    emc: ->
      comment: "Don't produce electric noise that can interfere with " +
               "observations"
      isRequiredBy: roles.observer
    switching: ->
      comment: "Be able to switch between covered/uncovered"
      isRequiredBy: roles.observer
    covering: ->
      comment: "Be able to switch to covered state within 120s"
      isDerivedFrom: self.switching
    uncovering: ->
      comment: "Be able to switch to uncovered state within 120s"
      isDerivedFrom: self.switching
    automated: ->
      comment: "Be able to open/close remotely with a single command"
      isRequiredBy: roles.observer
    safe: ->
      comment: "Be intrinsically safe"
      isRequiredBy: [roles.observer, roles.tech]
    wind: ->
      comment: "Be resilient to 'high' wind load while (un)covered."
      isRequiredBy: [roles.observer, roles.tech]
  properties:
    maxSwitchingTime   : ->
        comment : "Maximum switching time"
        value   : 120
        unit    : unit.SecondTime
    maxHeatDissipation : ->
        comment : "Maximum heat dissipation"
        value   : 30
        unit    : unit.Watt
    actHeatDissipation : ->
        comment : "Actual heat dissipation"
        unit    : unit.Watt
  states:
    # the cover has covered/uncovered states
    covered    : -> comment: "Fully covered"
    uncovered  : -> comment: "Fully uncovered"
    # the cover also has covering/uncovering states
    covering   : -> comment: "Switching to covered state"
    uncovering : -> comment: "Switching to uncovered state"
  constraints:
    uncovering: ->
      always:
         if   : $.states.uncovering
         then : EVENTUALLY($.states.uncovered,
                           within: $.properties.maxSwitchingTime)
      represents: $.requirements.uncovering
    covering: ->
      always:
         if   : $.states.covering
         then : EVENTUALLY($.states.covered,
                           within: $.properties.maxSwitchingTime)
      represents: $.requirements.covering
    heat: ->
      always:
        if   : $.states.uncovered
        then : LT($.properties.actHeatDissipation,
                  $.properties.maxHeatDissipation)
      represents: $.requirements.heat
  tests:
    covered: ->
      comment   : "Test if the covered state fully covers the tube, by visual inspection"
      verifies  : $.requirements.covered
    uncovered: ->
      comment   : "Test if the uncovered state doesn't obstruct the beam, by visual inspection"
      verifies  : $.requirements.uncovered

##########################################################################
# TC: System design
##########################################################################

# Since the systemDesign will define two very similar "panelSet" concepts,
# we can create a function to generate a panelSet concept.
# This function will be called twice within the systemDesign definition
# (once to generate the "top" panelSet concept, once to generate the
# "bottom" panelSet concept).
createPanelSetConcept = (name) ->
  comment    : "The #{name} panel set"
  requirements:
    open: ->
      comment: "Have an open state"
      isDerivedFrom: $.$.$.requirements.open
    closed: ->
      comment: "Have a closed state"
      isDerivedFrom: $.$.$.requirements.closed
    safe: ->
      comment: "Be intrisically safe"
      isDerivedFrom: $.$.$.requirements.safe
    actuated: ->
      comment: "Be actuated"
      isDerivedFrom: $.$.$.requirements.automated
    wind: ->
      comment: "Be resilient to high wind load when open/closed"
      isDerivedFrom: $.$.$.requirements.wind
  states:
    open   : -> {} # TBD by the realization
    closed : -> {} # TBD by the realization
  properties:
    powerDuringObservations: -> {} # TBD by the realization

# Below we define the systemDesign.
# It is a realization of the previously defined system concept
# (cover_sys.concept).
cover_sys.ADD MTCS_DESIGN "systemDesign",
  comment: "System design of the Mercator telescope cover"
  realizes: cover_sys.concept
  requirements:
    # Requirements defined by the system concept were added automatically
    # by realization (i.e. when the when the "realizes: ..." line
    # was executed).
    # The requirements below are new requirements, derived from the
    # realized ones.
    panelSets: ->
      comment: "Have two sets of overlapping panels, to improve sealing"
      isDerivedFrom: $.requirements.covering
    open: ->
      comment: "Be uncovered if both panel sets are open"
      refines: $.requirements.uncovered
    closed: ->
      comment: "Be covered if both panel sets are closed"
      refines: $.requirements.covered
    opening: ->
      comment: "Be opening on command within 3 seconds"
      isDerivedFrom: [$.requirements.uncovering, $.requirements.automated]
    closing: ->
      comment: "Be closing on command within 3 seconds"
      isDerivedFrom: [$.requirements.covering, $.requirements.automated]
    stopping: ->
      comment: "Be stopped on command within 3 seconds"
      isDerivedFrom: $.requirements.automated
    stopPriority: ->
      comment: "Stop command has priority over close and open command"
      isDerivedFrom: $.requirements.automated
    closePriority: ->
      comment: "Close command has priority over open command"
      isDerivedFrom: $.requirements.automated
  parts:
    # the top and bottom panelSet concepts:
    top: -> createPanelSetConcept("top")
    bottom: -> createPanelSetConcept("bottom")
    # the electric cabinet concept, to be realized below:
    cabinet: ->
      comment    : "Electrical cabinet concept"
      requirements:
        safe: ->
         comment: "The cabinet shall be safe"
         isDerivedFrom: $.$.$.requirements.safe
    # the software, to be realized by the cover_soft model:
    software: ->
      comment: "Control software concept"
  properties:
    heatDissipation: ->
        sameAs  : SUM($.parts.top.properties.powerDuringObservations,
                      $.parts.bottom.properties.powerDuringObservations)
    accelerationTime: ->
        comment : "Maximum time to accelerate"
        unit    : unit.SecondTime
        value   : 3.0
    decelerationTime: ->
        comment : "Maximum time to decelerate"
        unit    : unit.SecondTime
        value   : 3.0
  states:
    open   : -> sameAs: AND($.parts.top.states.open,
                            $.parts.bottom.states.open)
    closed : -> sameAs: AND($.parts.top.states.closed,
                            $.parts.bottom.states.closed)
    partiallyOpen: -> sameAs: NOT(OR($.states.open, $.states.closed))
    # the cover can be opening, closing, or stopped
    opening    : -> comment: "The cover is opening"
    closing    : -> comment: "The cover is closing"
    stopped    : -> comment: "The cover is stopped"
    # three commands can control the cover
    doClose    : -> comment: "The cover is commanded to close"
    doOpen     : -> comment: "The cover is commanded to open"
    doStop     : -> comment: "The cover is commanded to stop"
  transitions:
    stopped_to_opening: ->
      from     : $.states.stopped
      to       : $.states.opening
      condition: AND($.states.doOpen,
                     NOT(OR($.states.doClose,$.states.doStop)))
      within   : $.properties.accelerationTime
    stopped_to_closing: ->
      from     : $.states.stopped
      to       : $.states.closing
      condition: AND($.states.doClose, NOT($.states.doStop))
      within   : $.properties.accelerationTime
    opening_to_stopped: ->
      from     : $.states.opening
      to       : $.states.stopped
      condition: $.states.doStop
      within   : $.properties.decelerationTime
    closing_to_stopped: ->
      from     : $.states.closing
      to       : $.states.stopped
      condition: $.states.doStop
      within   : $.properties.decelerationTime
  constraints:
    opening: ->
      always     : $.transitions.stopped_to_opening
      represents : $.requirements.opening
    closing: ->
      always     : $.transitions.stopped_to_closing
      represents : [$.requirements.closing, $.requirements.closePriority]
    stop: ->
      always     : AND($.transitions.opening_to_stopped, $.transitions.closing_to_stopped)
      represents : [$.requirements.stopping, $.requirements.stopPriority]


########################################################################################################################
# TC: cabinet design
########################################################################################################################

cover_sys.ADD MTCS_DESIGN "cabinetDesign",
  comment: "System design of the electric cabinet"
  realizes: cover_sys.systemDesign.parts.cabinet
  parts:
    panel        : -> comment: "Concept: panel"             # to be realized by cover_elec model
    socket230VAC : -> comment: "Concept: 230VAC socket"     # to be realized by cover_elec model
    io           : -> comment: "Concept: I/O modules"       # to be realized by cover_elec model
    power        : -> comment: "Concept: power supply(ies)" # to be realized by cover_elec model
    terminals    : -> comment: "Concept: power terminals"   # to be realized by cover_elec model
    connectors   : -> comment: "Concept: connectors"        # to be realized by cover_elec model
  tests:
    safety: ->
      comment   : "Verify if the cabinet is in accordance to safety regulations"
      verifies  : $.requirements.safe

########################################################################################################################
# TC: panel set design
########################################################################################################################

createPanelConcept = (args) ->
  comment     : "Panel #{args.number}"
  requirements:
    open: ->
      comment: "Have an open state"
      isDerivedFrom: $.$.$.requirements.open
    closed: ->
      comment: "Have a closed state"
      isDerivedFrom: $.$.$.requirements.closed
    safe: ->
      comment: "Be intrisically safe"
      isDerivedFrom: $.$.$.requirements.safe
    actuated: ->
      comment: "Be actuated"
      isDerivedFrom: $.$.$.requirements.actuated
    wind: ->
      comment: "Be resilient to high wind load when open/closed"
      isDerivedFrom: $.$.$.requirements.wind
  states:
    open    : -> {}
    closed  : -> {}
  properties:
    powerDuringObservations : -> {}

cover_sys.ADD MTCS_DESIGN "panelSetDesign",
    realizes: [ cover_sys.systemDesign.parts.top,
                cover_sys.systemDesign.parts.bottom ]
    requirements:
        # The previously defined requirements are automatically
        # "added" by realization
        {}
    parts:
        p1: -> createPanelConcept(number: 1)
        p2: -> createPanelConcept(number: 2)
        p3: -> createPanelConcept(number: 3)
        p4: -> createPanelConcept(number: 4)
    states:
        open   : -> { sameAs: AND($.parts.p1.states.open,
                                  $.parts.p2.states.open,
                                  $.parts.p3.states.open,
                                  $.parts.p4.states.open ) }
        closed : -> { sameAs: AND($.parts.p1.states.closed,
                                  $.parts.p2.states.closed,
                                  $.parts.p3.states.closed,
                                  $.parts.p4.states.closed ) }
  properties:
    powerDuringObservations: ->
        sameAs: SUM($.parts.p1.properties.powerDuringObservations,
                    $.parts.p2.properties.powerDuringObservations,
                    $.parts.p3.properties.powerDuringObservations,
                    $.parts.p4.properties.powerDuringObservations)

##########################################################################
# The panel design
##########################################################################

cover_sys.ADD MTCS_DESIGN "panelDesign",
  comment: "The design of the telescope cover panels"
  realizes: cover_sys.panelSetDesign.parts["p#{i}"] for i in [1..4]
  requirements:
    # Previously defined requirements (open, closed, safe, ...) at the
    # concept level have been added by realization.
    # The requirements below are derived from them.
    tiltingPetal: ->
        comment: "A petal can tilt around an axis, to an open or " +
                 "closed position"
        isDerivedFrom: [ $.requirements.open, $.requirements.closed ]
    clamping: ->
        comment: "A petal can be 'clamped' by pressing the flexible " +
                 "petal against the tube or M2 before releasing power"
        isDerivedFrom: self.tiltingPetal
    closedLoop: ->
        comment: "The panel is controlled in closed loop"
        isDerivedFrom: self.clamping
    absFeedback: ->
        comment: "Absolute position feedback is available"
        isDerivedFrom: self.closedLoop
    absFeedbackStatus: ->
        comment: "The status of the absolute feedback shall be known"
        isDerivedFrom: cover_sys.systemDesign.requirements.automated
  parts:
    # below we define concepts, they still have to be realized
    # (e.g. by the realizations in the cover_mech and cover_elec models).
    petal: ->
      requirements:
        flexible: ->
          comment: "Be made of flexible material, to allow clamping"
          isDerivedFrom: [ $.$.$.requirements.clamping,
                           $.$.$.requirements.tiltingPetal ]
    shaft: ->
      requirements:
        fixedToPetal: ->
          comment: "Petal shaft, mounted inside bearings of the bracket"
          isDerivedFrom: $.$.$.requirements.tiltingPetal
    bracket: ->
      requirements:
        fixed: ->
          comment: "Fixed to the tube, holds bearings for the petal shaft"
          isDerivedFrom: $.$.$.requirements.tiltingPetal
    encoder: ->
      requirements:
        resolution: ->
          comment: "Sufficient resolution to allow repeatable " +
                   "positioning at the open/closed positions " +
                   "with the desired clamping torque"
          isDerivedFrom: [ $.$.$.requirements.clamping ]
    magnet: ->
      requirements:
        power: ->
          comment: "Sufficiently low to minimize heat dissipation, " +
                   "sufficiently high to hold petal during wind gusts"
          isDerivedFrom: [ cover_sys.systemDesign.requirements.heat
                           $.$.$.requirements.wind ]
      properties:
        power: ->
          comment: "Electric power consumption"
      states:
        on: -> comment: "Powered on"
        off: -> comment: "Powered off"
    motor: ->
      requirements:
        torque: ->
          comment: "Sufficiently low to minimize motor weight, " +
                   "sufficiently high to actuate petal"
      states:
        on: -> comment: "Powered on"
        off: -> comment: "Powered off"
    slipClutch: ->
      requirements:
        torque: ->
          comment: "Sufficiently low to allow manual opening/closing, " +
                   "sufficiently high to allow auto opening/closing"
    mot_to_shaft: ->
      comment: "Motor-to-shaft transmission"
      requirements:
        ratio: ->
          comment: "Sufficiently low to allow manual opening/closing, " +
                   "sufficiently high to allow auto opening/closing"
    enc_to_shaft: ->
      comment: "Motor-to-shaft transmission"
  properties:
    closedPosition  : ->
        comment: "Closed position (value TBD by software)"
        unit: unit.DegreeAngle
    openPosition    : ->
        comment: "Open position (value TBD by software)"
        unit: unit.DegreeAngle
    actualPosition  : ->
        comment: "Actual position (value TBD by software)"
        unit: unit.DegreeAngle
    openTolerance : ->
        comment: "Tolerance to determine if a panel is closed " +
                 "(value TBD by software)"
        unit: unit.DegreeAngle
    closedTolerance : ->
        comment: "Tolerance to determine if a panel is open " +
                 "(value TBD by software)"
        unit: unit.DegreeAngle
    maxClampingTime : ->
        comment: "Max. duration between the time when the panel is " +
                 "open/closed, and the time when the panel is clamped " +
                 "and the motor is turned off"
        unit: unit.SecondTime
        value: 5.0
  states:
    open: ->
      sameAs: LT( ABS( SUB($.properties.actualPosition,
                           $.properties.openPosition  ) ),
                  $.properties.openTolerance )
    closed  : ->
      sameAs: LT( ABS( SUB($.properties.actualPosition,
                           $.properties.closedPosition) ),
                  $.properties.closedTolerance )
    clamped: ->
      sameAs: AND( OR($.states.open, $.states.closed),
                   $.parts.motor.states.off,
                   $.parts.magnet.states.on)
  constraints:
    powerDuringObservations: ->
      always:
        if: AND($.states.open, $.states.clamped)
        then: EQ($.properties.powerDuringObservations,
                 $.parts.magnet.properties.power)





########################################################################################################################
# Write the model to file
########################################################################################################################

cover_sys.WRITE "models/mtcs/cover/system.jsonld"
