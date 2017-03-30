============================
SOFTWARE MODELING REFERENCE
============================

This document describes the primitives of the DSL (Domain Specific Language) used to model the Mercator Telescope. All syntax complies to Ontoscript_. 

--------------------
Terminology
--------------------

- a **reference** can only be referred to, it cannot be called. There are no parentheses. For example:

  - ``t_bool``
  - ``cover_soft.mtcs_cover.DomeShutter``

- a **function** can be called with **arguments** and nothing more. Parentheses are optional. For example:
  
  - ``MTCS_MAKE_LIB "mtcs_cover"``
  - ``MTCS_MAKE_LIB("mtcs_cover")``
  - ``AND(expression1, expression2)``
  
- a **macro** must be called with (zero or more) **arguments and an identifier**. Parentheses are mandatory. For example:

  - ``BOOL(TRUE) "myTruthConstant"``
  - ``INT16(2017) "thisYear"``
  - ``INT16() "unknownYear"``


--------------------
High-level functions
--------------------

High-level functions are defined in the softwarefactories_ model. 

======================  ==========================  ===================================================
Function                Description                 Examples
======================  ==========================  ===================================================
MTCS_MAKE_LIB_          Make a software library     ``mtcs_cover``, ``mtcs_m3``, ...
MTCS_MAKE_ENUM_         Make an enumeration         ``Units``, ``DriveOperatingModes``, ...
MTCS_MAKE_STATUS        Make a status               ``HealthStatus``, ``MotionStatus``, ...
MTCS_MAKE_STATEMACHINE  Make a status machine       ``Axes``, ``AxesAzimuthAxis``, ...
MTCS_MAKE_CONFIG        Make a configuration        ``AxesConfig``, ``AxesAzimuthConfig``, ...
MTCS_MAKE_STRUCT        Make a structure            ``TmcTarget``, ``TmcRaDec``, ...
MTCS_MAKE_PROCESS       Make a process              ``MTCSParkProcess``, ``AxesStopProcess``, 
MTCS_MAKE_INTERFACE     Make a software interface   ``mtcs_soft.interface``
======================  ==========================  ===================================================


--------------------
Primitive types
--------------------
      
You can refer to a specific type (often like: ``type: t_bool``) or you can use a macro to build
a value of a certain type (e.g. ``STRING("Institute of Astronomy") "ivsName"`` or ``UINT8(0) "nullChar"``).
      
==============  ==========  =============================
Reference       Macro       Comment
==============  ==========  =============================
t_bool          BOOL        Reference is the same as ``iec61131.BOOL``. Can be ``TRUE`` or ``FALSE``
t_bytestring    BYTESTRING  
t_double        DOUBLE      Reference is the same as ``iec61131.LREAL``. Doubles are preferred over floats
t_float         FLOAT       Reference is the same as ``iec61131.REAL`` 
t_int8          INT8        Reference is the same as ``iec61131.SINT``
t_int16         INT16       Reference is the same as ``iec61131.INT``
t_int32         INT32       Reference is the same as ``iec61131.DINT``
t_int64         INT64       Reference is the same as ``iec61131.LINT``
t_uint8         UINT8       Reference is the same as ``iec61131.USINT``
t_uint16        UINT16      Reference is the same as ``iec61131.UINT``
t_uint32        UINT32      Reference is the same as ``iec61131.UDINT``
t_uint64        UINT64      Reference is the same as ``iec61131.ULINT``
t_string        STRING      Reference is the same as ``iec61131.STRING``
iec61131.BYTE   
iec61131.WORD   
iec61131.DWORD  
==============  ==========  =============================

Examples:

.. code:: coffeescript
  
  MTCS_MAKE_STATEMACHINE THISLIB, "CurrentMeasurement",
    variables_hidden:
        microAmpsValue  : { type: t_int32                       , comment: "Measured value" }
        error           : { type: t_bool       , initial: FALSE , comment: "Error" }
        errorId         : { type: iec61131.WORD, initial: 0     , comment: "Error ID" }
    variables_read_only:
        current         : { type: THISLIB.Current               , comment: "The current" }
    calls:
        current:
            newAmpsValue : -> DIV(self.microAmpsValue, DOUBLE(1000000) "microamp_per_amp")


--------------------
Operations
--------------------

All operations are functions (not macros). Most of them can be nested, e.g.::

  ASSIGN(self.isGood, AND(self.isEnabled, GT( SUM(self.offset, self.value), self.limit)))


**Assignment operation**

======================  ==========================================  ===================================================
Function                Description                                 Example
======================  ==========================================  ===================================================
ASSIGN                  ``=`` (Python), ``:=`` (PLC), assign to     ``ASSIGN(self.unit, COMMONLIB.Units.RADIANS)``
======================  ==========================================  ===================================================

**Boolean operations**.
Multiple operands can be specified, e.g. ``OR(a,b,c)`` means ``OR(a,OR(b,c))``.

======================  ==========================================  ===================================================
Function                Description                                 Example
======================  ==========================================  ===================================================
AND                     ``AND``, logical conjunction                ``AND(self.isEnabled, GT(self.value, self.limit))``
OR                      ``OR``, logical disjunction                 ``OR(self.comError, self.otherError)``
NOT                     ``NOT``, logical negation                   ``NOT(self.error)``
======================  ==========================================  ===================================================

**Comparison operations.**

======================  ==========================================  ===================================================
Function                Description                                 Example
======================  ==========================================  ===================================================
EQ                      ``==`` (Python), ``=`` (PLC), is equal to   ``EQ(self.id, THISLIB.AxesIDs.AZI)``
GT                      ``>``, is greater than                      ``GT(self.value, self.limit)``
LT                      ``<``, is less than                         ``LT(self.value, self.limit)``
GE                      ``>=``, is greater than or equal to         ``GE(self.value, self.limit)``
LE                      ``<=``, is less than or equal to            ``LE(self.value, self.limit)``
======================  ==========================================  ===================================================

**Bit operations.**

======================  ==========================================  ===================================================
Function                Description                                 Example
======================  ==========================================  ===================================================
SHL                     Bit shift left                              ``SHL(self.data)``
SHR                     Bit shift right                             ``SHR(self.data)``
======================  ==========================================  ===================================================

**Mathematical operations.**

======================  ==========================================  ===================================================
Function                Description                                 Example
======================  ==========================================  ===================================================
ABS                     Absolute value                              ``ABS(self.value)``
SUM                     Sum                                         ``SUM(self.offset, self.value)``
SUB                     Subtraction                                 ``SUB(self.value, self.bias)``
MUL                     Multiplication                              ``MUL(self.value, self.conversion)``
DIV                     Division                                    ``DIV(self.value, self.conversion)``
POW                     Power                                       ``POW(self.base, self.exponent)``
NEG                     Unary minus                                 ``NEG(self.value)``
======================  ==========================================  ===================================================


--------------------
Low-level macros
--------------------

=====================  ====================================  ========================
Macro                  Arguments                             Description
=====================  ====================================  ========================
VARIABLE_              ``type``, ``realizes``, ``expand``,   Create a variable instance.
                       ``initial``, ``comment``, 
                       ``pointsToType``, ``attributes``,
                       ``arguments``, ``qualifiers``,
                       ``address``, ``copyFrom``
ARGUMENT_              Same args as VARIABLE_
ATTRIBUTE_             Same args as VARIABLE_
GLOBAL_VARIABLE_       Same args as VARIABLE_
POINTER_               ``to``, ``type``
IMPLEMENTATION_        A list of expressions
IF_THEN_               ``if``, ``then``, ``else``
DATA_
NAMESPACE_
LIBRARY_
ENUMERATION_           ``comment``, ``containedBy``,
                       ``type``, ``items``
ENUMERATION_ITEM_      ``comment``
=====================  ====================================  ========================


------------------------
Low-level relationships
------------------------

=====================  =================================================
Relationship           Example
=====================  =================================================
EXTENDS                ``mymodel.MySubClass EXTENDS mymodel.MyClass``
=====================  =================================================



--------------------------------------------------------

-----------------------------------------
Full description of macros and functions
-----------------------------------------


MTCS_MAKE_LIB
^^^^^^^^^^^^^

Make a software library, that can be converted into PLC code (.xml) and python code.

Syntax:

.. code:: coffeescript

  MTCS_MAKE_LIB "name"

Example:

.. code:: coffeescript
 
  # create a new software model
  MODEL "http://www.mercator.iac.es/onto/models/mtcs/dome/software" : "dome_soft"
  # make sure the common_soft library is imported
  dome_soft.IMPORT common_soft
  # add a library to the model
  dome_soft.ADD MTCS_MAKE_LIB "mtcs_dome"
  # add enums, statuses, state machines, configs, ...
  # ...
  # now write the model
  dome_soft.WRITE "models/mtcs/dome/software.jsonld"


MTCS_MAKE_ENUM
^^^^^^^^^^^^^^

Make an enumeration.

Syntax:

.. code:: coffeescript
 
  MTCS_MAKE_ENUM libraryToAddTheEnumTo, "NameOfTheEnum",
    # mandatory args
    items:
      [
        "ITEM_NUMBER_ONE",
        "ITEM_NUMBER_TWO",
        "ITEM_NUMBER_THREE"
      ]
    # optional args
    comment: "some description"
    type: someType

- arguments:

  - ``items``: a list of strings, in the correct order (the first item will be 0, the second 1, ...)
  - ``comment``: (OPTIONAL) a string, some description
  - ``type``: (OPTIONAL) by default, enumeration items are represented by ints. If you want a special type (such as ``t_uint64``), then you can specify it using this argument.
  
    
Example:

.. code:: coffeescript

    MTCS_MAKE_ENUM THISLIB, "AxesIds",
        comment: "The IDs of the telescope axes"
        items:
            [ 
              "AZI" ,
              "ABL" ,
              "ELE" ,
              "ROC" ,
              "RON" 
            ]
  
.. _softwarefactories: coffee/models/util/softwarefactories.coffee
.. _ontoscript: https://github.com/IvS-KULeuven/Ontoscript

