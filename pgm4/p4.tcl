set ns [new Simulator]
set val(chan) Channel/WirelessChannel; # channel type
set val(prop) Propagation/TwoRayGround; # radio-propagation model
set val(netif) Phy/WirelessPhy; # network interface type
set val(mac) Mac/802_11; # MAC type
set val(ifq) Queue/DropTail/PriQueue; # interface queue type
set val(ll) LL; # link layer type
set val(ant) Antenna/OmniAntenna; # antenna model
set val(ifqlen) 50; # max packet in ifq
set val(nn) 2; # number of mobilenodes
set val(rp) DSDV; # routing protocol set val(x) 1000.0;
set val(y) 1000.0;
set tf [open lab4.tr w]
$ns trace-all $tf
set topo [new Topography]
$topo load_flatgrid 1000 1000
set nf [open lab4.nam w]
$ns namtrace-all-wireless $nf 1000 1000
$ns node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace ON
create-god $val(nn)
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
$n0 label "tcp0"
$n1 label "sink1/tcp1"
$n2 label "sink2"
$n0 set X_ 250
$n0 set Y_ 250
$n0 set Z_ 0
$n1 set X_ 300
$n1 set Y_ 300
$n1 set Z_ 0
$n2 set X_ 600

$n2 set Y_ 600
$n2 set Z_ 0
$ns at 0.1 "$n0 setdest 250 250 15"
$ns at 0.1 "$n1 setdest 300 300 25"
$ns at 0.1 "$n2 setdest 600 600 25"
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
$ns connect $tcp0 $sink1
set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
set sink2 [new Agent/TCPSink]
$ns attach-agent $n2 $sink2
$ns connect $tcp1 $sink2
$ns at 5 "$ftp0 start"
$ns at 5 "$ftp1 start"
#The below code is used to provide the node movements.
$ns at 100 "$n1 setdest 550 550 15"
$ns at 190 "$n1 setdest 70 70 15"
proc finish {} {
global ns nf tf
$ns flush-trace
exec nam lab4.nam &
close $tf
exit 0
}
$ns at 250 "finish"
$ns run
