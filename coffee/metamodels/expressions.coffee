require "ontoscript"

REQUIRE "metamodels/external/topbraid.org/spin/owlrl-all.coffee"
REQUIRE "metamodels/external/qudt.org/vocab/dimensionalunit.coffee"
REQUIRE "metamodels/systems.coffee"

METAMODEL "http://www.mercator.iac.es/onto/metamodels/expressions" : "expr"

expr.READ "metamodels/expressions.jsonld"




root.IMPLIES = expr.implies
root.EXCLUDES = expr.excludes



expr.ADD expr.Equality "MkEquality" : (arg0, arg1) -> [
    expr.hasOperator expr.isEqualTo
    expr.hasOperand arg0
    expr.hasOperand arg1
]

expr.ADD expr.Assignment "MkAssignment" : (left, right) -> [
    expr.hasOperator expr.isAssignedTo
    expr.hasLeftOperand  left
    expr.hasRightOperand right
]
root.ASSIGNMENT = expr.MkAssignment


makeRecursiveExpression = (expression, operator, prefix, first, second, more=[]) ->
    res = expression UNIQUE(prefix), label:false
    res.ADD expr.hasOperator operator
    res.ADD expr.hasLeftOperand first
    if more.length is 0
        res.ADD expr.hasRightOperand second
    else if more.length is 1
        if more[0] instanceof Array
            if more[0].length is 0
                res.ADD expr.hasRightOperand second
            else
                ABORT "Unexpected error in makeRecursiveExpression: received #{more[0]} ===== #{more[0].length}"
        else
            res.ADD expr.hasRightOperand makeRecursiveExpression(expression, operator, prefix, second , more[0])
    else
        res.ADD expr.hasRightOperand makeRecursiveExpression(expression, operator, prefix, second , more[0], more[1..])
    return res

root.ASSIGN = (first, second, more...) -> makeRecursiveExpression(expr.Assignment           , expr.isAssignedTo             , "ASSIGN_"  , first, second, more)
root.EQ     = (first, second, more...) -> makeRecursiveExpression(expr.Equality             , expr.isEqualTo                , "EQ_"      , first, second, more)
root.GT     = (first, second, more...) -> makeRecursiveExpression(expr.GreaterThan          , expr.isGreaterThan            , "GT_", first, second, more)
root.LT     = (first, second, more...) -> makeRecursiveExpression(expr.LessThan             , expr.isLessThan               , "LT_", first, second, more)
root.GE     = (first, second, more...) -> makeRecursiveExpression(expr.GreaterThanOrEqualTo , expr.isGreaterThanOrEqualTo   , "GE_", first, second, more)
root.LE     = (first, second, more...) -> makeRecursiveExpression(expr.LessThanOrEqualTo    , expr.isLessThanOrEqualTo      , "LE_", first, second, more)
root.AND    = (first, second, more...) -> makeRecursiveExpression(expr.And                  , expr.and                      , "AND_", first, second, more)
root.OR     = (first, second, more...) -> makeRecursiveExpression(expr.Or                   , expr.or                       , "OR_", first, second, more)
root.NOT    = (arg) ->
                    res = expr.Not UNIQUE("NOT_"), label:false
                    res.ADD expr.hasOperand arg
                    res.ADD expr.hasOperator expr.not
                    return res


expr.ADD expr.Primitive  "MkPrimitive"  : (value) -> [ if value? then expr.hasValue value ]
expr.ADD expr.Bool       "MkBool"       : (value) -> [ if value? then expr.hasValue bool(value) ]
expr.ADD expr.ByteString "MkByteString" : (value) -> [ if value? then expr.hasValue bytestring(value) ]
expr.ADD expr.Double     "MkDouble"     : (value) -> [ if value? then expr.hasNumericValue double(value) ]
expr.ADD expr.Float      "MkFloat"      : (value) -> [ if value? then expr.hasNumericValue float(value) ]
expr.ADD expr.Int16      "MkInt16"      : (value) -> [ if value? then expr.hasNumericValue int16(value) ]
expr.ADD expr.Int32      "MkInt32"      : (value) -> [ if value? then expr.hasNumericValue int32(value) ]
expr.ADD expr.Int64      "MkInt64"      : (value) -> [ if value? then expr.hasNumericValue int64(value) ]
expr.ADD expr.Int8       "MkInt8"       : (value) -> [ if value? then expr.hasNumericValue int8(value) ]
expr.ADD expr.UInt16     "MkUInt16"     : (value) -> [ if value? then expr.hasNumericValue uint16(value) ]
expr.ADD expr.UInt32     "MkUInt32"     : (value) -> [ if value? then expr.hasNumericValue uint32(value) ]
expr.ADD expr.UInt32     "MkUInt64"     : (value) -> [ if value? then expr.hasNumericValue uint64(value) ]
expr.ADD expr.UInt8      "MkUInt8"      : (value) -> [ if value? then expr.hasNumericValue uint8(value) ]
expr.ADD expr.String     "MkString"     : (value) -> [ if value? then expr.hasValue string(value) ]



root.PRIMITIVE  = expr.MkPrimitive
root.BOOL       = expr.MkBool
root.BYTESTRING = expr.MkByteString
root.DOUBLE     = expr.MkDouble
root.FLOAT      = expr.MkFloat
root.INT16      = expr.MkInt16
root.INT32      = expr.MkInt32
root.INT64      = expr.MkInt64
root.INT8       = expr.MkInt8
root.UINT16     = expr.MkUInt16
root.UINT32     = expr.MkUInt32
root.UINT64     = expr.MkUInt64
root.UINT8      = expr.MkUInt8
root.STRING     = expr.MkString

root.t_bool       = expr.t_bool
root.t_bytestring = expr.t_bytestring
root.t_double     = expr.t_double
root.t_float      = expr.t_float
root.t_int16      = expr.t_int16
root.t_int32      = expr.t_int32
root.t_int64      = expr.t_int64
root.t_int8       = expr.t_int8
root.t_uint16     = expr.t_uint16
root.t_uint32     = expr.t_uint32
root.t_uint64     = expr.t_uint64
root.t_uint8      = expr.t_uint8
root.t_string     = expr.t_string




root.AT = (signal, args) ->
    if IS_NUMBER(args)
        n = args
    else if args.at?
        n = args.at
    else
        ABORT("wrong argument for AT: usage example: AT(signal, 1.0) or AT(signal, at: 1.0)")
    return EVENTUALLY(signal, from: n, to: n)

root.RISES = (signal, args) ->
    if args.sampling?
        return AND( ALWAYS(NOT(signal), from: 0, to: args.sampling-0.001), ALWAYS(signal, from: args.sampling, to: 2*args.sampling) )
    else
        ABORT("R_EDGE needs a 'sampling' argument!")



addSeconds = (arg, name) ->
    if IS_NUMBER(arg)
        return SEC(arg) name
    else
        return arg

expr.ADD expr.Interval "INTERVAL" : (args) -> [
    CHECK_ARGS("INTERVAL", args, ["from", "to", "within"])

    if args.from?
        expr.hasLeftBound addSeconds(args.from, "leftBound")

    if args.to?
        expr.hasRightBound addSeconds(args.to, "rightBound")

    if args.within?
        if (args.from? or args.to?)
            ABORT("INTERVAL cannot have both ('from' and/or 'to') and 'within' args")
        else
            [
                expr.hasLeftBound  addSeconds(0, "leftBound")
                expr.hasRightBound addSeconds(args.within, "rightBound")
            ]

]
root.INTERVAL = expr.INTERVAL


root.UNTIL = (arg0, arg1, temporalArgs) ->
    res = expr.Until UNIQUE("UNTIL_"), label:false
    res.ADD expr.hasLeftOperand arg0
    res.ADD expr.hasRightOperand arg1
    res.ADD expr.hasOperator expr.until
    res.ADD expr.hasInterval INTERVAL(temporalArgs) "interval"
    return res

root.TRUE = expr.true
root.FALSE = expr.false

root.EVENTUALLY = (arg, temporalArgs) ->
    res = expr.Eventually UNIQUE("EVENTUALLY_"), label:false
    res.ADD expr.hasOperand arg
    res.ADD expr.hasOperator expr.eventually
    res.ADD expr.hasInterval INTERVAL(temporalArgs) "interval"
    return res

root.ALWAYS = (arg, temporalArgs) ->
    res = expr.Always UNIQUE("ALWAYS_"), label:false
    res.ADD expr.hasOperand arg
    res.ADD expr.hasOperator expr.always
    res.ADD expr.hasInterval INTERVAL(temporalArgs) "interval"
    return res

# -> UNTIL(TRUE, arg, temporalArgs)
# root.ALWAYS = (arg, temporalArgs) -> NOT( EVENTUALLY(NOT(arg), temporalArgs) )

root.PASS = expr.pass
root.FAIL = expr.fail

expr.ADD expr.Implication "MkImplication" : (args) ->
    CHECK_ARGS("IMPLICATION", args, ["if", "then"])
    if not ( (args.if?) and (args.then?) ) then ABORT("IMPLICATION needs arguments with keywords if: and then:")
    expr.hasLeftOperand args.if
    expr.hasRightOperand args.then
    expr.hasOperator expr.implies

root.IMPLICATION = expr.MkImplication


root.COIMPLICATION = (args) ->
    CHECK_ARGS("COIMPLICATION", args, ["iff", "then"])
    if not ( (args.iff?) and (args.then?) ) then ABORT("COIMPLICATION needs arguments with keywords iff: and then:")
    res = expr.Coimplication UNIQUE("COIMPLICATION_"), label:false
    res.ADD expr.hasLeftOperand args.iff
    res.ADD expr.hasRightOperand args.then
    expr.hasOperator expr.coimplies
    return res


root.SHL = (arg) ->
                    res = expr.ShiftLeft UNIQUE("SHL_"), label:false
                    res.ADD expr.hasOperand arg
                    res.ADD expr.hasOperator expr.shiftLeft
                    return res
root.SHR = (arg) ->
                    res = expr.ShiftRight UNIQUE("SHR_"), label:false
                    res.ADD expr.hasOperand arg
                    res.ADD expr.hasOperator expr.shiftRight
                    return res


root.BUILD_EXPRESSION = ( args ) ->
    if IS_INDIVIDUAL(args)
        return args
    else if (args.if? and args.then?)
        return IMPLICATION(args) "implication"
    else
        ABORT "Unknown expression: #{args}"
