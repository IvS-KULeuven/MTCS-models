require "ontoscript"

REQUIRE "metamodels/external/spinrdf.org/spin.coffee"
REQUIRE "metamodels/models.coffee"
REQUIRE "metamodels/containers.coffee"

METAMODEL "http://www.mercator.iac.es/onto/metamodels/organizations" : "org"

org.READ "metamodels/organizations.jsonld"



org.ADD org.Organization "ORGANIZATION" : (args) -> [
    CHECK_ARGS("ORGANIZATION", args, ["shortName", "longName", "comment"])

    if args.shortName?
        org.hasShortName string(args.shortName)
    if args.longName?
        org.hasLongName  string(args.longName)
    if args.comment?
        COMMENT string(args.comment)
]
root.ORGANIZATION = org.ORGANIZATION



root.ROLE = () -> org.Role