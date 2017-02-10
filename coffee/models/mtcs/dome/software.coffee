##########################################################################
#                                                                        #
# Model of the dome software.                                           #
#                                                                        #
##########################################################################

require "ontoscript"

# models
REQUIRE "models/mtcs/common/software.coffee"
REQUIRE "models/util/softwarefactories.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/dome/software" : "dome_soft"

dome_soft.IMPORT common_soft

##########################################################################
# Define the containing PLC library
##########################################################################

dome_soft.ADD MTCS_MAKE_LIB "mtcs_dome"

# make aliases (with scope of this file only)
COMMONLIB = common_soft.mtcs_common
THISLIB   = dome_soft.mtcs_dome


##########################################################################
# DomeConfig
###########################################################################

MTCS_MAKE_CONFIG THISLIB, "DomeConfig",
  items:
    shutter             : { comment: "The config of the shutter mechanism" }
    rotation            : { comment: "The config of the bottom panel set" }
    maxTrackingDistance : { comment: "The maximum distance between telescope and dome while tracking",  type: t_double }


##########################################################################
# DomeShutterConfig
###########################################################################

MTCS_MAKE_CONFIG THISLIB, "DomeShutterConfig",
  typeOf: THISLIB.DomeConfig.shutter
  items:
    wirelessPolling         : { type: t_double, comment: "Polling frequency of the wireless I/O device, in seconds. Negative value = no polling." }
    wirelessIpAddress       : { type: t_string, comment: "IP address of the wireless I/O device" }
    wirelessPort            : { type: t_uint16, comment: "Port of the wireless I/O device" }
    wirelessUnitID          : { type: t_uint8 , comment: "Unit ID the wireless I/O device" }
    wirelessTimeoutSeconds  : { type: t_double, comment: "The timeout of a single command. Does not lead to an error (yet), because we still retry."}
    wirelessRetriesSeconds  : { type: t_double, comment: "The total timeout of the retries. If no valid data is received after this time, then we consider the shutters in error." }
    upperEstimatedOpenTime  : { type: t_double, comment: "Estimated opening time of the upper panel, in seconds"}
    upperEstimatedCloseTime : { type: t_double, comment: "Estimated closing time of the upper panel, in seconds"}
    lowerEstimatedOpenTime  : { type: t_double, comment: "Estimated opening time of the lower panel, in seconds"}
    lowerEstimatedCloseTime : { type: t_double, comment: "Estimated closing time of the lower panel, in seconds"}
    lowerOpenTimeout        : { type: t_double, comment: "Opening timeout of the lower panel, in seconds"}
    lowerCloseTimeout       : { type: t_double, comment: "Closing timeout of the lower panel, in seconds"}
    upperOpenTimeout        : { type: t_double, comment: "Opening timeout of the upper panel, in seconds"}
    upperCloseTimeout       : { type: t_double, comment: "Closing timeout of the upper panel, in seconds"}
    timeAfterStop           : { type: t_double, comment: "Time to wait after a stop command, in seconds"}

##########################################################################
# DomeRotationConfig
###########################################################################

MTCS_MAKE_CONFIG THISLIB, "DomeRotationConfig",
  typeOf: THISLIB.DomeConfig.rotation
  items:
    maxMasterSlaveLag  : { type: t_double, comment: "Below this lag value (in degrees), the lag is considered not an error" }



########################################################################################################################
# Dome
########################################################################################################################

MTCS_MAKE_STATEMACHINE THISLIB, "Dome",
  variables:
    editableConfig              : { type: THISLIB.DomeConfig                , comment: "Editable configuration of the cover" }
  references:
    operatorStatus              : { type: COMMONLIB.OperatorStatus          , comment: "Reference to the operator (observer/tech)"}
    aziPos                      : { type: COMMONLIB.AngularPosition         , comment: "Actual azimuth position of the telescope Axes"}
  variables_read_only:
    config                      : { type: THISLIB.DomeConfig                , comment: "Active configuration of the cover" }
    isPoweredOffByPersonInDome  : { type: t_bool                            , comment: "True if the dome is powered off due to a person entering the dome" }
    isTracking                  : { type: t_bool                            , comment: "True if the dome is tracking the telescope" }
  parts:
    shutter:
      comment                   : "Shutter mechanism"
      arguments:
        initializationStatus    : { comment: "Dome initialization status (initialized/initializing/...)" }
        operatorStatus          : { comment: "MTCS operator (observer/tech)" }
        operatingStatus         : { comment: "Dome operating status (manual/auto)" }
        config                  : { comment: "The shutter config" }
      attributes:
        statuses:
          attributes:
            healthStatus        : { type: COMMONLIB.HealthStatus }
            busyStatus          : { type: COMMONLIB.BusyStatus }
    rotation:
      comment                   : "Rotation mechanism"
      arguments:
        initializationStatus    : { comment: "Dome initialization status (initialized/initializing/...)"}
        operatorStatus          : { comment: "MTCS operator (observer/tech)"}
        operatingStatus         : { comment: "Dome operating status (manual/auto)"}
        config                  : { comment: "The rotation config"}
      attributes:
        statuses:
          attributes:
            healthStatus        : { type: COMMONLIB.HealthStatus }
            busyStatus          : { type: COMMONLIB.BusyStatus }
            poweredStatus       : { type: COMMONLIB.PoweredStatus }
    io:
      comment                   : "EtherCAT devices"
      attributes:
        statuses:
          attributes:
            healthStatus        : { type: COMMONLIB.HealthStatus }
    configManager:
      comment                   : "The config manager (to load/save/activate configuration data)"
      type                      : COMMONLIB.ConfigManager
  statuses:
    initializationStatus        : { type: COMMONLIB.InitializationStatus }
    healthStatus                : { type: COMMONLIB.HealthStatus }
    busyStatus                  : { type: COMMONLIB.BusyStatus }
    operatingStatus             : { type: COMMONLIB.OperatingStatus }
    poweredStatus               : { type: COMMONLIB.PoweredStatus }
  processes:
    initialize                  : { type: COMMONLIB.Process                     , comment: "Start initializing" }
    lock                        : { type: COMMONLIB.Process                     , comment: "Lock the cover" }
    unlock                      : { type: COMMONLIB.Process                     , comment: "Unlock the cover" }
    changeOperatingState        : { type: COMMONLIB.ChangeOperatingStateProcess , comment: "Change the operating state (e.g. AUTO, MANUAL, ...)" }
    reset                       : { type: COMMONLIB.Process                     , comment: "Reset any errors" }
    powerOn                     : { type: COMMONLIB.Process                     , comment: "Power on the dome" }
    powerOff                    : { type: COMMONLIB.Process                     , comment: "Power off the dome" }
    syncWithAxes                : { type: COMMONLIB.Process                     , comment: "Synchronize the dome once with the axes" }
    trackAxes                   : { type: COMMONLIB.Process                     , comment: "Start tracking the axes" }
    stop                        : { type: COMMONLIB.Process                     , comment: "Stop the rotation movement and/or tracking" }
  calls:
    # processes
    initialize:
      isEnabled                 : -> OR(self.statuses.initializationStatus.shutdown,
                                        self.statuses.initializationStatus.initializingFailed,
                                        self.statuses.initializationStatus.initialized)
    lock:
      isEnabled                 : -> AND(self.operatorStatus.tech,
                                         self.statuses.initializationStatus.initialized)
    unlock:
      isEnabled                 : -> AND(self.operatorStatus.tech,
                                         self.statuses.initializationStatus.locked)
    changeOperatingState:
      isEnabled                 : -> AND(self.statuses.busyStatus.idle,
                                         self.statuses.initializationStatus.initialized)
    reset:
      isEnabled                 : -> AND(self.statuses.busyStatus.idle,
                                         self.statuses.initializationStatus.initialized)
    powerOn:
      isEnabled                 : -> AND(self.statuses.initializationStatus.initialized,
                                         self.processes.powerOn.statuses.busyStatus.idle )
    powerOff:
      isEnabled                 : -> AND(self.statuses.initializationStatus.initialized,
                                         self.processes.powerOff.statuses.busyStatus.idle )
    stop:
      isEnabled                 : -> OR(self.statuses.busyStatus.busy, self.isTracking)
    trackAxes:
      isEnabled                 : -> self.statuses.poweredStatus.enabled
    # parts
    shutter:
      initializationStatus      : -> self.statuses.initializationStatus
      operatorStatus            : -> self.operatorStatus
      operatingStatus           : -> self.statuses.operatingStatus
      config                    : -> self.config.shutter
    rotation:
      initializationStatus      : -> self.statuses.initializationStatus
      operatorStatus            : -> self.operatorStatus
      operatingStatus           : -> self.statuses.operatingStatus
      config                    : -> self.config.rotation
    configManager:
      isEnabled                 : -> self.operatorStatus.tech
    # statuses
    poweredStatus:
      isEnabled                 : -> self.parts.rotation.statuses.poweredStatus.enabled
    operatingStatus:
      superState                : -> self.statuses.initializationStatus.initialized
    healthStatus:
      isGood                    : -> MTCS_SUMMARIZE_GOOD(self.parts.shutter,
                                                         self.parts.rotation,
                                                         self.parts.io)
      hasWarning                : -> MTCS_SUMMARIZE_WARN(self.parts.shutter,
                                                         self.parts.rotation,
                                                         self.parts.io)
    busyStatus:
      isBusy                    : -> MTCS_SUMMARIZE_BUSY(self.parts.shutter,
                                                         self.parts.rotation)



########################################################################################################################
# DomeShutter
########################################################################################################################

MTCS_MAKE_STATEMACHINE THISLIB, "DomeShutter",
  typeOf: THISLIB.DomeParts.shutter
  variables:
    lowerOpenSignal         : { type: t_bool                            , comment: "False if the signal is not present OR if there is a communication error" }
    lowerClosedSignal       : { type: t_bool                            , comment: "False if the signal is not present OR if there is a communication error" }
    upperOpenSignal         : { type: t_bool                            , comment: "False if the signal is not present OR if there is a communication error" }
    upperClosedSignal       : { type: t_bool                            , comment: "False if the signal is not present OR if there is a communication error" }
    wirelessTimeout         : { type: t_bool                            , comment: "True if the wireless communication to the shutter signals is timing out" }
    wirelessError           : { type: t_bool                            , comment: "True if the wireless communication to the shutter signals is in error (other than timeout)" }
    wirelessErrorId         : { type: t_uint32                          , comment: "The error id if wirelessError is true" }
    wirelessData            : { type: t_uint16                          , comment: "The received wireless data" }
    upperTimeRemaining      : { type: COMMONLIB.Duration                , comment: "Estimated time remaining to open/close the upper panel" }
    lowerTimeRemaining      : { type: COMMONLIB.Duration                , comment: "Estimated time remaining to open/close the lower panel" }
  references:
    initializationStatus    : { type: COMMONLIB.InitializationStatus    , comment: "Dome initialization status (initialized/initializing/...)"}
    operatorStatus          : { type: COMMONLIB.OperatorStatus          , comment: "MTCS operator (observer/tech)"}
    operatingStatus         : { type: COMMONLIB.OperatingStatus         , comment: "Dome operating status (manual/auto)"}
    config                  : { type: THISLIB.DomeShutterConfig         , comment: "The shutter config"}
  parts:
    pumpsRelay              : { type: COMMONLIB.SimpleRelay             , comment: "Relay to start the pumps motors" }
    upperOpenRelay          : { type: COMMONLIB.SimpleRelay             , comment: "Relay to open the upper shutter panel" }
    upperCloseRelay         : { type: COMMONLIB.SimpleRelay             , comment: "Relay to close the upper shutter panel" }
    lowerOpenRelay          : { type: COMMONLIB.SimpleRelay             , comment: "Relay to open the upper shutter panel" }
    lowerCloseRelay         : { type: COMMONLIB.SimpleRelay             , comment: "Relay to close the upper shutter panel" }
  statuses:
    apertureStatus          : { type: COMMONLIB.ApertureStatus          , comment: "Combined aperture status (i.e. of both panels)" }
    lowerApertureStatus     : { type: COMMONLIB.ApertureStatus          , comment: "Aperture status of the lower panel" }
    upperApertureStatus     : { type: COMMONLIB.ApertureStatus          , comment: "Aperture status of the upper panel" }
    healthStatus            : { type: COMMONLIB.HealthStatus            , comment: "Health status"}
    busyStatus              : { type: COMMONLIB.BusyStatus              , comment: "Busy status" }
  processes:
    reset                   : { type: COMMONLIB.Process                 , comment: "Reset errors" }
    open                    : { type: COMMONLIB.Process                 , comment: "Open both panels" }
    close                   : { type: COMMONLIB.Process                 , comment: "Close both panels" }
    stop                    : { type: COMMONLIB.Process                 , comment: "Stop the panels" }
    lowerOpen               : { type: COMMONLIB.Process                 , comment: "Open the lower panel" }
    lowerClose              : { type: COMMONLIB.Process                 , comment: "Close the lower panel" }
    upperOpen               : { type: COMMONLIB.Process                 , comment: "Open the upper panel" }
    upperClose              : { type: COMMONLIB.Process                 , comment: "Close the upper panel" }
  calls:
    # processes
    stop:
      isEnabled             : -> self.statuses.busyStatus.busy
    reset:
      isEnabled             : -> TRUE
    open:
      isEnabled             : -> AND(self.statuses.busyStatus.idle, self.initializationStatus.initialized)
    lowerOpen:
      isEnabled             : -> self.processes.open.isEnabled # same as processes.open
    upperOpen:
      isEnabled             : -> self.processes.open.isEnabled # same as processes.open
    close:
      isEnabled             : -> AND(self.statuses.busyStatus.idle, self.initializationStatus.initialized)
    lowerClose:
      isEnabled             : -> self.processes.close.isEnabled # same as processes.close
    upperOpen:
      isEnabled             : -> self.processes.close.isEnabled # same as processes.close
    # relays
    pumpsRelay:
      isEnabled             : -> self.operatorStatus.tech
    upperOpenRelay:
      isEnabled             : -> self.operatorStatus.tech
    upperCloseRelay:
      isEnabled             : -> self.operatorStatus.tech
    lowerOpenRelay:
      isEnabled             : -> self.operatorStatus.tech
    lowerCloseRelay:
      isEnabled             : -> self.operatorStatus.tech
    # statuses
    lowerApertureStatus:
      superState            : -> NOT(OR(self.wirelessTimeout,self.wirelessError))
      isOpen                : -> self.lowerOpenSignal
      isClosed              : -> self.lowerClosedSignal
    upperApertureStatus:
      superState            : -> NOT(OR(self.wirelessTimeout,self.wirelessError))
      isOpen                : -> self.upperOpenSignal
      isClosed              : -> self.upperClosedSignal
    apertureStatus:
      superState            : -> NOT(OR(self.wirelessTimeout,self.wirelessError))
      isOpen                : -> AND(self.statuses.lowerApertureStatus.open     , self.statuses.upperApertureStatus.open )
      isClosed              : -> AND(self.statuses.lowerApertureStatus.closed   , self.statuses.upperApertureStatus.closed )
    healthStatus:
      isGood                : -> AND(
                                    NOT(OR(self.wirelessTimeout,self.wirelessError)),
                                    MTCS_SUMMARIZE_GOOD(self.processes.reset,
                                                        self.processes.open,
                                                        self.processes.close,
                                                        self.processes.stop,
                                                        self.processes.lowerOpen,
                                                        self.processes.lowerClose,
                                                        self.processes.upperOpen,
                                                        self.processes.upperClose ))
      hasWarning            : -> MTCS_SUMMARIZE_WARN( self.processes.reset,
                                                      self.processes.open,
                                                      self.processes.close,
                                                      self.processes.stop,
                                                      self.processes.lowerOpen,
                                                      self.processes.lowerClose,
                                                      self.processes.upperOpen,
                                                      self.processes.upperClose )
    busyStatus:
      isBusy                : -> MTCS_SUMMARIZE_BUSY( self.processes.reset,
                                                      self.processes.open,
                                                      self.processes.close,
                                                      self.processes.stop,
                                                      self.processes.lowerOpen,
                                                      self.processes.lowerClose,
                                                      self.processes.upperOpen,
                                                      self.processes.upperClose )


########################################################################################################################
# DomeRotation
########################################################################################################################

MTCS_MAKE_STATEMACHINE THISLIB, "DomeRotation",
  typeOf: THISLIB.DomeParts.rotation
  variables_read_only:
    actPos                      : { type: COMMONLIB.AngularPosition         , comment: "The actual position (same as parts.masterAxis!)", expand: false }
    actVelo                     : { type: COMMONLIB.AngularVelocity         , comment: "The actual velocity (same as parts.masterAxis!)", expand: false }
    actAcc                      : { type: COMMONLIB.AngularAcceleration     , comment: "The actual acceleration (same as parts.masterAxis!)", expand: false }
    actTorqueMaster             : { type: COMMONLIB.Torque                  , comment: "The actual torque on the telescope axis by the master motor", expand: false }
    actTorqueSlave              : { type: COMMONLIB.Torque                  , comment: "The actual torque on the telescope axis by the slave motor", expand: false }
    masterSlaveLag              : { type: COMMONLIB.AngularPosition         , comment: "masterAxis.actPos - slaveAxis.actPos" }
    masterSlaveLagError         : { type: t_bool                            , comment: "masterSlaveLag >= config.maxMasterSlaveLag" }
    homingSensorSignal          : { type: t_bool                            , comment: "True = at home position"}
  references:
    initializationStatus        : { type: COMMONLIB.InitializationStatus    , comment: "Reference to the MTCS initialization status"}
    operatorStatus              : { type: COMMONLIB.OperatorStatus          , comment: "Reference to the MTCS operator status"}
    operatingStatus             : { type: COMMONLIB.OperatingStatus         , comment: "Reference to the Dome operating status"}
    config                      : { type: THISLIB.DomeRotationConfig        , comment: "Reference to the rotation config"}
  parts:
    masterAxis                  : { type: COMMONLIB.AngularAxis             , comment: "Master axis" }
    slaveAxis                   : { type: COMMONLIB.AngularAxis             , comment: "Slave axis" }
    drive                       : { type: COMMONLIB.AX52XXDrive             , comment: "Dual axis drive" }
  statuses:
    healthStatus                : { type: COMMONLIB.HealthStatus            , comment: "Health status"}
    busyStatus                  : { type: COMMONLIB.BusyStatus              , comment: "Busy status" }
    poweredStatus               : { type: COMMONLIB.PoweredStatus           , comment: "Powered status" }
  processes:
    reset                       : { type: COMMONLIB.Process                 , comment: "Reset errors" }
    stop                        : { type: COMMONLIB.Process                 , comment: "Stop the rotation" }
  calls:
    reset:
      isEnabled                 : -> self.statuses.busyStatus.idle
    stop:
      isEnabled                 : -> self.statuses.busyStatus.busy
    # parts
    masterAxis:
      isEnabled                 : -> self.operatorStatus.tech
    slaveAxis:
      isEnabled                 : -> self.operatorStatus.tech
    drive:
      isEnabled                 : -> self.operatorStatus.tech
    # statuses
    poweredStatus:
      isEnabled             : -> AND(self.parts.masterAxis.statuses.poweredStatus.enabled,
                                     self.parts.slaveAxis.statuses.poweredStatus.enabled)
    healthStatus:
      isGood                : -> AND(
                                    MTCS_SUMMARIZE_GOOD(self.parts.masterAxis,
                                                        self.parts.slaveAxis,
                                                        self.parts.drive,
                                                        self.processes.reset,
                                                        self.processes.stop),
                                    NOT(self.masterSlaveLagError))
      hasWarning            : -> MTCS_SUMMARIZE_WARN(self.parts.masterAxis,
                                                     self.parts.slaveAxis,
                                                     self.parts.drive,
                                                     self.processes.reset,
                                                     self.processes.stop)
    busyStatus:
      isBusy                : -> MTCS_SUMMARIZE_BUSY(self.parts.masterAxis,
                                                     self.parts.slaveAxis,
                                                     self.parts.drive,
                                                     self.processes.reset,
                                                     self.processes.stop)

########################################################################################################################
# DomeIO
########################################################################################################################

MTCS_MAKE_STATEMACHINE THISLIB, "DomeIO",
  typeOf        : [ THISLIB.DomeParts.io ]
  statuses:
    healthStatus  : { type: COMMONLIB.HealthStatus   , comment: "Is the I/O in a healthy state?"  }
  parts:
    coupler     : { type: COMMONLIB.EtherCatDevice , comment: "Coupler" }
    slot1       : { type: COMMONLIB.EtherCatDevice , comment: "Slot 1" }
    slot2       : { type: COMMONLIB.EtherCatDevice , comment: "Slot 2" }
    slot3       : { type: COMMONLIB.EtherCatDevice , comment: "Slot 3" }
    slot4       : { type: COMMONLIB.EtherCatDevice , comment: "Slot 4" }
    slot5       : { type: COMMONLIB.EtherCatDevice , comment: "Slot 5" }
    slot6       : { type: COMMONLIB.EtherCatDevice , comment: "Slot 6" }
    slot7       : { type: COMMONLIB.EtherCatDevice , comment: "Slot 7" }
    slot8       : { type: COMMONLIB.EtherCatDevice , comment: "Slot 8" }
  calls:
    coupler:
      id      : -> STRING("110A1") "id"
      typeId    : -> STRING("EK1101") "typeId"
    slot1:
      id      : -> STRING("115A1") "id"
      typeId    : -> STRING("EL2008") "typeId"
    slot2:
      id      : -> STRING("116A1") "id"
      typeId    : -> STRING("EL4008") "typeId"
    slot3:
      id      : -> STRING("117A1") "id"
      typeId    : -> STRING("EL1088") "typeId"
    slot4:
      id      : -> STRING("118A1") "id"
      typeId    : -> STRING("EL5002") "typeId"
    slot5:
      id      : -> STRING("118A5") "id"
      typeId    : -> STRING("EL5002") "typeId"
    slot6:
      id      : -> STRING("119A1") "id"
      typeId    : -> STRING("EL5002") "typeId"
    slot7:
      id      : -> STRING("119A5") "id"
      typeId    : -> STRING("EL5002") "typeId"
    slot8:
      id      : -> STRING("111A1") "id"
      typeId    : -> STRING("EL2622") "typeId"
    healthStatus:
      isGood    : -> MTCS_SUMMARIZE_GOOD(
                          self.parts.coupler,
                          self.parts.slot1,
                          self.parts.slot2,
                          self.parts.slot3,
                          self.parts.slot4,
                          self.parts.slot5,
                          self.parts.slot6,
                          self.parts.slot7,
                          self.parts.slot8 )


########################################################################################################################
# Write the model to file
########################################################################################################################

dome_soft.WRITE "models/mtcs/dome/software.jsonld"
