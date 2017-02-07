require "ontoscript"

REQUIRE "metamodels/external/www.linkedmodel.org/schema/dtype.coffee"
REQUIRE "metamodels/external/www.linkedmodel.org/schema/vaem.coffee"
REQUIRE "metamodels/external/qudt.org/schema/qudt.coffee"

# quantities, units, dimensions, types

METAMODEL "http://qudt.org/schema/dimension" : "qudt_dimension"

qudt_dimension.READ "metamodels/external/qudt.org/schema/dimension.jsonld"



# REMOVED: now expr:Primitive instances instead of qudt:QuantityValues!
#
#root.QUDT_QV_COUNTER = 0
#
#makePrimitiveQuantityValue = (value, units, primitive) =>
#    n = qudt.QuantityValue "QV#{QUDT_QV_COUNTER}"
#    QUDT_QV_COUNTER += 1
#    n.ADD qudt.numericValue primitive.call(undefined, value)
#    if units? then n.ADD qudt.unit units else []
#    return n
#
#root.BOOL       = (value, units) -> makePrimitiveQuantityValue(value, units, bool)
#root.INT8       = (value, units) -> makePrimitiveQuantityValue(value, units, int8)
#root.UINT8      = (value, units) -> makePrimitiveQuantityValue(value, units, uint8)
#root.INT16      = (value, units) -> makePrimitiveQuantityValue(value, units, int16)
#root.UINT16     = (value, units) -> makePrimitiveQuantityValue(value, units, uint16)
#root.INT32      = (value, units) -> makePrimitiveQuantityValue(value, units, int32)
#root.UINT32     = (value, units) -> makePrimitiveQuantityValue(value, units, uint32)
#root.INT64      = (value, units) -> makePrimitiveQuantityValue(value, units, int64)
#root.UINT64     = (value, units) -> makePrimitiveQuantityValue(value, units, uint64)
#root.FLOAT      = (value, units) -> makePrimitiveQuantityValue(value, units, float)
#root.DOUBLE     = (value, units) -> makePrimitiveQuantityValue(value, units, double)
#root.STRING     = (value, units) -> makePrimitiveQuantityValue(value, units, string)
#root.BYTESTRING = (value, units) -> makePrimitiveQuantityValue(value, units, bytestring)
#root.INT        = (value, units) -> makePrimitiveQuantityValue(value, units, int)
#root.TIME       = (value, units) -> makePrimitiveQuantityValue(value, units, time)
