## MTCS-models

Models of the Mercator Telescope Control System, written in a DSL (Domain Specific Language) called Ontoscript.

Ontoscript is available at: https://github.com/IvS-KULeuven/Ontoscript

When the models are executed, they are converted into json-ld files. 

These json-ld files can be read by OntoManager: https://github.com/IvS-KULeuven/OntoManager

OntoManager is a web-based application that provides convenient access to the models. It can be used to
* query the models
* convert the models into web-pages (e.g. for documenting system requirements, electric systems, software, ...)
* convert software models into source code (Python and IEC61131-3 to be imported by TwinCAT)
* analyze the models by reasoning (requires SPIN API by TopBraid)

