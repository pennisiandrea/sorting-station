
TYPE
	ConveyorType : 	STRUCT  (*Conveyor Main type*)
		Commands : ConveyorCommadsType;
		Feedbacks : ConveyorFeedbacksType;
		Parameters : ConveyorParametersType;
		Interface : ConveyorInterfaceType;
	END_STRUCT;
	ConveyorCommadsType : 	STRUCT  (*Conveyor Commands type*)
		Enable : BOOL;
		Reset : BOOL;
		Automatic : ConveyorAutomaticCommadsType;
		Manual : ConveyorManualCommadsType;
	END_STRUCT;
	ConveyorFeedbacksType : 	STRUCT  (*Conveyor Feedbacks type*)
		Enabled : BOOL;
		WaitingStart : BOOL;
		Error : BOOL;
		WaitingCap : BOOL;
		InitDone : BOOL;
		AxisHomed : BOOL;
		AxisPowered : BOOL;
		InitPosition : BOOL;
		AxisSpeed : REAL;
		AxisPosition : LREAL;
		NewCapTrigger : BOOL;
	END_STRUCT;
	ConveyorParametersType : 	STRUCT  (*Conveyor Parameters type*)
		TargetSpeed : REAL := 50;
		Acceleration : REAL := 5000;
	END_STRUCT;
	ConveyorInterfaceType : 	STRUCT  (*Conveyor Interface type*)
		Inputs : ConveyorInterfaceInputsType;
		Outputs : ConveyorInterfaceOutputsType;
	END_STRUCT;
	ConveyorInterfaceOutputsType : 	STRUCT  (*Conveyor Interface Output type*)
		SetSpeed : REAL;
	END_STRUCT;
	ConveyorInterfaceInputsType : 	STRUCT  (*Conveyor Interface Input type*)
		CapInStartPosition : BOOL;
	END_STRUCT;
	ConveyorAutomaticCommadsType : 	STRUCT  (*Conveyor Commands type*)
		Start : BOOL;
		Init : BOOL;
		SendTrigger : BOOL;
	END_STRUCT;
	ConveyorManualCommadsType : 	STRUCT  (*Conveyor Commands type*)
		Enable : BOOL;
		PowerOn : BOOL;
		Move : BOOL;
		Home : BOOL;
		Speed : REAL := 50;
	END_STRUCT;
END_TYPE
