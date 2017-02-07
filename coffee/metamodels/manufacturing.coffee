require "ontoscript"

REQUIRE "metamodels/organizations.coffee"
REQUIRE "metamodels/development.coffee"
REQUIRE "metamodels/development.coffee"


METAMODEL "http://www.mercator.iac.es/onto/metamodels/manufacturing" : "man"


man.READ "metamodels/manufacturing.jsonld"




man.ADD man.Manufacturer "MANUFACTURER" : (args) -> [
    APPLY org.ORGANIZATION(args)
]
root.MANUFACTURER = man.MANUFACTURER