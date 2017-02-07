require "ontoscript"

REQUIRE "metamodels/external/qudt.org/schema/qudt.coffee"
REQUIRE "metamodels/external/www.linkedmodel.org/schema/dtype.coffee"
REQUIRE "metamodels/external/www.linkedmodel.org/schema/vaem.coffee"

METAMODEL "http://qudt.org/schema/quantity" : "quantity"

quantity.READ "metamodels/external/qudt.org/schema/quantity.jsonld"

