########################################################################################################################
#                                                                                                                      #
# Model of the Services software.                                                                                        #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "models/import_all.coffee"

# models
REQUIRE "models/mtcs/common/software.coffee"
REQUIRE "models/mtcs/tmc/software.coffee"

MODEL "http://www.mercator.iac.es/onto/models/mtcs/services/software" : "services_soft"

services_soft.IMPORT mm_all
services_soft.IMPORT common_soft
services_soft.IMPORT tmc_soft



########################################################################################################################
# Define the containing PLC library
########################################################################################################################

services_soft.ADD MTCS_MAKE_LIB "mtcs_services"

# make aliases (with scope of this file only)
COMMONLIB = common_soft.mtcs_common
THISLIB   = services_soft.mtcs_services
TMCLIB    = tmc_soft.mtcs_tmc


########################################################################################################################
# ServicesTimingTimeSource
########################################################################################################################

MTCS_MAKE_ENUM THISLIB, "ServicesTimingTimeSource",
    items:
        [ "LOCAL_CLOCK",
          "PTP_IEEE_1588" ]




########################################################################################################################
# ServicesTimingConfig
########################################################################################################################

MTCS_MAKE_CONFIG THISLIB, "ServicesTimingConfig",
    items:
        leapSeconds:
            type: t_int16
            comment: "Number of leap seconds, so that UTC = TAI + this value. See ftp://maia.usno.navy.mil/ser7/tai-utc.dat for the latest number."
        dut:
            type: t_double
            comment: "Delta UT (= UT1 - UTC). Put to 0.0 to ignore."
        alwaysUseLocalClock:
            type: t_bool
            comment: "If TRUE, then the local clock (source=LOCAL_CLOCK) will be used even if an external (more accurate!) clock is available"
        ignoreSerialError:
            type: t_bool
            comment: "Don't show the Servicestiming status as ERROR in case the serial link fails"


########################################################################################################################
# ServicesMeteoConfig
########################################################################################################################

MTCS_MAKE_CONFIG THISLIB, "ServicesMeteoConfig",
    items:
        wetLimit:
            type: t_double
            comment: "Wet if (rainIntensity+hailIntrelaensity)>wetLimit"
        windSpeedMinimum:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the wind speed minimum"
            expand: false
        windSpeedAverage:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the wind speed average"
            expand: false
        windSpeedMaximum:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the wind speed maximum"
            expand: false
        windDirectionMinimum:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the wind direction minimum"
            expand: false
        windDirectionAverage:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the wind direction average"
            expand: false
        windDirectionMaximum:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the wind direction maximum"
            expand: false
        airPressure:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the air pressure"
            expand: false
        airTemperature:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the air temperature"
            expand: false
        internalTemperature:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the internal temperature"
            expand: false
        relativeHumidity:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the relative humidity"
            expand: false
        rainAccumulation:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the rain accumulation"
            expand: false
        rainDuration:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the rain duration"
            expand: false
        rainIntensity:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the rain intensity"
            expand: false
        rainPeakIntensity:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the rain peak intensity"
            expand: false
        hailAccumulation:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the hail accumulation"
            expand: false
        hailDuration:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the hail duration"
            expand: false
        hailIntensity:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the hail intensity"
            expand: false
        hailPeakIntensity:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the hail peak intensity"
            expand: false
        heatingTemperature:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the heating temperature"
            expand: false
        heatingVoltage:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the heating voltage"
            expand: false
        supplyVoltage:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the supply voltage"
            expand: false
        referenceVoltage:
            type: COMMONLIB.MeasurementConfig
            comment: "Config for the 3.5 V reference voltage"
            expand: false

########################################################################################################################
# ServicesWestConfig
########################################################################################################################

MTCS_MAKE_CONFIG THISLIB, "ServicesWestConfig",
    items:
        pollingInterval :
            type: t_double
            comment: "Time between West reads in seconds"



########################################################################################################################
# ServicesConfig
########################################################################################################################

MTCS_MAKE_CONFIG THISLIB, "ServicesConfig",
    items:
        timing:
            type: THISLIB.ServicesTimingConfig
            comment: "Timing config"
            expand: false
        meteo:
            type: THISLIB.ServicesMeteoConfig
            comment: "Meteo config"
        west:
            type: THISLIB.ServicesWestConfig
            comment: "West config"



########################################################################################################################
# Services
########################################################################################################################

MTCS_MAKE_STATEMACHINE THISLIB,  "Services",
    variables:
        editableConfig                  : { type: THISLIB.ServicesConfig        , comment: "Editable configuration of the Services subsystem", expand: false }
    references:
        operatorStatus                  : { type: COMMONLIB.OperatorStatus      , comment: "Shared operator status" }
    variables_read_only:
        config                          : { type: THISLIB.ServicesConfig        , comment: "Active configuration of the Services subsystem" }
    parts:
        timing:
            comment                     : "Timing service"
            arguments:
                config                  : {}
                operatorStatus          : {}
            attributes:
                statuses:
                    attributes:
                        healthStatus    : { type: COMMONLIB.HealthStatus }
        meteo:
            comment                     : "Meteo service"
            arguments:
                config                  : {}
            attributes:
                statuses:
                    attributes:
                        healthStatus    : { type: COMMONLIB.HealthStatus }
        west:
            comment                     : "West service"
            arguments:
                config                  : {}
                operatorStatus          : {}                
            attributes:
                statuses:
                    attributes:
                        healthStatus    : { type: COMMONLIB.HealthStatus }       
        io:
            comment                     : "I/O modules"
            attributes:
                statuses:
                    attributes:
                        healthStatus    : { type: COMMONLIB.HealthStatus }
        configManager:
            comment                     : "The config manager (to load/save/activate configuration data)"
            type                        : COMMONLIB.ConfigManager
    statuses:
        initializationStatus            : { type: COMMONLIB.InitializationStatus }
        healthStatus                    : { type: COMMONLIB.HealthStatus }
        busyStatus                      : { type: COMMONLIB.BusyStatus }
        operatingStatus                 : { type: COMMONLIB.OperatingStatus }
    processes:
        initialize                      : { type: COMMONLIB.Process                       , comment: "Start initializing" }
        lock                            : { type: COMMONLIB.Process                       , comment: "Lock the system" }
        unlock                          : { type: COMMONLIB.Process                       , comment: "Unlock the system" }
        changeOperatingState            : { type: COMMONLIB.ChangeOperatingStateProcess   , comment: "Change the operating state (e.g. AUTO, MANUAL, ...)" }
    calls:
        initialize:
            isEnabled                   : -> OR(self.statuses.initializationStatus.shutdown,
                                                self.statuses.initializationStatus.initializingFailed,
                                                self.statuses.initializationStatus.initialized)
        lock:
            isEnabled                   : -> AND(self.operatorStatus.tech, self.statuses.initializationStatus.initialized)
        unlock:
            isEnabled                   : -> AND(self.operatorStatus.tech, self.statuses.initializationStatus.locked)
        changeOperatingState:
            isEnabled                   : -> FALSE # there is no MANUAL mode #-> AND(self.statuses.busyStatus.idle, self.statuses.initializationStatus.initialized)
        operatingStatus:
            superState                  : -> self.statuses.initializationStatus.initialized
        healthStatus:
            isGood                      : -> AND(self.parts.timing.healthStatus.good, 
                                                 self.parts.meteo.healthStatus.good,
                                                 self.parts.west.healthStatus.good,
                                                 self.parts.io.healthStatus.good)
            hasWarning                  : -> OR(self.parts.timing.healthStatus.warning, 
                                                self.parts.meteo.healthStatus.warning,
                                                self.parts.west.healthStatus.warning,
                                                self.parts.io.healthStatus.warning)
        busyStatus:
            isBusy                      : -> self.statuses.initializationStatus.initializing
        configManager:
            isEnabled                   : -> self.operatorStatus.tech
        timing:
            operatorStatus              : -> self.operatorStatus
            config                      : -> self.config.timing
        meteo:
            config                      : -> self.config.meteo
        west:
            config                      : -> self.config.west
            operatorStatus              : -> self.operatorStatus


########################################################################################################################
# ServicesTiming
########################################################################################################################

MTCS_MAKE_STATEMACHINE THISLIB,  "ServicesTiming",
    typeOf                              : [ THISLIB.ServicesParts.timing ]
    variables:
        fromEL6688                      : { type: TMCLIB.TmcFromIoEL6688        , address: "%I*" , comment: "Data from the EL6688", expand: false}
        fromEcatMaster                  : { type: TMCLIB.TmcFromIoEcatMaster    , address: "%I*" , comment: "Data from the EtherCAT master", expand: false}
        fromCppTiming                   : { type: TMCLIB.TmcToPlcTiming         , address: "%I*" , comment: "Data from the C++ task", expand: false}
    references:
        operatorStatus                  : { type: COMMONLIB.OperatorStatus      , comment: "Shared operator status"}
        config                          : { type: THISLIB.ServicesTimingConfig  , comment: "The config" }
    variables_read_only:
        toCppTiming                     : { type: TMCLIB.TmcFromPlcTiming       , address: "%Q*" , comment: "Data to the C++ task", expand: false}
        # actual source
        utcDateString                   : { type: t_string                      , comment: "UTC date as a string of format YYYY-MM-DD" }
        utcTimeString                   : { type: t_string                      , comment: "UTC time as a string of format HH-MM-SS.SSS" }
        # timestamp strings
        internalTimestampString         : { type : t_string                     , comment: "String representation of the internal timestamp"}
        externalTimestampString         : { type : t_string                     , comment: "String representation of the external timestamp (note: this is TAI, not UTC!)"}
    parts:
        serialInfo:
            comment                     : "Info acquired by serial link"
            attributes:
                statuses:
                    attributes:
                        healthStatus    : { type: COMMONLIB.HealthStatus }
    statuses:
        healthStatus                    : { type: COMMONLIB.HealthStatus }
    processes:
        {}
    calls:
        healthStatus:
            isGood                      : -> OR(self.config.ignoreSerialError, self.parts.serialInfo.statuses.healthStatus.good)


########################################################################################################################
# ServicesTimingSerialInfo
########################################################################################################################

MTCS_MAKE_STATEMACHINE THISLIB,  "ServicesTimingSerialInfo",
    typeOf                          : [ THISLIB.ServicesTimingParts.serialInfo ]
    variables_read_only:
        serialTimeout               : { type: t_bool    , comment: "Is the serial data not being received within time?" }
        comError                    : { type: t_bool    , comment: "Is there any problem with the COM port?" }
        comErrorID                  : { type: t_int16   , comment: "COM error id (see Beckhoff ComError_t)" }
        comErrorDescription         : { type: t_string  , comment: "Description of the COM error id" }
        time_h                      : { type: t_uint8   , comment: "Time: hours (0-24)" }
        time_m                      : { type: t_uint8   , comment: "Time: minutes (0-59)" }
        time_s                      : { type: t_uint8   , comment: "Time: seconds (0-59, or 60 if leap second)" }
        latitude_deg                : { type: t_uint8   , comment: "Latitude: degrees (0-90)" }
        latitude_min                : { type: t_float   , comment: "Latitude: minutes (0.0-59.99999)" }
        latitude_sign               : { type: t_string  , comment: "Latitude: sign (either 'N' or 'S')" }
        longitude_deg               : { type: t_uint8   , comment: "Longitude: degrees (0-180)" }
        longitude_min               : { type: t_float   , comment: "Longitude: minutes (0.0-59.99999)" }
        longitude_sign              : { type: t_string  , comment: "Longitude: sign (either 'E' or 'W')" }
        positionFix                 : { type: t_bool    , comment: "True if a position fix was accomplished, False if not" }
        satellitesUsed              : { type: t_uint8   , comment: "Number of satellites used" }
        horizontalDilutionOfPosition: { type: t_float   , comment: "Horizontal dilution of position" }
        meanSeaLevelAltitude        : { type: t_float   , comment: "Mean altitude above sea level in meters" }
        geoidSeparation             : { type: t_float   , comment: "Geoid separation in meters" }
        checksum                    : { type: t_uint8   , comment: "Checksum send by the time server" }
        calculatedChecksum          : { type: t_uint8   , comment: "Checksum calculated by the PLC" }
    statuses:
        portHealthStatus            : { type: COMMONLIB.HealthStatus }
        transmissionHealthStatus    : { type: COMMONLIB.HealthStatus }
        checksumHealthStatus        : { type: COMMONLIB.HealthStatus }
        healthStatus                : { type: COMMONLIB.HealthStatus }
    calls:
        portHealthStatus:
            isGood                  : -> NOT self.comError
        transmissionHealthStatus:
            isGood                  : -> NOT self.serialTimeout
        checksumHealthStatus:
            isGood                  : -> EQ( self.checksum, self.calculatedChecksum )
        healthStatus:
            isGood                  : -> AND( self.statuses.portHealthStatus.good,
                                              self.statuses.transmissionHealthStatus.good,
                                              self.statuses.checksumHealthStatus.good )



########################################################################################################################
# ServicesMeteoId
########################################################################################################################


MTCS_MAKE_ENUM THISLIB, "ServicesMeteoId",
    items:
        [
            "WIND_SPEED_MINIMUM",
            "WIND_SPEED_AVERAGE",
            "WIND_SPEED_MAXIMUM",
            "WIND_DIRECTION_MINIMUM",
            "WIND_DIRECTION_AVERAGE",
            "WIND_DIRECTION_MAXIMUM",
            "AIR_PRESSURE",
            "AIR_TEMPERATURE",
            "INTERNAL_TEMPERATURE",
            "RELATIVE_HUMIDITY",
            "RAIN_ACCUMULATION",
            "RAIN_DURATION",
            "RAIN_INTENSITY",
            "RAIN_PEAK_INTENSITY",
            "HAIL_ACCUMULATION",
            "HAIL_DURATION",
            "HAIL_PEAK_INTENSITY",
            "HAIL_INTENSITY",
            "HEATING_TEMPERATURE",
            "HEATING_VOLTAGE",
            "SUPPLY_VOLTAGE",
            "REFERENCE_VOLTAGE",
        ]


########################################################################################################################
# ServicesMeteoMeasurement
########################################################################################################################
MTCS_MAKE_STATEMACHINE THISLIB, "ServicesMeteoMeasurement",
    variables:
        id              : { type: THISLIB.ServicesMeteoId       , comment: "ID" }
    variables_hidden:
        inputString     : { type: t_string                      , comment: "Input string from the meteo station" }
    variables_read_only:
        data            : { type: COMMONLIB.QuantityValue       , comment: "Actual value" }
        invalidData     : { type: t_bool                        , comment: "True if the data is invalid" }
        lastChar        : { type: t_string                      , comment: "Last character" }
        name            : { type: t_string                      , comment: "Name of the measurementw" }
    references:
        config          : { type: COMMONLIB.MeasurementConfig   , comment: "Reference to the config" }
    statuses:
        enabledStatus   : { type: COMMONLIB.EnabledStatus       , comment: "Is the temperature being measured?" }
        healthStatus    : { type: COMMONLIB.HealthStatus        , comment: "Is the data valid and within range?" }
        alarmStatus     : { type: COMMONLIB.HiHiLoLoAlarmStatus , comment: "Alarm status"}
    calls:
        enabledStatus:
            isEnabled    : -> self.config.enabled
        alarmStatus:
            superState   : -> self.statuses.enabledStatus.enabled
            config       : -> self.config.alarms
            value        : -> self.data.value
        healthStatus:
            superState   : -> self.statuses.enabledStatus.enabled
            isGood       : -> NOT( OR(self.invalidData,
                                      self.statuses.alarmStatus.hiHi,
                                      self.statuses.alarmStatus.loLo))
            hasWarning   : -> OR( self.statuses.alarmStatus.hi,
                                  self.statuses.alarmStatus.lo )



########################################################################################################################
# ServicesMeteo
########################################################################################################################

MTCS_MAKE_STATEMACHINE THISLIB,  "ServicesMeteo",
    typeOf                              : [ THISLIB.ServicesParts.meteo ]
    variables:
        # serial comm
        serialTimeout               : { type: t_bool    , comment: "Is the serial data not being received within time?" }
        comError                    : { type: t_bool    , comment: "Is there any problem with the COM port?" }
        comErrorID                  : { type: t_int16   , comment: "COM error id (see Beckhoff ComError_t)" }
        comErrorDescription         : { type: t_string  , comment: "Description of the COM error id" }
        # measurements
        windSpeedMinimum            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Wind speed minimum" }
        windSpeedAverage            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Wind speed average" }
        windSpeedMaximum            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Wind speed maximum" }
        windDirectionMinimum        : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Wind direction minimum" }
        windDirectionAverage        : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Wind direction average" }
        windDirectionMaximum        : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Wind direction maximum" }
        airPressure                 : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Air pressure" }
        airTemperature              : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Air temperature" }
        internalTemperature         : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Internal temperature" }
        relativeHumidity            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Relative humidity" }
        rainAccumulation            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Rain accumulation" }
        rainDuration                : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Rain duration" }
        rainIntensity               : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Rain intensity" }
        rainPeakIntensity           : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Rain peak intensity" }
        hailAccumulation            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Hail accumulation" }
        hailDuration                : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Hail duration" }
        hailIntensity               : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Hail intensity" }
        hailPeakIntensity           : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Hail peak intensity" }
        heatingTemperature          : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Heating temperature" }
        heatingVoltage              : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Heating voltage" }
        supplyVoltage               : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Supply voltage" }
        referenceVoltage            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Reference voltage" }
        # durationOK
        durationOK                  : { type: COMMONLIB.Duration                , comment: "Duration that the meteo is OK" }
        dewpoint                    : { type: COMMONLIB.Temperature             , comment: "Calculated dewpoint" }
        wet                         : { type: t_bool                            , comment: "Wet if (rainIntensity+hailIntensity) > config.wetLimit" }
        heating                     : { type: t_bool                            , comment: "Heating or not?"}
        windDirectionMinimumString  : { type: t_string                          , comment: "Average direction of the wind as a string"}
        windDirectionAverageString  : { type: t_string                          , comment: "Average direction of the wind as a string"}
        windDirectionMaximumString  : { type: t_string                          , comment: "Average direction of the wind as a string"}
    references:
        config                      : { type: THISLIB.ServicesMeteoConfig  , comment: "The config" }
    statuses:
        meteoHealthStatus            : { type: COMMONLIB.HealthStatus }
        healthStatus                : { type: COMMONLIB.HealthStatus }
    processes:
        {}
    calls:
        windSpeedMinimum:
            id                      : -> THISLIB.ServicesMeteoId.WIND_SPEED_MINIMUM
            config                  : -> self.config.windSpeedMinimum
        windSpeedAverage:
            id                      : -> THISLIB.ServicesMeteoId.WIND_SPEED_AVERAGE
            config                  : -> self.config.windSpeedAverage
        windSpeedMaximum:
            id                      : -> THISLIB.ServicesMeteoId.WIND_SPEED_MAXIMUM
            config                  : -> self.config.windSpeedMaximum
        windDirectionMinimum:
            id                      : -> THISLIB.ServicesMeteoId.WIND_DIRECTION_MINIMUM
            config                  : -> self.config.windDirectionMinimum
        windDirectionAverage:
            id                      : -> THISLIB.ServicesMeteoId.WIND_DIRECTION_AVERAGE
            config                  : -> self.config.windDirectionAverage
        windDirectionMaximum:
            id                      : -> THISLIB.ServicesMeteoId.WIND_DIRECTION_MAXIMUM
            config                  : -> self.config.windDirectionMaximum
        airPressure:
            id                      : -> THISLIB.ServicesMeteoId.AIR_PRESSURE
            config                  : -> self.config.airPressure
        airTemperature:
            id                      : -> THISLIB.ServicesMeteoId.AIR_TEMPERATURE
            config                  : -> self.config.airTemperature
        internalTemperature:
            id                      : -> THISLIB.ServicesMeteoId.INTERNAL_TEMPERATURE
            config                  : -> self.config.internalTemperature
        relativeHumidity:
            id                      : -> THISLIB.ServicesMeteoId.RELATIVE_HUMIDITY
            config                  : -> self.config.relativeHumidity
        rainAccumulation:
            id                      : -> THISLIB.ServicesMeteoId.RAIN_ACCUMULATION
            config                  : -> self.config.rainAccumulation
        rainDuration:
            id                      : -> THISLIB.ServicesMeteoId.RAIN_DURATION
            config                  : -> self.config.rainDuration
        rainIntensity:
            id                      : -> THISLIB.ServicesMeteoId.RAIN_INTENSITY
            config                  : -> self.config.rainIntensity
        rainPeakIntensity:
            id                      : -> THISLIB.ServicesMeteoId.RAIN_PEAK_INTENSITY
            config                  : -> self.config.rainPeakIntensity
        hailAccumulation:
            id                      : -> THISLIB.ServicesMeteoId.HAIL_ACCUMULATION
            config                  : -> self.config.hailAccumulation
        hailDuration:
            id                      : -> THISLIB.ServicesMeteoId.HAIL_DURATION
            config                  : -> self.config.hailDuration
        hailIntensity:
            id                      : -> THISLIB.ServicesMeteoId.HAIL_INTENSITY
            config                  : -> self.config.hailIntensity
        hailPeakIntensity:
            id                      : -> THISLIB.ServicesMeteoId.HAIL_PEAK_INTENSITY
            config                  : -> self.config.hailPeakIntensity
        heatingTemperature:
            id                      : -> THISLIB.ServicesMeteoId.HEATING_TEMPERATURE
            config                  : -> self.config.heatingTemperature
        heatingVoltage:
            id                      : -> THISLIB.ServicesMeteoId.HEATING_VOLTAGE
            config                  : -> self.config.heatingVoltage
        supplyVoltage:
            id                      : -> THISLIB.ServicesMeteoId.SUPPLY_VOLTAGE
            config                  : -> self.config.supplyVoltage
        referenceVoltage:
            id                      : -> THISLIB.ServicesMeteoId.REFERENCE_VOLTAGE
            config                  : -> self.config.referenceVoltage
        healthStatus:
            isGood                  : -> NOT( OR(self.serialTimeout, self.comError) )
        meteoHealthStatus:
            superState              : -> self.statuses.healthStatus.good
            isGood                  : -> MTCS_SUMMARIZE_GOOD_OR_DISABLED(
                                                self.windSpeedMinimum,
                                                self.windSpeedAverage,
                                                self.windSpeedMaximum,
                                                self.windDirectionMinimum,
                                                self.windDirectionAverage,
                                                self.windDirectionMaximum,
                                                self.airPressure,
                                                self.airTemperature,
                                                self.internalTemperature,
                                                self.relativeHumidity,
                                                self.rainAccumulation,
                                                self.rainDuration,
                                                self.rainIntensity,
                                                self.rainPeakIntensity,
                                                self.hailAccumulation,
                                                self.hailDuration,
                                                self.hailIntensity,
                                                self.hailPeakIntensity,
                                                self.heatingTemperature,
                                                self.heatingVoltage,
                                                self.supplyVoltage,
                                                self.referenceVoltage
                                        )
            hasWarning                 : -> MTCS_SUMMARIZE_WARN(
                                                self.windSpeedMinimum,
                                                self.windSpeedAverage,
                                                self.windSpeedMaximum,
                                                self.windDirectionMinimum,
                                                self.windDirectionAverage,
                                                self.windDirectionMaximum,
                                                self.airPressure,
                                                self.airTemperature,
                                                self.internalTemperature,
                                                self.relativeHumidity,
                                                self.rainAccumulation,
                                                self.rainDuration,
                                                self.rainIntensity,
                                                self.rainPeakIntensity,
                                                self.hailAccumulation,
                                                self.hailDuration,
                                                self.hailIntensity,
                                                self.hailPeakIntensity,
                                                self.heatingTemperature,
                                                self.heatingVoltage,
                                                self.supplyVoltage,
                                                self.referenceVoltage
                                        )


########################################################################################################################
# ServicesWest
########################################################################################################################

MTCS_MAKE_STATEMACHINE THISLIB,  "ServicesWest",
    typeOf                              : [ THISLIB.ServicesParts.west ]
    variables:
        # measurements
        windSpeedMinimum            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Wind speed minimum" }
        windSpeedAverage            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Wind speed average" }
        windSpeedMaximum            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Wind speed maximum" }
        windDirectionMinimum        : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Wind direction minimum" }
        windDirectionAverage        : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Wind direction average" }
        windDirectionMaximum        : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Wind direction maximum" }
        airPressure                 : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Air pressure" }
        airTemperature              : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Air temperature" }
        internalTemperature         : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Internal temperature" }
        relativeHumidity            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Relative humidity" }
        rainAccumulation            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Rain accumulation" }
        rainDuration                : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Rain duration" }
        rainIntensity               : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Rain intensity" }
        rainPeakIntensity           : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Rain peak intensity" }
        hailAccumulation            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Hail accumulation" }
        hailDuration                : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Hail duration" }
        hailIntensity               : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Hail intensity" }
        hailPeakIntensity           : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Hail peak intensity" }
        heatingTemperature          : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Heating temperature" }
        heatingVoltage              : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Heating voltage" }
        supplyVoltage               : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Supply voltage" }
        referenceVoltage            : { type: THISLIB.ServicesMeteoMeasurement  , comment: "Reference voltage" }
        # durationOK
        durationOK                  : { type: COMMONLIB.Duration                , comment: "Duration that the meteo is OK" }
        dewpoint                    : { type: COMMONLIB.Temperature             , comment: "Calculated dewpoint" }
        wet                         : { type: t_bool                            , comment: "Wet if (rainIntensity+hailIntensity) > config.wetLimit" }
        heating                     : { type: t_bool                            , comment: "Heating or not?"}
        windDirectionMinimumString  : { type: t_string                          , comment: "Average direction of the wind as a string"}
        windDirectionAverageString  : { type: t_string                          , comment: "Average direction of the wind as a string"}
        windDirectionMaximumString  : { type: t_string                          , comment: "Average direction of the wind as a string"}
    references:
        config                      : { type: THISLIB.ServicesMeteoConfig  , comment: "The config" }
    statuses:
        meteoHealthStatus            : { type: COMMONLIB.HealthStatus }
        healthStatus                : { type: COMMONLIB.HealthStatus }
    processes:
        {}
    calls:
        windSpeedMinimum:
            id                      : -> THISLIB.ServicesMeteoId.WIND_SPEED_MINIMUM
            config                  : -> self.config.windSpeedMinimum
        windSpeedAverage:
            id                      : -> THISLIB.ServicesMeteoId.WIND_SPEED_AVERAGE
            config                  : -> self.config.windSpeedAverage
        windSpeedMaximum:
            id                      : -> THISLIB.ServicesMeteoId.WIND_SPEED_MAXIMUM
            config                  : -> self.config.windSpeedMaximum
        windDirectionMinimum:
            id                      : -> THISLIB.ServicesMeteoId.WIND_DIRECTION_MINIMUM
            config                  : -> self.config.windDirectionMinimum
        windDirectionAverage:
            id                      : -> THISLIB.ServicesMeteoId.WIND_DIRECTION_AVERAGE
            config                  : -> self.config.windDirectionAverage
        windDirectionMaximum:
            id                      : -> THISLIB.ServicesMeteoId.WIND_DIRECTION_MAXIMUM
            config                  : -> self.config.windDirectionMaximum
        airPressure:
            id                      : -> THISLIB.ServicesMeteoId.AIR_PRESSURE
            config                  : -> self.config.airPressure
        airTemperature:
            id                      : -> THISLIB.ServicesMeteoId.AIR_TEMPERATURE
            config                  : -> self.config.airTemperature
        internalTemperature:
            id                      : -> THISLIB.ServicesMeteoId.INTERNAL_TEMPERATURE
            config                  : -> self.config.internalTemperature
        relativeHumidity:
            id                      : -> THISLIB.ServicesMeteoId.RELATIVE_HUMIDITY
            config                  : -> self.config.relativeHumidity
        rainAccumulation:
            id                      : -> THISLIB.ServicesMeteoId.RAIN_ACCUMULATION
            config                  : -> self.config.rainAccumulation
        rainDuration:
            id                      : -> THISLIB.ServicesMeteoId.RAIN_DURATION
            config                  : -> self.config.rainDuration
        rainIntensity:
            id                      : -> THISLIB.ServicesMeteoId.RAIN_INTENSITY
            config                  : -> self.config.rainIntensity
        rainPeakIntensity:
            id                      : -> THISLIB.ServicesMeteoId.RAIN_PEAK_INTENSITY
            config                  : -> self.config.rainPeakIntensity
        hailAccumulation:
            id                      : -> THISLIB.ServicesMeteoId.HAIL_ACCUMULATION
            config                  : -> self.config.hailAccumulation
        hailDuration:
            id                      : -> THISLIB.ServicesMeteoId.HAIL_DURATION
            config                  : -> self.config.hailDuration
        hailIntensity:
            id                      : -> THISLIB.ServicesMeteoId.HAIL_INTENSITY
            config                  : -> self.config.hailIntensity
        hailPeakIntensity:
            id                      : -> THISLIB.ServicesMeteoId.HAIL_PEAK_INTENSITY
            config                  : -> self.config.hailPeakIntensity
        heatingTemperature:
            id                      : -> THISLIB.ServicesMeteoId.HEATING_TEMPERATURE
            config                  : -> self.config.heatingTemperature
        heatingVoltage:
            id                      : -> THISLIB.ServicesMeteoId.HEATING_VOLTAGE
            config                  : -> self.config.heatingVoltage
        supplyVoltage:
            id                      : -> THISLIB.ServicesMeteoId.SUPPLY_VOLTAGE
            config                  : -> self.config.supplyVoltage
        referenceVoltage:
            id                      : -> THISLIB.ServicesMeteoId.REFERENCE_VOLTAGE
            config                  : -> self.config.referenceVoltage
        healthStatus:
            isGood                  : -> NOT( OR(self.serialTimeout, self.comError) )
        meteoHealthStatus:
            superState              : -> self.statuses.healthStatus.good
            isGood                  : -> MTCS_SUMMARIZE_GOOD_OR_DISABLED(
                                                self.windSpeedMinimum,
                                                self.windSpeedAverage,
                                                self.windSpeedMaximum,
                                                self.windDirectionMinimum,
                                                self.windDirectionAverage,
                                                self.windDirectionMaximum,
                                                self.airPressure,
                                                self.airTemperature,
                                                self.internalTemperature,
                                                self.relativeHumidity,
                                                self.rainAccumulation,
                                                self.rainDuration,
                                                self.rainIntensity,
                                                self.rainPeakIntensity,
                                                self.hailAccumulation,
                                                self.hailDuration,
                                                self.hailIntensity,
                                                self.hailPeakIntensity,
                                                self.heatingTemperature,
                                                self.heatingVoltage,
                                                self.supplyVoltage,
                                                self.referenceVoltage
                                        )
            hasWarning                 : -> MTCS_SUMMARIZE_WARN(
                                                self.windSpeedMinimum,
                                                self.windSpeedAverage,
                                                self.windSpeedMaximum,
                                                self.windDirectionMinimum,
                                                self.windDirectionAverage,
                                                self.windDirectionMaximum,
                                                self.airPressure,
                                                self.airTemperature,
                                                self.internalTemperature,
                                                self.relativeHumidity,
                                                self.rainAccumulation,
                                                self.rainDuration,
                                                self.rainIntensity,
                                                self.rainPeakIntensity,
                                                self.hailAccumulation,
                                                self.hailDuration,
                                                self.hailIntensity,
                                                self.hailPeakIntensity,
                                                self.heatingTemperature,
                                                self.heatingVoltage,
                                                self.supplyVoltage,
                                                self.referenceVoltage
                                        )


########################################################################################################################
# ServicesIO
########################################################################################################################

MTCS_MAKE_STATEMACHINE THISLIB, "ServicesIO",
    typeOf              : [ THISLIB.ServicesParts.io ]
    statuses:
        healthStatus    : { type: COMMONLIB.HealthStatus   , comment: "Is the I/O in a healthy state?"  }
    parts:
        coupler         : { type: COMMONLIB.EtherCatDevice , comment: "Coupler" }
        slot1           : { type: COMMONLIB.EtherCatDevice , comment: "Slot 1" }
        slot2           : { type: COMMONLIB.EtherCatDevice , comment: "Slot 2" }
        slot3           : { type: COMMONLIB.EtherCatDevice , comment: "Slot 3" }
        slot4           : { type: COMMONLIB.EtherCatDevice , comment: "Slot 4" }
    calls:
        coupler:
            id          : -> STRING("COUPLER") "id"
            typeId      : -> STRING("EK1100") "typeId"
        slot1:
            id          : -> STRING("TI-RS232") "id"
            typeId      : -> STRING("EL6001") "typeId"
        slot2:
            id          : -> STRING("METEO") "id"
            typeId      : -> STRING("EL6001") "typeId"
        slot3:
            id          : -> STRING("WESTS") "id"
            typeId      : -> STRING("EL6001") "typeId"
        slot4:
            id          : -> STRING("TI-PTP") "id"
            typeId      : -> STRING("EL6688") "typeId"
        healthStatus:
            isGood      : -> MTCS_SUMMARIZE_GOOD( self.parts.coupler,
                                                  self.parts.slot1,
                                                  self.parts.slot2,
                                                  self.parts.slot3,
                                                  self.parts.slot4 )


########################################################################################################################
# Write the model to file
########################################################################################################################

services_soft.WRITE "models/mtcs/services/software.jsonld"



