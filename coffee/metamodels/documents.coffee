require "ontoscript"

REQUIRE "metamodels/models.coffee"

METAMODEL "http://www.mercator.iac.es/onto/metamodels/documents" : "doc"

doc.READ "metamodels/documents.jsonld"
