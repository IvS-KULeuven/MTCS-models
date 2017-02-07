require "ontoscript"


REQUIRE "metamodels/external/qudt.org/vocab/dimensionalunit.coffee"
REQUIRE "metamodels/external/qudt.org/spin/unitconversion.coffee"
REQUIRE "metamodels/expressions.coffee"


METAMODEL "http://www.mercator.iac.es/onto/metamodels/mathematics" : "math"

math.READ "metamodels/mathematics.jsonld"

root.PIVALUE =3.1415926535897932384626433

math.ADD math.Angle "MkAngle" : ({deg, rad} = {}) -> [
    if deg? and rad? then ABORT "Invalid arguments for ANGLE: degrees and radians cannot be mentioned together"

    if deg?
            qudt.quantityValue qudt.MkDoubleValue(deg, unit.Degrees) "deg"
    else if rad?
        qudt.quantityValue qudt.MkDoubleValue(rad, unit.Radian) "rad"
    else
        qudt.quantityValue qudt.MkDoubleValue(undefined, unit.Radian) "rad"
]
root.ANGLE = math.MkAngle


root.ABS = (arg) ->
                    res = math.Abs UNIQUE("ABS_"), label:false
                    res.ADD expr.hasOperand arg
                    res.ADD expr.hasOperator math.absOf
                    return res


root.SUM = (arg0, arg1) ->
                    res = math.Addition UNIQUE("SUM_"), label:false
                    res.ADD expr.hasLeftOperand arg0
                    res.ADD expr.hasRightOperand arg1
                    res.ADD expr.hasOperator math.plus
                    return res

root.SUB = (arg0, arg1) ->
                    res = math.Subtraction UNIQUE("SUB_"), label:false
                    res.ADD expr.hasLeftOperand arg0
                    res.ADD expr.hasRightOperand arg1
                    res.ADD expr.hasOperator math.minus
                    return res

root.MUL = (arg0, arg1) ->
                    if arg0 is undefined
                        ABORT("First arg of MUL(#{arg0},#{arg1}) is undefined")
                    res = math.Multiplication UNIQUE("MUL_"), label:false
                    res.ADD expr.hasLeftOperand arg0
                    res.ADD expr.hasRightOperand arg1
                    res.ADD expr.hasOperator math.times
                    return res

root.DIV = (arg0, arg1) ->
                    res = math.Division UNIQUE("DIV_"), label:false
                    res.ADD expr.hasLeftOperand arg0
                    res.ADD expr.hasRightOperand arg1
                    res.ADD expr.hasOperator math.dividedBy
                    return res

root.POW = (arg0, arg1) ->
                    res = math.Power UNIQUE("POW_"), label:false
                    res.ADD expr.hasLeftOperand arg0
                    res.ADD expr.hasRightOperand arg1
                    res.ADD expr.hasOperator math.exponent
                    return res

root.NEG = (arg) ->
                    res = math.UnaryMinus UNIQUE("NEG_"), label:false
                    res.ADD expr.hasOperand arg
                    res.ADD expr.hasOperator math.unaryMinus
                    return res
