//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	//execute in a worker to process callbacks
	CALL WORKER:C1389(1; Current method name:C684; {})
	
Else 
	
	$cases:=["keisuke.miyako@4D.com"; "Keisuke Miyako<keisuke.miyako@4D.com>"; "宮古啓介<keisuke.miyako@4D.com>"]
	
	$file:=File:C1566("/DATA/sample.txt")
	
	$file.setText($cases.join("\n"))
	
	var $grex : cs:C1710.grex
	$grex:=cs:C1710.grex.new()
/*
file can be file, text, BLOB
*/
	
	$results:=$grex.generate([{file: $file; \
		words: True:C214; \
		non_words: True:C214; \
		spaces: True:C214; \
		non_spaces: True:C214; \
		digits: True:C214; \
		non_digits: True:C214; \
		ignore_case: True:C214; \
		capture_groups: True:C214; \
		repetitions: True:C214}; {file: $file; \
		words: False:C215; \
		non_words: True:C214; \
		spaces: True:C214; \
		non_spaces: False:C215; \
		digits: True:C214; \
		non_digits: False:C215; \
		ignore_case: False:C215; \
		capture_groups: False:C215; \
		repetitions: False:C215}])
	
	SET TEXT TO PASTEBOARD:C523($results[0])
	
/*
(?i)^(\w{7}\s\w{6}\D\w(\w{6}\D){2}\d\w\D\w{3}\D|\w{4}\D\w(\w{6}\D){2}\d\w\D\w{3}\D|\w(\w{6}\D){2}\d\w\D\w{3})$
*/
	
	SET TEXT TO PASTEBOARD:C523($results[1])
	
/*
^(?:Keisuke\sMiyako\Wkeisuke\Wmiyako\W\dD\Wcom\W|\u5bae\u53e4\u5553\u4ecb\Wkeisuke\Wmiyako\W\dD\Wcom\W|keisuke\Wmiyako\W\dD\Wcom)$	
*/
	
	For each ($regex; $results)
		For each ($case; $cases)
			ASSERT:C1129(Match regex:C1019($regex; $case; 1))
		End for each 
	End for each 
	
End if 