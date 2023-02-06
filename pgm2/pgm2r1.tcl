set ns [new Simulator]
set nf [open pgm2r1.nam w]
$ns namtrace-all $nf
set tf [open pgm2r1.tr w]
$ns trace-all $tf 

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n4 10Mb 1ms DropTail
$ns duplex-link $n1 $n4 10Mb 1ms DropTail
$ns duplex-link $n2 $n4 10Mb 1ms DropTail
$ns duplex-link $n3 $n4 10Mb 1ms DropTail
$ns duplex-link $n5 $n4 10Mb 1ms DropTail

set p1 [new Agent/Ping]
$ns attach-agent $n0 $p1
$p1 set packetSize_ 50000
$p1 set interval_ 0.0001

set p2 [new Agent/Ping]
$ns attach-agent $n1 $p2

set p3 [new Agent/Ping]
$ns attach-agent $n2 $p3
$p1 set packetSize_ 30000
$p1 set interval_ 0.0001

set p4 [new Agent/Ping]
$ns attach-agent $n3 $p4

set p5 [new Agent/Ping]
$ns attach-agent $n4 $p5



Agent/Ping instproc recv {from rtt} {
$self instvar node_
puts "node [$node_ id] recieved from $from with a roundtrip time of $rtt"
}

$ns queue-limit $n0 $n4 2
$ns queue-limit $n2 $n4 1

$ns connect $p1 $p5
$ns connect $p3 $p4

proc finish {} {
global ns nf tf
$ns flush-trace
close $nf
close $tf
exec nam pgm2r1.nam &
exit 0
}


$ns at 0.1 "$p1 send"
$ns at 0.2 "$p1 send"
$ns at 0.3 "$p1 send"
$ns at 0.4 "$p1 send"
$ns at 0.5 "$p1 send"
$ns at 0.6 "$p1 send"
$ns at 0.7 "$p1 send"
$ns at 0.8 "$p1 send"
$ns at 0.9 "$p1 send"
$ns at 1.0 "$p1 send"

$ns at 0.1 "$p3 send"
$ns at 0.2 "$p3 send"
$ns at 0.3 "$p3 send"
$ns at 0.4 "$p3 send"
$ns at 0.5 "$p3 send"
$ns at 0.6 "$p3 send"
$ns at 0.7 "$p3 send"
$ns at 0.8 "$p3 send"
$ns at 0.9 "$p3 send"
$ns at 1.0 "$p3 send"


$ns at 2.0 "finish"
$ns run
