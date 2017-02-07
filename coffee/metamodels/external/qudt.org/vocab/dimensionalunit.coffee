require "ontoscript"

REQUIRE "metamodels/external/qudt.org/vocab/quantity.coffee"
REQUIRE "metamodels/external/qudt.org/vocab/unit.coffee"
REQUIRE "metamodels/external/qudt.org/schema/dimension.coffee"
REQUIRE "metamodels/external/qudt.org/schema/qudt.coffee"

METAMODEL "http://qudt.org/vocab/dimensionalunit" : "qudt_dimensionalunit"

qudt_dimensionalunit.READ "metamodels/external/qudt.org/vocab/dimensionalunit.jsonld"