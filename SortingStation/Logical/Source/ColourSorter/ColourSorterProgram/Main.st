//******************************************************************************************************
// Program: 	ColourSorterProgram
// Author: 		Andrea Pennisi
// Rev.: 		1.0.0
// Date:		28.11.2023
//
// Description:
// This module uses both cap pusher and pickup arm tools. 
// At init the module try to reach the initial position.
// At start the module uses arm and cap pusher in order to deliver a cap in the conveyor.
//******************************************************************************************************
        
PROGRAM _INIT
        
    ResetOutputsAction;
    ResetFeedbacksAction;
    
	MpRecipeRegParFB(MpLink := ADR(gRecipesXmlMpLink), Enable := TRUE, PVName := ADR('gColourSorter.Parameters'));
	
    MachineState.NextState := WAITING_INIT;
    
END_PROGRAM

PROGRAM _CYCLIC	
    // Recipe
	MpRecipeRegParFB(ErrorReset := gColourSorter.Commands.Reset AND MpRecipeRegParFB.Error);

    // Enable module
    IF NOT gColourSorter.Commands.Enable THEN
        ResetOutputsAction;
		ResetFeedbacksAction;	
		ResetAlarmsAction;
        RETURN;
    END_IF
    
	IF EDGENEG(gColourSorter.Commands.Automatic.Start) THEN
		IF MachineState.NextState <> ERROR THEN
			MachineState.NextState := WAITING_START;
		END_IF
	END_IF
	
	IF EDGEPOS(gColourSorter.Commands.Automatic.Init) THEN
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
				gColourSorter.Feedbacks.CapSorted := FALSE;
			END_IF
			
			IF gColourSorter.Commands.Automatic.Init THEN
				Internal.Lane1ForwardPositionRequest := FALSE;
				Internal.Lane2ForwardPositionRequest := FALSE;
				Internal.CapOnProcess := FALSE;
				gColourSorter.Feedbacks.CapSorted := FALSE;
				
				MachineState.NextState := SET_LANES;
				
			ELSIF gColourSorter.Commands.Manual.Enable THEN
				MachineState.NextState := MANUALS;
				
			END_IF
        
		MANUALS:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			// Manual commands
			gColourSorter.Interface.Outputs.Lane1GateForward := gColourSorter.Commands.Manual.Lane1Forward;
			gColourSorter.Interface.Outputs.Lane2GateForward := gColourSorter.Commands.Manual.Lane2Forward;
			gColourSorter.Interface.Outputs.StopperForward := gColourSorter.Commands.Manual.StopperForward;
			
			IF NOT gColourSorter.Commands.Manual.Enable THEN
				MachineState.NextState := WAITING_INIT;
			END_IF
		
		SET_LANES:
			MachineState.TimeoutTimer.PT := T#3S;
			IF MachineState.NewTriggerState THEN
				Internal.Lane1PositionOk := FALSE;
				Internal.Lane2PositionOk := FALSE;				
			END_IF
			
			gColourSorter.Interface.Outputs.Lane1GateForward := Internal.Lane1ForwardPositionRequest;
			gColourSorter.Interface.Outputs.Lane2GateForward := Internal.Lane2ForwardPositionRequest;
			
			IF Internal.Lane1ForwardPositionRequest THEN
				Internal.Lane1PositionOk := gColourSorter.Interface.Inputs.Lane1GateForward;
			ELSE
				Internal.Lane1PositionOk := gColourSorter.Interface.Inputs.Lane1GateBackward;
			END_IF
			
			IF Internal.Lane2ForwardPositionRequest THEN
				Internal.Lane2PositionOk := gColourSorter.Interface.Inputs.Lane2GateForward;
			ELSE
				Internal.Lane2PositionOk := gColourSorter.Interface.Inputs.Lane2GateBackward;
			END_IF
			
			IF Internal.Lane1PositionOk AND Internal.Lane2PositionOk THEN
				IF Internal.CapOnProcess THEN
					MachineState.NextState := STOPPER_BACKWARD;
				ELSE
					MachineState.NextState := STOPPER_FORWARD;
				END_IF
			END_IF			
				        			
		STOPPER_FORWARD:
			MachineState.TimeoutTimer.PT := T#10S;
			gColourSorter.Interface.Outputs.StopperForward := TRUE;
			IF MachineState.TimeoutTimer.ET > T#250MS THEN
				MachineState.NextState := WAITING_START;
			END_IF
			
		WAITING_START:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			
			IF gColourSorter.Commands.Automatic.Start THEN
				MachineState.NextState := WAITING_CAP;				
				
			ELSIF gColourSorter.Commands.Manual.Enable THEN
				MachineState.NextState := MANUALS;	
			END_IF  
			
        WAITING_CAP:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			IF MachineState.NewTriggerState THEN
				Internal.CapOnProcess := FALSE;
			END_IF
			
			IF gColourSorter.Interface.Inputs.CapAtStartPosition THEN
				Internal.CapOnProcess := TRUE;
				gColourSorter.Feedbacks.CapSorted := FALSE;
                MachineState.NextState := DETECTING_COLOR;
            END_IF         
	
		DETECTING_COLOR:
			MachineState.TimeoutTimer.PT := T#10S;
			IF gColourSorter.Interface.Inputs.ColourIsMetallic THEN
				// GRAY
				Internal.Lane1ForwardPositionRequest := (gColourSorter.Parameters.GreyLane = 1);
				Internal.Lane2ForwardPositionRequest := (gColourSorter.Parameters.GreyLane = 2);
					
			ELSIF gColourSorter.Interface.Inputs.ColourIsNotBlack THEN
				// RED
				Internal.Lane1ForwardPositionRequest := (gColourSorter.Parameters.RedLane = 1);
				Internal.Lane2ForwardPositionRequest := (gColourSorter.Parameters.RedLane = 2);
				
			ELSE
				// BLACK
				Internal.Lane1ForwardPositionRequest := (gColourSorter.Parameters.BlackLane = 1);
				Internal.Lane2ForwardPositionRequest := (gColourSorter.Parameters.BlackLane = 2);
				
			END_IF
			
			IF MachineState.TimeoutTimer.ET > T#250MS THEN
				MachineState.NextState := SET_LANES;
			END_IF
		
		STOPPER_BACKWARD:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			
			gColourSorter.Interface.Outputs.StopperForward := FALSE;
			
			MachineState.NextState := WAITING_CAP_EXIT;
							
		WAITING_CAP_EXIT:
			MachineState.TimeoutTimer.PT := T#15S;
			
			IF gColourSorter.Interface.Inputs.CapAtExitPosition THEN
				gColourSorter.Feedbacks.CapSorted := TRUE;
				MachineState.NextState := STOPPER_FORWARD;
			END_IF
			
		ERROR:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			ResetOutputsAction;
			IF NOT Internal.Error THEN
				MachineState.NextState := WAITING_INIT;
			END_IF
        
        ELSE
            MachineState.NextState := WAITING_INIT;			
        
    END_CASE
    		
    FeedbacksUpdateAction;
    
END_PROGRAM

PROGRAM _EXIT
	MpRecipeRegParFB(Enable := FALSE);
    
END_PROGRAM