require "ontoscript"

REQUIRE "metamodels/external/qudt.org/schema/qudt.coffee"
REQUIRE "metamodels/external/qudt.org/schema/quantity.coffee"
REQUIRE "metamodels/external/qudt.org/vocab/unit.coffee"

METAMODEL "http://qudt.org/vocab/quantity"  : "qudt_quantity"

qudt_quantity.READ "metamodels/external/qudt.org/vocab/quantity.jsonld"



qudt.ADD qudt.QuantityValue "MkDoubleValue" : (val, units, comment) -> [
    if val?     then qudt.numericValue double(val) else []
    if units?   then qudt.unit units else []
    if comment? then COMMENT comment
]


qudt.ADD qudt.QuantityValue "MkIntValue" : (val, units, comment) -> [
    if val?     then qudt.numericValue int(val) else []
    if units?   then qudt.unit units else []
    if comment? then COMMENT comment
]


quantity.ADD qudt.Quantity "MkNumber" : (num) -> [
    qudt.quantityValue qudt.MkIntValue(num, unit.number) "value"
    qudt.quantityKind  quantity.Dimensionless
]


quantity.ADD qudt.Quantity "MkRatio" : (ratio) -> [
    qudt.quantityValue qudt.MkDoubleValue(ratio, unit.unitless) "value"
    qudt.quantityKind  quantity.DimensionlessRatio
]

root.UNITLESS_INT = (val, comment) -> qudt.MkIntValue(val, unit.Unitless    , comment)
root.BIT          = (val, comment) -> qudt.MkIntValue(val, unit.Bit         , comment)
root.REVOLUTION   = (val, comment) -> qudt.MkIntValue(val, unit.Revolution  , comment)

root.SEC          = (val, comment) -> qudt.MkDoubleValue(val, unit.SecondTime           , comment)
root.DEG          = (val, comment) -> qudt.MkDoubleValue(val, unit.DegreeAngle          , comment)
root.RAD          = (val, comment) -> qudt.MkDoubleValue(val, unit.Radian               , comment)
root.NM           = (val, comment) -> qudt.MkDoubleValue(val, unit.NewtonMeter          , comment)
root.NEWTON       = (val, comment) -> qudt.MkDoubleValue(val, unit.Newton               , comment)
root.UNITLESS     = (val, comment) -> qudt.MkDoubleValue(val, unit.Unitless             , comment)
root.WATT         = (val, comment) -> qudt.MkDoubleValue(val, unit.Watt                 , comment)
root.DEG_PER_SEC  = (val, comment) -> qudt.MkDoubleValue(val, unit.DegreePerSecond      , comment)
root.RAD_PER_SEC  = (val, comment) -> qudt.MkDoubleValue(val, unit.RadianPerSecond      , comment)
root.RPM          = (val, comment) -> qudt.MkDoubleValue(val, unit.RevolutionPerMinute  , comment)
root.BAR          = (val, comment) -> qudt.MkDoubleValue(val, unit.Bar                  , comment)
root.METER        = (val, comment) -> qudt.MkDoubleValue(val, unit.Meter                , comment)
root.MICROMETER   = (val, comment) -> qudt.MkDoubleValue(val, unit.Micrometer           , comment)
root.EURO         = (val, comment) -> qudt.MkDoubleValue(val, unit.Euro                 , comment)
