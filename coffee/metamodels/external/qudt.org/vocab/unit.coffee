require "ontoscript"

REQUIRE "metamodels/external/www.linkedmodel.org/schema/vaem.coffee"
REQUIRE "metamodels/external/qudt.org/schema/qudt.coffee"

METAMODEL "http://qudt.org/vocab/unit" : "unit"

unit.READ "metamodels/external/qudt.org/vocab/unit.jsonld"
