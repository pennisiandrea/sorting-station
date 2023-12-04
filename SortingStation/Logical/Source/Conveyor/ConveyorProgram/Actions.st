ACTION FeedbacksUpdateAction: 

    gConveyor.Feedbacks.Enabled := TRUE;
    gConveyor.Feedbacks.WaitingStart := MachineState.ActualState = WAITING_START; 
    gConveyor.Feedbacks.Error := MachineState.ActualState = ERROR;
	gConveyor.Feedbacks.WaitingCap := MachineState.ActualState = WAITING_CAP;
	gConveyor.Feedbacks.AxisHomed := Internal.Axis.IsHomed;	
	gConveyor.Feedbacks.AxisPowered := Internal.Axis.PowerOn;	
	gConveyor.Feedbacks.InitPosition := ABS(Internal.Axis.Position - Internal.Parameters.Position)<0.1;
	gConveyor.Feedbacks.InitDone := gConveyor.Feedbacks.InitPosition AND gConveyor.Commands.Automatic.Init;
	gConveyor.Feedbacks.AxisSpeed := Internal.Axis.Velocity;
	gConveyor.Feedbacks.AxisPosition := Internal.Axis.Position;
	gConveyor.Feedbacks.NewCapTrigger := MachineState.ActualState = MOTION;
	
END_ACTION

ACTION ResetOutputsAction: 

	memset(ADR(gConveyor.Interface.Outputs),0,SIZEOF(gConveyor.Interface.Outputs));

END_ACTION

ACTION ResetMotionCommands:
	Internal.Axis.Power := FALSE;
	Internal.Axis.Home := FALSE;
	Internal.Axis.MoveVelocity := FALSE;
	Internal.Axis.MoveAbsolute := FALSE;
END_ACTION

ACTION ResetFeedbacksAction: 

    memset(ADR(gConveyor.Feedbacks),0,SIZEOF(gConveyor.Feedbacks));

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
		 
	IF gConveyor.Commands.Reset THEN
		Internal.Error := FALSE;
	END_IF
	
	IF MachineState.TimeoutTimer.Q THEN
        
		CASE MachineState.ActualState OF
			HOMING: MpAlarmXSet(gAlarmXCoreMpLink,'ConveyorTimeoutHoming'); // Edge alarm!				
			POWER_ON: MpAlarmXSet(gAlarmXCoreMpLink,'ConveyorTimeoutPowerOn'); // Edge alarm!				
			INIT: MpAlarmXSet(gAlarmXCoreMpLink,'ConveyorInitFail'); // Edge alarm!
		END_CASE
		
		Internal.Error := TRUE;
		MachineState.NextState := ERROR;		
	END_IF            

	IF Internal.Axis.Error THEN
		MpAlarmXSet(gAlarmXCoreMpLink,'ConveyorAxisError');
		Internal.Error := TRUE;
		MachineState.NextState := ERROR;
	ELSE
		MpAlarmXReset(gAlarmXCoreMpLink,'ConveyorAxisError');
	END_IF
	
END_ACTION

ACTION ResetAlarmsAction:
	
	MpAlarmXReset(gAlarmXCoreMpLink,'ConveyorAxisError');	
	
END_ACTION