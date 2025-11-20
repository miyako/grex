Class extends _CLI

Class constructor($controller : 4D:C1709.Class)
	
	If (Not:C34(OB Instance of:C1731($controller; cs:C1710._grex_Controller)))
		$controller:=cs:C1710._grex_Controller
	End if 
	
	Super:C1705("grex"; $controller)
	
Function get worker() : 4D:C1709.SystemWorker
	
	return This:C1470.controller.worker
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function generate($option : Variant; $formula : 4D:C1709.Function) : Collection
	
	var $stdOut; $isStream; $isAsync : Boolean
	var $options : Collection
	var $results : Collection
	$results:=[]
	
	Case of 
		: (Value type:C1509($option)=Is object:K8:27)
			$options:=[$option]
		: (Value type:C1509($option)=Is collection:K8:32)
			$options:=$option
		Else 
			$options:=[]
	End case 
	
	var $commands : Collection
	$commands:=[]
	
	If (OB Instance of:C1731($formula; 4D:C1709.Function))
		$isAsync:=True:C214
		This:C1470.controller.onResponse:=$formula
	End if 
	
	For each ($option; $options)
		
		If ($option=Null:C1517) || (Value type:C1509($option)#Is object:K8:27)
			continue
		End if 
		
		$stdOut:=Not:C34(OB Instance of:C1731($option.output; 4D:C1709.File))
		
		$command:=This:C1470.escape(This:C1470.executablePath)
		
		$command+=" --escape "
		
		Case of 
			: (Value type:C1509($option.file)=Is object:K8:27) && (OB Instance of:C1731($option.file; 4D:C1709.File)) && ($option.file.exists)
				$command+=" --file "
				$command+=This:C1470.escape(This:C1470.expand($option.file).path)
			: ((Value type:C1509($option.file)=Is object:K8:27) && (OB Instance of:C1731($option.file; 4D:C1709.Blob))) || (Value type:C1509($option.file)=Is BLOB:K8:12) || (Value type:C1509($option.file)=Is text:K8:3)
				$command+=" - "
				$isStream:=True:C214
		End case 
		
		var $arg : Object
		var $valueType : Integer
		var $key : Text
		
		For each ($arg; OB Entries:C1720($option))
			$valueType:=Value type:C1509($arg.value)
			Case of 
				: (["file"; "help"; "version"; "colorize"; "verbose"; "escape"].includes($arg.key))
					continue
				Else 
					$key:=Replace string:C233($arg.key; "_"; "-"; *)
					Case of 
						: ($valueType=Is real:K8:4)
							$command+=(" --"+$key+"="+String:C10($arg.value)+" ")
						: ($valueType=Is text:K8:3)
							$command+=(" --"+$key+"="+This:C1470.escape($arg.value)+" ")
						: ($valueType=Is boolean:K8:9) && ($arg.value)
							$command+=(" --"+$key+" ")
						Else 
							//
					End case 
			End case 
		End for each 
		
		var $worker : 4D:C1709.SystemWorker
		$worker:=This:C1470.controller.execute($command; $isStream ? $option.file : Null:C1517; $option.data).worker
		
		If (Not:C34($isAsync))
			$worker.wait()
		End if 
		
		If (Not:C34($isAsync))
			//%W-550.26
			//%W-550.2
			If ($stdOut)
				$results.push(This:C1470.controller.stdOut)
			Else 
				$results.push(Null:C1517)
			End if 
			This:C1470.controller.clear()
			//%W+550.2
			//%W+550.26
		End if 
		
	End for each 
	
	If (Not:C34($isAsync))
		return $results
	End if 