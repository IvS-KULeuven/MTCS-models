require "ontoscript"


REQUIRE "metamodels/expressions.coffee"
REQUIRE "metamodels/systems.coffee"
REQUIRE "metamodels/containers.coffee"


METAMODEL "http://www.mercator.iac.es/onto/metamodels/finitestatemachines" : "fsm"

fsm.READ "metamodels/finitestatemachines.jsonld"




fsm.ADD fsm.StateVariable "STATE_VARIABLE" : (args) -> [
    CHECK_ARGS("STATE", args, ["type", "assign"])

    if type?
        rdf.type type

    if assign?
        expr.isOperandOf expr.Assignment "assignment" : [ expr.hasOperand assign ]
]


root.STATE_VARIABLE = fsm.STATE_VARIABLE



fsm.ADD fsm.State "STATE" : (args) -> [
    CHECK_ARGS("STATE", args, ["comment", "isDerivedFrom", "sameAs", "realizes", "isAssignedTo"])


    if args.comment?
        COMMENT args.comment

    if args.sameAs?
        SAME_AS args.sameAs

    if args.realizes?
        sys.realizes args.realizes

    if args.isAssignedTo?
        expr.isAssignedTo args.isAssignedTo

    if args.isDerivedFrom?
        dev.isDerivedFrom args.isDerivedFrom

]
root.STATE = fsm.STATE


fsm.ADD fsm.Transition "TRANSITION" : (args) -> [
    CHECK_ARGS("TRANSITION", args, ["comment", "from", "to", "condition", "interval", "within"])

    if args.comment?
        COMMENT args.comment

    if args.from?
        fsm.transitsFrom args.from

    if args.to?
        fsm.transitsTo args.to

    if args.condition?
        fsm.hasCondition args.condition

    if args.interval?
        dev.hasInterval args.interval
    else if args.within?
        expr.hasInterval INTERVAL(within: args.within) "interval"
    else
        ABORT "Transitions must be specified with a time interval!"
]
root.TRANSITION = fsm.TRANSITION