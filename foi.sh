#!/usr/bin/env bash
testa1(){
echo um
}

testa2(){
echo "cuidado pois esse script roda todas as funções marcadas"
}


testa3(){
echo ${FUNCNAME[0]}
}




xtdc_up(){
ls
}

xtdc_install(){
testa1 && testa2 && testa3 && xtdc_up
}
