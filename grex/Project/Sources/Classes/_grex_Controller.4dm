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
	
	$stdOut:=This:C1470.stdOut+$params.data
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	While (Match regex:C1019("(\\\\u\\{((?:[:hex_digit:]{4}){1,2})\\})"; $stdOut; 1; $pos; $len))
		$stdOut:=Substring:C12($stdOut; 1; $pos{0}-1)\
			+"\\u"+Substring:C12($stdOut; $pos{2}; $len{2})\
			+Substring:C12($stdOut; $pos{0}+$len{0})
	End while 
	
	This:C1470.stdOut:=Substring:C12($stdOut; 1; Length:C16($stdOut)-1)  //remove trailing LF
	
Function onDataError($worker : 4D:C1709.SystemWorker; $params : Object)
	
	This:C1470.stdErr+=$params.data
	
Function onResponse($worker : 4D:C1709.SystemWorker; $params : Object)
	
Function onError($worker : 4D:C1709.SystemWorker; $params : Object)
	
Function onTerminate($worker : 4D:C1709.SystemWorker; $params : Object)
	