---
layout: default
---

![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm&color=blue)
[![license](https://img.shields.io/github/license/miyako/grex)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/grex/total)

# grex

based on [grex](https://github.com/pemistahl/grex)

## Usage

```4d
#DECLARE($params : Object)

If (Count parameters=0)
    
    //execute in a worker to process callbacks
    CALL WORKER(1; Current method name; {})
    
Else 
    
    $cases:=["keisuke.miyako@4D.com"; "Keisuke Miyako<keisuke.miyako@4D.com>"; "宮古啓介<keisuke.miyako@4D.com>"]
    
    $file:=File("/DATA/sample.txt")
    
    $file.setText($cases.join("\n"))
    
    var $grex : cs.grex
    $grex:=cs.grex.new()
    /*
        file can be file, text, BLOB
    */
    
    $results:=$grex.generate([{file: $file; \
    words: True; \
    non_words: True; \
    spaces: True; \
    non_spaces: True; \
    digits: True; \
    non_digits: True; \
    ignore_case: True; \
    capture_groups: True; \
    repetitions: True}; {file: $file; \
    words: False; \
    non_words: True; \
    spaces: True; \
    non_spaces: False; \
    digits: True; \
    non_digits: False; \
    ignore_case: False; \
    capture_groups: False; \
    repetitions: False}])
    
    SET TEXT TO PASTEBOARD($results[0])
    
    /*
        (?i)^(\w{7}\s\w{6}\D\w(\w{6}\D){2}\d\w\D\w{3}\D|\w{4}\D\w(\w{6}\D){2}\d\w\D\w{3}\D|\w(\w{6}\D){2}\d\w\D\w{3})$
    */
    
    SET TEXT TO PASTEBOARD($results[1])
    
    /*
        ^(?:Keisuke\sMiyako\Wkeisuke\Wmiyako\W\dD\Wcom\W|\u5bae\u53e4\u5553\u4ecb\Wkeisuke\Wmiyako\W\dD\Wcom\W|keisuke\Wmiyako\W\dD\Wcom)$    
    */
    
    For each ($regex; $results)
        For each ($case; $cases)
            ASSERT(Match regex($regex; $case; 1))
        End for each 
    End for each 
    
End if  
```

* onResponse

```4d
#DECLARE($worker : 4D.SystemWorker; $params : Object)

var $pdf : 4D.Blob
$pdf:=$worker.response

TRACE
```
