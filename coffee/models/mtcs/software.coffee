########################################################################################################################
#                                                                                                                      #
# Model containing the upper-level software design of the Mercator TCS.                                                #
#                                                                                                                      #
########################################################################################################################
require "ontoscript"

# models
REQUIRE "models/mtcs/cover/software.coffee"
REQUIRE "models/mtcs/m1/software.coffee"
REQUIRE "models/mtcs/m2/software.coffee"
REQUIRE "models/mtcs/m3/software.coffee"
REQUIRE "models/mtcs/services/software.coffee"
REQUIRE "models/mtcs/telemetry/software.coffee"
REQUIRE "models/mtcs/safety/software.coffee"
REQUIRE "models/mtcs/hydraulics/software.coffee"
REQUIRE "models/mtcs/axes/software.coffee"
REQUIRE "models/mtcs/dome/software.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/software" : "mtcs_soft"

mtcs_soft.IMPORT common_soft
mtcs_soft.IMPORT cover_elec
mtcs_soft.IMPORT cover_soft
mtcs_soft.IMPORT m1_soft
mtcs_soft.IMPORT m2_soft
mtcs_soft.IMPORT m3_soft
mtcs_soft.IMPORT services_soft
mtcs_soft.IMPORT telemetry_soft
mtcs_soft.IMPORT safety_soft
mtcs_soft.IMPORT hydraulics_soft
mtcs_soft.IMPORT axes_soft
mtcs_soft.IMPORT dome_soft


########################################################################################################################
# Define the containing PLC library
########################################################################################################################

mtcs_soft.ADD MTCS_MAKE_LIB "mtcs"

# make aliases (with scope of this file only)
COMMONLIB    = common_soft.mtcs_common
COVERLIB     = cover_soft.mtcs_cover
M1LIB        = m1_soft.mtcs_m1
M2LIB        = m2_soft.mtcs_m2
M3LIB        = m3_soft.mtcs_m3
SERVICESLIB  = services_soft.mtcs_services
TELEMETRYLIB = telemetry_soft.mtcs_telemetry
SAFETYLIB    = safety_soft.mtcs_safety
HYDRAULICSLIB= hydraulics_soft.mtcs_hydraulics
AXESLIB      = axes_soft.mtcs_axes
DOMELIB      = dome_soft.mtcs_dome

# also make an alias for the current lib
THISLIB   = mtcs_soft.mtcs




########################################################################################################################
# MTCSInstrumentsConfig
########################################################################################################################
MTCS_MAKE_CONFIG THISLIB, "MTCSInstrumentsConfig",
    items:
        instrument0: { type: COMMONLIB.InstrumentConfig, comment: "Instrument 0", expand: false }
        instrument1: { type: COMMONLIB.InstrumentConfig, comment: "Instrument 1", expand: false }
        instrument2: { type: COMMONLIB.InstrumentConfig, comment: "Instrument 2", expand: false }
        instrument3: { type: COMMONLIB.InstrumentConfig, comment: "Instrument 3", expand: false }
        instrument4: { type: COMMONLIB.InstrumentConfig, comment: "Instrument 4", expand: false }
        instrument5: { type: COMMONLIB.InstrumentConfig, comment: "Instrument 5", expand: false }
        instrument6: { type: COMMONLIB.InstrumentConfig, comment: "Instrument 6", expand: false }
        instrument7: { type: COMMONLIB.InstrumentConfig, comment: "Instrument 7", expand: false }
        instrument8: { type: COMMONLIB.InstrumentConfig, comment: "Instrument 8", expand: false }
        instrument9: { type: COMMONLIB.InstrumentConfig, comment: "Instrument 9", expand: false }


########################################################################################################################
# MTCSParkPositionConfig
########################################################################################################################
MTCS_MAKE_CONFIG THISLIB, "MTCSParkPositionConfig",
    items:
        name    : { type: t_string, comment: "The name of the position (e.g. 'PARK')" }
        axes    : { type: t_string, comment: "Name of the corresponding Axes position" }
        doAxes  : { type: t_bool,   comment: "Change the Axes to the 'axes' position" }
        m3      : { type: t_string, comment: "Name of the corresponding M3 position" }
        doM3    : { type: t_bool,   comment: "Change M3 to the 'm3' position" }
        dome    : { type: t_string, comment: "Name of the corresponding dome position" }
        doDome  : { type: t_bool,   comment: "Change M3 to the 'm3' position" }

########################################################################################################################
# MTCSParkPositionsConfig
########################################################################################################################
MTCS_MAKE_CONFIG THISLIB, "MTCSParkPositionsConfig",
    items:
        position0     : { type: THISLIB.MTCSParkPositionConfig, comment : "Park position 0"   , expand: false }
        position1     : { type: THISLIB.MTCSParkPositionConfig, comment : "Park position 1"   , expand: false }
        position2     : { type: THISLIB.MTCSParkPositionConfig, comment : "Park position 2"   , expand: false }
        position3     : { type: THISLIB.MTCSParkPositionConfig, comment : "Park position 3"   , expand: false }
        position4     : { type: THISLIB.MTCSParkPositionConfig, comment : "Park position 4"   , expand: false }
        position5     : { type: THISLIB.MTCSParkPositionConfig, comment : "Park position 5"   , expand: false }
        position6     : { type: THISLIB.MTCSParkPositionConfig, comment : "Park position 6"   , expand: false }
        position7     : { type: THISLIB.MTCSParkPositionConfig, comment : "Park position 7"   , expand: false }
        position8     : { type: THISLIB.MTCSParkPositionConfig, comment : "Park position 8"   , expand: false }
        position9     : { type: THISLIB.MTCSParkPositionConfig, comment : "Park position 9"   , expand: false }

########################################################################################################################
# MTCSEndOfNightStepConfig
########################################################################################################################
MTCS_MAKE_CONFIG THISLIB, "MTCSEndOfNightStepConfig",
    items:
        parkAxes              : { type: t_bool   , comment: "Park the telescope" }
        parkAxesPosition      : { type: t_string , comment: "Position to park the telescope" }
        parkTelescopeWait     : { type: t_bool   , comment: "Wait until the telescope is parked" }
        parkM3                : { type: t_bool   , comment: "Park M3" }
        parkM3Position        : { type: t_string , comment: "Position to park M3" }
        parkM3Wait            : { type: t_bool   , comment: "Wait until M3 is parked" }
        parkDome              : { type: t_bool   , comment: "Park the dome" }
        parkDomePosition      : { type: t_string , comment: "Position to park the dome" }
        parkDomeWait          : { type: t_bool   , comment: "Wait until the dome is parked" }
        closeCover            : { type: t_bool   , comment: "Close the cover" }
        closeCoverWait        : { type: t_bool   , comment: "Wait until the cover is closed" }
        closeDome             : { type: t_bool   , comment: "Close the dome" }
        closeDomeWait         : { type: t_bool   , comment: "Wait until the dome is closed" }
        stop                  : { type: t_bool   , comment: "Stop the axes and dome" }
        stopWait              : { type: t_bool   , comment: "Wait until the axes and dome are stopped" }
        goToSleep             : { type: t_bool   , comment: "Make the telescope go to sleep" }
        goToSleepWait         : { type: t_bool   , comment: "Wait until the telescope is sleeping" }


########################################################################################################################
# MTCSEndOfNightConfig
########################################################################################################################
MTCS_MAKE_CONFIG THISLIB, "MTCSEndOfNightConfig",
    items:
        step0 : { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 0" , expand: false }
        step1 : { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 1" , expand: false }
        step2 : { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 2" , expand: false }
        step3 : { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 3" , expand: false }
        step4 : { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 4" , expand: false }
        step5 : { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 5" , expand: false }
        step6 : { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 6" , expand: false }
        step7 : { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 7" , expand: false }
        step8 : { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 8" , expand: false }
        step9 : { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 9" , expand: false }
        step10: { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 10", expand: false }
        step11: { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 11", expand: false }
        step12: { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 12", expand: false }
        step13: { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 13", expand: false }
        step14: { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 14", expand: false }
        step15: { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 15", expand: false }
        step16: { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 16", expand: false }
        step17: { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 17", expand: false }
        step18: { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 18", expand: false }
        step19: { type: THISLIB.MTCSEndOfNightStepConfig, comment: "Step 19", expand: false }


########################################################################################################################
# MTCSConfig
########################################################################################################################
MTCS_MAKE_CONFIG THISLIB, "MTCSConfig",
    items:
        instruments:
            type: THISLIB.MTCSInstrumentsConfig
            comment: "Configure the instruments"
        endOfNight:
            type: THISLIB.MTCSEndOfNightConfig
            comment: "Configure the instruments"
            expand: false
        parkPositions:
            type: THISLIB.MTCSParkPositionsConfig
            comment: "Configure the park positions of the telescope (dome+telescope+m3+...)"


########################################################################################################################
# MTCSChangeInstrumentProcess
########################################################################################################################
MTCS_MAKE_PROCESS THISLIB, "MTCSChangeInstrumentProcess",
    extends: COMMONLIB.BaseProcess
    arguments:
        name : { type: t_string, comment: "Name of the instrument" }


########################################################################################################################
# MTCSParkProcess
########################################################################################################################
MTCS_MAKE_PROCESS THISLIB, "MTCSParkProcess",
    extends: COMMONLIB.BaseProcess
    arguments:
        name : { type: t_string, comment: "Name of the park position" }


########################################################################################################################
# MTCSPointProcess
########################################################################################################################
MTCS_MAKE_PROCESS THISLIB, "MTCSPointProcess",
    extends: COMMONLIB.BaseProcess
    arguments:
        # from AxesPointProcess
        alphaUnits          : { type: AXESLIB.AxesAlphaUnits    , comment: "The units in which alpha is given" }
        alpha               : { type: t_double                  , comment: "Right ascention, in the units of the alphaUnits argument" }
        deltaUnits          : { type: AXESLIB.AxesDeltaUnits    , comment: "The units in which delta is given" }
        delta               : { type: t_double                  , comment: "Declination, in the units of the deltaUnits argument" }
        muUnits             : { type: AXESLIB.AxesMuUnits       , comment: "The units in which muAlpha and muDelta are given" }
        muAlpha             : { type: t_double                  , comment: "Right ascention proper motion, the units of muUmits (do not multiply by cos(delta)!)" }
        muDelta             : { type: t_double                  , comment: "Declination proper motion, in radians/year" }
        parallax            : { type: t_double                  , comment: "Object parallax, in arcseconds" }
        radialVelocity      : { type: t_double                  , comment: "Object radial velocity, in km/s" }
        epoch               : { type: t_double, initial: 2000.0 , comment: "Epoch, e.g. 2000.0" }
        tracking            : { type: t_bool  , initial: true   , comment: "True to start tracking the object, false to Only do a pointing" }
        rotUnits            : { type: AXESLIB.AxesMoveUnits     , comment: "Units of the 'rot', 'roc' and 'ron' arguments (RADIANS, DEGREES, ARCSECONDS, ...)"}
        rotOffset           : { type: t_double                  , comment: "Offset to move the currently active rotator (incompatible with 'roc' and 'ron' args)"}
        rocOffset           : { type: t_double                  , comment: "Offset to move the cassegrain rotation axis (incompatible with 'rot' arg)" }
        ronOffset           : { type: t_double                  , comment: "Offset to move the nasmyth rotation axis (incompatible with 'rot' arg)" }
        doRotOffset         : { type: t_bool                    , comment: "True to move the currently active rotator, false to leave it untouched" }
        doRocOffset         : { type: t_bool                    , comment: "True to move the cassegrain rotation axis, false to leave it untouched" }
        doRonOffset         : { type: t_bool                    , comment: "True to move the nasmyth rotation axis, false to leave it untouched" }
        # dome
        doDomeTracking      : { type: t_bool   , initial: true  , comment: "True to enable dome tracking" }

########################################################################################################################
# MTCS
########################################################################################################################
MTCS_MAKE_STATEMACHINE THISLIB, "MTCS",
    variables:
        editableConfig              : { type: THISLIB.MTCSConfig                        , comment: "Editable configuration of the MTCS" , expand: false }
    variables_read_only:
        noOfFailedOperatorChanges   : { type: t_uint16                                  , comment: "How many times has a wrong password been entered?"}
        activeInstrument            : { type: COMMONLIB.InstrumentConfig                , comment: "Config of the currently active instrument (depending on M3 and possibly derotator) *if* isInstrumentActive is TRUE" , expand: false}
        activeInstrumentNumber      : { type: t_int16                                   , comment: "Number of the currently active instrument (0..9, or -1 if no instrument is active)" }
        activeInstrumentName        : { type: t_string                                  , comment: "Name of the currently active instrument" }
        isInstrumentActive          : { type: t_bool                                    , comment: "Is an instrument currently active (i.e. is M3 static at a known position?)"}
        config                      : { type: THISLIB.MTCSConfig                        , comment: "Active configuration of the ServicesTiming subsystem" }
    parts:
        telemetry:
            type : TELEMETRYLIB.Telemetry
            comment: "The telemetry"
            expand: false
            arguments:
                operatorStatus          : { type: COMMONLIB.OperatorStatus, expand: false }
            attributes:
                parts:
                    attributes:
                        temperatures    : { type: TELEMETRYLIB.TelemetryTemperatures , expand: false }
                        accelerometers:
                            attributes:
                                tube    : { type: TELEMETRYLIB.TelemetryAccelerometer , expand: false }
                statuses:
                    attributes:
                        healthStatus    : { type: COMMONLIB.HealthStatus }
                        busyStatus      : { type: COMMONLIB.BusyStatus }
        cover:
            type : COVERLIB.Cover
            comment: "The Cover of the telescope"
            expand: false
            arguments:
                operatorStatus          : { type: COMMONLIB.OperatorStatus, expand: false }
                aziPos                  : { type: COMMONLIB.AngularPosition, expand: false }
                elePos                  : { type: COMMONLIB.AngularPosition, expand: false }
            attributes:
                statuses:
                    attributes:
                        healthStatus    : { type: COMMONLIB.HealthStatus }
                        busyStatus      : { type: COMMONLIB.BusyStatus }
        m1:
            type : M1LIB.M1
            comment: "The primary mirror of the telescope"
            expand: false
            arguments:
                tubeAngleMeasurement    : { type: TELEMETRYLIB.TelemetryAccelerometer , expand: false }
                operatorStatus          : { type: COMMONLIB.OperatorStatus, expand: false }
            attributes:
                parts:
                    attributes:
                        io              : { type: M1LIB.M1M2IO , expand: false }
                statuses:
                    attributes:
                        healthStatus    : { type: COMMONLIB.HealthStatus }
                        busyStatus      : { type: COMMONLIB.BusyStatus }

        m2:
            type : M2LIB.M2
            comment: "The secondary mirror of the telescope"
            expand: false
            arguments:
                io                      : { type: M1LIB.M1M2IO , expand: false }
                operatorStatus          : { type: COMMONLIB.OperatorStatus, expand: false }
                actualFocalStation      : { type: M3LIB.M3PositionIDs, expand: false }
                m3KnownPositionsConfig  : { type: M3LIB.M3KnownPositionsConfig, expand: false }
                temperatures            : { type: TELEMETRYLIB.TelemetryTemperatures , expand: false }
            attributes:
                statuses:
                    attributes:
                        healthStatus    : { type: COMMONLIB.HealthStatus }
                        busyStatus      : { type: COMMONLIB.BusyStatus }

        m3:
            type : M3LIB.M3
            comment: "The tertiary mirror of the telescope"
            expand: false
            arguments:
                operatorStatus          : { type: COMMONLIB.OperatorStatus, expand: false }
            attributes:
                actualKnownPositionID   : { type: M3LIB.M3PositionIDs }
                config:
                    attributes:
                        knownPositions  : { type: M3LIB.M3KnownPositionsConfig, expand: false }
                statuses:
                    attributes:
                        healthStatus    : { type: COMMONLIB.HealthStatus }
                        busyStatus      : { type: COMMONLIB.BusyStatus }

        services:
            type : SERVICESLIB.Services
            comment: "The Services system"
            expand: false
            arguments:
                operatorStatus          : { type: COMMONLIB.OperatorStatus, expand: false }
            attributes:
                statuses:
                    attributes:
                        healthStatus    : { type: COMMONLIB.HealthStatus }
                        busyStatus      : { type: COMMONLIB.BusyStatus }
        safety:
            type : SAFETYLIB.Safety
            comment: "The safety"
            expand: false
            arguments:
                operatorStatus          : { type: COMMONLIB.OperatorStatus, expand: false }
                activityStatus          : { type: COMMONLIB.ActivityStatus, expand: false }
            attributes:
                parts:
                    attributes:
                        hydraulics      : { type: SAFETYLIB.SafetyHydraulics, expand: false }
                        io              : { type: SAFETYLIB.SafetyIO, expand: false }
                statuses:
                    attributes:
                        healthStatus    : { type: COMMONLIB.HealthStatus }
                        busyStatus      : { type: COMMONLIB.BusyStatus }
        hydraulics:
            type : HYDRAULICSLIB.Hydraulics
            comment: "The hydraulics"
            expand: false
            arguments:
                operatorStatus          : { type: COMMONLIB.OperatorStatus, expand: false }
                safetyHydraulics        : { type: SAFETYLIB.SafetyHydraulics, expand: false }
                safetyIO                : { type: SAFETYLIB.SafetyIO, expand: false }
            attributes:
                pumpsState              : { type: HYDRAULICSLIB.HydraulicsPumpsStates, expand: false }
                statuses:
                    attributes:
                        healthStatus    : { type: COMMONLIB.HealthStatus }
                        busyStatus      : { type: COMMONLIB.BusyStatus }
        axes:
            type : AXESLIB.Axes
            comment: "The axes"
            expand: false
            attributes:
                isTracking              : { type: t_bool }
                parts:
                    attributes:
                        azi:
                            attributes:
                                actPos          : { type: COMMONLIB.AngularPosition, expand: false}
                        ele:
                            attributes:
                                actPos          : { type: COMMONLIB.AngularPosition, expand: false}
                statuses:
                    attributes:
                        poweredStatus   : { type: COMMONLIB.PoweredStatus }
                        healthStatus    : { type: COMMONLIB.HealthStatus }
                        busyStatus      : { type: COMMONLIB.BusyStatus }
                processes:
                    attributes:
                        point           : { type: AXESLIB.AxesPointProcess }
        dome:
            type : DOMELIB.Dome
            comment: "The dome"
            expand: false
            arguments:
                operatorStatus          : { type: COMMONLIB.OperatorStatus, expand: false }
                aziPos                  : { type: COMMONLIB.AngularPosition, expand: false }
            attributes:
                isTracking              : { type: t_bool }
                statuses:
                    attributes:
                        poweredStatus   : { type: COMMONLIB.PoweredStatus }
                        healthStatus    : { type: COMMONLIB.HealthStatus }
                        busyStatus      : { type: COMMONLIB.BusyStatus }
                processes:
                    attributes:
                        trackAxes       : { type: COMMONLIB.Process }
        configManager:
            comment                     : "The config manager (to load/save/activate configuration data)"
            type                        : COMMONLIB.ConfigManager
    statuses:
        initializationStatus        : { type: COMMONLIB.InitializationStatus }
        healthStatus                : { type: COMMONLIB.HealthStatus }
        busyStatus                  : { type: COMMONLIB.BusyStatus }
        operatorStatus              : { type: COMMONLIB.OperatorStatus }
        passwordHealthStatus        : { type: COMMONLIB.HealthStatus }
        activityStatus              : { type: COMMONLIB.ActivityStatus }
    processes:
        initialize                  : { type: COMMONLIB.Process                         , comment: "Start initializing the whole MTCS" }
        lock                        : { type: COMMONLIB.Process                         , comment: "Lock the whole MTCS" }
        unlock                      : { type: COMMONLIB.Process                         , comment: "Unlock the whole MTCS" }
        changeOperator              : { type: COMMONLIB.ChangeOperatorStateProcess      , comment: "Change the operator (e.g. OBSERVER, TECH, ...)" }
        verifyPassword              : { type: COMMONLIB.ChangeOperatorStateProcess      , comment: "Only verify the operator password" }
        reboot                      : { type: COMMONLIB.Process                         , comment: "Reboot the whole MTCS" }
        shutdown                    : { type: COMMONLIB.Process                         , comment: "Shutdown the whole MTCS" }
        wakeUp                      : { type: COMMONLIB.Process                         , comment: "Wake up the whole MTCS" }
        goToSleep                   : { type: COMMONLIB.Process                         , comment: "Let the whole MTCS go to sleep" }
        stop                        : { type: COMMONLIB.Process                         , comment: "Stop the dome and telescope" }
        endOfNight                  : { type: COMMONLIB.Process                         , comment: "End of night" }
        changeInstrument            : { type: THISLIB.MTCSChangeInstrumentProcess       , comment: "Change the instrument" }
        park                        : { type: THISLIB.MTCSParkProcess                   , comment: "Park the telescope (including Axes, Dome, M3, ...)" }
        point                       : { type: THISLIB.MTCSPointProcess                  , comment: "Point the telescope and dome to a new target" }
    calls:
        initialize:
            isEnabled           : -> NOT(self.statuses.initializationStatus.initializing)
        lock:
            isEnabled           : -> AND(self.statuses.operatorStatus.tech, self.statuses.initializationStatus.initialized)
        unlock:
            isEnabled           : -> AND(self.statuses.operatorStatus.tech, self.statuses.initializationStatus.locked)
        changeOperator:
            isEnabled           : -> TRUE
        verifyPassword:
            isEnabled           : -> TRUE
        reboot:
            isEnabled           : -> TRUE
        endOfNight:
            isEnabled           : -> TRUE
        park:
            isEnabled           : -> AND(self.parts.axes.statuses.busyStatus.idle,
                                         self.parts.dome.statuses.busyStatus.idle,
                                         self.parts.m3.statuses.busyStatus.idle)
        point:
            isEnabled           : -> AND(self.parts.axes.processes.point.statuses.enabledStatus.enabled,
                                         self.parts.dome.processes.trackAxes.statuses.enabledStatus.enabled)
        shutdown:
            isEnabled           : -> self.statuses.operatorStatus.tech
        wakeUp:
            isEnabled           : -> self.statuses.activityStatus.sleeping
        goToSleep:
            isEnabled           : -> OR( self.statuses.activityStatus.awake, self.statuses.healthStatus.bad )
        stop:
            isEnabled           : -> self.statuses.initializationStatus.initialized
        changeInstrument:
            isEnabled           : -> OR( self.statuses.initializationStatus.initialized, self.statuses.healthStatus.bad )
        cover:
            operatorStatus      : -> self.statuses.operatorStatus
            aziPos              : -> self.parts.axes.parts.azi.actPos
            elePos              : -> self.parts.axes.parts.ele.actPos
        m3:
            operatorStatus      : -> self.statuses.operatorStatus
        services:
            operatorStatus      : -> self.statuses.operatorStatus
        telemetry:
            operatorStatus      : -> self.statuses.operatorStatus
        m1:
            operatorStatus      : -> self.statuses.operatorStatus
            tubeAngleMeasurement: -> self.parts.telemetry.parts.accelerometers.tube
        m2:
            operatorStatus      : -> self.statuses.operatorStatus
            io                  : -> self.parts.m1.parts.io
            actualFocalStation  : -> self.parts.m3.actualKnownPositionID
            m3KnownPositionsConfig  : -> self.parts.m3.config.knownPositions
            temperatures        : -> self.parts.telemetry.parts.temperatures
        safety:
            operatorStatus      : -> self.statuses.operatorStatus
            activityStatus      : -> self.statuses.activityStatus
        hydraulics:
            operatorStatus      : -> self.statuses.operatorStatus
            safetyHydraulics    : -> self.parts.safety.parts.hydraulics
            safetyIO            : -> self.parts.safety.parts.io
        dome:
            operatorStatus      : -> self.statuses.operatorStatus
            aziPos              : -> self.parts.axes.parts.azi.actPos
        configManager:
            isEnabled           : -> self.statuses.operatorStatus.tech
        activityStatus:
            superState          : -> OR(self.statuses.initializationStatus.initialized, self.statuses.initializationStatus.initializingFailed)
            isAwake             : -> OR( EQ( self.parts.hydraulics.pumpsState, HYDRAULICSLIB.HydraulicsPumpsStates.RUNNING ), self.parts.axes.statuses.poweredStatus.enabled)
            isMoving            : -> OR(self.parts.axes.statuses.busyStatus.busy, self.parts.axes.isTracking)
        healthStatus:
            isGood              : -> MTCS_SUMMARIZE_GOOD(self.parts.axes,
                                                         self.parts.cover,
                                                         self.parts.m1,
                                                         self.parts.m2,
                                                         self.parts.m3,
                                                         self.parts.services,
                                                         self.parts.telemetry,
                                                         self.parts.safety ,
                                                         self.parts.hydraulics,
                                                         self.parts.dome )
            hasWarning          : -> MTCS_SUMMARIZE_WARN(self.parts.axes,
                                                         self.parts.cover,
                                                         self.parts.m1,
                                                         self.parts.m2,
                                                         self.parts.m3,
                                                         self.parts.services,
                                                         self.parts.telemetry,
                                                         self.parts.safety,
                                                         self.parts.hydraulics,
                                                         self.parts.dome )
        busyStatus:
            isBusy              : -> MTCS_SUMMARIZE_BUSY(self.parts.axes,
                                                         self.parts.cover,
                                                         self.parts.m1,
                                                         self.parts.m2,
                                                         self.parts.m3,
                                                         self.parts.services,
                                                         self.parts.telemetry,
                                                         self.parts.safety,
                                                         self.parts.hydraulics,
                                                         self.parts.dome )

        passwordHealthStatus:
            superState          : -> self.statuses.operatorStatus.observer
    disabled_calls: ['axes']

########################################################################################################################
## INTERFACE
########################################################################################################################

# TODO: currently only proof-of-concept, must be expanded!!!

mtcs_soft.ADD MTCS_MAKE_INTERFACE(THISLIB.MTCS, "interface")


#MTCS_SOFT_ELEC_INTERFACE THISLIB.MTCS, "interface",
#    [
#        [ mtcs_soft.interface.parts.cover.parts.top.parts.p1.encoderErrorSignal, cover_elec.TC.slot3.soft_interface.p1 ]
#    ]



for i in [1..4]
    mtcs_soft.interface.parts.cover.parts.top.parts["p#{i}"].encoderErrorSignal.ADD sys.isInterfacedWith cover_elec.TC.io.slot3.soft_interface["input#{i}"]
    mtcs_soft.interface.parts.cover.parts.bottom.parts["p#{i}"].encoderErrorSignal.ADD sys.isInterfacedWith cover_elec.TC.io.slot3.soft_interface["input#{4+i}"]

#for i in [1..13]
#    mtcs_soft.interface.parts.cover.parts.io.parts["slot#{i}"].wcState.ADD sys.isInterfacedWith cover_elec.TC.io["slot#{i}"].soft_interface.WcState
#    mtcs_soft.interface.parts.cover.parts.io.parts["slot#{i}"].infoData.ADD sys.isInterfacedWith cover_elec.TC.io["slot#{i}"].soft_interface.InfoDataState


########################################################################################################################
# Write the model to file
########################################################################################################################

mtcs_soft.WRITE "models/mtcs/software.jsonld"
