require "ontoscript"

REQUIRE "metamodels/mathematics.coffee"
REQUIRE "metamodels/systems.coffee"

METAMODEL "http://www.mercator.iac.es/onto/metamodels/geometry" : "geom"

geom.READ "metamodels/geometry.jsonld"



geom.ADD geom.AngularVelocity "ANGULAR_VELOCITY" : (args = {}) -> [

    if args.rpm?
        geom.hasMagnitude RPM(args.rpm) "rpm"
    else if args.deg_per_sec?
        geom.hasMagnitude DEG_PER_SEC(args.deg_per_sec) "deg_per_sec"
    else if args.rad_per_sec
        geom.hasMagnitude RAD_PER_SEC(args.rad_per_sec) "rad_per_sec"

    if args.dir?
        geom.hasDirection args.dir
    else
        geom.hasDirection geom.Direction "direction"
]
root.ANGULAR_VELOCITY = geom.ANGULAR_VELOCITY



geom.ADD geom.Coordinate "MkCoordinate" : (value, axis) -> [
    qudt.numericValue       double(value)
    qudt.unit               PATH(axis, qudt.unit)
    geom.isMagnitudeAlong   axis
]


geom.ADD geom.Position "MkPosition" : (x, y, z, cs) -> [
    geom.hasXCoordinate geom.MkCoordinate(x, cs.xAxis) "x"
    geom.hasYCoordinate geom.MkCoordinate(y, cs.yAxis) "y"
    geom.hasZCoordinate geom.MkCoordinate(z, cs.zAxis) "z"
]


geom.ADD geom.Point "MkPoint" : (x, y, z, cs) -> [
    geom.hasPosition geom.MkPosition(x, y, z, cs) "position"
]


geom.ADD geom.PointVector "MkPointVector" : (x, y, z, cs) -> [
    geom.hasFromPoint PATH(cs, geom.hasOrigin)
    geom.hasToPoint   geom.MkPoint(x,y,z, cs) "toPoint"
]


geom.ADD geom.CoordinateSystem "COORDINATE_SYSTEM" : (units=unit.Unitless, axes=true, directions=false) -> [
    """
    A carthesian coordinate system.
    """

    if axes then [
        geom.hasXAxis  geom.Axis  "xAxis" : [ qudt.unit units ]
        geom.hasYAxis  geom.Axis  "yAxis" : [ qudt.unit units ]
        geom.hasZAxis  geom.Axis  "zAxis" : [ qudt.unit units ]

        if directions then [ $.xAxis.ADD geom.hasDirection geom.Direction "direction"
                             $.yAxis.ADD geom.hasDirection geom.Direction "direction"
                             $.zAxis.ADD geom.hasDirection geom.Direction "direction" ]
        else []

    ]
    else []
]
root.COORDINATE_SYSTEM = geom.COORDINATE_SYSTEM


geom.ADD geom.Rotation "ROTATION" : (args) -> [

    CHECK_ARGS("ROTATION", args, ["operand", "axis", "angle", "velocity", "acceleration"])

    if args.operand?      then expr.hasOperand             ?args.operand
    if args.axis?         then geom.hasRotationAxis        ?args.axis
    if args.angle?        then geom.hasRotationAngle       ?args.angle
    if args.velocity?     then geom.hasAngularVelocity     ?args.velocity
    if args.acceleration? then geom.hasAngularAcceleration ?args.acceleration
]
root.ROTATION = geom.ROTATION


#geom.ADD geom.CoordinateSystem "MkFullCoordinateSystem" : (units=unit.Unitless) -> [
#    INHERIT geom.MkCoordinateSystem(units, true, true)
#    geom.alignsTo geom.CoordinateSystem "directionCoordinateSystem"
#    $.x.direction.ADD [ geom.hasFromPoint $.origin
#                        geom.hasToPoint   geom.MkPoint(1,0,0,$) "unitPoint" ]
#    $.y.direction.ADD [ geom.hasFromPoint $.origin
#                        geom.hasToPoint   geom.MkPoint(0,1,0,$) "unitPoint" ]
#    $.z.direction.ADD [ geom.hasFromPoint $.origin
#                        geom.hasToPoint   geom.MkPoint(0,0,1,$) "unitPoint" ]
#]


#geom.ADD geom.CoordinateSystem "MkCoordinateSystem" : (units=unit.Unitless, axes=true, directions=true) -> [
#    """
#    A carthesian coordinate system.
#    """
#    if axes then [
#        geom.hasXAxis  geom.XAxis  "x" : [ qudt.unit units ]
#        geom.hasYAxis  geom.YAxis  "y" : [ qudt.unit units ]
#        geom.hasZAxis  geom.ZAxis  "z" : [ qudt.unit units ]
#
#        geom.hasOrigin geom.MkPoint(0,0,0, $) "origin"
#
#        if directions then [
#            sys.hasPart geom.CoordinateSystem "directionCoordinateSystem" : [
#                                geom.hasXAxis  geom.XAxis  "x" : [ qudt.unit unit.Unitless ]
#                                geom.hasYAxis  geom.YAxis  "y" : [ qudt.unit unit.Unitless ]
#                                geom.hasZAxis  geom.ZAxis  "z" : [ qudt.unit unit.Unitless ]
#                                geom.hasOrigin $.origin ]
#            $.origin.ADD geom.hasXCoordinate geom.MkCoordinate(0, $.directionCoordinateSystem.x) "x"
#            $.origin.ADD geom.hasYCoordinate geom.MkCoordinate(0, $.directionCoordinateSystem.y) "y"
#            $.origin.ADD geom.hasZCoordinate geom.MkCoordinate(0, $.directionCoordinateSystem.z) "z"
#
#            $.directionCoordinateSystem.x.ADD geom.hasDirection geom.MkPointVector(1,0,0, $.directionCoordinateSystem) "direction"
#            $.directionCoordinateSystem.y.ADD geom.hasDirection geom.MkPointVector(0,1,0, $.directionCoordinateSystem) "direction"
#            $.directionCoordinateSystem.z.ADD geom.hasDirection geom.MkPointVector(0,0,1, $.directionCoordinateSystem) "direction"
#        ]
#        else []
#
#    ]
#    else []
#]

