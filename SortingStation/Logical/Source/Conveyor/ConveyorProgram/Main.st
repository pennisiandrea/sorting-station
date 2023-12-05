//******************************************************************************************************
// Program: 	ConveyorProgram
// Author: 		Andrea Pennisi
// Rev.: 		1.0.0
// Date:		5.12.2023
//
// Description:
// This module is used to deliver the cap from the starting position of the conveyor to the exit.
// An axis is controlled by mappMotion tools. The control is made in velocity.
//******************************************************************************************************
PROGRAM _INIT
        
    ResetOutputsAction;
    ResetFeedbacksAction;
    
	Internal.Parameters.Homing.Mode := mcHOMING_ABSOLUTE;
	 
    MachineState.NextState := WAITING_INIT;
    
END_PROGRAM

PROGRAM _CYCLIC
	
	MotionAction;
	
    // Enable module
    IF NOT gConveyor.Commands.Enable THEN
        ResetOutputsAction;
		ResetFeedbacksAction;
		ResetAlarmsAction;	
		ResetMotionCommands;
        RETURN;
    END_IF    
	
	IF EDGENEG(gConveyor.Commands.Automatic.Start) THEN
		IF MachineState.NextState <> ERROR THEN
			MachineState.NextState := WAITING_START;
		END_IF
	END_IF
	
	IF EDGEPOS(gConveyor.Commands.Automatic.Init) THEN
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
			END_IF
			
			IF gConveyor.Commands.Automatic.Init THEN
				gConveyor.Feedbacks.CapsOnConveyor := 0;
				MachineState.NextState := HOMING;
				
			ELSIF gConveyor.Commands.Manual.Enable THEN
				MachineState.NextState := MANUALS;
				
			END_IF
		     
		MANUALS:	
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			
			Internal.Parameters.Velocity := gConveyor.Commands.Manual.Speed;
			IF Internal.Parameters.Velocity>0 THEN
				Internal.Parameters.Direction := mcDIR_POSITIVE;
			ELSE
				Internal.Parameters.Direction := mcDIR_NEGATIVE;
			END_IF
			
			Internal.Axis.Home := gConveyor.Commands.Manual.Home AND Internal.Axis.Active AND NOT Internal.Axis.Error;
			IF Internal.Axis.IsHomed THEN			
				Internal.Axis.Power := gConveyor.Commands.Manual.PowerOn AND Internal.Axis.Active AND NOT Internal.Axis.Error;
				IF Internal.Axis.PowerOn THEN		
					Internal.Axis.MoveVelocity := gConveyor.Commands.Manual.Move AND Internal.Axis.Active AND NOT Internal.Axis.Error;
				ELSE
					Internal.Axis.MoveVelocity := FALSE;
				END_IF
			ELSE
				Internal.Axis.Power := FALSE;
				Internal.Axis.MoveVelocity := FALSE;
			END_IF
			
			IF NOT gConveyor.Commands.Manual.Enable THEN
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
				IF gConveyor.Commands.Automatic.Init THEN
					MachineState.NextState := INIT;
				ELSE
					MachineState.NextState := MOTION;
				END_IF
			END_IF
			
		INIT:
			MachineState.TimeoutTimer.PT := T#30S;
			IF MachineState.NewTriggerState THEN				
				Internal.Parameters.Velocity := gConveyor.Parameters.TargetSpeed;
				Internal.Parameters.Direction := mcDIR_POSITIVE;
			END_IF
			Internal.Axis.MoveAbsolute := Internal.Axis.Active AND NOT Internal.Axis.Error;
			IF Internal.Axis.MoveDone THEN
				Internal.Axis.MoveAbsolute := FALSE;
				MachineState.NextState := WAITING_START;
			END_IF	
			
        WAITING_START:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			IF MachineState.NewTriggerState THEN
				ResetMotionCommands;
			END_IF
			
            IF gConveyor.Commands.Automatic.Start THEN
				MachineState.NextState := POWER_ON;				
				
			ELSIF gConveyor.Commands.Manual.Enable THEN
				MachineState.NextState := MANUALS;	
            END_IF   		
		
		MOTION:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			IF MachineState.NewTriggerState THEN				
				Internal.Parameters.Direction := mcDIR_POSITIVE;
			END_IF
			
			// On-fly velocity change
			IF Internal.Parameters.Velocity <> gConveyor.Parameters.TargetSpeed THEN
				Internal.Parameters.Velocity := gConveyor.Parameters.TargetSpeed;
				Internal.Axis.Update := TRUE;
			ELSIF Internal.Axis.UpdateDone THEN
				Internal.Axis.Update := FALSE;
			END_IF
			
			Internal.Axis.MoveVelocity := TRUE;			
			
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
    				
    FeedbacksUpdateAction;
    
END_PROGRAM

PROGRAM _EXIT
    
END_PROGRAM