########################################################################################################################
#                                                                                                                      #
# Model that holds factories to create sofware artifacts (e.g. state machine models).                                  #
#                                                                                                                      #
# TODO: clean up and add comments                                                                                      #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


# metamodels
REQUIRE "metamodels/iec61131.coffee"
REQUIRE "metamodels/containers.coffee"

# models
REQUIRE "models/external/beckhoff.coffee"

MODEL "http://www.mercator.iac.es/onto/models/util/softwarefactories" : "softwarefactories"

softwarefactories.IMPORT cont
softwarefactories.IMPORT iec61131
softwarefactories.IMPORT beckhoff


########################################################################################################################
# MTCS_MAKE_LIB
########################################################################################################################

softwarefactories.ADD LIBRARY() "MkLib" : () -> [
    soft.isElementOf iec61131.iec61131

    CONTAINS NAMESPACE() "Enums"
    CONTAINS NAMESPACE() "Statuses"
    CONTAINS NAMESPACE() "StateMachines" : [
        CONTAINS NAMESPACE() "Parts"
        CONTAINS NAMESPACE() "Processes"
        CONTAINS NAMESPACE() "Statuses"
    ]
    CONTAINS NAMESPACE() "Configs"
    CONTAINS NAMESPACE() "Structs"
    CONTAINS NAMESPACE() "Processes" : [
        CONTAINS NAMESPACE() "Args"
    ]
]

root.MTCS_MAKE_LIB = (name) -> softwarefactories.MkLib() name


########################################################################################################################
# MTCS_MAKE_ENUM
########################################################################################################################

root.MTCS_MAKE_ENUM = (ns, name, args) ->
    CHECK_ARGS("MAKE_ENUM_MODEL", args, ["items", "type", "comment"])
    enumArgs = {}
    if args.items?
        enumArgs.items = args.items
    if args.type?
        enumArgs.type = args.type
    if args.comment?
        enumArgs.comment = args.comment

    enumArgs.containedBy = ns.Enums

    ns.ADD ENUMERATION(enumArgs) name




########################################################################################################################
# MTCS_MAKE_STATUS
########################################################################################################################

softwarefactories.ADD PLC_FB() "MkStatus" : (args) -> [
    CHECK_ARGS("MTCS_MAKE_STATUS", args, ["variables", "states"])

    # create a BOOL, which represents an optional super state
    HAS VAR_IN(
        initial: bool(true)
        type: t_bool,
        comment: "Super state (TRUE if the super state is active, or if there is no super state)"
        ) "superState"

    # add the state variables as VAR_IN
    if args.variables?
        for name, details of args.variables
            HAS VAR_IN(details) name

    # add the states as VAR_OUT
    if args.states?
        for name, details of args.states
            HAS VAR_OUT(
                    type: t_bool
                    comment: details.comment
                    qualifiers: [ beckhoff.OPC_UA_ACTIVATE, beckhoff.OPC_UA_ACCESS_R ] ) name

    # add the implementation part
    HAS IMPLEMENTATION() "implementation" : [
        CONTAINS ASSIGN( self[name], AND( details.expr() , self.superState ) ) for name, details of args.states
    ]
]

root.MTCS_MAKE_STATUS = (ns, name, args) ->

    sts = softwarefactories.MkStatus(args) name

    # add the status to the library, and have it contained by the Statuses folder
    ns.ADD sts
    sts.ADD cont.isContainedBy ns.Statuses



########################################################################################################################
# MTCS_MAKE_STATEMACHINE
########################################################################################################################

softwarefactories.ADD PLC_FB() "MkBaseStateMachine" : ( ns, sm_name, args ) -> [

    CHECK_ARGS("MkBaseStateMachine", args, ["variables",
                                            "variables_hidden",
                                            "variables_read_only",
                                            "statuses",
                                            "parts",
                                            "local",
                                            "methods",
                                            "calls",
                                            "disabled_calls",
                                            "updates",
                                            "references",
                                            "extends",
                                            "processes",
                                            "constraints"])

    if args.extends?
        APPLY PLC_FB(extends: args.extends)
    else
        APPLY PLC_FB()

    # ============ DECLARATION PART ============

    varNames = []
    statusNames = []
    partNames = []
    processNames = []
    disabledCallNames = []

    # add a special String variable that will hold the current status description
    if not self.actualStatus?
        HAS VAR_OUT(
                type: t_string
                comment: "Current status description"
                qualifiers: [ beckhoff.OPC_UA_ACTIVATE, beckhoff.OPC_UA_ACCESS_R ]) "actualStatus"

    # add a special String variable that will hold the previous status description
    if not self.previousStatus?
        HAS VAR_OUT(
                type: t_string
                comment: "Previous status description") "previousStatus"

    # add the variables as VAR_IN
    if args.variables?
        for name, details of args.variables
            varNames.push name
        for name, details of args.variables
            details["qualifiers"] = [beckhoff.OPC_UA_ACTIVATE, beckhoff.OPC_UA_ACCESS_R ]
            HAS VAR_IN(details) name

    # add the variables_read_only as VAR_OUT
    if args.variables_read_only?
        for name, details of args.variables_read_only
            varNames.push name
        for name, details of args.variables_read_only
            details["qualifiers"] = [beckhoff.OPC_UA_ACTIVATE, beckhoff.OPC_UA_ACCESS_R ]
            HAS VAR_OUT(details) name

    # add the variables_hidden as VAR_IN
    if args.variables_hidden?
        for name, details of args.variables_hidden
            varNames.push name
        for name, details of args.variables_hidden
            details["qualifiers"] = [beckhoff.OPC_UA_DEACTIVATE]
            HAS VAR_IN(details) name

    # add the references as VAR_IN_OUT
    if args.references?
        for name, details of args.references
            details['qualifiers'] = [ beckhoff.OPC_UA_DEACTIVATE ]
            HAS VAR_IN_OUT(details) name

    # add the statuses as VAR_OUT
    if args.statuses?
        for name, details of args.statuses
            statusNames.push name
        statusesStruct = PLC_STRUCT(items: args.statuses, containedBy: ns.StateMachines.Statuses) "#{sm_name}Statuses"
        ns.ADD statusesStruct
        HAS VAR_OUT(type: statusesStruct, comment: "Statuses of the state machine") "statuses"

    # create a struct for the parts
    if args.parts?
        for name, details of args.parts
            partNames.push name
        partsStruct = PLC_STRUCT(items: args.parts, containedBy: ns.StateMachines.Parts) "#{sm_name}Parts"
        ns.ADD partsStruct
        HAS VAR_OUT(type: partsStruct, comment: "Parts of the state machine") "parts"

    # store the disabled calls
    if args.disabled_calls?
        disabledCallNames = args.disabled_calls

    # add the processes as VAR_OUT and as methods
    if args.processes?
        # declare a Struct which bundles all processes of the given state machine
        processesStruct = PLC_STRUCT(items: args.processes, containedBy: ns.StateMachines.Processes) "#{sm_name}Processes"
        ns.ADD processesStruct
        HAS VAR_OUT(type: processesStruct, comment: "Processes of the state machine") "processes"

    if args.processes?
        for name, details of args.processes
            processNames.push name
            [
                HAS PLC_METHOD(
                    comment: details.comment
                    returnType: common_soft.mtcs_common.RequestResults
                    inputArgs: __BUILD__( ( __PAIR__(v._name, { type: PATH(v, soft.hasType) } ) for v in PATHS(details.type.request, HAS_VAR_IN) ) )
                ) name
                # add the implementation of the method
                self[name].ADD HAS IMPLEMENTATION(
                    [
                        ASSIGN(
                            self[name],
                            CALL(
                                    calls: self.processes[name].request,
                                    assigns: __BUILD__( ( __PAIR__(v._name, v) for v in PATHS(self[name], HAS_VAR_IN) ) ) ) "callRequest"
                        )
                    ]
                ) "implementation"
            ]

    # add the local variables
    if args.local?
        for name, details of args.local
            details["qualifiers"] = [beckhoff.OPC_UA_ACTIVATE ]
            HAS VAR(details) name

    # add the methods
    if args.methods?
        for name, details of args.methods
            HAS PLC_METHOD(details) name


    CONTAINER() "constraints"
    if constraints?
        for name, detailsFunction of constraints
            self.constraints.ADD CONTAINS CONSTRAINT(detailsFunction()) name
            sys.hasConstraint self.constraints[name]


    # ============ IMPLEMENTATION PART ============

    if not args.calls?
        args.calls = {}
        []

    HAS IMPLEMENTATION(

        # call the variables (if specified!)
        CALL(
            calls: self[name]
            assigns : __BUILD__( ( __PAIR__(left, right()) for left, right of args.calls[name] ) )
        ) "call_var_#{name}" for name in varNames when (name in Object.keys(args.calls) and (name not in disabledCallNames))

        # call the parts
        CALL(
            calls: self.parts[name]
            assigns : __BUILD__( ( __PAIR__(left, right()) for left, right of args.calls[name] ) )
        ) "call_part_#{name}" for name in partNames when name not in disabledCallNames

        # call the statuses
        CALL(
            calls: self.statuses[name]
            assigns : __BUILD__( ( __PAIR__(left, right()) for left, right of args.calls[name] ) )
        ) "call_status_#{name}" for name in statusNames when name not in disabledCallNames

        # call the processes
        CALL(
            calls: self.processes[name],
            assigns: __BUILD__( ( __PAIR__(left, right()) for left, right of args.calls[name] ) )
        ) "call_process_#{name}" for name in processNames when name not in disabledCallNames

        # call the superclass if needed
        if args.extends?
            if args.calls["SUPER"]?
                [ CALL(
                    calls: PLC_DEREF(operand: self.SUPER),
                    assigns: __BUILD__( ( __PAIR__(left, right()) for left, right of args.calls["SUPER"] ) )
                  ) "callSuper" ]
            else
                [ CALL(calls: PLC_DEREF(operand: self.SUPER)) "callSuper" ]
        else
            []

    ) "implementation"


    # ============ lOGGING METHOD  ============

    # only add the _log method on the base type (not on sub-types)
    if not self._log?
        HAS PLC_METHOD(
            comment         : "Log to buffer"
            inputArgs:
                name        : { type: t_string, comment: "Name of this function block instance" }
            inOutArgs:
                buffer      : { type: common_soft.LogBuffer, comment: "Buffer to write all logging to" }
            localArgs:
                subBuffer   : { type: common_soft.LogBuffer, comment: "Temporary buffer to write logging by parts (sub-statemachines) to" }
            returnType      : t_bool
        ) "_log"

    if not self._log.implementation?
        implementationArg = []

        loggerCallAssigns =
            name            : -> $.$._log.name
            actualStatus    : -> $.$.actualStatus
            previousStatus  : -> $.$.previousStatus
            buffer          : -> $.$._log.buffer
            subBuffer       : -> $.$._log.subBuffer

        if self.parts?
            for part in self.parts.attributes
                # add a _log method in case one wasn't defined already
                if not part._log?
                    part.ADD iec61131.hasMethodInstance iec61131.MethodInstance "_log" : [
                        HAS VAR_IN() 'name'
                        HAS VAR_IN_OUT() 'buffer'
                    ]

                implementationArg.push CALL(
                    calls: part._log
                    assigns:
                        name : -> STRING(part._name) "name"
                        buffer : -> $.$._log.subBuffer
                    ) "call_#{part._name}"
        # New feature added by JPP. Logging the processes
        if self.processes?
            for process in self.processes.attributes
                # add a _log method in case one wasn't defined already
                if not process._log?
                    process.ADD iec61131.hasMethodInstance iec61131.MethodInstance "_log" : [
                        HAS VAR_IN() 'name'
                        HAS VAR_IN_OUT() 'buffer'
                    ]
                processName = "processes.#{process._name}"
                implementationArg.push CALL(
                    calls: process._log
                    assigns:
                        name : -> STRING(processName) "name"
                        buffer : -> $.$._log.subBuffer
                    ) "call_#{process._name}"

        if self.statuses?
            if self.statuses.healthStatus?
                loggerCallAssigns['pHealthStatus'] = -> ADR($.$.statuses.healthStatus)
            if self.statuses.busyStatus?
                loggerCallAssigns['pBusyStatus'] = -> ADR($.$.statuses.busyStatus)

        implementationArg.push CALL(calls: common_soft.LOGGER, assigns: loggerCallAssigns) "loggerCall"

        self._log.ADD soft.hasImplementation IMPLEMENTATION(implementationArg) "implementation"

]

root.MTCS_MAKE_STATEMACHINE = (ns, name, args) ->
    baseStateMachineName = "SM_#{name}"
    mainStateMachineName = name

    # typeOf: applies to the derived state machine and not to the base state machine!
    CHECK_KEY(args, "typeOf")
    if args.typeOf?
        typeOf = args.typeOf
        delete args.typeOf
    else
        typeOf = []

    ns.ADD softwarefactories.MkBaseStateMachine(ns, name, args)                    baseStateMachineName
    ns.ADD PLC_FB(extends: ns[baseStateMachineName], typeOf: typeOf) mainStateMachineName

    if IS_ARRAY(typeOf)
        for t in typeOf
            t.ADD soft.hasType ns[mainStateMachineName]
    else
        typeOf.ADD soft.hasType ns[mainStateMachineName]

    # add the base state machine to the namespace.StateMachines:
    ns[baseStateMachineName].ADD IS_CONTAINED_BY ns.StateMachines


########################################################################################################################
# MTCS_MAKE_CONFIG
########################################################################################################################


root.MTCS_MAKE_CONFIG = (ns, name, args) ->
    ns.ADD PLC_STRUCT(args) name
    ns[name].ADD IS_CONTAINED_BY ns.Configs



########################################################################################################################
# MTCS_MAKE_STRUCT
########################################################################################################################


root.MTCS_MAKE_STRUCT = (ns, name, args) ->
    ns.ADD PLC_STRUCT(args) name
    ns[name].ADD IS_CONTAINED_BY ns.Structs


########################################################################################################################
# MTCS_MAKE_PROCESS
########################################################################################################################

softwarefactories.ADD PLC_FB() "MkProcess" : (ns, processName, args = {}) -> [
    CHECK_ARGS("MkProcess", args, ["extends", "arguments", "variables", "variables_hidden", "references"])

    IS_CONTAINED_BY ns.Processes

    if args.extends?
        APPLY PLC_FB(extends: args.extends)
    else
        APPLY PLC_FB(extends: common_soft.mtcs_common.BaseProcess)

    # add the variables as VAR_IN
    if args.variables?
        for name, details of args.variables
            HAS VAR_IN(details) name

    # add the references as VAR_IN_OUT
    if args.references?
        for name, details of args.references
            details['qualifiers'] = [ beckhoff.OPC_UA_DEACTIVATE ]
            HAS VAR_IN_OUT(details) name

    # in case we have arguments, add a <ProcessName>Args Struct, containing the arguments!
    if args.arguments?
        argsStruct = PLC_STRUCT(items: args.arguments, containedBy: ns.Processes.Args) "#{processName}Args"
        ns.ADD argsStruct

    if not (args.variables? or args.arguments?)
        HAS VAR(
            type: t_bool,
            comment: "At least 1 variable needed because subclass members of an empty class are not exposed by OPC UA (TwinCAT bug!)"
            qualifiers: [ beckhoff.OPC_UA_DEACTIVATE ]
        ) "testVar"

    # in case we have arguments, also add a 'set' and 'get' instance of this <ProcessName>Args struct
    if args.arguments?
        [
            HAS VAR_IN(
                type: argsStruct,
                comment: "Arguments to be set, before writing do_request TRUE"
                qualifiers: [ beckhoff.OPC_UA_ACTIVATE ]) "set"
            HAS VAR_OUT(
                type: argsStruct,
                comment: "Arguments in use by the process, if do_request was accepted"
                qualifiers: [ beckhoff.OPC_UA_ACTIVATE, beckhoff.OPC_UA_ACCESS_R ]) "get"
        ]

    # add a start(...) method
    if args.arguments?
        HAS PLC_METHOD(inputArgs: args.arguments) "start"
    else
        HAS PLC_METHOD() "start"

    # add implementation of the start method
    self.start.ADD [
        COMMENT "Start the process. This method does not check the enabledStatus, and should not be exposed via OPC UA!"
        HAS IMPLEMENTATION(
            ( ASSIGN(self.get[argName], self.start[argName]) for argName,argDetails of args.arguments )
            [
                CALL( calls: self.statuses.busyStatus   , assigns: { isBusy : TRUE } ) "setBusy"
                CALL( calls: self.statuses.healthStatus , assigns: { isGood : TRUE } ) "setGood"
            ]
        ) "implementation"
    ]

    # add a request(...) method
    if args.arguments?
        # add a method
        HAS PLC_METHOD(inputArgs: args.arguments, returnType: common_soft.mtcs_common.RequestResults) "request"
    else
        HAS PLC_METHOD(returnType: common_soft.mtcs_common.RequestResults) "request"

    # add details of the request method
    self.request.ADD [
        COMMENT "Request the start of this process"
        HAS IMPLEMENTATION(
            [
                IF_THEN(
                    if   : self.statuses.enabledStatus.enabled
                    then :
                        [
                            CALL(calls: self.start, assigns: __BUILD__( ( __PAIR__(argName, self.request[argName]) for argName, details of args.arguments ) ) ) "callStart"
                            ASSIGN(self.request, common_soft.mtcs_common.RequestResults.ACCEPTED)
                        ]
                    else :  [ ASSIGN(self.request, common_soft.mtcs_common.RequestResults.REJECTED) ]
                    ) "callStartIfEnabled"
            ]
        ) "implementation"
    ]

    # ============ IMPLEMENTATION PART ============

    HAS IMPLEMENTATION(
        [
            IF_THEN(
                if: self.do_request
                then: [ ASSIGN(self.do_request_result,
                               CALL(
                                   calls: self.request,
                                   assigns: __BUILD__( ( __PAIR__(argName, self.set[argName]) for argName, details of args.arguments ) ) ) "callRequest")
                        ASSIGN(self.do_request, FALSE) ]
            ) "manualRequestCall"
            CALL(calls: PLC_DEREF(operand: self.SUPER)) "callSuper"
        ]
    ) "implementation"

]
root.MTCS_MAKE_PROCESS = (ns, name, args={}) ->
    ns.ADD softwarefactories.MkProcess(ns, name, args) name


########################################################################################################################
# MTCS_MAKE_INTERFACE
########################################################################################################################

getInterface = (subject, name, isInterface=true) ->
    i = 0
    if isInterface
        ret = soft.Interface name
    else
        ret = VARIABLE(type: subject, expand: false) name # dont expand, we will only add the variables with an address!

    for [property,range] in [ [soft.hasArgument           , soft.Argument           ],
                              [soft.hasAttribute          , soft.Attribute          ],
                              [soft.hasCallable           , soft.Callable           ],
                              [iec61131.hasLocalVariable  , iec61131.LocalVariable  ],
                              [iec61131.hasInputVariable  , iec61131.InputVariable  ],
                              [iec61131.hasOutputVariable , iec61131.OutputVariable ] ] # Methods of a FB are soft:Types that must be instantiated!
                                                                                        # better alternative: soft.declares , soft.Variable(or Member) ???
        for result in PATHS(subject, property)
            attrName = result.qName().partName()

            attrAdr = PATH(result, soft.hasAddress)
            if attrAdr?
                i = i + 1

                args = { address: attrAdr }
                attrType = PATH(result, soft.hasType)
                if attrType?
                    args.type = attrType
                attrComment = PATH(result, COMMENT )
                if attrComment?
                    args.comment = attrComment

                ret.ADD soft.hasVariable VARIABLE(args) attrName
            else
                attrType = PATH(result, soft.hasType)
                if attrType?
                    [d, j] = getInterface(attrType, attrName, false)
                    i = i + j
                    if j > 0
                        ret.ADD soft.hasVariable d
#                        ret[attrName] = d
    return [ret, i]


root.MTCS_MAKE_INTERFACE = (type, name) ->
    return getInterface(type, name)[0]


########################################################################################################################
# Write the model to file
########################################################################################################################

softwarefactories.WRITE "models/util/softwarefactories.jsonld"
