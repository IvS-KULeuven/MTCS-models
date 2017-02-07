########################################################################################################################
#                                                                                                                      #
# The purpose of this model is just to be able to import all external models at once.                                  #
#                                                                                                                      #
########################################################################################################################

require "ontoscript"

REQUIRE "models/external/beckhoff.coffee"
REQUIRE "models/external/binder.coffee"
REQUIRE "models/external/faulhaber.coffee"
REQUIRE "models/external/harting.coffee"
REQUIRE "models/external/heidenhain.coffee"
REQUIRE "models/external/itt.coffee"
REQUIRE "models/external/ivs.coffee"
REQUIRE "models/external/kuebler.coffee"
REQUIRE "models/external/magnetschultz.coffee"
REQUIRE "models/external/maxon.coffee"
REQUIRE "models/external/phoenix.coffee"
REQUIRE "models/external/prehkeytec.coffee"
REQUIRE "models/external/propower.coffee"
REQUIRE "models/external/schneider.coffee"
REQUIRE "models/external/sick.coffee"
REQUIRE "models/external/various.coffee"

MODEL "http://www.mercator.iac.es/onto/models/external/all" : "external_all"

external_all.IMPORT beckhoff
external_all.IMPORT binder
external_all.IMPORT faulhaber
external_all.IMPORT harting
external_all.IMPORT heidenhain
external_all.IMPORT itt
external_all.IMPORT ivs
external_all.IMPORT kuebler
external_all.IMPORT magnetschultz
external_all.IMPORT maxon
external_all.IMPORT phoenix
external_all.IMPORT prehkeytec
external_all.IMPORT propower
external_all.IMPORT schneider
external_all.IMPORT sick
external_all.IMPORT various


########################################################################################################################
# Write the model to file
########################################################################################################################

external_all.WRITE "models/external/all.jsonld"
