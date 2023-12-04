
PROGRAM _INIT
	diCapOnSortingConveyor;
	diHolePuncherForward;
	diHolePuncherBack;
	diColourDetection;
	diCapColourNotBlack;
	diCapColourMetallic;
	diLaneGate1Forward;
	diLaneGate1Back;
	diLaneGate2Forward;
	diLaneGate2Back;
	diLaneTop;
	aiPuncherAxisActPos;
	doHolePuncher;
	doSortingConveyorClear;
	doCapStopper;
	doLaneGate1;
	doLaneGate2;
	aoSortingConveyorSetSpeed;
	aoPuncherAxisSetPos;
	doLaneStopper1Clear;
	doLaneStopper2Clear;
	doLaneStopper3Clear;
	doCreateCapForSorting;	 
END_PROGRAM

PROGRAM _CYCLIC
	
	// Colour sorter
	gColourSorter.Interface.Inputs.CapAtStartPosition := diColourDetection;
	gColourSorter.Interface.Inputs.CapAtExitPosition := diLaneTop;
	gColourSorter.Interface.Inputs.ColourIsMetallic := diCapColourMetallic;
	gColourSorter.Interface.Inputs.ColourIsNotBlack := diCapColourNotBlack;
	gColourSorter.Interface.Inputs.Lane1GateBackward := diLaneGate1Back;
	gColourSorter.Interface.Inputs.Lane1GateForward := diLaneGate1Forward;
	gColourSorter.Interface.Inputs.Lane2GateBackward := diLaneGate2Back;
	gColourSorter.Interface.Inputs.Lane2GateForward := diLaneGate2Forward;
	
	doLaneGate1 := gColourSorter.Interface.Outputs.Lane1GateForward;
	doLaneGate2 := gColourSorter.Interface.Outputs.Lane2GateForward;
	doCapStopper := gColourSorter.Interface.Outputs.StopperForward;
	
	// Conveyor
	gConveyor.Interface.Inputs.CapInStartPosition := diCapOnSortingConveyor;
	
	aoSortingConveyorSetSpeed := gConveyor.Interface.Outputs.SetSpeed/1000;
	
	// Puncher
	gPuncher.Interface.Inputs.ActualPosition := aiPuncherAxisActPos*1000;
	gPuncher.Interface.Inputs.PunchIsForward := diHolePuncherForward;
	gPuncher.Interface.Inputs.PunchIsBackward := diHolePuncherBack;
	
	aoPuncherAxisSetPos := LREAL_TO_REAL(gPuncher.Interface.Outputs.SetPosition/1000);
	doHolePuncher := gPuncher.Interface.Outputs.PunchForward;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

