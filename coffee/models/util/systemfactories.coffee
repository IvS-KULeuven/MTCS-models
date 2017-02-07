########################################################################################################################
#                                                                                                                      #
# Model that holds factories to create system artifacts (e.g. projects).                                               #
#                                                                                                                      #
# TODO: clean up and add comments                                                                                      #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"


# metamodels
REQUIRE "metamodels/systems.coffee"
REQUIRE "metamodels/development.coffee"
REQUIRE "metamodels/containers.coffee"
REQUIRE "metamodels/finitestatemachines.coffee"
REQUIRE "metamodels/mathematics.coffee"



MODEL "http://www.mercator.iac.es/onto/models/util/systemfactories" : "systemfactories"

systemfactories.IMPORT cont
systemfactories.IMPORT dev
systemfactories.IMPORT sys
systemfactories.IMPORT fsm
systemfactories.IMPORT math


########################################################################################################################
# MTCS_PROJECT
########################################################################################################################

systemfactories.ADD dev.Project "MkProject" : (args={}) -> [
    CHECK_ARGS("MkProject", args, ["comment", "label"])
    if args.comment?
        rdfs.comment args.comment
    if args.label?
        __UPDATE__( rdfs.label, args.label )
]

root.MTCS_PROJECT = (name, args) -> systemfactories.MkProject(args) name


########################################################################################################################
# Some functions to handle requirements, states, properties, constraints, tests, ...
########################################################################################################################

handleRequirements = (reqs) -> [
    if reqs?
        [
            if not self.requirements?
                CONTAINER() "requirements"

            INIT()
            for name, detailsFunction of reqs
                if self.$.requirements[name]?
                    [
                        self.$.requirements[name].ADD APPLY REQUIREMENT(detailsFunction())
                        dev.hasRequirement self.$.requirements[name]
                    ]
                else
                    [
                        self.$.requirements.ADD CONTAINS REQUIREMENT(detailsFunction()) name
                        dev.hasRequirement self[name]
                    ]
            EXIT()
        ]
]

handleStates = (states) -> [
    if states?
        if not self.states?
            CONTAINER() "states"
    if states?
        [
            INIT()
            for name, detailsFunction of states
                if self.$.states[name]?
                    [
                        self.$.states[name].ADD APPLY STATE(detailsFunction())
                        fsm.hasState self.$.states[name]
                    ]
                else
                    [
                        self.$.states.ADD CONTAINS STATE(detailsFunction()) name
                        fsm.hasState self[name]
                    ]
            EXIT()
        ]
]

handleTransitions = (transitions) -> [
    if transitions?
        if not self.transitions?
            CONTAINER() "transitions"

    if transitions?
        [
            INIT()
            for name, detailsFunction of transitions
                if self.$.transitions[name]?
                    [
                        self.$.transitions[name].ADD APPLY TRANSITION(detailsFunction())
                        fsm.hasTransition self.$.transitions[name]
                    ]
                else
                    [
                        self.$.transitions.ADD CONTAINS TRANSITION(detailsFunction()) name
                        fsm.hasTransition self[name]
                    ]
            EXIT()
        ]
]

handleProperties = (properties) -> [
    if properties?
        [
            if not self.properties?
                CONTAINER() "properties"
            INIT()
            for name, detailsFunction of properties
                details = detailsFunction()
                if details instanceof CONSTRUCTION
                    self.$.properties.ADD CONTAINS details.macro(name)
                    sys.hasProperty self.$.properties[name]
                else
                    self.$.properties.ADD CONTAINS PROPERTY(details) name
                    sys.hasProperty self.$.properties[name]
            EXIT()
        ]
]

handleConstraints = (constraints) -> [
    if constraints?
        [
            if not self.constraints?
                CONTAINER() "constraints"
            INIT()
            for name, detailsFunction of constraints
                self.$.constraints.ADD CONTAINS CONSTRAINT(detailsFunction()) name
                sys.hasProperty self.$.constraints[name]
            EXIT()
        ]
]

handleTests = (tests) -> [
    if tests?
        [
            if not self.tests?
                CONTAINER() "tests"
            INIT()
            for name, detailsFunction of tests
                self.$.tests.ADD CONTAINS TEST(detailsFunction()) name
                sys.hasProperty self.$.tests[name]
            EXIT()
        ]
]

handleParts = (parts) -> [
    if parts?
        [
            if not self.parts?
                CONTAINER() "parts"
            INIT()
            for name, detailsFunction of parts
                details = detailsFunction()
                if details instanceof CONSTRUCTION
                    self.$.parts.ADD CONTAINS details.macro(name)
                    sys.hasPart self.$.parts[name]
                else
                    self.$.parts.ADD CONTAINS MTCS_CONCEPT(name, details)
                    sys.hasPart self.$.parts[name]
            EXIT()
        ]

]


########################################################################################################################
# MTCS_CONCEPT
########################################################################################################################

systemfactories.ADD dev.Concept "MkConcept" : (name, args) -> [
    CHECK_ARGS("MTCS_CONCEPT", args, ["comment", "label", "partOf", "states", "requirements", "properties", "constraints", "tests", "realizedBy"])

    if args.comment?
        COMMENT args.comment

    if args.label?
        __UPDATE__( rdfs.label, args.label )

    if args.realizedBy?
        sys.isRealizedBy args.realizedBy

    if args.partOf?
        sys.isPartOf args.partOf

    handleRequirements(args.requirements)
    handleProperties(args.properties)
    handleStates(args.states)
    handleTransitions(args.transitions)
    handleConstraints(args.constraints)
    handleTests(args.tests)
]

root.MTCS_CONCEPT = (name, args={}) ->
    return systemfactories.MkConcept(name, args) name


########################################################################################################################
# MTCS_DESIGN
########################################################################################################################


systemfactories.ADD dev.Design "MkDesign" : (name, args) -> [
    CHECK_ARGS("MTCS_DESIGN", args, ["comment", "realizes", "states", "requirements", "properties", "transitions", "constraints", "tests", "parts"])

    if args.comment?
        COMMENT args.comment

    APPLY dev.DESIGN(args)

    handleRequirements(args.requirements)
    handleParts(args.parts)
    handleProperties(args.properties)
    handleStates(args.states)
    handleTransitions(args.transitions)
    handleConstraints(args.constraints)
    handleTests(args.tests)
]

root.MTCS_DESIGN = (name, args={}) ->
    return systemfactories.MkDesign(name, args) name


########################################################################################################################
# Write the model to file
########################################################################################################################

systemfactories.WRITE "models/util/systemfactories.jsonld"