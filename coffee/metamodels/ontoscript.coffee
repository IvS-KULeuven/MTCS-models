require "ontoscript"



ontoscript.ADD ontoscript.View "VIEW" : (args) -> [
    CHECK_ARGS("ontoscript.VIEW", args, ["comment", "views", "category", "type", "priority"])

    if args.comment?
        rdfs.comment args.comment

    if args.views?
        ontoscript.views args.views

    if args.category?
        ontoscript.hasViewCategory args.category

    if args.type?
        ontoscript.hasViewType args.type

    if args.priority?
        ontoscript.hasViewPriority args.priority
]