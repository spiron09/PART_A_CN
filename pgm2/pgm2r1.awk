BEGIN {drop=0;} {
if($1=="d"){
drop++;
}
}
END { printf("The number of packets dropped is %d", drop); }
