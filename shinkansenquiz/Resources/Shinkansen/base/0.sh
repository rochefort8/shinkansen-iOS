#!/bin/bash

for d in $(find . -type d)
do
    if [ -f $d/base.txt ]; then

        base=$(echo $d| cut -d/ -f2-)
        fn=$d/$base.json
        echo "{" > $fn
        echo "    \"name\"      :\"$base\"," >> $fn
        echo "    \"name_kanji\":\"\"," >> $fn
        echo "    \"name_kana\" :\"\"," >> $fn
        echo "    \"station\":[" >> $fn
        id=1
        while read f1 f2 f3
        do
            echo "        {" >> $fn
            echo "            \"id\"        :\"$id\"," >> $fn        
            echo "            \"name\"      :\"$f3\"," >> $fn
            echo "            \"name_kanji\":\"$f1\"," >> $fn
            echo "            \"name_kana\" :\"$f2\"" >> $fn
            echo "        }," >> $fn
            let id=$id+1
        done < $d/base.txt
        echo "    ]" >> $fn
        echo "}" >> $fn
    fi
done