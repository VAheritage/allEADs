#!/bin/bash

for file in `cat /tmp/vt1.list`
do 
    eadid=`egrep "eadid" $file | sed -e 's/></>\n</g' | egrep eadid | sed -e 's/.*">//' -e 's/<.*//' -e 's/xx\(.*\)xx/\1/' `
    if [[ -e "vt/${eadid}.xml" ]]; then
        echo $file $eadid "vt/${eadid}.xml"
        oaititle=`cat $file | tr -d '\r\n' | sed -e 's#^.*\?<titleproper>##' -e 's#</titleproper>.*$##' -e 's/<date.*//' -e 's/<num.*//' -e 's/ [ ]*/ /g' -e 's/[;,. ]*$//' -e 's/A Guide to \(the \)\?//' | tr "[]()" "()()"`
        vttitle=`cat vt/${eadid}.xml | tr -d '\r\n' | sed -e 's#^.*\?<titleproper>##' -e 's#</titleproper>.*$##' -e 's/<date.*//' -e 's/<num.*//' -e 's/ [ ]*/ /g' -e 's/[;,. ]*$//' -e 's/A Guide to \(the \)\?//' | tr "[]()" "()()"`
        if [[ ${oaititle} == ${vttitle} ]] ; then
            echo "Match-y match"
            cmp -s "vt/${eadid}.xml" "../vivaxtf/data/vt/${eadid}.xml" 
            result=$?
            if [[ "$result" == "0" ]] ; then 
                mv "vt/${eadid}.xml" ../deleted/vt
                #rm "../vivaxtf/vt/${eadid}.xml" 
            fi
        else    
            diff=`diffcolor <(echo "${oaititle}) <(echo "${vttitle}")`
            echo "vt/${eadid}.xml" $diff
        fi
#    else     
#        if [[ "${eadid}" == "" ]] ; then 
#            echo $file "no_id" "no_match" 
#        else 
#            echo $file ${eadid} "no_match"
#        fi
    fi
done 

