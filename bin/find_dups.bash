#!/bin/bash

for file in `cat /tmp/vt1.list`
do 
    eadid=`egrep "eadid" $file | sed -e 's/></>\n</g' | egrep eadid | sed -e 's/.*">//' -e 's/<.*//' -e 's/xx\(.*\)xx/\1/' `
    if [[ -e "vt/${eadid}.xml" ]]; then
        # echo $file $eadid "vt/${eadid}.xml"
        oaititle=`cat $file | tr -d '\n' | sed -e 's#^.*\?<titleproper>##' -e 's#</titleproper>.*$##' | sed -e 's/ [ ]*/ /g'`
        vttitle=`cat vt/${eadid}.xml | tr -d '\n' | sed -e 's#^.*\?<titleproper>##' -e 's#</titleproper>.*$##' | sed -e 's/ [ ]*/ /g'`
        echo "vt/${eadid}.xml#${oaititle}#${vttitle}"
#    else     
#        if [[ "${eadid}" == "" ]] ; then 
#            echo $file "no_id" "no_match" 
#        else 
#            echo $file ${eadid} "no_match"
#        fi
    fi
done 

