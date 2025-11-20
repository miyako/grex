property stdOut : Text
property stdErr : Text

Class extends _CLI_Controller

Class constructor($CLI : cs:C1710._CLI)
	
	Super:C1705($CLI)
	
	This:C1470.clear()
	
Function clear() : cs:C1710._grex_Controller
	
	This:C1470.stdOut:=""
	This:C1470.stdErr:=""
	
	return This:C1470
	
Function onData($worker : 4D:C1709.SystemWorker; $params : Object)
	
	This:C1470.stdOut+=$params.data
	This:C1470.stdOut:=Substring:C12(This:C1470.stdOut; 1; Position:C15(This:C1470.instance.EOL; This:C1470.stdOut; *)-1)
	
Function onDataError($worker : 4D:C1709.SystemWorker; $params : Object)
	
	This:C1470.stdErr+=$params.data
	
Function onResponse($worker : 4D:C1709.SystemWorker; $params : Object)
	
Function onError($worker : 4D:C1709.SystemWorker; $params : Object)
	
Function onTerminate($worker : 4D:C1709.SystemWorker; $params : Object)
	