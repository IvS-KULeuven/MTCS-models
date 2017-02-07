########################################################################################################################
#                                                                                                                      #
# Model containing products and software libraries by Beckhoff.                                                        #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

# metamodels
REQUIRE "metamodels/manufacturing.coffee"
REQUIRE "metamodels/iec61131.coffee"
REQUIRE "metamodels/electricity.coffee"

MODEL "http://www.mercator.iac.es/onto/models/external/beckhoff" : "beckhoff"

beckhoff.IMPORT iec61131
beckhoff.IMPORT man
beckhoff.IMPORT elec


########################################################################################################################
# Company
########################################################################################################################

beckhoff.ADD MANUFACTURER(
        shortName : "Beckhoff"
        longName  : "Beckhoff Automation"
        comment   : "Produces IPCs, PLCs, I/O, control panels, ...") "company"


########################################################################################################################
# Tc2_MC2 library
########################################################################################################################

beckhoff.ADD LIBRARY() "Tc2_MC2" : [
    soft.isElementOf iec61131.iec61131
    INIT()
    CONTAINS PLC_STRUCT(
        items:
            UpdateTaskIndex:
                type    : iec61131.BYTE
                comment : "Task-Index of the task that updated this data set"
            UpdateCycleTime:
                type    : iec61131.LREAL
                comment : "Task cycle time of the task which calls the status function"
            CycleCounter:
                type    : iec61131.UDINT
                comment : "PLC cycle counter when this data set updated"
            NcCycleCounter:
                type    : iec61131.LREAL
                comment : "NC cycle counter incremented after NC task updated NcToPlc data structures"
            Error:
                type    : iec61131.BOOL
                comment : "Axis error state"
            ErrorId:
                type    : iec61131.UDINT
                comment : "Axis error code"
            Disabled:
                type    : iec61131.LREAL
                comment : "Disabled state according to the PLCopen motion control statemachine*)"
            ControlLoopClosed:
                type    : iec61131.BOOL
                comment : "Is the control loop closed?"
            ExtSetPointGenEnabled:
                type    : iec61131.BOOL
                comment : "Is the external setpoint generator enabled?"
        ) "ST_AxisStatus"

    CONTAINS PLC_STRUCT(
        items:
            ControlDWord:
                type    : iec61131.DWORD
                comment : "Control double word"
            Override:
                type    : iec61131.DWORD
                comment : "Velocity override"
            AxisModeRequest:
                type    : iec61131.DWORD
                comment : "Axis operating mode (PLC request)"
            AxisModeDWord:
                type    : iec61131.DWORD
                comment : "Optional mode parameter"
            AxisModeLReal:
                type    : iec61131.LREAL
                comment : "Optional mode parameter"
            PositionCorrection:
                type    : iec61131.LREAL
                comment : "Correction value for current position"
            ExtSetPos:
                type    : iec61131.LREAL
                comment : "External position setpoint"
            ExtSetVelo:
                type    : iec61131.LREAL
                comment : "External velocity setpoint"
            ExtSetAcc:
                type    : iec61131.LREAL
                comment : "External acceleration setpoint"
            ExtSetDirection:
                type    : iec61131.DINT
                comment : "External direction setpoint"
            ExtControllerOutput:
                type    : iec61131.LREAL
                comment : "External controller output"
            GearRatio1:
                type    : iec61131.LREAL
                comment : "Gear ratio for dynamic multi master coupling modes"
            GearRatio2:
                type    : iec61131.LREAL
                comment : "Gear ratio for dynamic multi master coupling modes"
            GearRatio3:
                type    : iec61131.LREAL
                comment : "Gear ratio for dynamic multi master coupling modes"
            GearRatio4:
                type    : iec61131.LREAL
                comment : "Gear ratio for dynamic multi master coupling modes"
        ) "PLCTONC_AXIS_REF"

    CONTAINS PLC_STRUCT(
        items:
            StateDWord:
                type    : iec61131.DWORD
                comment : "Status double word"
            ErrorCode:
                type    : iec61131.DWORD
                comment : "Axis error code"
            AxisState:
                type    : iec61131.DWORD
                comment : "Axis moving status"
            AxisModeConfirmation:
                type    : iec61131.DWORD
                comment : "Axis mode confirmation (feedback from NC)"
            HomingState:
                type    : iec61131.DWORD
                comment : "State of axis calibration (homing)"
            CoupleState:
                type    : iec61131.DWORD
                comment : "Axis coupling state"
            SvbEntries:
                type    : iec61131.DWORD
                comment : "SVB entries/orders (SVB = Set preparation task)"
            SafEntries:
                type    : iec61131.DWORD
                comment : "SAF entries/orders (SAF = Set execution task)"
            AxisId:
                type    : iec61131.DWORD
                comment : "Axis ID"
            OpModeDWord:
                type    : iec61131.DWORD
                comment : "Current operation mode"
            ActiveControlLoopIndex:
                type    : iec61131.WORD
                comment : "Active control loop index"
            ControlLoopIndex:
                type    : iec61131.WORD
                comment : "Axis control loop index (0, 1, 2, when multiple control loops are used)"
            ActPos:
                type    : iec61131.LREAL
                comment : "Actual position (absolut value from NC)"
            ModuloActPos:
                type    : iec61131.LREAL
                comment : "comment : Actual modulo positio"
            ModuloActTurns:
                type    : iec61131.DINT
                comment : "Actual modulo turns"
            ActVelo:
                type    : iec61131.LREAL
                comment : "Actual velocity"
            PosDiff:
                type    : iec61131.LREAL
                comment : "Position difference (lag distance)"
            SetPos:
                type    : iec61131.LREAL
                comment : "Setpoint position"
            SetVelo:
                type    : iec61131.LREAL
                comment : "Setpoint velocity"
            SetAcc:
                type    : iec61131.LREAL
                comment : "Setpoint acceleration"
            TargetPos:
                type    : iec61131.LREAL
                comment : "Estimated target position"
            ModuloSetPos:
                type    : iec61131.LREAL
                comment : "Setpoint modulo position"
            ModuloSetTurns:
                type    : iec61131.DINT
                comment : "Setpoint modulo turns"
            CmdNo:
                type    : iec61131.WORD
                comment : "Continuous actual command number"
            CmdState:
                type    : iec61131.WORD
                comment : "Command state"
        ) "NCTOPLC_AXIS_REF"

    CONTAINS PLC_FB(
        in:
            PlcToNc:
                type    : self.PLCTONC_AXIS_REF
        out:
            NcToPlc:
                type    : self.NCTOPLC_AXIS_REF
            Status:
                type    : self.ST_AxisStatus
        ) "AXIS_REF"
    EXIT()
]


beckhoff.ADD PLC_OPEN_ATTRIBUTE('OPC.UA.DA', '0') "OPC_UA_DEACTIVATE"
beckhoff.ADD PLC_OPEN_ATTRIBUTE('OPC.UA.DA', '1') "OPC_UA_ACTIVATE"
beckhoff.ADD PLC_OPEN_ATTRIBUTE('OPC.UA.DA.Access', '0') "OPC_UA_ACCESS"
beckhoff.ADD PLC_OPEN_ATTRIBUTE('OPC.UA.DA.Access', '1') "OPC_UA_ACCESS_R"
beckhoff.ADD PLC_OPEN_ATTRIBUTE('OPC.UA.DA.Access', '2') "OPC_UA_ACCESS_W"
beckhoff.ADD PLC_OPEN_ATTRIBUTE('OPC.UA.DA.Access', '3') "OPC_UA_ACCESS_RW"



########################################################################################################################
# I/O modules
########################################################################################################################

beckhoff.ADD IO_MODULE_TYPE(
    id              : "EK1101"
    comment         : "EtherCAT Coupler with ID switch"
    manufacturer    : beckhoff.company
    terminals       :
        X1 : -> symbol: "X1"  , comment: "EtherCAT IN"
        X2 : -> symbol: "X2"  , comment: "EtherCAT OUT"
        1  : -> symbol: "24V" , comment: "coupler +24V"
        2  : -> symbol: "+"   , comment: "bus + power"
        3  : -> symbol: "-"   , comment: "bus - power"
        4  : -> symbol: "PE"  , comment: "Protective Earth"
        5  : -> symbol: "0V"  , comment: "coupler GND"
        6  : -> symbol: "+"   , comment: "bus + power"
        7  : -> symbol: "-"   , comment: "bus - power"
        8  : -> symbol: "PE"  , comment: "Protective Earth"
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EK1101"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL1008"
    comment         : "8-channel digital input terminal 24V DC"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "I1" , comment: "Input 1"
        2  : -> symbol: "I3" , comment: "Input 3"
        3  : -> symbol: "I5" , comment: "Input 5"
        4  : -> symbol: "I7" , comment: "Input 7"
        5  : -> symbol: "I2" , comment: "Input 2"
        6  : -> symbol: "I4" , comment: "Input 4"
        7  : -> symbol: "I6" , comment: "Input 6"
        8  : -> symbol: "I8" , comment: "Input 8"
    channels:
        1  : -> terminals: [ self.terminals["1"] ]
        2  : -> terminals: [ self.terminals["5"] ]
        3  : -> terminals: [ self.terminals["2"] ]
        4  : -> terminals: [ self.terminals["6"] ]
        5  : -> terminals: [ self.terminals["3"] ]
        6  : -> terminals: [ self.terminals["7"] ]
        7  : -> terminals: [ self.terminals["4"] ]
        8  : -> terminals: [ self.terminals["8"] ]
    soft_interface:
        input1        : -> { type: t_bool  , comment: 'Input 1' }
        input2        : -> { type: t_bool  , comment: 'Input 2' }
        input3        : -> { type: t_bool  , comment: 'Input 3' }
        input4        : -> { type: t_bool  , comment: 'Input 4' }
        input5        : -> { type: t_bool  , comment: 'Input 5' }
        input6        : -> { type: t_bool  , comment: 'Input 6' }
        input7        : -> { type: t_bool  , comment: 'Input 7' }
        input8        : -> { type: t_bool  , comment: 'Input 8' }
        WcState       : -> { type: t_bool  , comment: 'EtherCAT Working counter state' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT state (INIT, PREOP, OP, ...)' }
    ) "EL1008"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL1088"
    comment         : "8-channel digital input terminal 24V DC, negative switching"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "I1" , comment: "Input 1"
        2  : -> symbol: "I3" , comment: "Input 3"
        3  : -> symbol: "I5" , comment: "Input 5"
        4  : -> symbol: "I7" , comment: "Input 7"
        5  : -> symbol: "I2" , comment: "Input 2"
        6  : -> symbol: "I4" , comment: "Input 4"
        7  : -> symbol: "I6" , comment: "Input 6"
        8  : -> symbol: "I8" , comment: "Input 8"
    channels:
        1  : -> terminals: [ self.terminals["1"] ]
        2  : -> terminals: [ self.terminals["5"] ]
        3  : -> terminals: [ self.terminals["2"] ]
        4  : -> terminals: [ self.terminals["6"] ]
        5  : -> terminals: [ self.terminals["3"] ]
        6  : -> terminals: [ self.terminals["7"] ]
        7  : -> terminals: [ self.terminals["4"] ]
        8  : -> terminals: [ self.terminals["8"] ]
    soft_interface:
        input1        : -> { type: t_bool  , comment: 'Input 1' }
        input2        : -> { type: t_bool  , comment: 'Input 2' }
        input3        : -> { type: t_bool  , comment: 'Input 3' }
        input4        : -> { type: t_bool  , comment: 'Input 4' }
        input5        : -> { type: t_bool  , comment: 'Input 5' }
        input6        : -> { type: t_bool  , comment: 'Input 6' }
        input7        : -> { type: t_bool  , comment: 'Input 7' }
        input8        : -> { type: t_bool  , comment: 'Input 8' }
        WcState       : -> { type: t_bool  , comment: 'EtherCAT Working counter state' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT state (INIT, PREOP, OP, ...)' }
    ) "EL1088"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL1904"
    comment         : "4-channel digital input terminal, TwinSAFE 24V DC"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "I1" , comment: "Input 1+"
        2  : -> symbol: "I3" , comment: "Input 1-"
        3  : -> symbol: "I5" , comment: "Input 3+"
        4  : -> symbol: "I7" , comment: "Input 3-"
        5  : -> symbol: "I2" , comment: "Input 2+"
        6  : -> symbol: "I4" , comment: "Input 2-"
        7  : -> symbol: "I6" , comment: "Input 4+"
        8  : -> symbol: "I8" , comment: "Input 4-"
    channels:
        1  : -> terminals: [ self.terminals["1"], self.terminals["2"] ]
        2  : -> terminals: [ self.terminals["5"], self.terminals["6"] ]
        3  : -> terminals: [ self.terminals["3"], self.terminals["4"] ]
        4  : -> terminals: [ self.terminals["7"], self.terminals["8"] ]
    soft_interface:
        input1        : -> { type: t_bool  , comment: 'Input 1' }
        input2        : -> { type: t_bool  , comment: 'Input 2' }
        input3        : -> { type: t_bool  , comment: 'Input 3' }
        input4        : -> { type: t_bool  , comment: 'Input 4' }
        WcState       : -> { type: t_bool  , comment: 'EtherCAT Working counter state' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT state (INIT, PREOP, OP, ...)' }
    ) "EL1904"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL2008"
    comment         : "8-channel digital output terminal 24V DC"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "O1" , comment: "Output 1"
        2  : -> symbol: "O3" , comment: "Output 3"
        3  : -> symbol: "O5" , comment: "Output 5"
        4  : -> symbol: "O7" , comment: "Output 7"
        5  : -> symbol: "O2" , comment: "Output 2"
        6  : -> symbol: "O4" , comment: "Output 4"
        7  : -> symbol: "O6" , comment: "Output 6"
        8  : -> symbol: "O8" , comment: "Output 8"
    channels:
        1  : -> terminals: [ self.terminals[1] ]
        2  : -> terminals: [ self.terminals[5] ]
        3  : -> terminals: [ self.terminals[2] ]
        4  : -> terminals: [ self.terminals[6] ]
        5  : -> terminals: [ self.terminals[3] ]
        6  : -> terminals: [ self.terminals[7] ]
        7  : -> terminals: [ self.terminals[4] ]
        8  : -> terminals: [ self.terminals[8] ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL2008"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL2904"
    comment         : "4-channel digital output terminal, TwinSAFE, 24V DC"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "O1" , comment: "Output 1"
        2  : -> symbol: "O3" , comment: "Output 3"
        3  : -> symbol: "O5" , comment: "Output 5"
        4  : -> symbol: "O7" , comment: "Output 7"
        5  : -> symbol: "O2" , comment: "Output 2"
        6  : -> symbol: "O4" , comment: "Output 4"
        7  : -> symbol: "O6" , comment: "Output 6"
        8  : -> symbol: "O8" , comment: "Output 8"
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[2] ]
        2  : -> terminals: [ self.terminals[5], self.terminals[6] ]
        3  : -> terminals: [ self.terminals[3], self.terminals[4] ]
        4  : -> terminals: [ self.terminals[7], self.terminals[8] ]
    soft_interface:
        output1       : -> { type: t_bool  , comment: 'Output 1' }
        output2       : -> { type: t_bool  , comment: 'Output 2' }
        output3       : -> { type: t_bool  , comment: 'Output 3' }
        output4       : -> { type: t_bool  , comment: 'Output 4' }
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL2904"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL2024"
    comment         : "4-channel digital output terminals 24 V DC, 2 A"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "O1"    , comment: "Output 1"
        2  : -> symbol: "-"     , comment: "0V"
        3  : -> symbol: "-"     , comment: "0V"
        4  : -> symbol: "O3"    , comment: "Output 3"
        5  : -> symbol: "O2"    , comment: "Output 2"
        6  : -> symbol: "-"     , comment: "0V"
        7  : -> symbol: "-"     , comment: "0V"
        8  : -> symbol: "O4"    , comment: "Output 4"
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[2] ]
        2  : -> terminals: [ self.terminals[5], self.terminals[6] ]
        3  : -> terminals: [ self.terminals[3], self.terminals[4] ]
        4  : -> terminals: [ self.terminals[7], self.terminals[8] ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL2024"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL2124"
    comment         : "4-channel digital output terminals 5 V DC"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "O1"    , comment: "Output 1"
        2  : -> symbol: "-"     , comment: "0V"
        3  : -> symbol: "-"     , comment: "0V"
        4  : -> symbol: "O3"    , comment: "Output 3"
        5  : -> symbol: "O2"    , comment: "Output 2"
        6  : -> symbol: "-"     , comment: "0V"
        7  : -> symbol: "-"     , comment: "0V"
        8  : -> symbol: "O4"    , comment: "Output 4"
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[2] ]
        2  : -> terminals: [ self.terminals[5], self.terminals[6] ]
        3  : -> terminals: [ self.terminals[3], self.terminals[4] ]
        4  : -> terminals: [ self.terminals[7], self.terminals[8] ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL2124"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL2622"
    comment         : "2-channel relay"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> { symbol: "O1" , comment: "Output 1" }
        2  : -> { symbol: "L"  , comment: "Output 1" }
        3  : -> { symbol: ""   , comment: "(not connected)" }
        4  : -> { symbol: "PE" , comment: "Protective Earth" }
        5  : -> { symbol: "O2" , comment: "Output 2" }
        6  : -> { symbol: "L"  , comment: "Output 2" }
        7  : -> { symbol: ""   , comment: "(not connected)" }
        8  : -> { symbol: "PE" , comment: "Protective Earth" }
    channels:
        1  : -> { terminals: [ self.terminals[1], self.terminals[2] ] }
        2  : -> { terminals: [ self.terminals[5], self.terminals[6] ] }
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL2622"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL3024"
    comment         : "4-channel analog input terminals 4...20mA, differential inputs, 12 bit"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "+I1"   , comment: "+Input 1"
        2  : -> symbol: "-I1"   , comment: "-Input 1"
        3  : -> symbol: "+I3"   , comment: "+Input 3"
        4  : -> symbol: "-I3"   , comment: "-Input 3"
        5  : -> symbol: "+I2"   , comment: "+Input 2"
        6  : -> symbol: "-I2"   , comment: "-Input 2"
        7  : -> symbol: "+I4"   , comment: "+Input 4"
        8  : -> symbol: "-I4"   , comment: "-Input 4"
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[2] ]
        2  : -> terminals: [ self.terminals[5], self.terminals[6] ]
        3  : -> terminals: [ self.terminals[3], self.terminals[4] ]
        4  : -> terminals: [ self.terminals[7], self.terminals[8] ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL3024"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL3152"
    comment         : "2-channel analog input terminal 4..20 mA, single-ended, 16 bit"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "I1"    , comment: "Input 1"
        2  : -> symbol: "+"     , comment: "+24 V"
        3  : -> symbol: "-"     , comment: "0 V"
        4  : -> symbol: "S"     , comment: "Shield"
        5  : -> symbol: "I2"    , comment: "Input 2"
        6  : -> symbol: "+"     , comment: "+24 V"
        7  : -> symbol: "GND"   , comment: "0 V"
        8  : -> symbol: "S"     , comment: "Shield"
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[2], self.terminals[3], self.terminals[4] ]
        2  : -> terminals: [ self.terminals[5], self.terminals[6], self.terminals[7], self.terminals[8] ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL3152"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL3102"
    comment         : "2-channel analog input terminals -10...+10 V, differential input, 16 bit"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "+I1"   , comment: "+Input 1"
        2  : -> symbol: "-I1"   , comment: "-Input 1"
        3  : -> symbol: "GND"   , comment: "GND"
        4  : -> symbol: "S"     , comment: "Shield"
        5  : -> symbol: "+I2"   , comment: "+Input 2"
        6  : -> symbol: "-I2"   , comment: "-Input 2"
        7  : -> symbol: "GND"   , comment: "GND"
        8  : -> symbol: "S"     , comment: "Shield"
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[2] ]
        2  : -> terminals: [ self.terminals[5], self.terminals[6] ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL3102"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL3164"
    comment         : "4-channel analog input terminal 0...10 V, single-ended, 16 bit"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "I1"    , comment: "Input 1"
        2  : -> symbol: "GND"   , comment: "GND"
        3  : -> symbol: "I3"    , comment: "Input 3"
        4  : -> symbol: "GND"   , comment: "GND"
        5  : -> symbol: "I2"    , comment: "Input 2"
        6  : -> symbol: "GND"   , comment: "GND"
        7  : -> symbol: "I4"    , comment: "Input 4"
        8  : -> symbol: "GND"   , comment: "GND"
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[2] ]
        2  : -> terminals: [ self.terminals[5], self.terminals[6] ]
        3  : -> terminals: [ self.terminals[3], self.terminals[4] ]
        4  : -> terminals: [ self.terminals[7], self.terminals[8] ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL3164"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL3202-0010"
    comment         : "2-channel input terminals PT100 (RTD) for 4-wire connection, high-precision"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "+R1"   , comment: "Channel 1: + sensor wire"
        2  : -> symbol: "+RL1"  , comment: "Channel 1: + line wire"
        3  : -> symbol: "-R1"   , comment: "Channel 1: - sensor wire"
        4  : -> symbol: "-RL1"  , comment: "Channel 1: - line wire"
        5  : -> symbol: "+R2"   , comment: "Channel 2: + sensor wire"
        6  : -> symbol: "+RL2"  , comment: "Channel 2: + line wire"
        7  : -> symbol: "-R2"   , comment: "Channel 2: - sensor wire"
        8  : -> symbol: "-RL2"  , comment: "Channel 2: - line wire"
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[2], self.terminals[3], self.terminals[4] ]
        2  : -> terminals: [ self.terminals[5], self.terminals[6], self.terminals[7], self.terminals[8] ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL3202_0010"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL3351"
    comment         : "1-channel resistor bridge terminal (strain gauge)"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "+Ud"   , comment: "Bridge voltage +Ud"
        2  : -> symbol: "-Ud"   , comment: "Bridge voltage -Ud"
        3  : -> symbol: "-Uv"   , comment: "Supply voltage output = 0V"
        4  : -> symbol: "S"     , comment: "Shield"
        5  : -> symbol: "+Uref" , comment: "Supply voltage input +Uref"
        6  : -> symbol: "-Uref" , comment: "Supply voltage input -Uref"
        7  : -> symbol: "+Uv"   , comment: "Supply voltage output = 5V"
        8  : -> symbol: "S"     , comment: "Shield"
    channels:
        1  : -> terminals: self.terminals[i] for i in [1..8]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL3351"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL3681"
    comment         : "Digital multimeter"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "V"     , comment: "Voltage"
        2  : -> symbol: "COM"   , comment: "Common"
        3  : -> symbol: "10A"   , comment: "10 Amps input"
        4  : -> symbol: "S"     , comment: "Shield"
        5  : -> symbol: "V"     , comment: "Voltage"
        6  : -> symbol: "COM"   , comment: "Common"
        7  : -> symbol: "1A"    , comment: "1 Amp input"
        8  : -> symbol: "S"     , comment: "Shield"
    channels:
        1  : -> terminals: self.terminals[i] for i in [1..8]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL3681"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL4008"
    comment         : "8-channel analog output terminal 0...10V, 12 bit"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "O1" , comment: "Output 1"
        2  : -> symbol: "O2" , comment: "Output 2"
        3  : -> symbol: "O3" , comment: "Output 3"
        4  : -> symbol: "O4" , comment: "Output 4"
        5  : -> symbol: "O5" , comment: "Output 5"
        6  : -> symbol: "O6" , comment: "Output 6"
        7  : -> symbol: "O7" , comment: "Output 7"
        8  : -> symbol: "O8" , comment: "Output 8"
    channels:
        1  : -> terminals: [ self.terminals[1] ]
        2  : -> terminals: [ self.terminals[2] ]
        3  : -> terminals: [ self.terminals[3] ]
        4  : -> terminals: [ self.terminals[4] ]
        5  : -> terminals: [ self.terminals[5] ]
        6  : -> terminals: [ self.terminals[6] ]
        7  : -> terminals: [ self.terminals[7] ]
        8  : -> terminals: [ self.terminals[8] ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL4008"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL4022"
    comment         : "2-channel analog output terminal 4...20 mA, 12 bit"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "O1"    , comment: "Output 1"
        2  : -> symbol: "+"     , comment: "+24V"
        3  : -> symbol: "-"     , comment: "0V"
        4  : -> symbol: "S"     , comment: "Shield"
        5  : -> symbol: "O2"    , comment: "Output 2"
        6  : -> symbol: "+"     , comment: "+24V"
        7  : -> symbol: "-"     , comment: "0V"
        8  : -> symbol: "S"     , comment: "Shield"
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[2] ]
        2  : -> terminals: [ self.terminals[5], self.terminals[6] ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL4022"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL4132"
    comment         : "2-channel analog output terminal -10...+10V, 16 bit"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "O1"    , comment: "Output 1"
        2  : -> symbol: ""      , comment: ""
        3  : -> symbol: "GND"   , comment: "GND"
        4  : -> symbol: "S"     , comment: "Shield"
        5  : -> symbol: "O2"    , comment: "Output 2"
        6  : -> symbol: ""      , comment: ""
        7  : -> symbol: "GND"   , comment: "GND"
        8  : -> symbol: "S"     , comment: "Shield"
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[3], self.terminals[4] ]
        2  : -> terminals: [ self.terminals[5], self.terminals[7], self.terminals[8] ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL4132"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL5001"
    comment         : "1-channel SSI encoder"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "D+"   , comment: "Data +"
        2  : -> symbol: "+"    , comment: "+24V"
        3  : -> symbol: "-"    , comment: "0V"
        4  : -> symbol: "CI+"  , comment: "Clock +"
        5  : -> symbol: "D-"   , comment: "Data -"
        6  : -> symbol: "+"    , comment: "+24V"
        7  : -> symbol: "-"    , comment: "0V"
        8  : -> symbol: "CI-"  , comment: "Clock -"
    channels:
        1  : -> terminals: [ self.terminals[1],
                             self.terminals[2],
                             self.terminals[3],
                             self.terminals[4],
                             self.terminals[5],
                             self.terminals[6],
                             self.terminals[7],
                             self.terminals[8] ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL5001"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL5002"
    comment         : "2-channel SSI encoder"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "D1+"  , comment: "Channel 1: Data +"
        2  : -> symbol: "CL1+" , comment: "Channel 1: Clock +"
        3  : -> symbol: "D2+"  , comment: "Channel 2: Data +"
        4  : -> symbol: "CL2+" , comment: "Channel 2: Clock +"
        5  : -> symbol: "D1-"  , comment: "Channel 1: Data -"
        6  : -> symbol: "CL1-" , comment: "Channel 1: Clock -"
        7  : -> symbol: "D2-"  , comment: "Channel 2: Data -"
        8  : -> symbol: "CL2-" , comment: "Channel 2: Clock -"
    channels:
        1  : -> terminals: [ self.terminals[1], self.terminals[2], self.terminals[5], self.terminals[6] ]
        2  : -> terminals: [ self.terminals[3], self.terminals[4], self.terminals[7], self.terminals[8] ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL5002"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL5101"
    comment         : "1-channel incremental encoder"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "A"    , comment: "Input A"
        2  : -> symbol: "B"    , comment: "Input B"
        3  : -> symbol: "C"    , comment: "Input C"
        4  : -> symbol: "G1"   , comment: "Latch 24V"
        5  : -> symbol: "-A"   , comment: "Input A-inverted"
        6  : -> symbol: "-B"   , comment: "Input B-inverted"
        7  : -> symbol: "-C"   , comment: "Input C-inverted"
        8  : -> symbol: "G2"   , comment: "Gate 24V"
        _1 : -> symbol: "UE"   , comment: "Encoder supply UE"
        _2 : -> symbol: "+"    , comment: "+24V"
        _3 : -> symbol: "-"    , comment: "0V"
        _4 : -> symbol: "I1"   , comment: "Input 1V"
        _5 : -> symbol: "U0"   , comment: "Encoder supply U0"
        _6 : -> symbol: "+"    , comment: "+24V"
        _7 : -> symbol: "-"    , comment: "0V"
        _8 : -> symbol: "S"    , comment: "Shield"
    channels:
        1  : -> terminals: [ self.terminals[1],
                             self.terminals[2],
                             self.terminals[3],
                             self.terminals[4],
                             self.terminals[5],
                             self.terminals[6],
                             self.terminals[7],
                             self.terminals[8],
                             self.terminals._1,
                             self.terminals._2,
                             self.terminals._3,
                             self.terminals._4,
                             self.terminals._5,
                             self.terminals._6,
                             self.terminals._7,
                             self.terminals._8 ]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL5101"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL6001"
    comment         : "RS-232 serial communication"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "TxD"   , comment: "TxD"
        2  : -> symbol: "RTS_"  , comment: "RTS-inverted"
        3  : -> symbol: "GND"   , comment: "GND"
        4  : -> symbol: "S"     , comment: "Shield"
        5  : -> symbol: "RxD"   , comment: "RxD"
        6  : -> symbol: "CTS_"  , comment: "CTS-inverted"
        7  : -> symbol: "GND"   , comment: "GND"
        8  : -> symbol: "S"     , comment: "Shield"
    channels:
        1  : -> terminals: self.terminals[i] for i in [1..8]
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL6001"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL6688"
    comment         : "IEEE 1588 external synchronisation interface"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "1"
        2  : -> symbol: "2"
        3  : -> symbol: "3"
        4  : -> symbol: "4"
        5  : -> symbol: "5"
        6  : -> symbol: "6"
        7  : -> symbol: "7"
        8  : -> symbol: "8"
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL6688"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL6751"
    comment         : "CANopen master/slave controller"
    manufacturer    : beckhoff.company
    terminals:
        2  : -> symbol: "CAN-"   , comment: "CAN low"
        3  : -> symbol: "GND"    , comment: "CAN GND"
        6  : -> symbol: "GND"    , comment: "CAN GND"
        7  : -> symbol: "CAN+"   , comment: "CAN high"
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL6751"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL6900"
    comment         : "TwinSAFE Logic"
    manufacturer    : beckhoff.company
    terminals       : {}
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL6900"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL9070"
    comment         : "Shield terminal"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "S" , comment: "Shield"
        2  : -> symbol: "S" , comment: "Shield"
        3  : -> symbol: "S" , comment: "Shield"
        4  : -> symbol: "S" , comment: "Shield"
        5  : -> symbol: "S" , comment: "Shield"
        6  : -> symbol: "S" , comment: "Shield"
        7  : -> symbol: "S" , comment: "Shield"
        8  : -> symbol: "S" , comment: "Shield"
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL9070"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL9186"
    comment         : "Potential distribution terminal, 8 x 24V"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "A1" , comment: "Output 1"
        2  : -> symbol: "A2" , comment: "Output 2"
        3  : -> symbol: "A3" , comment: "Output 3"
        4  : -> symbol: "A4" , comment: "Output 4"
        5  : -> symbol: "A5" , comment: "Output 5"
        6  : -> symbol: "A6" , comment: "Output 6"
        7  : -> symbol: "A7" , comment: "Output 7"
        8  : -> symbol: "A8" , comment: "Output 8"
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL9186"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL9187"
    comment         : "Potential distribution terminal, 8 x 0V"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "A1" , comment: "Output 1"
        2  : -> symbol: "A2" , comment: "Output 2"
        3  : -> symbol: "A3" , comment: "Output 3"
        4  : -> symbol: "A4" , comment: "Output 4"
        5  : -> symbol: "A5" , comment: "Output 5"
        6  : -> symbol: "A6" , comment: "Output 6"
        7  : -> symbol: "A7" , comment: "Output 7"
        8  : -> symbol: "A8" , comment: "Output 8"
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL9187"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL9410"
    comment         : "Power supply terminals for E-bus (with diagnostics)"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "24V"   , comment: "+24V"
        2  : -> symbol: "+"     , comment: "Infeed 24V"
        3  : -> symbol: "-"     , comment: "Infeed 0V"
        4  : -> symbol: "PE"    , comment: "PE"
        5  : -> symbol: "0V"    , comment: "0 V"
        6  : -> symbol: "+"     , comment: "Infeed 24V"
        7  : -> symbol: "-"     , comment: "Infeed 0V"
        8  : -> symbol: "PE"    , comment: "PE"
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL9410"


beckhoff.ADD IO_MODULE_TYPE(
    id              : "EL9505"
    comment         : "Power supply terminals 5 V"
    manufacturer    : beckhoff.company
    terminals:
        1  : -> symbol: "24V"   , comment: "+24V"
        2  : -> symbol: "Uo"    , comment: "Output voltage +5V"
        3  : -> symbol: "0V"    , comment: "Output voltage 0V"
        4  : -> symbol: "S"     , comment: "Shield"
        5  : -> symbol: "0V"    , comment: "0 V"
        6  : -> symbol: "Uo"    , comment: "Output voltage +5V"
        7  : -> symbol: "0V"    , comment: "Output voltage 0V"
        8  : -> symbol: "S"     , comment: "Shield"
    soft_interface:
        WcState       : -> { type: t_bool  , comment: 'EtherCAT working counter state (false = data valid, true = data invalid)' }
        InfoDataState : -> { type: t_uint16, comment: 'EtherCAT info data state (e.g. INIT, PREOP, OP, ...)' }
    ) "EL9505"


########################################################################################################################
# Write the model to file
########################################################################################################################

beckhoff.WRITE "models/external/beckhoff.jsonld"
