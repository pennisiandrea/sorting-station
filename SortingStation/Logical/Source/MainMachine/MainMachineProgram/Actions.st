ACTION FeedbacksUpdateAction: 
	
	gMainMachine.Feedbacks.WaitingInit := MachineState.ActualState = AUTO_WAITING_INIT; 
	
	gMainMachine.Feedbacks.Initializing := MachineState.ActualState = AUTO_INITIALIZING; 
	
	gMainMachine.Feedbacks.WaitingStart := MachineState.ActualState = AUTO_WAITING_START; 
	
	gMainMachine.Feedbacks.WaitingModulesReady := MachineState.ActualState = AUTO_WAITING_MODULES_READY; 
	
	gMainMachine.Feedbacks.PunchingCap := MachineState.ActualState = AUTO_DELIVERING_AND_PUNCHING_CAP AND gPuncher.Commands.Automatic.Start; 
	
	gMainMachine.Feedbacks.WaitingCap := MachineState.ActualState = AUTO_WAITING_CAP; 

	gMainMachine.Feedbacks.DeliveringCap := MachineState.ActualState = AUTO_DELIVERING_AND_PUNCHING_CAP; 
	
	gMainMachine.Feedbacks.SortingCap := MachineState.ActualState = AUTO_SORTING_CAP; 
	
	gMainMachine.Feedbacks.Error := MachineState.ActualState = ERROR;
	
	gMainMachine.Feedbacks.WaitModeSelection := MachineState.ActualState = WAITING_MODE_SELECTION;
	
	gMainMachine.Feedbacks.Stopping := gMainMachine.Feedbacks.Started AND Internal.OnPhaseStopRequest;
	
	gMainMachine.Feedbacks.ManualMode := (MachineState.ActualState = MANUAL);
	
	gMainMachine.Feedbacks.AutomaticMode := NOT gMainMachine.Feedbacks.ManualMode AND NOT gMainMachine.Feedbacks.WaitModeSelection AND NOT gMainMachine.Feedbacks.Error;
	
	IF gMainMachine.Commands.LinkMode THEN
		gMainMachine.Feedbacks.CapsOnConveyor := gConveyor.Feedbacks.CapsOnConveyor + gPickingStation.Outputs.CapsOnConveyor;
	ELSE
		gMainMachine.Feedbacks.CapsOnConveyor := gConveyor.Feedbacks.CapsOnConveyor;
	END_IF
		
	IF gMainMachine.Commands.Automatic.Init AND gMainMachine.Feedbacks.CapsOnConveyor > 0 THEN
		gMainMachine.Feedbacks.AskRemoveCaps := TRUE;
	ELSIF gMainMachine.Commands.Automatic.CapsRemoved THEN
		gMainMachine.Feedbacks.AskRemoveCaps := FALSE;
	END_IF
	
	// Started
	IF (MachineState.ActualState = AUTO_WAITING_MODULES_READY)
		OR (MachineState.ActualState = AUTO_WAITING_CAP)
		OR (MachineState.ActualState = AUTO_DELIVERING_AND_PUNCHING_CAP)
		OR (MachineState.ActualState = AUTO_SORTING_CAP) THEN
	
		gMainMachine.Feedbacks.Started := TRUE;
	ELSE
		gMainMachine.Feedbacks.Started := FALSE;
	END_IF
	
	IF NOT gMainMachine.Feedbacks.Started THEN
		gMainMachine.Feedbacks.NewCapOnWork := FALSE;
	END_IF
END_ACTION

ACTION MachineStateManagementAction: 

    // Machine state timeout check
    MachineState.TimeoutTimer(IN := MachineState.TimeoutTimer.PT <> T#0S AND NOT MachineState.NewTriggerState);
      
	// Machine state change state logic
	MachineState.NewTriggerState := (MachineState.ActualState <> MachineState.NextState);
	IF MachineState.NewTriggerState THEN
		MachineState.OldState := MachineState.ActualState;
	END_IF
	MachineState.ActualState := MachineState.NextState;

END_ACTION

ACTION SetAlarmsAction:      
	
	//Timeouts
	IF MachineState.TimeoutTimer.Q THEN
        
		// Throw here timeout alarms
		CASE MachineState.ActualState OF
			AUTO_INITIALIZING: MpAlarmXSet(gAlarmXCoreMpLink,'MainMachineInitializationTimeout'); // Edge alarm!
			AUTO_SORTING_CAP: MpAlarmXSet(gAlarmXCoreMpLink,'MainMachineCapMissing'); // Edge alarm!
			AUTO_DELIVERING_AND_PUNCHING_CAP: MpAlarmXSet(gAlarmXCoreMpLink,'MainMachineCapMissing'); // Edge alarm!
		END_CASE
		
		MachineState.NextState := ERROR;		
	END_IF 
	
	//MainMachineEmergencyCircuitInterrupted
	IF FALSE THEN
		MpAlarmXSet(gAlarmXCoreMpLink,'MainMachineEmergencyCircuitInterrupted'); // Persistent alarm
	ELSE
		MpAlarmXReset(gAlarmXCoreMpLink,'MainMachineEmergencyCircuitInterrupted'); // Persistent alarm
	END_IF
	
	//MainMachineCommunicationLost
	IF NOT Internal.PickingStationCommunicationOk AND gMainMachine.Commands.LinkMode THEN
		MpAlarmXSet(gAlarmXCoreMpLink,'MainMachineCommunicationLost');
	ELSE
		MpAlarmXReset(gAlarmXCoreMpLink,'MainMachineCommunicationLost');
	END_IF
	
	//MainMachinePickingStationInError
	IF EDGEPOS(gPickingStation.Outputs.Error) AND gMainMachine.Commands.LinkMode AND gAlarms.Feedbacks.Pendings = 0 THEN
		MpAlarmXSet(gAlarmXCoreMpLink,'MainMachinePickingStationInError');
	END_IF
	
	//MainMachinePickingStationNotInLinkMode
	IF gMainMachine.Commands.LinkMode 
		AND NOT gPickingStation.Outputs.LinkActive 
		AND MachineState.ActualState <> MANUAL 
		AND MachineState.ActualState <> ERROR
		AND MachineState.ActualState <> WAITING_MODE_SELECTION
		AND MachineState.ActualState <> AUTO_WAITING_INIT THEN
		MpAlarmXSet(gAlarmXCoreMpLink,'MainMachinePickingStationNotInLinkMode');
	ELSE
		MpAlarmXReset(gAlarmXCoreMpLink,'MainMachinePickingStationNotInLinkMode');
	END_IF
	
END_ACTION

ACTION PickingStationCommunication: 
	
	// Send communication heart beat to picking station
	Internal.HeartBeatTimer(IN:=NOT Internal.HeartBeatTimer.Q);
	IF Internal.HeartBeatTimer.Q THEN
		gPickingStation.Inputs.HeartBeat := NOT gPickingStation.Inputs.HeartBeat;
	END_IF
      
	// Check communication heart beat from the slave
	IF EDGE(gPickingStation.Outputs.HeartBeat) THEN
		Internal.CommunicationTimeoutTimer.IN := FALSE;
		CommunicationInitialized := TRUE;
	ELSE
		Internal.CommunicationTimeoutTimer.IN := TRUE;			
		IF Internal.CommunicationTimeoutTimer.Q THEN
			CommunicationInitialized := TRUE;
		END_IF
		
	END_IF
	
	Internal.CommunicationTimeoutTimer();
	
	Internal.PickingStationCommunicationOk := NOT Internal.CommunicationTimeoutTimer.Q AND CommunicationInitialized;
	gMainMachine.Feedbacks.LinkOk := Internal.PickingStationCommunicationOk;
	
END_ACTION

ACTION EnableModules:
		
	gColourSorter.Commands.Enable := TRUE;
	
	gConveyor.Commands.Enable := TRUE;
	
	gPuncher.Commands.Enable := TRUE;	
	
END_ACTION

ACTION StopModules:
		
	gColourSorter.Commands.Manual.Enable := FALSE;
	gColourSorter.Commands.Automatic.Start := FALSE;
	gColourSorter.Commands.Automatic.Init := FALSE;
	gColourSorter.Commands.Reset := FALSE;
	
	gConveyor.Commands.Manual.Enable := FALSE;
	gConveyor.Commands.Automatic.Start := FALSE;
	gConveyor.Commands.Automatic.Init := FALSE;
	gConveyor.Commands.Reset := FALSE;
	gConveyor.Commands.Automatic.DecreaseCapCounter := FALSE;
	
	gPuncher.Commands.Manual.Enable := FALSE;
	gPuncher.Commands.Automatic.Start := FALSE;
	gPuncher.Commands.Automatic.Init := FALSE;
	gPuncher.Commands.Reset := FALSE;
	gPuncher.Commands.Automatic.PunchCap := FALSE;		
	
	gPickingStation.Inputs.Start := FALSE;
	gPickingStation.Inputs.Init := FALSE;
	gPickingStation.Inputs.Reset := FALSE;
	
END_ACTION

ACTION ResetModulesManualCommands:
	
	memset(ADR(gColourSorter.Commands.Manual),0,SIZEOF(gColourSorter.Commands.Manual));
	memset(ADR(gPuncher.Commands.Manual),0,SIZEOF(gPuncher.Commands.Manual));
	memset(ADR(gConveyor.Commands.Manual),0,SIZEOF(gConveyor.Commands.Manual));
		
END_ACTION

ACTION ResetModules:
	
	gColourSorter.Commands.Reset := TRUE;	
	gConveyor.Commands.Reset := TRUE;	
	gPuncher.Commands.Reset := TRUE;
	gPickingStation.Inputs.Reset := TRUE;		
	
END_ACTION

ACTION InitModules:
	
	gColourSorter.Commands.Automatic.Init := TRUE;	
	gConveyor.Commands.Automatic.Init := TRUE;	
	gPuncher.Commands.Automatic.Init := TRUE;	
	gPickingStation.Inputs.Init := TRUE;		
	
END_ACTION

ACTION StartModules:
	
	gColourSorter.Commands.Automatic.Start := TRUE;	
	gConveyor.Commands.Automatic.Start := TRUE;	
	gPuncher.Commands.Automatic.Start := gMainMachine.Parameters.PuncherEnable;	
	gPickingStation.Inputs.Start := TRUE;		
	
END_ACTION

ACTION StatisticsAction: 
	
	// Stats clear
	IF gMainMachine.Commands.ClearStats THEN
		memset(ADR(CapsWorkingTimeHistory),0,SIZEOF(CapsWorkingTimeHistory));
		gMainMachine.Statistics.CapsCounter := 0;
		gMainMachine.Feedbacks.ClearStatsDone := TRUE;
		CapWorkStopwatch.IN := FALSE;
	ELSE
		gMainMachine.Feedbacks.ClearStatsDone := FALSE;
	END_IF
	
	// Manage the stopwatch to measure the current cap working time
	IF EDGE(gMainMachine.Feedbacks.NewCapOnWork) THEN
		IF gMainMachine.Feedbacks.NewCapOnWork THEN
			gMainMachine.Statistics.CapsCounter := gMainMachine.Statistics.CapsCounter + 1;
			CapWorkStopwatch.IN := TRUE;	
		ELSE
			CapWorkStopwatch.IN := FALSE;
			memmove(ADR(CapsWorkingTimeHistory[1]),ADR(CapsWorkingTimeHistory[0]),SIZEOF(CapsWorkingTimeHistory)-SIZEOF(CapsWorkingTimeHistory[0]));
			CapsWorkingTimeHistory[0] := CapWorkStopwatch.ET;
		END_IF
	END_IF	
	
	CapWorkStopwatch();	
		
	// Calc the total amount of time stored in the history array
	TotHistoryWorkedTime := T#0S;
	FOR Index:=0 TO STATS_HISTORY_MAX_INDEX DO
		IF CapsWorkingTimeHistory[Index]>T#0s THEN
			TotHistoryWorkedTime := TotHistoryWorkedTime + CapsWorkingTimeHistory[Index];
		ELSE
			EXIT;
		END_IF
	END_FOR
	
	gMainMachine.Statistics.CurrentCapWorkingTime := CapWorkStopwatch.ET; 
	gMainMachine.Statistics.LastCapWorkingTime := CapsWorkingTimeHistory[0];
	gMainMachine.Statistics.AverageCapWorkingTime := UDINT_TO_TIME(TIME_TO_UDINT(TotHistoryWorkedTime)/MAX(1,Index));
END_ACTION

ACTION PickingStationAction: 
		
	gPickingStation.Inputs.AutomaticMode := gMainMachine.Feedbacks.AutomaticMode;
	
	gPickingStation.Inputs.Error := gMainMachine.Feedbacks.Error;
	
	IF NOT gMainMachine.Commands.Automatic.Start THEN				
		IF gMainMachine.Commands.LinkMode AND gPickingStation.Outputs.Started THEN
			gPickingStation.Inputs.Start := FALSE;
		END_IF
	END_IF
END_ACTION