
TYPE
	PickingStationType : 	STRUCT  (*Master Main type*)
		Inputs : PickingStationInputsType;
		Outputs : PickingStationOutputsType;
	END_STRUCT;
	PickingStationInputsType : 	STRUCT  (*Master Feedbacks type*)
		HeartBeat : BOOL;
		Reset : BOOL;
		Error : BOOL;
		ClearStats : BOOL;
		Init : BOOL;
		Start : BOOL;
		AutomaticMode : BOOL;
		StampIncluded : BOOL;
		StampOffset : REAL;
		ConveyorSpeed : REAL;
	END_STRUCT;
	PickingStationOutputsType : 	STRUCT  (*Master Commands type*)
		HeartBeat : BOOL;
		Error : BOOL;
		WaitingStart : BOOL;
		WaitingModeSelection : BOOL;
		WaitingInit : BOOL;
		InitDone : BOOL;
		Started : BOOL;
		ClearStatsDone : BOOL;
		LinkActive : BOOL;
		NewCapArriving : BOOL;
		ActStampIncluded : BOOL;
		ActStampOffset : REAL;
		CapsOnConveyor : USINT;
	END_STRUCT;
END_TYPE
