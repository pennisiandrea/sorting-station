//******************************************************************************************************
// Program: 	HMIProgram
// Author: 		Andrea Pennisi
// Rev.: 		1.0.0
// Date:		5.12.2023
//
// Description:
// This module is used to manage the enables/visibility and value of the variable in the HMI
//******************************************************************************************************
PROGRAM _INIT
	SetInitialValuesAction;
END_PROGRAM

PROGRAM _CYCLIC
	
	HeaderContentAction;
	
	AutomaticPageAction;
	
	ManualPageAction;
	
	RecipeContentAction;
	
END_PROGRAM

PROGRAM _EXIT
    
END_PROGRAM