
TYPE
	MachineStateType : 	STRUCT  (*Machine state main type*)
		OldState : MachineStateEnum; (*Actual state*)
		ActualState : MachineStateEnum; (*Actual state*)
		NextState : MachineStateEnum; (*Next state*)
		NewTriggerState : BOOL; (*Trigger state change*)
		TimeoutTimer : TON; (*State timeout*)
	END_STRUCT;
	MachineStateEnum : 
		( (*Machine State enumeration*)
		WAITING_INIT, (*WAITING state*)
		MANUALS,
		WAITING_START,
		HOMING,
		POWER_ON,
		INIT,
		MOTION,
		ERROR (*ERROR state*)
		);
	InternalType : 	STRUCT 
		Axis : MpAxisBasic;
		Parameters : MpAxisBasicParType;
		Error : BOOL;
	END_STRUCT;
END_TYPE
