ACTION FeedbacksUpdateAction: 

    gPuncher.Feedbacks.Enabled := TRUE;
    gPuncher.Feedbacks.WaitingStart := (MachineState.ActualState = WAITING_START); 
	gPuncher.Feedbacks.Error := (MachineState.ActualState = ERROR);
	gPuncher.Feedbacks.OnSyncMotion := Internal.Cam.InCam;
	gPuncher.Feedbacks.WaitingCap := (Internal.Cam.ActualStateIndex = 0) AND (MachineState.ActualState = WAITING_CAP);	
	gPuncher.Feedbacks.InitPosition := ABS(Internal.Axis.Position - Internal.Parameters.Position)<0.1;
	gPuncher.Feedbacks.InitDone := gPuncher.Feedbacks.InitPosition AND gPuncher.Commands.Automatic.Init;
	gPuncher.Feedbacks.AxisHomed := Internal.Axis.IsHomed;	
	gPuncher.Feedbacks.AxisPowered := Internal.Axis.PowerOn;
	gPuncher.Feedbacks.AxisSpeed := Internal.Axis.Velocity;
	gPuncher.Feedbacks.AxisPosition := Internal.Axis.Position;
	
END_ACTION

ACTION ResetOutputsAction: 

    memset(ADR(gPuncher.Interface.Outputs),0,SIZEOF(gPuncher.Interface.Outputs));

END_ACTION

ACTION ResetFeedbacksAction: 

    memset(ADR(gPuncher.Feedbacks),0,SIZEOF(gPuncher.Feedbacks));

END_ACTION

ACTION ResetMotionCommands:
	Internal.Axis.Power := FALSE;
	Internal.Axis.Home := FALSE;
	Internal.Axis.MoveVelocity := FALSE;
	Internal.Axis.MoveAbsolute := FALSE;
	
	Internal.Cam.Enable := FALSE;
	Internal.Cam.Start := FALSE;
	
	Internal.Offset.Enable := FALSE;
	Internal.Offset.StartShift := FALSE;
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
	
	IF gPuncher.Commands.Reset THEN
		Internal.Error := FALSE;
	END_IF
	
	IF MachineState.TimeoutTimer.Q THEN
        
		CASE MachineState.ActualState OF
			HOMING: MpAlarmXSet(gAlarmXCoreMpLink,'PuncherTimeoutHoming'); // Edge alarm!
			POWER_ON: MpAlarmXSet(gAlarmXCoreMpLink,'PuncherTimeoutPowerOn'); // Edge alarm!
			PUNCH_FORWARD: MpAlarmXSet(gAlarmXCoreMpLink,'PuncherTimeoutPunchForward'); // Edge alarm!
			PUNCH_BACKWARD: MpAlarmXSet(gAlarmXCoreMpLink,'PuncherTimeoutPunchBackward'); // Edge alarm!
			ACTIVATE_CAM: MpAlarmXSet(gAlarmXCoreMpLink,'PuncherAxisTimeout'); // Edge alarm!
			PUNCHING: MpAlarmXSet(gAlarmXCoreMpLink,'PuncherAxisTimeout'); // Edge alarm!
		END_CASE

		Internal.Error := TRUE;
		MachineState.NextState := ERROR;		
	END_IF 
	
	IF Internal.Axis.Error OR Internal.Cam.Error OR Internal.Offset.Error THEN
		MpAlarmXSet(gAlarmXCoreMpLink,'PuncherAxisError');
		Internal.Error := TRUE;
		MachineState.NextState := ERROR;
	ELSE
		MpAlarmXReset(gAlarmXCoreMpLink,'PuncherAxisError');
	END_IF
	
	IF gPuncher.Interface.Inputs.PunchIsForward AND gPuncher.Interface.Inputs.PunchIsBackward THEN
		MpAlarmXSet(gAlarmXCoreMpLink,'PuncherInvalidSensorsCombination');
		Internal.Error := TRUE;
		MachineState.NextState := ERROR;
	ELSE
		MpAlarmXReset(gAlarmXCoreMpLink,'PuncherInvalidSensorsCombination');
	END_IF
	
END_ACTION

ACTION ResetAlarmsAction:  
	
	MpAlarmXReset(gAlarmXCoreMpLink,'PuncherInvalidSensorsCombination');
	
END_ACTION   

ACTION OffsetManagement:  
	
	Internal.Offset.Enable := Internal.Axis.Info.PLCopenState = mcAXIS_SYNCHRONIZED_MOTION;
	Internal.Offset.StartShift := (Internal.OffsetToDo OR Internal.LastOffset <> gPuncher.Parameters.Offset) AND Internal.Offset.Valid;
	Internal.LastOffset := gPuncher.Parameters.Offset;
	IF Internal.OffsetToDo AND Internal.Offset.StartShift THEN
		Internal.OffsetToDo := FALSE;
	END_IF
	
END_ACTION  