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

=======================  ==========================  ===================================================
Function                 Description                 Examples
=======================  ==========================  ===================================================
MTCS_MAKE_LIB_           Make a software library     ``mtcs_cover``, ``mtcs_m3``, ...
MTCS_MAKE_ENUM_          Make an enumeration         ``Units``, ``DriveOperatingModes``, ...
MTCS_MAKE_STATUS_        Make a status               ``HealthStatus``, ``MotionStatus``, ...
MTCS_MAKE_STATEMACHINE_  Make a status machine       ``Axes``, ``AxesAzimuthAxis``, ...
MTCS_MAKE_CONFIG_        Make a configuration        ``AxesConfig``, ``AxesAzimuthConfig``, ...
MTCS_MAKE_STRUCT_        Make a structure            ``TmcTarget``, ``TmcRaDec``, ...
MTCS_MAKE_PROCESS_       Make a process              ``MTCSParkProcess``, ``AxesStopProcess``, 
MTCS_MAKE_INTERFACE_     Make a software interface   ``mtcs_soft.interface``
=======================  ==========================  ===================================================


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


**Assignment operation:**

======================  ==========================================  ===================================================
Function                Description                                 Example
======================  ==========================================  ===================================================
ASSIGN                  ``=`` (Python), ``:=`` (PLC), assign to     ``ASSIGN(self.unit, COMMONLIB.Units.RADIANS)``
======================  ==========================================  ===================================================

**Boolean operations:**
Multiple operands can be specified, e.g. ``OR(a,b,c)`` means ``OR(a,OR(b,c))``.

======================  ==========================================  ===================================================
Function                Description                                 Example
======================  ==========================================  ===================================================
AND                     ``AND``, logical conjunction                ``AND(self.isEnabled, GT(self.value, self.limit))``
OR                      ``OR``, logical disjunction                 ``OR(self.comError, self.otherError)``
NOT                     ``NOT``, logical negation                   ``NOT(self.error)``
======================  ==========================================  ===================================================

**Comparison operations:**

======================  ==========================================  ===================================================
Function                Description                                 Example
======================  ==========================================  ===================================================
EQ                      ``==`` (Python), ``=`` (PLC), is equal to   ``EQ(self.id, THISLIB.AxesIDs.AZI)``
GT                      ``>``, is greater than                      ``GT(self.value, self.limit)``
LT                      ``<``, is less than                         ``LT(self.value, self.limit)``
GE                      ``>=``, is greater than or equal to         ``GE(self.value, self.limit)``
LE                      ``<=``, is less than or equal to            ``LE(self.value, self.limit)``
======================  ==========================================  ===================================================

**Bit operations:**

======================  ==========================================  ===================================================
Function                Description                                 Example
======================  ==========================================  ===================================================
SHL                     Bit shift left                              ``SHL(self.data)``
SHR                     Bit shift right                             ``SHR(self.data)``
======================  ==========================================  ===================================================

**Mathematical operations:**

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

**Other operations:**

======================  ==========================================  ===================================================
Function                Description                                 Example
======================  ==========================================  ===================================================
ADR                     Get the memory address of a variable        ``ADR(self.variable)``
PLC_DEREF               Dereference an IEC 61131-3 pointer          ``PLC_DEREF(self.pointerToTemperatureValue)``
======================  ==========================================  ===================================================


--------------------
Low-level macros
--------------------

**Programming language-independent macros:**

=====================  ====================================  ========================
Macro                  Arguments                             Description
=====================  ====================================  ========================
VARIABLE_              ``type``, ``realizes``, ``expand``,   Create a variable instance.
                       ``initial``, ``comment``, 
                       ``pointsToType``, ``attributes``,
                       ``arguments``, ``qualifiers``,
                       ``address``, ``copyFrom``
ARGUMENT_              Same args as VARIABLE_                Create an argument of a callable variable.
ATTRIBUTE_             Same args as VARIABLE_                Create a "sub-variable" of a variable.
GLOBAL_VARIABLE_       Same args as VARIABLE_                Create a variable of the global namespace.
POINTER_               ``to``, ``type``                      Create a pointer to a variable.
IMPLEMENTATION_        A list of expressions                 Create the implementation of a callable.
IF_THEN_               ``if``, ``then``, ``else``            Create an if-then(-else) instruction.
NAMESPACE_             None                                  Create a namespace.
LIBRARY_               None                                  Create a library that can be converted into source code.
ENUMERATION_           ``comment``, ``containedBy``,         Create an enumeration.
                       ``type``, ``items``
ENUMERATION_ITEM_      ``comment``                           Create an enumeration item.
CALL_                  ``calls``, ``assigns``                Create a call instruction.
=====================  ====================================  ========================

**IEC61131-specific macros:**

=====================  ====================================  ========================
Macro                  Arguments                             Description
=====================  ====================================  ========================
PLC_FB_                ``containedBy``, ``typeOf``,          Create a Function Block.
                       ``extends``, ``comment``, 
                       ``label``, ``in``,
                       ``out``, ``inout``
PLC_OPEN_ATTRIBUTE_    ``symbol``, ``value``                 Create a PLCopen variable attribute.
PLC_STRUCT_            ``containedBy``, ``typeOf``,          Create a Struct.
                       ``items``, ``comment``, ``label``
PLC_METHOD_            ``inputArgs``, ``inOutArgs``,         Create a Function Block Method.
                       ``localArgs``, ``returnType``, 
                       ``comment``, ``implementation``
PLC_DEREFERENCE_       ``operand``                           Create a pointer dereference (``^``) instruction.
VAR_                   Same args as VARIABLE_                Create a local variable.
VAR_IN_                Same args as VARIABLE_                Create an input variable.
VAR_OUT_               Same args as VARIABLE_                Create an output variable.
VAR_IN_OUT_            Same args as VARIABLE_                Create an input/output variable.
=====================  ====================================  ========================



--------------------------------------------------------

-----------------------------------------
Full description of macros and functions
-----------------------------------------


MTCS_MAKE_LIB
^^^^^^^^^^^^^

High-level function to make a software library, that can be converted into PLC code (.xml) and python code.

The resulting library will be an IEC 61131-3 library, and will have the following namespaces::

  Enums
  Statuses
  StateMachines
      Parts
      Processes
      Statuses
  Configs
  Structs
  Processes
      Args

When code is generated for the library, the namespaces will be represented as folders of the above structure.
      
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

High-level function to make an enumeration within a library. 

The enumeration will be automatically be contained by the ``Enums`` namespace of the library.

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

Args:

- ``items``: same as ``items`` of ENUMERATION_ 
- ``comment``: same as ``comment`` of ENUMERATION_ 
- ``type``: same as ``type`` of ENUMERATION_ 
  
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
  
MTCS_MAKE_STATUS
^^^^^^^^^^^^^^^^

High-level function to make a Status within a library. 

A **status** contains **states**, represented as boolean variables, of which at most 1 can be true.

A status also has a super state, which is a boolean variable, assigned to true by default. If the super state is false, then all states will be false.


A status is converted into an IEC61131-3 function block (PLC_FB_), with these properties:

- it is contained by the ``Statuses`` namespace of the library.
- it has a boolean VAR_IN_ called ``superState``, representing the super state
- it may have some variables (generated as VAR_IN_ variables), which can be used to calculate the true/false value of the states
- it has boolean VAR_OUT_ variables for all states.


Syntax:

.. code:: coffeescript
 
  MTCS_MAKE_ENUM libraryToAddTheStatusTo, "NameOfTheStatus",
    variables: 
        # variables are used to calculate the true/false value of the states
        inputVariable1Name : inputVariable1Args
        inputVariable2Name : inputVariable2Args
        # and so on
    states:
        state1Name : 
          expr: -> state1Expression
          comment: "State 1 comment"
        state2Name : 
          expr: -> state2Expression
          comment: "State 2 comment"
        # and so on

Args:

- ``variables``: VAR_IN_ instances, as a dictionary of *key:value* pairs where *key* is the name of the variable, and *value* is the args of the VAR_IN_ instance.
- ``states``: dictionary of *key:value* pairs where *key* is the name of the state, and *value* has two arguments: ``expr`` and ``comment``.

  - ``expr`` is the boolean expression of that state, precedented by the ``->`` arrow. It is AND-ed with the automatically generated ``superState`` input variable.
  - ``comment`` is just a description string.
  
Example:

.. code:: coffeescript

  MTCS_MAKE_STATUS THISLIB, "MotionStatus",
    variables:
        actVel:
            type: t_double
            comment: "Actual velocity"
        tolerance:
            type: t_double
            comment: "Tolerance (should be positive)!"
    states:
        forward:
            expr: -> GT(self.actVel, ABS(self.tolerance))
            comment: "Moving forwared"
        backward:
            expr: -> LT( self.actVel, NEG(ABS(self.tolerance)) )
            comment: "Moving backward"
        standstill:
            expr: -> NOT( OR( self.forward, self.backward ) )
            comment: "Standing still"
  
  
MTCS_MAKE_STATEMACHINE
^^^^^^^^^^^^^^^^^^^^^^^

High-level function to make a state machine within a library. 

A state machine contains the following arguments:

- ``variables``: VAR_IN_ instances, visible by OPC UA with read+write access
- ``variables_hidden``: VAR_IN_ instances, hidden by OPC UA
- ``variables_read_only``: VAR_OUT_ instances, visible by OPC UA with read-only access
- ``references``: VAR_IN_OUT_ instances, hidden by OPC UA 
- ``local``: VAR_ instances, visible by OPC UA with read-only access
- ``methods``: PLC_METHOD_ instances, hidden by OPC UA
- ``statuses``: instances of the function blocks generated by MTCS_MAKE_STATUS_. These instances are the items of an automatically generated PLC_STRUCT_ called *<nameOfTheStateMachine>Statuses*, and added to the ``StateMachines/Statuses`` namespace of the library.
- ``parts``: instances of the function blocks generated by MTCS_MAKE_STATEMACHINE_. These instances are the items of an automatically generated PLC_STRUCT_ called *<nameOfTheStateMachine>Parts*, and added to the ``StateMachines/Parts`` namespace of the library.
- ``processes``: instances of the function blocks generated by MTCS_MAKE_PROCESS_. These instances are the items of an automatically generated PLC_STRUCT_ called *<nameOfTheStateMachine>Processes*, and added to the ``StateMachines/Processes`` namespace of the library.
- ``calls``: calls to the above defined variables, parts, processes, and statuses. In each call, the arguments of the variable/part/process/status can be assigned. If a part or process or status is not assigned explicitly, it will be called automatically without arguments **unless** the part/process/status is mentioned in the ``disabled_calls`` arg (see below).
- ``disabled_calls``: list of parts or processes or statuses that must not be called automatically.
- ``extends``: reference to the super-state machine (super-function block).


As a result, a function block will be generated, with these properties:

- **VAR_IN**: the *variables* and *variables_hidden*
- **VAR_IN_OUT**: the *references*
- **VAR_OUT**: 
   - the *variables_read_only*
   - a struct called ``statuses`` of type *<nameOfTheStateMachine>Statuses*
   - a struct called ``parts`` of type *<nameOfTheStateMachine>Parts*
   - a struct called ``processes`` of type *<nameOfTheStateMachine>Processes*
- **implementation**: the calls to the variables, parts, statuses, processes, and possible super-statemachine, in this order.


Example:

.. code:: coffeescript

  MTCS_MAKE_STATEMACHINE THISLIB, "DomeRotation",
    typeOf: THISLIB.DomeParts.rotation
    variables_read_only:
        actPos          : { type: COMMONLIB.AngularPosition         , comment: "The actual position" }
        actVelo         : { type: COMMONLIB.AngularVelocity         , comment: "The actual velocity" }
        actTorqueMaster : { type: COMMONLIB.Torque                  , comment: "The actual torque by the master motor" }
        actTorqueSlave  : { type: COMMONLIB.Torque                  , comment: "The actual torque by the slave motor" }
        masterSlaveLag  : { type: COMMONLIB.AngularPosition         , comment: "masterAxis.actPos - slaveAxis.actPos" }
    references:
        operatorStatus  : { type: COMMONLIB.OperatorStatus          , comment: "Reference to the MTCS operator status"}
        config          : { type: THISLIB.DomeRotationConfig        , comment: "Reference to the rotation config"}
    parts:
        masterAxis      : { type: COMMONLIB.AngularAxis             , comment: "Master axis" }
        slaveAxis       : { type: COMMONLIB.AngularAxis             , comment: "Slave axis" }
        drive           : { type: COMMONLIB.AX52XXDrive             , comment: "Dual axis drive" }
    statuses:
        healthStatus    : { type: COMMONLIB.HealthStatus            , comment: "Health status"}
        busyStatus      : { type: COMMONLIB.BusyStatus              , comment: "Busy status" }
        poweredStatus   : { type: COMMONLIB.PoweredStatus           , comment: "Powered status" }
    processes:
        reset           : { type: COMMONLIB.Process                 , comment: "Reset errors" }
        stop            : { type: COMMONLIB.Process                 , comment: "Stop the rotation" }
        moveAbsolute    : { type: THISLIB.DomeMoveProcess           , comment: "Move absolute" }
    calls:
        # processes
        reset:
            isEnabled   : -> self.statuses.busyStatus.idle
        stop:
            isEnabled   : -> self.statuses.busyStatus.busy
        moveAbsolute:
            isEnabled   : -> AND(self.statuses.busyStatus.idle, self.statuses.poweredStatus.enabled)
        moveRelative:
        # parts
        masterAxis:
            isEnabled   : -> self.operatorStatus.tech
        slaveAxis:
            isEnabled   : -> self.operatorStatus.tech
        drive:
            isEnabled   : -> self.operatorStatus.tech
        # statuses
        poweredStatus:
            isEnabled   : -> AND(self.parts.masterAxis.statuses.poweredStatus.enabled,
                                 self.parts.slaveAxis.statuses.poweredStatus.enabled)
        healthStatus:
            isGood      : -> MTCS_SUMMARIZE_GOOD(self.parts.masterAxis,
                                                 self.parts.slaveAxis,
                                                 self.parts.drive,
                                                 self.processes.reset,
                                                 self.processes.stop)
            hasWarning  : -> MTCS_SUMMARIZE_WARN(self.parts.masterAxis,
                                                 self.parts.slaveAxis,
                                                 self.parts.drive,
                                                 self.processes.reset,
                                                 self.processes.stop)
        busyStatus:
            isBusy      : -> MTCS_SUMMARIZE_BUSY(self.parts.masterAxis,
                                                 self.parts.slaveAxis,
                                                 self.parts.drive,
                                                 self.processes.reset,
                                                 self.processes.stop)
  

MTCS_MAKE_CONFIG
^^^^^^^^^^^^^^^^^

High-level function to make a config within a library, represented by an IEC 61131-3 PLC_STRUCT_.

The struct will be automatically be contained by the ``Configs`` namespace of the library.

Syntax:

.. code:: coffeescript
 
  MTCS_MAKE_CONFIG libraryToAddTheConfigTo, "NameOfTheConfig",
    items:
      item1Name : item1Args
      item2Name : item2Args
      # and so on...
    comment: "some description"
    typeOf: someVariable

Args: ``items``, ``comment``, ``label``, ``typeOf``: same as for PLC_STRUCT_
  
Example:

.. code:: coffeescript

  MTCS_MAKE_CONFIG THISLIB, "DomeShutterConfig",
      typeOf: THISLIB.DomeConfig.shutter
      items:
         wirelessPolling   : { type: t_double, comment: "Polling frequency of the I/O, in seconds." }
         wirelessIpAddress : { type: t_string, comment: "IP address of the wireless I/O device" }
         wirelessPort      : { type: t_uint16, comment: "Port of the wireless I/O device" }
         wirelessUnitID    : { type: t_uint8 , comment: "Unit ID the wireless I/O device" }
  
  

MTCS_MAKE_STRUCT
^^^^^^^^^^^^^^^^^
  
Same as MTCS_MAKE_CONFIG_, only structs are added to the ``Structs`` namespace of the library.
  
Syntax, arguments and examples are the same as for MTCS_MAKE_CONFIG_, just replace *struct* with *config*.
  


  
MTCS_MAKE_PROCESS
^^^^^^^^^^^^^^^^^^^^^^^

High-level function to make a process within a library. 

A process is a kind of state machine that represents a process. It is contained by the ``Processes`` namespace of the library. It contains the following arguments:

- ``arguments``: input arguments of the processes. Not all processes have arguments. If arguments are present, then a struct (of type *<nameOfTheProcess>Args*) will be created that contains them. This struct is contained by the ``Processes/Args`` namespace of the library. 
- ``variables``: VAR_IN_ instances, visible by OPC UA with read+write access. These are not input variables, they are just extra variables of the process that are useful to the outside world (e.g. a ``state`` variable, a ``errorId`` variable, ...). Only in seldom cases you should use this.
- ``references``: VAR_IN_OUT_ instances, hidden by OPC UA. These are not input variables, they are just extra references used by the process. Only in very seldom cases you should use this.
- ``extends``: reference to the super-process (super-function block).


A process contains two instances of the arguments struct: a ``set`` VAR_IN_ instance and a ``get`` VAR_OUT_ instance. The ``set`` instance is used by an external party (e.g. OPC UA client) to supply the arguments. If the call is accepted, then ``set`` will be copied to ``get``, so that the process can run using the ``get`` variables. During the run of the process, an external party may already change the ``set`` arguments.

Processes are based on the ``common_soft.mtcs_common.BaseProcess`` state machine, or an extension of this function block. As a result, processes have the following properties:

- **VAR**:
   - ``do_request``: a boolean variable, that is set to true to start the process by an external party. The implementation of the process automatically sets the ``do_request`` boolean to false again after the first cycle. When ``do_request`` is set to true (e.g. by an OPC UA client), then ``do_request_result`` will be set to ``ACCEPTED`` if ``statuses.enabledStatus.enabled`` is true, or it will be set to ``REJECTED`` if ``statuses.enabledStatus.disabled`` is true.
   - ``do_request_result``: an enum instance of type ``common_soft.mtcs_common.RequestResults``, can be ``ACCEPTED`` or ``REJECTED``. 
   - any other variable, specified by the *variables* argument.
- **VAR_IN**:
   - ``isEnabled``: a boolean variable, to update the ``statuses.enabledStatus`` from within the software (i.e. not by an external OPC UA client).
   - ``set``: an instance of the arguments struct (of type *<nameOfTheProcess>Args*). This will be copied to the ``get`` output variable if ``do_request`` is accepted.
- **VAR_IN_OUT**: the *references*, if specified
- **VAR_OUT**: 
   - ``get``: an instance of the arguments struct (of type *<nameOfTheProcess>Args*).
   - ``statuses``: a struct of type *<nameOfTheProcess>Statuses* that contains:
      - ``healthStatus`` (of type ``common_soft.mtcs_common.HealthStatus``)
      - ``busyStatus`` (of type ``common_soft.mtcs_common.BusyStatus``)
      - ``enabledStatus`` (of type ``common_soft.mtcs_common.EnabledStatus``)
- **METHODS**:
   - ``start``: start the process internally (i.e. from within the software, not by an external OPC UA client). The arguments of ``start`` are the same as specified by the process *arguments*.
   - ``request``: start the process if ``statuses.enabledStatus.enabled`` is true.  The arguments of ``request`` are the same as specified by the process *arguments*.
- **implementation**: the code to call the ``start`` method *if* ``do_request`` has been set to true *and* if ``statuses.enabledStatus.enabled`` is true.


Example:

.. code:: coffeescript

  MTCS_MAKE_PROCESS THISLIB, "DomeMoveProcess",
      extends: COMMONLIB.BaseProcess
      arguments:
          position : { type: t_double, comment: "New position value in degrees" }

  
  
MTCS_MAKE_INTERFACE
^^^^^^^^^^^^^^^^^^^

High-level function to make an interface.

An interface consists only of software variables with a known address (i.e. those specified using the ``address:`` arg).

You can use the ``sys.isInterfacedWith`` relationship to link interface items.

Syntax:

.. code:: coffeescript

   MTCS_MAKE_INTERFACE(typeToMakeAnInterfaceOf, "nameOfTheInterface)

Example:   

.. code:: coffeescript

   mtcs_soft.ADD MTCS_MAKE_INTERFACE(THISLIB.MTCS, "interface")

  
VARIABLE
^^^^^^^^^^^^^^

Low-level macro to instantiate a variable.

Syntax:

.. code:: coffeescript
 
   VARIABLE(args) "nameOfVariable"

Args:

- ``type``: (OPTIONAL) the type of the software variable (e.g. ``type: t_bool`` or ``type: COMMONLIB.Temperature``).
- ``pointsToType``: (OPTIONAL) if the variable is a pointer, then it doesn't use the ``type`` argument but the ``pointsToType`` argument (e.g. ``pointsToType: t_bool`` or ``pointsToType: COMMONLIB.Temperature``).
- ``comment``: (OPTIONAL) a string, some description
- ``realizes``: (OPTIONAL): (only used to link the software model to the systems model, to indicate that some software variable realizes a system concept)
- ``expand``: (OPTIONAL) use ``expand: true`` to expand the variable into all it's sub-variables (slow), or use ``expand: false`` to not expand the variable (fast, but impossible to reference a sub-variable in the remainder of the model).
- ``initial``: (OPTIONAL) initial value of the variable, assigned in the declaration. Example: ``initial: double(2.0)``, or ``initial: int(10)``, or ``initial: bool(false)``...
- ``attributes``: (OPTIONAL) sub-variables (actually: ATTRIBUTE_ instances) of the variable. Attributes cannot be assigned when the variable would be a callable that is called. The argument of ``attributes`` is a dictionary of ATTRIBUTE_ instances, where the keys are the name of the attributes and the values are the args of the attributes.          
- ``arguments``: (OPTIONAL) sub-variables (actually: ARGUMENT_ instances) of the variable. Arguments are only part of *callable* variables (e.g. methods, functions, function blocks, ...), they can be assigned when the variable is called. The argument of ``arguments`` is a dictionary of ARGUMENT_ instances, where the keys are the name of the arguments and the values are the args of the arguments.  
- ``qualifiers``: (OPTIONAL) qualifiers are special properties of variables for the compiler or the run-time system, e.g. to notify the run-time system that particular variables must be exposed with read/write access over the network. E.g. ``qualifiers: [beckhoff.OPC_UA_ACTIVATE, beckhoff.OPC_UA_ACCESS_RW]``.
- ``address``: (OPTIONAL) memory address of the variable (e.g. ``address: "%I*"`` in IEC 61131-3).

    
Example:

.. code:: coffeescript

  VARIABLE(
    type : DOMELIB.Dome
    comment: "The dome"
    expand: false
    arguments:
        operatorStatus          : { type: COMMONLIB.OperatorStatus          , expand: false }
        safetyDomeAccess        : { type: SAFETYLIB.SafetyDomeAccess        , expand: false }
    attributes:
        isTracking              : { type: t_bool , comment: "True if the dome is tracking"  }
        parts:
            attributes:
                shutter:
                    attributes:
                        statuses:
                            attributes:
                                apertureStatus: { type: COMMONLIB.ApertureStatus }
        statuses:
            attributes:
                poweredStatus   : { type: COMMONLIB.PoweredStatus }
                healthStatus    : { type: COMMONLIB.HealthStatus }
                busyStatus      : { type: COMMONLIB.BusyStatus }
        processes:
            attributes:
                startTracking   : { type: COMMONLIB.Process }
     ) "dome"
  
  
ATTRIBUTE
^^^^^^^^^^^^^^

Low-level macro to instantiate an attribute.

An attribute is a "sub-variable" of another variable.

Syntax:

.. code:: coffeescript
 
   ATTRIBUTE(args) "nameOfAttribute"

Args: the exact same arguments as VARIABLE_.

Example: see VARIABLE_.
  
  
ARGUMENT
^^^^^^^^^^^^^^

Low-level macro to instantiate an argument of a callable (a method, a function, a function block, ...).

Syntax:

.. code:: coffeescript
 
   ARGUMENT(args) "nameOfArgument"

Args: the exact same arguments as VARIABLE_.

Example: see VARIABLE_.
  

GLOBAL_VARIABLE
^^^^^^^^^^^^^^^^^

Low-level macro to instantiate a global variable. Global variables can be referred to "directly" since they are in the global namepace.

Syntax:

.. code:: coffeescript
 
   GLOBAL_VARIABLE(args) "nameOfGlobalVariable"

Args: the exact same arguments as VARIABLE_.

Example: see VARIABLE_.
  


POINTER
^^^^^^^^^^^^^^

Low-level macro to instantiate a pointer.

Syntax:

.. code:: coffeescript
 
   POINTER(args) "nameOfPointer"

Args:

- ``type``: (OPTIONAL) the type of the variable to which the pointer points (e.g. ``type: t_bool`` or ``type: COMMONLIB.Temperature``).
- ``to``: (OPTIONAL) the variable to which the pointer points to.
    
Example:

.. code:: coffeescript

  POINTER(type : t_double, to: self.velocity) "pVelocity"

  
IMPLEMENTATION
^^^^^^^^^^^^^^^^

Low-level macro to create an implementation (a list of expressions).

Syntax:

.. code:: coffeescript
 
   IMPLEMENTATION(args) "nameOfImplementation"
  
Args: a list of expressions (or a list of lists of expressions).

Example:

.. code:: coffeescript
  
  IMPLEMENTATION(
    [
        ASSIGN(self.mass     , 12.3)
        ASSIGN(self.velocity , 100.5)
        ASSIGN(self.energy   , CALL( 
                                 calls: self.calculateEnergy
                                 assigns:
                                    mass     : self.mass
                                    velocity : self.velocity   ) "call0" )                   
    ]
  ) "methodImplementation"
  
  
IF_THEN
^^^^^^^^^^^^^^^^

Low-level macro to create an if-then instruction.

Syntax:

.. code:: coffeescript
 
   IF_THEN(args) "nameOfInstruction"
  
Args:

- ``if``: an expression
- ``then``: an IMPLEMENTATION_ instance or a list of expressions (which will be converted into an IMPLEMENTATION_ instance)
- ``else``: (OPTIONAL): an IMPLEMENTATION_ instance or a list of expressions (which will be converted into an IMPLEMENTATION_ instance)

Example:

.. code:: coffeescript
  
  IF_THEN(
    if: GT(self.velocity, 50.0)
    then: [
      ASSIGN(self.message, "high speed")
      ASSIGN(self.warningLevel, 3)
    ]
    else: [
      ASSIGN(self.message, "low speed")
    ]
  ) "instruction_5"
  

NAMESPACE
^^^^^^^^^^^^^^^^

Low-level macro to create a namespace.

Syntax:

.. code:: coffeescript
 
   NAMESPACE() "nameOfNamespace"

Args: none


LIBRARY
^^^^^^^^^^^^^^^^

Low-level macro to create a library.

Syntax:

.. code:: coffeescript
 
   LIBRARY() "nameOfLibrary"

Args: none



ENUMERATION
^^^^^^^^^^^^^^^^

Low-level macro to create an enumeration.

Syntax:

.. code:: coffeescript
 
   ENUMERATION(args) "nameOfEnumeration"
  
Args:

- ``comment``: (OPTIONAL) a description string of the enumeration
- ``containedBy``: (OPTIONAL) a reference to the namespace or library which contains the enumeration (e.g. ``containedBy: common_soft.mtcs_common`` or ``containedBy: COMMONLIB``).
- ``type``: (OPTIONAL): type of the enumeration. Most enumerations get a default type (an integer) but in some programming languages you can give a specific one, e.g. ``type: t_int32``.
- ``items``: a list of strings that will be converted into ENUMERATION_ITEM_ instances, in the correct order.

Example:

.. code:: coffeescript
  
  ENUMERATION(
    comment: "Quantity value units"
    containedBy: COMMONLIB
    items: [
      "DEGREES_CELSIUS",
      "NEWTONMETERS",
      "SECONDS"
    ]
  ) "units"


ENUMERATION_ITEM
^^^^^^^^^^^^^^^^

Low-level macro to create an enumeration item.

Syntax:

.. code:: coffeescript
 
   ENUMERATION_ITEM(args) "nameOfEnumerationItem"
  
Args:

- ``comment``: (OPTIONAL) a description string of the enumeration item

Example:

.. code:: coffeescript
  
  ENUMERATION_ITEM(comment: "Seconds of time") "SECONDS"

  


CALL
^^^^^^^^^^^^^^^^

Low-level macro to create a call instruction (e.g. call a method). Often contained by an IMPLEMENTATION_.

Syntax:

.. code:: coffeescript
 
   CALL(args) "nameOfTheInstruction"
  
Args:

- ``calls``: the callable (method, function block instance, ...) to call
- ``assigns``: assignments of the arguments, as a dictionary of *key:value* pairs where the *key* is the name of the argument that must be assigned, and the *value* is the expression to which the argument is assigned (see example).

Example:

.. code:: coffeescript
  
  CALL(calls: self.calculateMass,
       assigns:
          volume         : POW(self.lengthOfCube, 3)
          massPerVolume  : self.massPerVolume
    ) "instruction_6"

    
PLC_FB
^^^^^^^^^^^^^^^^

Low-level macro to create an IEC 61131-3 function block.

Syntax:

.. code:: coffeescript
 
   PLC_FB(args) "nameOfTheFunctionBlock"
  
Args:

- ``containedBy``: (OPTIONAL) the namespace or library which contains this function block.
- ``typeOf``: (OPTIONAL) a variable, or a list of variables, which have this function block as their type.  E.g. ``typeOf: THISLIB.DomeParts.shutter`` or ``typeOf: [THISLIB.AxesParts.azi.velocity, THISLIB.AxesParts.ele.velocity]``.
- ``extends``: (OPTIONAL) reference to the super-function block, e.g. ``extends: THISLIB.BaseAxis``. The super-function block can be accessed in the remainder of the code via a ``SUPER`` pointer attribute which will automatically be created.
- ``comment``: (OPTIONAL) a description string of the function block
- ``in``: (OPTIONAL) input variables of the function block, as a dictionary of *key:value* pairs where *key* is the name of the variable and *value* is the arguments of the variable (see example).
- ``out``: (OPTIONAL) output variables of the function block, as a dictionary of *key:value* pairs where *key* is the name of the variable and *value* is the arguments of the variable (see example).
- ``inout``: (OPTIONAL) input/output variables of the function block, as a dictionary of *key:value* pairs where *key* is the name of the variable and *value* is the arguments of the variable (see example).

Example:

.. code:: coffeescript
  
  PLC_FB(
    comment: "The dome"
    containedBy: THISLIB
    extends: COMMONLIB.GenericComponent
    in:
        doTracking : { type: t_bool                    , comment: "True if the dome must be tracking" }
        doStop     : { type: t_bool                    , comment: "True if the dome must be stopped" }
    inout:
        setPos     : { type: COMMONLIB.AngularPosition , comment: "Setpoint position" }
    out:
        isTracking : { type: t_bool                    , comment: "True if the dome is tracking" }
    ) "FB_Dome"

    
PLC_OPEN_ATTRIBUTE
^^^^^^^^^^^^^^^^^^^

Low-level macro to create an IEC 61131-3 attribute of a variable.

Syntax:

.. code:: coffeescript
 
   PLC_OPEN_ATTRIBUTE(args) "nameOfAttribute"
  
Args:

- ``symbol``: (OPTIONAL) a string, the symbol name.
- ``value``: (OPTIONAL) a string, the value of the attribute

Example:

.. code:: coffeescript
  
  PLC_OPEN_ATTRIBUTE(symbol: 'OPC.UA.DA', value: '1') "OPC_UA_ACTIVATE"
    

    
PLC_STRUCT
^^^^^^^^^^^^^^^^

Low-level macro to create an IEC 61131-3 struct.

Syntax:

.. code:: coffeescript
 
   PLC_STRUCT(args) "nameOfTheStruct"
  
Args:

- ``containedBy``: (OPTIONAL) the namespace or library which contains this function block.
- ``typeOf``: (OPTIONAL) a variable, or a list of variables, which have this function block as their type.  E.g. ``typeOf: THISLIB.DomeParts.shutter`` or ``typeOf: [THISLIB.AxesParts.azi.velocity, THISLIB.AxesParts.ele.velocity]``.
- ``comment``: (OPTIONAL) a description string of the function block
- ``label``: (OPTIONAL) the name of the struct when it will be generated as source code. Only use this argument if this name must be different than the "nameOfTheStruct" in the above syntax.
- ``items``: the items (in fact: ATTRIBUTE_ instances) of the struct, as a dictionary of *key:value* pairs where *key* is the name of the ATTRIBUTE_ and *value* is the args of the ATTRIBUTE_.


Example:

.. code:: coffeescript
  
  PLC_STRUCT(
    comment: "The dome config"
    containedBy: THISLIB
    items:
        maxTrackingDistance   : { type: t_double , comment: "Maximum tracking distance, in degrees" }
        trackingCycleDuration : { type: t_double , comment: "Duration of the tracking cycle, in sec." }
    ) "DomeConfig"

    
PLC_METHOD
^^^^^^^^^^^^^^^^

Low-level macro to create an IEC 61131-3 method of a function block.

Syntax:

.. code:: coffeescript
 
   PLC_METHOD(args) "nameOfTheMethod"
  
Args:

- ``comment``: (OPTIONAL) a description string of the function block
- ``inputArgs``: the input variables (in fact: VAR_IN_ instances) of the method, as a dictionary of *key:value* pairs where *key* is the name of the VAR_IN_ and *value* is the args of the VAR_IN_.
- ``inOutArgs``: the input/output variables (in fact: VAR_IN_OUT_ instances) of the method, as a dictionary of *key:value* pairs where *key* is the name of the VAR_IN_OUT_ and *value* is the args of the VAR_IN_OUT_.
- ``localArgs``: the local variables (in fact: VAR_ instances) of the method, as a dictionary of *key:value* pairs where *key* is the name of the VAR_ and *value* is the args of the VAR_.
- ``returnType``: the type of the return value of the method (can be a primitive, a function block, ...).
- ``implementation``: the args for the IMPLEMENTATION_ of the method (see args description of IMPLEMENTATION_).

Example:

.. code:: coffeescript
  
  PLC_METHOD(
    comment: "Calculate the mass (returns TRUE if input arguments were within bounds)."
    returnType: t_bool
    inputArgs:
        volume        : { type: t_double , comment: "The volume, in m^3" }
        massPerVolume : { type: t_double , comment: "The mass per volume, in kg/m^3" }
    implementation: 
       [
          ASSIGN($.mass, MUL(self.volume, self.massPerVolume))
       ]
    ) "calculateMass"


    
PLC_DEREFERENCE
^^^^^^^^^^^^^^^^

Low-level macro to create a dereference of an IEC 61131-3 pointer. This macro shouldn't be used directly, it's easier to use the ``PLC_DEREF`` operation.

Syntax:

.. code:: coffeescript
 
   PLC_DEREFERENCE(args) "nameOfTheInstruction"
  
Args:

- ``operand``: (OPTIONAL) the pointer to dereference.

Example:

.. code:: coffeescript
  
  PLC_DEREFERENCE(operand: self.pointerToVelocity) "instruction_7"

    
VAR
^^^^^^^^^^^^^^^^

Low-level macro to create an IEC 61131-3 local variable.

Syntax:

.. code:: coffeescript
 
   VAR(args) "nameOfTheVariable"
  
Args: same as the args of VARIABLE_

Example:

.. code:: coffeescript
  
  VAR(type: THISLIB.FB_DomeShutter) "shutter"


VAR_IN
^^^^^^^^^^^^^^^^

Similar to VAR_, only this is an *input* variable.


VAR_OUT
^^^^^^^^^^^^^^^^

Similar to VAR_, only this is an *output* variable.


VAR_IN_OUT
^^^^^^^^^^^^^^^^

Similar to VAR_, only this is an *input/output* variable.




  
.. _softwarefactories: coffee/models/util/softwarefactories.coffee
.. _ontoscript: https://github.com/IvS-KULeuven/Ontoscript

