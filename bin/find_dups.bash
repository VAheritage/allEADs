#!/bin/bash

cat /dev/null > /tmp/f1
cat /dev/null > /tmp/f2
if [[ "$1" == "-t" ]] ; then 
    test=1
else
    test=0
fi

for file in `cat /tmp/vt1.list`
do 
    eadid=`egrep "eadid" $file | sed -e 's/></>\n</g' | egrep eadid | sed -e 's/.*">//' -e 's/<.*//' -e 's/xx\(.*\)xx/\1/' `
    if [[ -e "vt/${eadid}.xml" ]]; then
        echo $file $eadid "vt/${eadid}.xml"
        oaititle=`cat $file | tr -d '\r\n' | sed -e 's#^.*\?<titleproper>##' -e 's#</titleproper>.*$##' -e 's/<date.*//' -e 's/<num.*//' -e 's/ [ ]*/ /g' -e 's/[;":),. ]*$//' -e 's/A Guide to \(the \)\?//' | tr "[]()" "()()"`
        vttitle=`cat vt/${eadid}.xml | tr -d '\r\n' | sed -e 's#^.*\?<titleproper>##' -e 's#</titleproper>.*$##' -e 's/<date.*//' -e 's/<num.*//' -e 's/ [ ]*/ /g' -e 's/[;,":). ]*$//' -e 's/A Guide to \(the \)\?//' | tr "[]()" "()()"`
        oaititlestrip=`echo $oaititle | sed -e 's/[., ")(:;*]//g' -e "s/'//g"`
        vttitlestrip=`echo $vttitle | sed -e 's/[., ")(:;*]//g' -e "s/'//g"`
        if [[ ${oaititle} == ${vttitle} ]] ; then
            echo "Match-y match"
            cmp -s "vt/${eadid}.xml" "../vivaxtf/data/vt/${eadid}.xml" 
            result=$?
            if [[ "$result" == "0" ]] ; then 
                if [[ "$test" == 0 ]] ; then
                    mv "vt/${eadid}.xml" ../deleted/vt
                else
                    echo mv "vt/${eadid}.xml" ../deleted/vt
                fi
            fi
        elif [[ "${oaititle}" == *"${vttitle}"* ]] ; then 
            echo "near Match-y match"
            cmp -s "vt/${eadid}.xml" "../vivaxtf/data/vt/${eadid}.xml"
            result=$?
            if [[ "$result" == "0" ]] ; then
                if [[ "$test" == 0 ]] ; then
                    mv "vt/${eadid}.xml" ../deleted/vt
                else
                    echo mv "vt/${eadid}.xml" ../deleted/vt
                fi
            fi
        elif [[ "${vttitle}" == *"${oaititle}"* ]] ; then 
            echo "near Match-y match-y"
            cmp -s "vt/${eadid}.xml" "../vivaxtf/data/vt/${eadid}.xml"
            result=$?
            if [[ "$result" == "0" ]] ; then
                if [[ "$test" == 0 ]] ; then
                    mv "vt/${eadid}.xml" ../deleted/vt
                else
                    echo mv "vt/${eadid}.xml" ../deleted/vt
                fi
            fi
        elif [[ "${vttitlestrip}" == "${oaititlestrip}" ]] ; then 
            echo "near Match-y match-y strip"
            cmp -s "vt/${eadid}.xml" "../vivaxtf/data/vt/${eadid}.xml"
            result=$?
            if [[ "$result" == "0" ]] ; then
                if [[ "$test" == 0 ]] ; then
                    mv "vt/${eadid}.xml" ../deleted/vt
                else
                    echo mv "vt/${eadid}.xml" ../deleted/vt
                fi
            fi
        else    
            echo "vt/${eadid}.xml ${oaititle}" >> /tmp/f1
            echo "vt/${eadid}.xml ${vttitle}" >> /tmp/f2
        fi
#    else     
#        if [[ "${eadid}" == "" ]] ; then 
#            echo $file "no_id" "no_match" 
#        else 
#            echo $file ${eadid} "no_match"
#        fi
    fi
done 

