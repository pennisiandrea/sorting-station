
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
		WAITING_MODE_SELECTION,
		MANUAL,
		AUTO_WAITING_INIT,
		AUTO_INITIALIZING,
		AUTO_WAITING_START,
		AUTO_WAITING_MODULES_READY,
		AUTO_WAITING_CAP,
		AUTO_DELIVERING_AND_PUNCHING_CAP,
		AUTO_SORTING_CAP,
		AUTO_WAITING_PICKUP_STATION_STOP,
		ERROR (*ERROR state*)
		);
	InternalType : 	STRUCT 
		HeartBeatTimer : TON := (PT:=T#250MS);
		CommunicationTimeoutTimer : TON := (PT:=T#3S);
		PickingStationCommunicationOk : BOOL;
		OnPhaseStopRequest : BOOL;
		Error : BOOL;
		LastCapCounter : USINT;
	END_STRUCT;
END_TYPE
