ACTION FeedbacksUpdateAction: 

	gColourSorter.Feedbacks.Enabled := TRUE;
    gColourSorter.Feedbacks.WaitingCap := MachineState.ActualState = WAITING_CAP; 
    gColourSorter.Feedbacks.Error := MachineState.ActualState = ERROR;		
	gColourSorter.Feedbacks.InitPosition := gColourSorter.Interface.Inputs.Lane1GateBackward AND gColourSorter.Interface.Inputs.Lane2GateBackward;
	gColourSorter.Feedbacks.InitDone := gColourSorter.Feedbacks.InitPosition AND gColourSorter.Commands.Automatic.Init;

END_ACTION

ACTION ResetOutputsAction: 

    memset(ADR(gColourSorter.Interface.Outputs),0,SIZEOF(gColourSorter.Interface.Outputs));
		
END_ACTION

ACTION ResetFeedbacksAction: 

    memset(ADR(gColourSorter.Feedbacks),0,SIZEOF(gColourSorter.Feedbacks));

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
	 
	IF gColourSorter.Commands.Reset THEN
		Internal.Error := FALSE;
	END_IF
	
	// Timeouts alarms
	IF MachineState.TimeoutTimer.Q THEN  
		CASE MachineState.ActualState OF
			SET_LANES: MpAlarmXSet(gAlarmXCoreMpLink,'ColourSorterTimeoutSetLanes'); // Edge alarm!
			WAITING_CAP_EXIT: MpAlarmXSet(gAlarmXCoreMpLink,'ColourSorterMissingCap'); // Edge alarm!
		END_CASE
		Internal.Error := TRUE;		
		MachineState.NextState := ERROR;		
	END_IF
	
	// ColourSorterInvalidSensorsCombinationLane1
	IF gColourSorter.Interface.Inputs.Lane1GateBackward AND gColourSorter.Interface.Inputs.Lane1GateForward THEN
		MpAlarmXSet(gAlarmXCoreMpLink,'ColourSorterInvalidSensorsCombinationLane1'); // Periodic alarm!
		Internal.Error := TRUE;
		MachineState.NextState := ERROR;
	ELSE
		MpAlarmXReset(gAlarmXCoreMpLink,'ColourSorterInvalidSensorsCombinationLane1');
	END_IF
	
	// ColourSorterInvalidSensorsCombinationLane2
	IF gColourSorter.Interface.Inputs.Lane1GateBackward AND gColourSorter.Interface.Inputs.Lane1GateForward THEN
		MpAlarmXSet(gAlarmXCoreMpLink,'ColourSorterInvalidSensorsCombinationLane2'); // Periodic alarm!
		Internal.Error := TRUE;
		MachineState.NextState := ERROR;
	ELSE
		MpAlarmXReset(gAlarmXCoreMpLink,'ColourSorterInvalidSensorsCombinationLane2');
	END_IF
	
	// ColourSorterInvalidParametersCombination
	IF gColourSorter.Parameters.BlackLane < 1 OR gColourSorter.Parameters.BlackLane > 3 
		OR gColourSorter.Parameters.GreyLane < 1 OR gColourSorter.Parameters.GreyLane > 3 
		OR gColourSorter.Parameters.RedLane < 1 OR gColourSorter.Parameters.RedLane > 3
		OR gColourSorter.Parameters.BlackLane = gColourSorter.Parameters.RedLane
		OR gColourSorter.Parameters.BlackLane = gColourSorter.Parameters.GreyLane
		OR gColourSorter.Parameters.GreyLane = gColourSorter.Parameters.RedLane THEN
		
		MpAlarmXSet(gAlarmXCoreMpLink,'ColourSorterInvalidParametersCombination'); // Periodic alarm!
		Internal.Error := TRUE;
		MachineState.NextState := ERROR;
	ELSE
		MpAlarmXReset(gAlarmXCoreMpLink,'ColourSorterInvalidParametersCombination');
	END_IF
	
	// ColourSorterFullLanes
	Internal.LaneFullTimeout(IN:=gColourSorter.Interface.Inputs.CapAtExitPosition);
	IF Internal.LaneFullTimeout.Q THEN
		Internal.Error := TRUE;
		MachineState.NextState := ERROR;
		MpAlarmXSet(gAlarmXCoreMpLink,'ColourSorterFullLanes'); // Periodic alarm!
	ELSE
		MpAlarmXReset(gAlarmXCoreMpLink,'ColourSorterFullLanes');
	END_IF
	
END_ACTION

ACTION ResetAlarmsAction: 
	
	MpAlarmXReset(gAlarmXCoreMpLink,'ColourSorterInvalidSensorsCombinationLane1');
	MpAlarmXReset(gAlarmXCoreMpLink,'ColourSorterInvalidSensorsCombinationLane2');
	MpAlarmXReset(gAlarmXCoreMpLink,'ColourSorterInvalidParametersCombination');
	
END_ACTION
