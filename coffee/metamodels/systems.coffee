require "ontoscript"

REQUIRE "metamodels/external/spinrdf.org/spin.coffee"
REQUIRE "metamodels/external/topbraid.org/spin/owlrl-all.coffee"

METAMODEL "http://www.mercator.iac.es/onto/metamodels/systems" : "sys"

sys.READ "metamodels/systems.jsonld"


# ======================================================================================================================
# properties
# ======================================================================================================================
root.HAS_ELEMENT = sys.hasElement
root.HAS_PART = sys.hasPart
root.HAS_PROPERTY = sys.hasProperty
root.IS_ELEMENT_OF = sys.isElementOf
root.IS_PART_OF = sys.isPartOf
root.IS_PROPERTY_OF = sys.isPropertyOf
root.REALIZES = sys.realizes
root.IS_REALIZED_BY = sys.isRealizedBy
root.INTERFACES = sys.interfaces
root.IS_INTERFACED_WITH = sys.isInterfacedWith


# ======================================================================================================================
# Classes
# ======================================================================================================================


# ----------------------------------------------------------------------------------------------------------------------

root.PART = () -> sys.Part
root.INTERFACE = () -> sys.Interface
root.SYSTEM = () -> sys.System

# ----------------------------------------------------------------------------------------------------------------------
sys.ADD sys.Realization "REALIZATION" : (args = {}) -> [
    CHECK_ARGS("REALIZATION", args, ["realizes", "complete"])

    if args.complete?
        if args.complete
            rdf.type sys.Complete

    if args.realizes?
        if IS_ARRAY(args.realizes)
            sys.realizes r for r in args.realizes
        else
            sys.realizes args.realizes

    if args.realizes?
        [
            #INIT()
            if IS_ARRAY(args.realizes)
                for r in args.realizes
                    for attr in r.attributes
                        # if the attribute already exists, only add the sys:realizes relations:
                        if self[attr._name]?
                            addRealizes(self[attr._name], attr)
                        else
                            sys.hasElement sys.REALIZATION(realizes: attr, complete: attr.hasLabel) attr._name
                            #if attr.hasLabel
                            #    sys.hasElement sys.REALIZATION(realizes: attr) attr._name #, ontoscriptProperties: false #, label: false
            else
                for attr in args.realizes.attributes
                    sys.hasElement sys.REALIZATION(realizes: attr, complete: attr.hasLabel) attr._name
                    #if attr.hasLabel
                    #    sys.hasElement sys.REALIZATION(realizes: attr) attr._name #, ontoscriptProperties: false #, label: false
            #EXIT()
        ]
]
root.REALIZATION = sys.REALIZATION


addRealizes = (fromObject, toObject) ->
    if toObject.hasLabel
        fromObject.ADD sys.realizes toObject
        for attr in fromObject.attributes
            addRealizes(attr, toObject[attr._name])

# ----------------------------------------------------------------------------------------------------------------------


sys.ADD sys.Property "MkProperty" : (args) -> [
    CHECK_ARGS("PROPERTY", args, ["comment", "sameAs", "realizes", "unit", "value"])

    if args.comment?
        COMMENT args.comment

    if args.sameAs?
        SAME_AS args.sameAs

    if args.realizes?
        sys.realizes args.realizes

    if args.unit?
        if not qudt? then ABORT("QUDT not required!")

        qudt.unit args.unit

    if args.value?
        if not qudt? then ABORT("QUDT not required!")

        qudt.numericValue double(args.value)

    #if args.isDerivedFrom?
    #    if args.isDerivedFrom instanceof Array
    #        [ sys.isDerivedFrom req for req in args.isDerivedFrom ]
    #    else
    #        sys.isDerivedFrom args.isDerivedFrom

    #if args.value?
    #    qudt.numericValue args.value

    #if args.unit?
    #    qudt.unit args.unit

]
root.PROPERTY = sys.MkProperty

# ----------------------------------------------------------------------------------------------------------------------





