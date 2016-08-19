#!/bin/bash
set -e 

### Variables
variable1=1
variable2=2


Require(){
    echo "Required Environment: "
    echo -e "    OS Platform: "
    echo -e "    Kernel Version: "
    echo -e "    Packages: "
}

FuncA(){
	echo -e "do Something..."
}

FuncB(){
	echo -e "do Something..."
}

Help(){
    Require	
    echo "Usage: bash $0 [FuncA|FuncB]"
}

$1
