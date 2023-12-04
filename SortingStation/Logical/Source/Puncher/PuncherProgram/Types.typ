
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
		WAITING_INIT,
		MANUAL,
		WAITING_START, (*WAITING state*)
		HOMING,
		POWER_ON, (*INIT state*)
		INIT,
		ACTIVATE_CAM,
		WAITING_CAP,
		PUNCH_FORWARD,
		PUNCHING,
		PUNCH_BACKWARD,
		ERROR (*ERROR state*)
		);
	InternalType : 	STRUCT 
		Axis : MpAxisBasic;
		Parameters : MpAxisBasicParType;
		Cam : MC_BR_CamAutomatCommand;
		Offset : MC_BR_Offset;
		LastOffset : LREAL;
		CamStartTrigger : BOOL;
		Error : BOOL;
		OffsetToDo : BOOL;
	END_STRUCT;
END_TYPE
