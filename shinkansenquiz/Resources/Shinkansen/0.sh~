aaa=
for l0 in $(cat l)
do
    if [ ! -n "$aaa" ];then
	aaa="y"
	prev=$l0
	continue
    fi
    mv $l0 $prev
    prev=$l0
done