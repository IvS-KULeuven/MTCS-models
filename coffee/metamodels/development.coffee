require "ontoscript"

REQUIRE "metamodels/containers.coffee"
REQUIRE "metamodels/systems.coffee"
REQUIRE "metamodels/finitestatemachines.coffee"
REQUIRE "metamodels/models.coffee"
REQUIRE "metamodels/organizations.coffee"

METAMODEL "http://www.mercator.iac.es/onto/metamodels/development" : "dev"

dev.READ "metamodels/development.jsonld"



root.DERIVES = dev.derives

root.IS_REQUIRED_BY = dev.isRequiredBy
root.SATISFIES = dev.satisfies
root.IS_DERIVED_FROM = dev.isDerivedFrom
root.VERIFIES = dev.validates
root.ASSERTS = dev.asserts
root.TESTS = dev.tests
root.CERTIFIES = dev.certifies
root.IS_ASSERTED_BY = dev.isAssertedBy
root.IS_TESTED_BY = dev.isTestedBy

root.PROJECT = () -> dev.Project
root.FEATURE = () -> dev.Feature
root.CONCEPT = () -> dev.Concept
root.REQUIREMENTS = () -> dev.Requirements



dev.ADD dev.Implementation "IMPLEMENTATION" : (args = {}) -> [
    #INIT $
    CHECK_ARGS("IMPLEMENTATION", args, ["realizes"])

    if args.realizes?
        APPLY( sys.REALIZATION(realizes: args.realizes) )
    else
        APPLY( sys.REALIZATION() )
]


dev.ADD dev.Design "DESIGN" : (args = {}) -> [
    #INIT $
    #CHECK_ARGS("DESIGN", args, ["realizes"])

    if args.realizes?
        APPLY( sys.REALIZATION(realizes: args.realizes) )
    else
        APPLY( sys.REALIZATION() )

    #if args.states?
    #    for name, details in args.states
    #EXIT $
]




dev.ADD dev.Requirement "MkRequirement" : (args) -> [
    CHECK_ARGS("REQUIREMENT", args, ["comment", "isRequiredBy", "isDerivedFrom", "refines"])

    if args.comment?
        COMMENT args.comment

    if args.isRequiredBy?
        if args.isRequiredBy instanceof Array
            [ dev.isRequiredBy role for role in args.isRequiredBy ]
        else
            dev.isRequiredBy args.isRequiredBy

    if args.isDerivedFrom?
        if args.isDerivedFrom instanceof Array
            [ dev.isDerivedFrom req for req in args.isDerivedFrom ]
        else
            dev.isDerivedFrom args.isDerivedFrom

    if args.refines?
        if args.refines instanceof Array
            [ dev.refines req for req in args.refines ]
        else
            dev.refines args.refines
]

root.REQUIREMENT = dev.MkRequirement

#dev.ADD dev.Specification "MkSpecification" : ( args ) ->
#    validArgs = ["description", "derivedFrom"]
#    [
#        for arg in Object.keys(args)
#            if arg not in validArgs
#                ABORT("Invalid argument #{arg} for MkSpecification! Expected: #{validArgs}")
#
#        if args.description?
#            COMMENT args.description
#
#        if args.derivedFrom?
#            IS_DERIVED_FROM args.derivedFrom
#    ]
#root.SPECIFICATION = dev.MkSpecification


dev.ADD dev.Constraint "CONSTRAINT" : ( args, more = {}) -> [
    CHECK_ARGS("CONSTRAINT", args, ["comment", "always", "testedBy", "represents"])
    #INIT $

    if args.comment?
        COMMENT args.comment

    if args.always?
        [
            expr.hasOperand BUILD_EXPRESSION(args.always)
        ]

    if args.testedBy?
        IS_TESTED_BY args.testedBy

    if args.represents?
        mod.represents args.represents

    #EXIT $
]
root.CONSTRAINT = dev.CONSTRAINT


dev.ADD dev.Test "MkTest" : ( args = {} ) ->
    validArgs = ["comment", "tests", "verifies", "result"]
    [
        for arg in Object.keys(args)
            if arg not in validArgs
                ABORT("Invalid argument '#{arg}' for MkTest! Expected: #{validArgs}")

        if args.comment?
            COMMENT args.comment

        if args.tests instanceof Array
            (TESTS test) for test in args.tests
        else if args.tests?
            TESTS args.tests

        if args.result?
            dev.hasResult result

        if args.verifies instanceof Array
            (dev.verifies v) for v in args.verifies
        else if args.verifies?
            dev.verifies args.verifies
    ]
root.TEST = dev.MkTest


#
## link the requirements to the project:
#addDerived = (req, predicate) ->
#    for derived in PATHS(req, DERIVES)
#        cover.project.ADD predicate derived
#        addDerived(derived, predicate) # recursive
#
#
#root.TIE_REQUIREMENTS_TO_PROJECT = (container, project) ->
#    for req in PATHS(container, MEMBER)
#        project.ADD HAS_REQUIREMENT req
#        addDerived(req, HAS_REQUIREMENT)
#
#root.TIE_SPECIFICATIONS_TO_PROJECT = (container, project) ->
#    for spec in PATHS(container, MEMBER)
#        project.ADD HAS_SPECIFICATION spec
#        addDerived(spec, HAS_SPECIFICATION)

