PROGRAM _INIT
        
    ResetOutputsAction;
    ResetFeedbacksAction;
    
	Internal.Parameters.Homing.Mode := mcHOMING_DIRECT;
	
	Internal.Offset.AdvancedParameters.ShiftMode := mcSHIFT_ABSOLUTE;
	Internal.Offset.Enable := TRUE;
	
    MachineState.NextState := WAITING_INIT;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	MotionAction;
	
    // Enable module
    IF NOT gPuncher.Commands.Enable THEN
        ResetOutputsAction;
		ResetFeedbacksAction;
		ResetAlarmsAction;	
		ResetMotionCommands;
        RETURN;
    END_IF
    
	IF EDGENEG(gPuncher.Commands.Automatic.Start) THEN
		IF MachineState.NextState <> ERROR THEN
			MachineState.NextState := WAITING_START;
		END_IF
	END_IF
	
	IF EDGEPOS(gPuncher.Commands.Automatic.Init) THEN
		IF MachineState.NextState <> ERROR THEN
			MachineState.NextState := WAITING_INIT;
		END_IF
	END_IF
	
	// Alarms
	SetAlarmsAction;
	
    // Machine state
    MachineStateManagementAction;
    CASE MachineState.ActualState OF
        
		WAITING_INIT:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			IF MachineState.NewTriggerState THEN
				ResetOutputsAction;
				ResetMotionCommands;
				Internal.CamStartTrigger := FALSE;				
			END_IF
			
			IF gPuncher.Commands.Automatic.Init THEN
				MachineState.NextState := HOMING;	
				
			ELSIF gPuncher.Commands.Manual.Enable THEN
				MachineState.NextState := MANUAL;	
				
			END_IF			
		
		MANUAL:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			
			Internal.Parameters.Velocity := gPuncher.Commands.Manual.Speed;
			Internal.Parameters.Position := gPuncher.Commands.Manual.Position;
			
			gPuncher.Interface.Outputs.PunchForward := gPuncher.Commands.Manual.PuncherForward;
			
			Internal.Axis.Home := gPuncher.Commands.Manual.Home AND Internal.Axis.Active AND NOT Internal.Axis.Error;
			IF Internal.Axis.IsHomed THEN			
				Internal.Axis.Power := gPuncher.Commands.Manual.PowerOn AND Internal.Axis.Active AND NOT Internal.Axis.Error;
				IF Internal.Axis.PowerOn THEN		
					Internal.Axis.MoveAbsolute := gPuncher.Commands.Manual.Move AND Internal.Axis.Active AND NOT Internal.Axis.Error;
				ELSE
					Internal.Axis.MoveAbsolute := FALSE;
				END_IF
			ELSE
				Internal.Axis.Power := FALSE;
				Internal.Axis.MoveAbsolute := FALSE;
			END_IF
			
			IF NOT gPuncher.Commands.Manual.Enable THEN
				MachineState.NextState := WAITING_INIT;
			END_IF			
			
		HOMING:
			MachineState.TimeoutTimer.PT := T#3S;
			IF Internal.Axis.IsHomed THEN
				Internal.Axis.Home := FALSE;
				MachineState.NextState := POWER_ON;
			ELSE
				Internal.Axis.Home := Internal.Axis.Active AND NOT Internal.Axis.Error;
			END_IF
					
		POWER_ON:
			MachineState.TimeoutTimer.PT := T#3S;
			
			Internal.Axis.Power := Internal.Axis.Active AND NOT Internal.Axis.Error;
			IF Internal.Axis.PowerOn THEN
				IF gPuncher.Commands.Automatic.Init THEN
					MachineState.NextState := INIT;
				ELSE
					MachineState.NextState := ACTIVATE_CAM;
				END_IF
			END_IF
			
		INIT:
			MachineState.TimeoutTimer.PT := T#15S;
			Internal.Parameters.Position := 0;
			Internal.Axis.MoveAbsolute := Internal.Axis.Active AND NOT Internal.Axis.Error;
			IF Internal.Axis.MoveDone THEN
				Internal.OffsetToDo := TRUE;
				Internal.Axis.MoveAbsolute := FALSE;
				MachineState.NextState := WAITING_START;
			END_IF		
			
        WAITING_START:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state			
			IF MachineState.NewTriggerState THEN
				ResetMotionCommands;
			END_IF
			
			IF gPuncher.Commands.Automatic.Start THEN
				gPuncher.Feedbacks.PunchCapDone := FALSE;
				MachineState.NextState := POWER_ON;				
				
			ELSIF gPuncher.Commands.Manual.Enable THEN
				MachineState.NextState := MANUAL;	
            END_IF
			
		ACTIVATE_CAM:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state		
			Internal.Cam.Enable := TRUE;
			Internal.Cam.Start := TRUE;
			IF Internal.Axis.Info.PLCopenState = mcAXIS_SYNCHRONIZED_MOTION THEN
				MachineState.NextState := WAITING_CAP;
			END_IF			
			
		WAITING_CAP:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state			
			IF gPuncher.Commands.Automatic.PunchCap THEN
				gPuncher.Feedbacks.PunchCapDone := FALSE;
				Internal.CamStartTrigger := TRUE;
				Internal.Parameters.Velocity := gPuncher.Parameters.Speed;
			END_IF
			
			IF Internal.Cam.InCam AND Internal.Cam.ActualStateIndex = 1 THEN // Syncronized motion
				Internal.CamStartTrigger := FALSE;
				MachineState.NextState := PUNCH_FORWARD;
			END_IF
			
		PUNCH_FORWARD:
			MachineState.TimeoutTimer.PT := T#3S;
			
			gPuncher.Interface.Outputs.PunchForward := TRUE;
			IF gPuncher.Interface.Inputs.PunchIsForward THEN
				MachineState.NextState := PUNCHING;
			END_IF
			
		PUNCHING:
			MachineState.TimeoutTimer.PT := T#15S;
			
			IF Internal.Cam.ActualStateIndex <> 1 THEN
				gPuncher.Interface.Outputs.PunchForward := FALSE;
				MachineState.NextState := PUNCH_BACKWARD;
			END_IF
			
		PUNCH_BACKWARD:
			MachineState.TimeoutTimer.PT := T#3S;
			
			IF gPuncher.Interface.Inputs.PunchIsBackward THEN
				gPuncher.Feedbacks.PunchCapDone := TRUE;
				MachineState.NextState := WAITING_CAP;
			END_IF
			
        ERROR:
            MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			ResetOutputsAction;
			ResetMotionCommands;
			IF NOT Internal.Error THEN
				MachineState.NextState := WAITING_INIT;
			END_IF
        
        ELSE
            MachineState.NextState := WAITING_START;			
        
    END_CASE
			
	OffsetManagement;
	
    FeedbacksUpdateAction;	
	
END_PROGRAM

PROGRAM _EXIT
	Internal.Axis(Enable := FALSE);
	Internal.Cam(Enable := FALSE);
	Internal.Offset(Enable := FALSE);
    
END_PROGRAM