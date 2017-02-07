require "ontoscript"


REQUIRE "metamodels/all.coffee"

MODEL "http://www.mercator.iac.es/onto/models/import_all" : "import_all"

# import the dependencies
import_all.IMPORT mm_all

import_all.WRITE "models/import_all.jsonld"