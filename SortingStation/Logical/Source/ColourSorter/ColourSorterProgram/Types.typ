
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
		MANUALS,
		WAITING_START,
		STOPPER_FORWARD, (*INIT state*)
		SET_LANES, (*WAITING state*)
		WAITING_CAP, (*ERROR state*)
		DETECTING_COLOR,
		STOPPER_BACKWARD,
		WAITING_CAP_EXIT,
		ERROR
		);
	InternalType : 	STRUCT 
		Error : BOOL;
		Lane1ForwardPositionRequest : BOOL;
		Lane2ForwardPositionRequest : BOOL;
		Lane1PositionOk : BOOL;
		Lane2PositionOk : BOOL;
		CapOnProcess : BOOL;
		LaneFullTimeout : TON := (PT:=T#10S);
	END_STRUCT;
END_TYPE
