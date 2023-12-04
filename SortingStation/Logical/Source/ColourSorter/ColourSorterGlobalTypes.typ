
TYPE
	ColourSorterType : 	STRUCT  (*ColourSorter Main type*)
		Commands : ColourSorterCommadsType;
		Feedbacks : ColourSorterFeedbacksType;
		Interface : ColourSorterInterfaceType;
		Parameters : ColourSorterParametersType;
	END_STRUCT;
	ColourSorterCommadsType : 	STRUCT  (*ColourSorter Commands type*)
		Enable : BOOL;
		Reset : BOOL;
		Manual : ColourSorterManualCommadsType;
		Automatic : ColourSorterAutomaticCommadsType;
	END_STRUCT;
	ColourSorterFeedbacksType : 	STRUCT  (*ColourSorter Feedbacks type*)
		Enabled : BOOL;
		WaitingCap : BOOL;
		Error : BOOL;
		WaitingStart : BOOL;
		CapSorted : BOOL;
		InitDone : BOOL;
		InitPosition : BOOL;
	END_STRUCT;
	ColourSorterInterfaceType : 	STRUCT  (*ColourSorter Interface type*)
		Inputs : ColourSorterInterfaceInputsType;
		Outputs : ColourSorterInterfaceOutputsType;
	END_STRUCT;
	ColourSorterInterfaceOutputsType : 	STRUCT  (*ColourSorter Interface Output type*)
		StopperForward : BOOL;
		Lane1GateForward : BOOL;
		Lane2GateForward : BOOL;
	END_STRUCT;
	ColourSorterInterfaceInputsType : 	STRUCT  (*ColourSorter Interface Input type*)
		CapAtStartPosition : BOOL;
		ColourIsNotBlack : BOOL;
		ColourIsMetallic : BOOL;
		Lane1GateBackward : BOOL;
		Lane1GateForward : BOOL;
		Lane2GateBackward : BOOL;
		Lane2GateForward : BOOL;
		CapAtExitPosition : BOOL;
	END_STRUCT;
	ColourSorterAutomaticCommadsType : 	STRUCT  (*ColourSorter Commands type*)
		Init : BOOL;
		Start : BOOL;
	END_STRUCT;
	ColourSorterManualCommadsType : 	STRUCT  (*ColourSorter Commands type*)
		Enable : BOOL;
		Lane1Forward : BOOL;
		Lane2Forward : BOOL;
		StopperForward : BOOL;
	END_STRUCT;
	ColourSorterParametersType : 	STRUCT  (*ColourSorter Commands type*)
		GreyLane : USINT := 1;
		RedLane : USINT := 2;
		BlackLane : USINT := 3;
	END_STRUCT;
END_TYPE
