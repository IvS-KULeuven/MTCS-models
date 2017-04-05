require "ontoscript"


REQUIRE "metamodels/software.coffee"


METAMODEL "http://www.mercator.iac.es/onto/metamodels/iec61131" : "iec61131"

iec61131.READ "metamodels/iec61131.jsonld"


iec61131.ADD iec61131.FunctionBlock "MkFunctionBlock" : (args = {}) -> [
    CHECK_ARGS("MkFunctionBlock", args, ["containedBy", "typeOf", "extends", "comment", "label", "in", "out", "inout"])

    if args.containedBy?
        cont.isContainedBy args.containedBy

    CHECK_KEY(args, "typeOf")

    if args.typeOf?
        if IS_ARRAY(args.typeOf)
            for t in args.typeOf
                IS_TYPE_OF t
        else
            IS_TYPE_OF args.typeOf

    if args.extends?
        [
            EXTENDS args.extends
            HAS_ATTRIBUTE POINTER(type: args.extends) "SUPER"
            SHORTCUT("SUPER^", args.extends)
            APPLY SUBTYPE(args.extends)
        ]

    for name, details of args.in
        HAS VAR_IN(details) name

    for name, details of args.out
        HAS VAR_OUT(details) name

    for name, details of args.inout
        HAS VAR_IN_OUT(details) name
]
root.PLC_FB = iec61131.MkFunctionBlock


iec61131.ADD soft.Qualifier "MkPlcOpenAttribute" : (args = {}) -> [
    CHECK_ARGS("MkPlcOpenAttribute", args, ["symbol", "value"])

    if args.symbol?
        iec61131.hasSymbol args.symbol

    if args.value?
        expr.hasValue args.value
]
root.PLC_OPEN_ATTRIBUTE = iec61131.MkPlcOpenAttribute



iec61131.ADD iec61131.Struct "MkStruct" : (args = {}) -> [
    CHECK_ARGS("MkStruct", args, ["containedBy", "typeOf", "items", "comment", "label"])

    if args.comment?
        COMMENT args.comment

    if args.label?
        LABEL args.label

    if args.containedBy?
        cont.isContainedBy args.containedBy

    if args.typeOf?
        if IS_ARRAY(args.typeOf)
            for t in args.typeOf
                IS_TYPE_OF t
        else
            IS_TYPE_OF args.typeOf

    for name, details of args.items
        #CHECK_ARGS("PLC_STRUCT.items.#{name}", details, ["type", "comment", "initial"])
        HAS ATTRIBUTE(details) name
]
root.PLC_STRUCT = iec61131.MkStruct




iec61131.ADD iec61131.Method "MkMethod" : (args = {}) -> [
    CHECK_ARGS("MkMethod", args, ["inputArgs", "inOutArgs", "localArgs", "returnType", "comment", "implementation"])

    if args.comment?
        COMMENT args.comment

    for name, details of args.inputArgs
        HAS VAR_IN(details) name

    for name, details of args.inOutArgs
        HAS VAR_IN_OUT(details) name

    for name, details of args.localArgs
        HAS VAR(details) name

    if args.returnType?
        soft.hasReturnType args.returnType

    if args.implementation?
        soft.hasImplementation IMPLEMENTATION(args.implementation) "implementation"
]
root.PLC_METHOD = iec61131.MkMethod





iec61131.ADD iec61131.LocalVariable  "MkLocalVariable"  : (args) -> __HANDLE_SOFTWARE_VARIABLES__("VAR", args)
iec61131.ADD iec61131.InputVariable  "MkInputVariable"  : (args) -> __HANDLE_SOFTWARE_VARIABLES__("VAR_IN", args)
iec61131.ADD iec61131.OutputVariable "MkOutputVariable" : (args) -> __HANDLE_SOFTWARE_VARIABLES__("VAR_OUT", args)
iec61131.ADD iec61131.InOutVariable  "MkInOutVariable"  : (args) -> __HANDLE_SOFTWARE_VARIABLES__("VAR_IN_OUT", args)


iec61131.ADD iec61131.Dereference "MkDereference" : (args = {}) -> [
    CHECK_ARGS("MkDereference", args, ["operand"])
    expr.hasOperator iec61131.dereference
    if args.operand?
        expr.hasOperand args.operand
]
root.PLC_DEREFERENCE = iec61131.MkDereference
root.PLC_DEREF = (pointerOrReference, more) -> iec61131.MkDereference(pointerOrReference,more) UNIQUE("DEREF_"), label:false

root.VAR         = iec61131.MkLocalVariable
root.VAR_IN      = iec61131.MkInputVariable
root.VAR_OUT     = iec61131.MkOutputVariable
root.VAR_IN_OUT  = iec61131.MkInOutVariable

root.HAS_VAR = iec61131.hasLocalVariable
root.HAS_VAR_IN = iec61131.hasInputVariable
root.HAS_VAR_OUT = iec61131.hasOutputVariable
root.HAS_VAR_IN_OUT = iec61131.hasInOutVariable