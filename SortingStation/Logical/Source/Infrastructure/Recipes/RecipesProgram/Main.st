
PROGRAM _INIT
	
	MpRecipeXmlFB(MpLink := ADR(gRecipesXmlMpLink), Enable := TRUE, DeviceName := ADR('RECIPES'));
	MpRecipeUIFB(MpLink := ADR(gRecipesXmlMpLink), Enable := TRUE, UIConnect := ADR(gRecipes));
	
END_PROGRAM

PROGRAM _CYCLIC
	MpRecipeXmlFB(ErrorReset := gMainMachine.Commands.Reset AND MpRecipeXmlFB.Error);
	MpRecipeUIFB(ErrorReset := gMainMachine.Commands.Reset AND MpRecipeUIFB.Error);
	
	// Manage the recipe change
	IF MpRecipeXmlFB.StatusID = ERR_OK AND MpRecipeUIFB.StatusID = ERR_OK THEN
		gRecipes.Recipe.List.SelectedIndex := MIN(gRecipes.Recipe.List.SelectedIndex,gRecipes.Recipe.List.MaxSelection);
		// Load recipe on power on of plc or if a new recipe is selected from HMI
		IF NOT InitDone OR gRecipes.Recipe.List.SelectedIndex <> LastRecipeIndex THEN
			gRecipes.Recipe.Load := TRUE;
			InitDone := TRUE;
			LastRecipeIndex := gRecipes.Recipe.List.SelectedIndex;
		END_IF
	END_IF
	
END_PROGRAM

PROGRAM _EXIT
	MpRecipeXmlFB.Enable := FALSE;
	MpRecipeXmlFB();
	 
	MpRecipeUIFB.Enable := FALSE;
	MpRecipeUIFB();
END_PROGRAM

