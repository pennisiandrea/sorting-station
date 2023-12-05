
TYPE
	MainMachineType : 	STRUCT  (*MainMachine Main type*)
		Commands : MainMachineCommadsType;
		Feedbacks : MainMachineFeedbacksType;
		Parameters : MainMachineParametersType;
		Statistics : MainMachineStatisticsType;
	END_STRUCT;
	MainMachineCommadsType : 	STRUCT  (*MainMachine Commands type*)
		LinkMode : BOOL;
		Reset : BOOL;
		ClearStats : BOOL;
		Automatic : MainMachineAutomaticCommadsType;
		Manual : MainMachineManualCommadsType;
	END_STRUCT;
	MainMachineFeedbacksType : 	STRUCT  (*MainMachine Feedbacks type*)
		WaitingStart : BOOL;
		Started : BOOL;
		Stopping : BOOL;
		Error : BOOL;
		AutomaticMode : BOOL;
		LinkOk : BOOL;
		ManualMode : BOOL;
		InitDone : BOOL;
		WaitModeSelection : BOOL;
		WaitingInit : BOOL;
		NewCapOnWork : BOOL;
		ClearStatsDone : BOOL;
		Initializing : BOOL;
		WaitingModulesReady : BOOL;
		PunchingCap : BOOL;
		SortingCap : BOOL;
		DeliveringCap : BOOL;
		WaitingCap : BOOL;
		AskRemoveCaps : BOOL;
		CapsOnConveyor : USINT;
	END_STRUCT;
	MainMachineParametersType : 	STRUCT  (*MainMachine Parameters type*)
		PuncherEnable : BOOL := TRUE;
	END_STRUCT;
	MainMachineStatisticsType : 	STRUCT 
		CapsCounter : UDINT;
		CurrentCapWorkingTime : TIME;
		LastCapWorkingTime : TIME;
		AverageCapWorkingTime : TIME;
	END_STRUCT;
	MainMachineAutomaticCommadsType : 	STRUCT  (*MainMachine Commands type*)
		Enable : BOOL;
		Init : BOOL;
		Start : BOOL;
		CapsRemoved : BOOL;
	END_STRUCT;
	MainMachineManualCommadsType : 	STRUCT  (*MainMachine Commands type*)
		Enable : BOOL;
	END_STRUCT;
END_TYPE
