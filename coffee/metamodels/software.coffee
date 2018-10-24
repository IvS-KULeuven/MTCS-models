require "ontoscript"


REQUIRE "metamodels/mathematics.coffee"
REQUIRE "metamodels/containers.coffee"
REQUIRE "metamodels/documents.coffee"



METAMODEL "http://www.mercator.iac.es/onto/metamodels/software" : "soft"

soft.READ "metamodels/software.jsonld"



# TRYOUT========
#root.bool_t = soft.bool_t
#root.uint32_t = soft.uint32_t





# ======================================================================================================================
root.__INSTANTIATE__ = (subject, isType=true) ->
    ret = []

    if isType then ret.push( soft.hasType subject )

    #ret.push(rdf.type sys.Complete) # enable constraint verification

    for [property,range] in [ [soft.hasArgument           , soft.Argument           ],
                              [soft.hasAttribute          , soft.Attribute          ],
                              [soft.hasCallable           , soft.Callable           ],
                              [iec61131.hasLocalVariable  , iec61131.LocalVariable  ],
                              [iec61131.hasInputVariable  , iec61131.InputVariable  ],
                              [iec61131.hasOutputVariable , iec61131.OutputVariable ],
                              [iec61131.hasInOutVariable  , iec61131.InOutVariable  ],
                              [iec61131.hasMethodInstance , iec61131.MethodInstance ],
                              [iec61131.hasMethod         , iec61131.MethodInstance ] ] # Methods of a FB are soft:Types that must be instantiated!
                                                                                        # better alternative: soft.declares , soft.Variable(or Member) ???
        for result in PATHS(subject, property)
            name = result.qName().partName()
            args = {}

            #console.log result.qName().toCompactString()
#
#            if PATH(result, soft.hasType)?
#                result = PATH(result, soft.hasType)
#                resultIsType = true
#            else
#                resultIsType = false

            args[name] = [ #INIT $$$$$$ # a stack never used
                           __INSTANTIATE__(result, false)
                           sys.realizes result ]

            #               IS_VARIABLE_OF result ]

            ret.push( property( range(args) ) )
    return ret
# ======================================================================================================================



root.__HANDLE_SUBTYPE__ = (superType) ->
    ret = []
    for property in [ soft.hasVariable, soft.hasCallable,
                      iec61131.hasLocalVariable, iec61131.hasInputVariable, iec61131.hasOutputVariable,
                      iec61131.hasInOutVariable, iec61131.hasMethodInstance, iec61131.hasMethod ]
        for result in PATHS(superType, property)
            name = result.qName().partName()
            ret.push( property result )
            ret.push( SHORTCUT(name, result) )
    return ret


soft.ADD soft.Type "MkSubType" : (superType) -> __HANDLE_SUBTYPE__(superType)
root.SUBTYPE = soft.MkSubType





# ======================================================================================================================


root.__HANDLE_SOFTWARE_VARIABLES__ = (name, args={}) ->

    expand = (not args.expand?) or args.expand == true

    CHECK_ARGS(name, args, ["type", "realizes", "expand", "initial", "comment",
                            "pointsToType", "attributes", "qualifiers", "arguments",
                            "address", "copyFrom"])
    CHECK_ARGS_INVALID_COMBINATION(name, args, ["type", "pointsToType"])

    ret = []
    if args.type?
        if expand
            ret.push( __INSTANTIATE__(args.type, true) )
        else
            ret.push( soft.hasType args.type )

    else if args.pointsToType?
        ret.push( TYPE soft.Pointer )
        ret.push( soft.pointsToType args.pointsToType )
        if expand
            ret.push( __INSTANTIATE__(args.pointsToType, false) )

    if args.copyFrom?
        # if the initial value is not provided, copy the numericValue from copyFrom
        if not args.initial?
            numericValue = PATH(args.copyFrom, qudt.numericValue)
            if numericValue?
                ret.push( soft.hasInitialValue numericValue )
        if not args.comment?
            comment = PATH(args.copyFrom, COMMENT)
            if comment?
                ret.push( COMMENT comment )

    if args.realizes?
        ret.push( sys.realizes args.realizes )

    if args.initial isnt undefined
        ret.push( soft.hasInitialValue args.initial )

    if args.comment?
        ret.push( COMMENT args.comment )

    if args.address?
        ret.push( soft.hasAddress args.address )

    if args.attributes?
        for name, details of args.attributes
            ret.push( HAS ATTRIBUTE(details) name )

    if args.arguments?
        for name, details of args.arguments
            ret.push( HAS ARGUMENT(details) name )

    if args.qualifiers?
        for qualifier in args.qualifiers
            ret.push HAS qualifier

    return ret



soft.ADD soft.Argument "MkArgument" : (args) -> __HANDLE_SOFTWARE_VARIABLES__("ARGUMENT", args)
root.ARGUMENT = soft.MkArgument

soft.ADD soft.Attribute "MkAttribute" : (args) -> __HANDLE_SOFTWARE_VARIABLES__("ATTRIBUTE", args)
root.ATTRIBUTE = soft.MkAttribute

#soft.ADD soft.Instance  "MkInstance"  : (args) -> __HANDLE_SOFTWARE_VARIABLES__("INSTANCE", args)
#root.INSTANCE = soft.MkInstance

soft.ADD soft.Variable  "MkVariable"  : (args) -> __HANDLE_SOFTWARE_VARIABLES__("VARIABLE", args)
root.VARIABLE = soft.MkVariable

soft.ADD soft.GlobalVariable  "MkGlobalVariable"  : (args) -> __HANDLE_SOFTWARE_VARIABLES__("GLOBAL_VARIABLE", args)
root.GLOBAL_VARIABLE = soft.MkGlobalVariable


#root.VARIABLE = () -> soft.Variable
root.DATA = () -> soft.Data
root.NAMESPACE = () -> soft.Namespace
root.LIBRARY = () -> soft.Library

root.MODELS = soft.models
root.DECLARES = soft.declares
root.EXECUTES = soft.executes
root.EXTENDS = soft.extends
root.RETURNS = soft.returns
root.HAS_ATTRIBUTE = soft.hasAttribute

root.DECLARATION = soft.Declaration

root.IS_TYPE_OF = soft.isTypeOf
root.IS_VARIABLE_OF = soft.isVariableOf



soft.ADD soft.Interface "INTERFACE" : (args={}) -> [
    for name, detailsFunction of args
        soft.hasVariable VARIABLE(detailsFunction()) name

]
root.SOFT_INTERFACE = soft.INTERFACE

root.CALLABLE = () -> soft.Callable


soft.ADD soft.Pointer "MkPointer" : (args={}) -> [
    CHECK_ARGS("POINTER", args, ["to", "type"])

    if args.to?
        soft.pointsTo args.to

    if args.type?
        soft.pointsToType args.type
]





root.POINTER = soft.MkPointer

soft.ADD soft.Enumeration "ENUMERATION" : (args={}) -> [
    CHECK_ARGS("ENUMERATION", args, ["comment", "containedBy", "type", "items"])
    if args.comment?
        COMMENT args.comment
    if args.containedBy?
        cont.isContainedBy args.containedBy
    if args.type?
        soft.hasType args.type
    if args.items?
        for item, i in args.items
            enumItem = ENUMERATION_ITEM() item
            containment = CONTAINMENT(number: i) "containment"
            enumItem.ADD cont.isItemOf containment
            [
                cont.hasContainment containment
                CONTAINS enumItem
            ]
]
root.ENUMERATION = soft.ENUMERATION

soft.ADD soft.EnumerationItem "MkEnumerationItem" : (args={}) -> [
    CHECK_ARGS("ENUMERATION_ITEM", args, ["comment"])
    if args.comment?
        COMMENT args.comment
]
root.ENUMERATION_ITEM = soft.MkEnumerationItem




handleImplementationExpressions = (oneOrMoreExpressionLists) ->
    ret = []
    i = 0
    for expressionList in oneOrMoreExpressionLists
        for expression in expressionList
            containment = CONTAINMENT(number: i) "containment"
            expression.ADD cont.isItemOf containment
            ret.push CONTAINS expression
            ret.push cont.hasContainment containment
            i = i+1
    return ret

soft.ADD soft.Implementation "MkImplementation" : (oneOrMoreExpressionLists...) -> handleImplementationExpressions(oneOrMoreExpressionLists)


root.IMPLEMENTATION = soft.MkImplementation

getAssignments = (calls, assigns = {}) ->
    ret = []
    allVars =
        "In"    : for path in PATHS(calls, iec61131.hasInputVariable)
                    path
        "InOut" : for path in PATHS(calls, iec61131.hasInOutVariable)
                    path
        "Out"   : for path in PATHS(calls, iec61131.hasOutputVariable)
                    path
        "Attributes": for path in PATHS(calls, soft.hasAttribute)
                        path
        "Arguments": for path in PATHS(calls, soft.hasArgument)
                        path

    i = 0
    for name, assignTo of assigns

        isAssigned = false
        for kind, variables of allVars

            for variable in variables

                if name == variable.qName().partName()

                    containment = CONTAINMENT(number: i) "containment#{i}"
                    ret.push cont.hasContainment containment

                    # input variables and attributes have to be assigned left-to-right, but output variables right-to-left!
                    assignmentArgs = {}
                    if kind is "In"
                        assignmentArgs["assignment_#{i}_in"] = [ cont.isItemOf containment ]
                        ret.push HAS ASSIGNMENT(variable, assignTo) assignmentArgs
                    else if kind is "InOut"
                        assignmentArgs["assignment_#{i}_in_out"] = [ cont.isItemOf containment ]
                        ret.push HAS ASSIGNMENT(variable, assignTo) assignmentArgs
                    else if kind is "Attributes"
                        assignmentArgs["assignment_#{i}_attr"] = [ cont.isItemOf containment ]
                        ret.push HAS ASSIGNMENT(variable, assignTo) assignmentArgs
                    else if kind is "Arguments"
                        assignmentArgs["assignment_#{i}_arg"] = [ cont.isItemOf containment ]
                        ret.push HAS ASSIGNMENT(variable, assignTo) assignmentArgs
                    else
                        assignmentArgs["assignment_#{i}_out"] = [ cont.isItemOf containment ]
                        ret.push HAS ASSIGNMENT(assignTo, variable) assignmentArgs

                    isAssigned = true
                    i = i+1


        if not isAssigned
            ABORT("Error in MkCall: '#{name}' is not an In/InOut/Out variable or attribute or argument of #{calls.qName().toCompactString()}")

    return ret


soft.ADD soft.Call "MkCall" : (args) -> [

    if not args?
        ABORT("MkCall should be called with arguments!")

    CHECK_ARGS("CALL", args, ["calls","assigns"])

    if not (args.calls?)
        ABORT("MkCall should have these arguments: 'calls' (and optional 'assigns')")

    soft.calls args.calls

    if args.assigns?
        getAssignments(args.calls, args.assigns)
]
root.CALL = soft.MkCall



soft.ADD soft.IfThen "MkIfThen" : (args = {}) -> [
    CHECK_ARGS("IF_THEN", args, ["if", "then", "else"])

    if args.if?
        soft.if args.if
    else
        ABORT("SOFTWARE_IF needs arguments with keyword 'if'")

    if args.then?
        if IS_ARRAY(args.then)
            soft.then IMPLEMENTATION( args.then ) "then"
        else
            soft.then args.then
    else
        ABORT("SOFTWARE_IF needs arguments with keyword 'then'")

    # 'else' is optional:
    if args.else?
        if IS_ARRAY(args.else)
            soft.else IMPLEMENTATION( args.else ) "else"
        else
            soft.else args.else
]
root.IF_THEN = soft.MkIfThen


root.IMPLICATION = expr.MkImplication


soft.ADD soft.ADR "MkADR" : (variable) -> [
    expr.hasOperator soft.adr
    if variable?
        expr.hasOperand variable
]
root.ADR = (variable) -> soft.MkADR(variable) UNIQUE("ADR_"), label:false
