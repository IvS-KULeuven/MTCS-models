require "ontoscript"

REQUIRE "metamodels/systems.coffee"

METAMODEL "http://www.mercator.iac.es/onto/metamodels/containers" : "cont"

cont.READ "metamodels/containers.jsonld"


# ======================================================================================================================
# properties
# ======================================================================================================================
root.CONTAINS          = cont.contains
root.HAS_CONTAINMENT   = cont.hasContainment
root.HAS_ITEM          = cont.hasItem
root.IS_CONTAINED_BY   = cont.isContainedBy
root.IS_CONTAINMENT_OF = cont.isContainmentOf
root.IS_ITEM_OF        = cont.isItemOf



# ======================================================================================================================
# Classes
# ======================================================================================================================

# ----------------------------------------------------------------------------------------------------------------------

root.ITEM = () -> cont.Item


# ----------------------------------------------------------------------------------------------------------------------

cont.ADD cont.Containment "CONTAINMENT" : (args={}) -> [
    CHECK_ARGS("CONTAINMENT", args, ["number"])
    if args.number?
        cont.hasNumber args.number
]
root.CONTAINMENT = cont.CONTAINMENT

# ----------------------------------------------------------------------------------------------------------------------

cont.ADD cont.Container "CONTAINER" : (args={}) -> [
    CHECK_ARGS("CONTAINER", args, ["comment", "items"])

    if args.comment?
        COMMENT args.comment

    if args.items?
        # original syntax
        if IS_ARRAY(args.items)
            for item in args.items
                [
                  cont.contains item
                ]
        # alternative syntax
        else
            i = 0
            for name, detailsFunction of args.items
                # create the item
                item = detailsFunction() name
                [
                  cont.contains item
                ]
]
root.CONTAINER = cont.CONTAINER

# ----------------------------------------------------------------------------------------------------------------------

cont.ADD cont.List "LIST" : (args={}) -> [
    CHECK_ARGS("LIST", args, ["comment", "items"])

    if args.comment?
        COMMENT args.comment

    if args.items?
        # original syntax
        if IS_ARRAY(args.items)
            for item, i in args.items
                # create the n-ary containment relation
                c = CONTAINMENT(number: i) "containment_#{i}"
                c.ADD cont.hasItem item
                # add the item and containment
                [
                  cont.contains item
                  cont.hasContainment c
                ]
        # alternative syntax
        else
            i = 0
            for name, detailsFunction of args.items
                # create the item
                item = detailsFunction() name
                # create the n-ary containment relation
                c = CONTAINMENT(number: i) "containment_#{i}"
                c.ADD cont.hasItem item
                i = i + 1
                [
                  cont.contains item
                  cont.hasContainment c
                ]
]
root.LIST = cont.LIST
