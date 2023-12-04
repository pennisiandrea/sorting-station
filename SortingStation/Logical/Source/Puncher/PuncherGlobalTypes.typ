
TYPE
	PuncherType : 	STRUCT  (*Puncher Main type*)
		Commands : PuncherCommadsType;
		Feedbacks : PuncherFeedbacksType;
		Parameters : PuncherParametersType;
		Interface : PuncherInterfaceType;
	END_STRUCT;
	PuncherCommadsType : 	STRUCT  (*Puncher Commands type*)
		Enable : BOOL;
		Reset : BOOL;
		Automatic : PuncherAutomaticCommadsType;
		Manual : PuncherManualCommadsType;
	END_STRUCT;
	PuncherFeedbacksType : 	STRUCT  (*Puncher Feedbacks type*)
		Enabled : BOOL;
		WaitingStart : BOOL;
		Error : BOOL;
		OnSyncMotion : BOOL;
		WaitingCap : BOOL;
		PunchCapDone : BOOL;
		InitDone : BOOL;
		InitPosition : BOOL;
		AxisSpeed : REAL;
		AxisPosition : LREAL;
		AxisHomed : BOOL;
		AxisPowered : BOOL;
	END_STRUCT;
	PuncherParametersType : 	STRUCT  (*Puncher Parameters type*)
		Offset : REAL := 65;
		Speed : REAL := 10000;
		Acceleration : REAL := 20000;
	END_STRUCT;
	PuncherInterfaceType : 	STRUCT  (*Puncher Interface type*)
		Inputs : PuncherInterfaceInputsType;
		Outputs : PuncherInterfaceOutputsType;
	END_STRUCT;
	PuncherInterfaceOutputsType : 	STRUCT  (*Puncher Interface Output type*)
		PunchForward : BOOL;
		SetPosition : LREAL;
	END_STRUCT;
	PuncherInterfaceInputsType : 	STRUCT  (*Puncher Interface Input type*)
		ActualPosition : REAL;
		PunchIsForward : BOOL;
		PunchIsBackward : BOOL;
	END_STRUCT;
	PuncherAutomaticCommadsType : 	STRUCT  (*Puncher Commands type*)
		Start : BOOL;
		Init : BOOL;
		PunchCap : BOOL;
	END_STRUCT;
	PuncherManualCommadsType : 	STRUCT  (*Puncher Commands type*)
		Enable : BOOL;
		PuncherForward : BOOL;
		Position : LREAL;
		Speed : REAL := 50;
		PowerOn : BOOL;
		Move : BOOL;
		Home : BOOL;
	END_STRUCT;
END_TYPE
