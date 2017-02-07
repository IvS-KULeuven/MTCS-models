require "ontoscript"

REQUIRE "metamodels/systems.coffee"
REQUIRE "metamodels/mathematics.coffee"
REQUIRE "metamodels/external/qudt.org/vocab/dimensionalunit.coffee"
REQUIRE "metamodels/models.coffee"

METAMODEL "http://www.mercator.iac.es/onto/metamodels/controlsystems" : "ctrl"

mod.READ "metamodels/controlsystems.jsonld"
