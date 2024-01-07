# This file explains all the things needed for network simulator

# to install ns2 on ubuntu:
# sudo apt-get update
# sudo apt-get install ns2 -y
# sudo apt-get install nam
# sudo apt-get install tcl -y

# to run a tcl file:
# ns <filename>.tcl

# First of all the syntax, comparing it with c++ for easier understanding

# 1: To use a value of variable, we use $ sign before it
# int a = 20;
# int b;
# b = a;

set a 20
set b $a

# 2: To display output, we use puts command
# cout << "hello world" << endl;

# int a = 20;s
# cout << "a = " << a << endl;

puts "hello world"
set a 20
puts "a = $a"

# 3: Getting input from user, use gets stdin
# int a;
# cin >> a;

set a [gets stdin]

# 4: mathematical expression, use expr
# set c = a + b;

set c [expr $a + $b]

# 5: if else, use if else
# if(a > b){
#     cout << "a is greater than b" << endl;
# }
# else{
#     cout << "b is greater than a" << endl;
# }

if {$a > $b} {
    puts "a is greater than b"
} else {
    puts "b is greater than a"
}

# 6: for loop, use for
# for(int i = 0; i < 10; i++){
#     cout << i << endl;
# }

for {set i 0} {$i < 10} {incr i} {
    puts $i
}

# 7: while loop, use while
# while(a < 10){
#     cout << a << endl;
#     a++;
# }

while {$a < 10} {
    puts $a
    incr a
}

# ---------------------------------------------------------------

puts "Enter a number greater than 4: "
flush stdout
set userNumber [gets stdin]

# Check if the input is a valid number
if {![string is integer $userNumber] || $userNumber <= 4} {
    puts "Invalid input. Please enter a number greater than 4."
} else {
    # Convert the input to an integer
    set userNumber [expr {$userNumber + 0}]

    # Check if the number is even or odd
    if {$userNumber % 2 == 0} {
        # If even, print even integers starting from 4
        for {set i 4} {$i <= $userNumber} {incr i 2} {
            puts $i
        }
    } else {
        # If odd, print odd integers starting from 3
        for {set i 3} {$i <= $userNumber} {incr i 2} {
            puts $i
        }
    }
}

# ---------------------------------------------------------------

# An NS Simulator starts with the following command:
set ns [new Simulator]

# In order to have output files for visualizations (nam files) we need to create files using open command:
# opennam file
setnf [open out.nam w]
$ns namtrace-all $nf

# The termination of the program is done using the finish procedure:
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    execnamout.nam
    exit 0
}

# this is used to call finish
$ns at 5.0 “finish”

# last but not the least, we need to run the simulation
$ns run

# ---------------------------------------------------------------

# NS2 Syntax:

# Create Simulation: 
set ns [new Simulator]

# Trace Files for NAM: 
set nf [open out.nam w]
$ns namtrace-all $nf

# Finish Procedure: 
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam &amp;
    exit 0
}

# Routing Algorithm: 
$ns rtproto <protocol_name>; <protocol_name>: DV

# Node creation: 
set <node_name> [$ns node]

# Links Creation: 
$ns <link_type> <node1> <node2> <Bandwidth> <Delay> <queue_type>
<link_type>: simplex-link, duplex-link; <queue_type>: DropTail, SFQ

# Graphical Settings (NAM): 
$ns <type> <node1> <node2> <option> <args>
<type> : simplex-link-op, duplex-link-op; <option> : orient, queuePos

# Transport Layer: 
set <layer_name> [new Agent/<agent_type>]
<agent_type>: UDP,TCP,Null,TCPSink

# Attaching Transport layer: 
$ns attach-agent <node_name> <layer_name>

# Connecting Transport layer: 
$ns connect <layer_name> <layer_name>

# File Transfer Protocol: 
set <ftp_name> [new Application/FTP]

# FTP Attach Agent: 
<ftp_name> attach-agent <layer_name>

# Constant Bit Rate: 
set <cbr_name> [new Application/Traffic/CBR]

# CBR Attach Agent: 
<cbr_name> attach-agent <layer_name>

# CBR Parameters: 
<cbr_name> set <parameter> <parameter_value>
<parameter>: packetSize_, interval_, rate_

# Event Scheduling: 
$ns at <time_frame_value> “<cbr_name>/<ftp_name> <time_event>”
<time_event>: start, stop

# Ending Simulation: 
$ns at <time_frame_value> “finish”

# Run Simulation: 
$ns run

# Link Up/Down: 
$ns rtmodel-at <time_frame_value> <function> <node1> <node2>
<function>: up,down

# ---------------------------------------------------------------

# now to the questions

# Question 1:
# Write tcl script to implement the simple network shown in the figure below
    # 1. This network consists of 4 nodes (n0, n1, n2, n3)
    # 2. The duplex links between n0 and n2, and n1 and n2 have 2 Mbps of bandwidth and 10 ms of delay.
    # 3. The duplex link between n2 and n3 has 1.7 Mbps of bandwidth and 20 ms of delay.
    # 4. Each node uses a DropTail queue, of which the maximum size is 10. You will have to orient the nodes as shown in the diagram below.
    # 5. A "tcp" agent is attached to n1, and a connection is established to a tcp "sink" agent attached to n3.
    # 6. A tcp "sink" agent generates and sends ACK packets to the sender (tcp agent) and frees the received packets.
    # 7. A "udp" agent that is attached to n0 is connected to a "null" agent attached to n3. A "null" agent just frees the packets received.
    # 8. A "ftp" and a "cbr" traffic generator are attached to "tcp" and "udp" agents respectively, and the "cbr" is configured to generate packets having size of 1 Kbytesat the rate of 100 packets per second.
    # 9. FTP will control the traffic automatically according to the throttle mechanism in TCP.
    # 10. The traffic flow of UDP must be colored red and traffic flow of TCP must be colored blue.
    # 11. The "cbr" is set to start at 0.1 sec and stop at 4.5 sec,
    # 12. "ftp" is set to start at 0.5 sec and stop at 4.0 sec.

# Answer 1:

# First of all, we need to create the simulator
set ns [new Simulator]

# Then we need to create the nam file
set nf [open out.nam w]
$ns namtrace-all $nf

# Then we need to create the nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# Then we need to create the links
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.7Mb 20ms DropTail

# Then we need to create the agents
set tcp [new Agent/TCP]
$ns attach-agent $n1 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink  

set udp [new Agent/UDP]
$ns attach-agent $n0 $udp

set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp $null

# Then we need to create the traffic generators
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP
$ftp set packet_size_ 1000
$ftp set rate_ 1mb
$ftp set maxpkts_ 1000
$ftp set interval_ 0.01
$ftp set random_ false

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 100
$cbr set interval_ 0.01
$cbr set random_ false

# Then we need to create the color for the traffic
$ns color 1 Blue
$ns color 2 Red

# color the traffic
$tcp color 1
$udp color 2

# set the start and stop time for the traffic
$ns at 0.1 "$cbr start"
$ns at 4.5 "$cbr stop"
$ns at 0.5 "$ftp start"
$ns at 4.0 "$ftp stop"

# call finish procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam
    exit 0
}

# stop the simulation
$ns at 5.0 "finish"

# run the simulation
$ns run

# ---------------------------------------------------------------

# In NS2, we add following command to set the routing protocol to Distance Vector
$ns rtproto DV

# To bring the link between two nodes down/up at specific simulation time we write the followingcommands
$ns rtmodel-at 0.30 down $node1 $node2
$ns rtmodel-at 0.40 up $node1 $node2

# Question 2:
# Write a Tcl script that 
    # 1. Forms a network consisting of 7 nodes, numbered from 0 to 6, forming a ring topology.
    # 2. The links have a 512Kbps bandwidth with 5ms delay and droptail queue.
    # 3. Set the routing protocol to DV (Distance vector).
    # 4. Send UDP packets from node 0 to node 3 with the rate of 100 packets/sec with  each packet having a size of 1 Kilo Bytes.
    # 5. Start transmission at 0.02.
    # 6. Bring down the link between node 2 and node 3 at 0.4.
    # 7. Bring the dropped link back up at 1.0.
    # 8. Finish the transmission at 1.5  End the simulation at 2.0.

# Answer 2:

# Create simulation
set ns [new Simulator]

# Create nam file
set nf [open out.nam w]
$ns namtrace-all $nf

# Create trace file
set tf [open out.tr w]
$ns trace-all $tf

# Create nodes and links
set numNodes 7
set bandwidth "512Kbps"
set delay "5ms"
set queueType "droptail"

for {set i 0} {$i < $numNodes} {incr i} {
    set node($i) [$ns node]
    $ns duplex-link $node($i) $node([expr ($i+1)%$numNodes]) $bandwidth $delay $queueType
}

# Set routing protocol to Distance Vector
for {set i 0} {$i < $numNodes} {incr i} {
    $ns rtproto DV $node($i)
}

# Send UDP packets from node 0 to node 3
set packetRate 100
set packetSize "1K"
set startTime 0.02
set endTime 1.5

set udp [new Agent/UDP]
$ns attach-agent $node(0) $udp

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packetSize $packetSize
$cbr set rate $packetRate
$cbr set random false

$ns connect $udp $node(3)

$ns at $startTime "$cbr start"
$ns at $endTime "$cbr stop"

# Bring down the link between node 2 and node 3 at 0.4
set linkDownTime 0.4
$ns at $linkDownTime "$ns duplex-link-op $node(2) $node(3) down"

# Bring the dropped link back up at 1.0
set linkUpTime 1.0
$ns at $linkUpTime "$ns duplex-link-op $node(2) $node(3) up"

# End the simulation at 2.0
set simulationEndTime 2.0
$ns at $simulationEndTime "finish"

$ns run

# ---------------------------------------------------------------

# Question 3:
# You will have to create a star topolgy as given in the diagram below using ns2 to implement the Distance vector routing protocol. Assume all the devices in the following star topology as nodes and all the wires as duplex links having a capacity of 512Kb and a propagation delay of 10ms with a stochastic fair queue scheduling algorithm. You will have to send TCP data from H1 to H4 having red color. Also you will have to send UDP data with a rate of 256Kbps from H2 to H5 having blue color. Scheduling Events:
# - TCP Data starts at 0.1 and stops at 1.5
# - UDP Data starts at 0.2 and stops at 1.3
# - Bring the link between SW1 and H5 down at 0.5 and bring it back up at 0.9
# - Bring the link between SW1 and H4 down at 0.7 and bring it back up at 1.2
# - Stop the simulation at 2.0

# See the question from LAB 10 (Question 2)

# Answer 3:
set ns [new Simulator]

# Create nodes
set numNodes 5
for {set i 1} {$i <= $numNodes} {incr i} {
    set node($i) [$ns node]
}

# Create links
for {set i 2} {$i <= $numNodes} {incr i} {
    set link($i) [$ns duplex-link $node(1) $node($i) 512Kb 10ms DropTail]
}

# Set link properties
for {set i 2} {$i <= $numNodes} {incr i} {
    $link($i) queue-type SFQ
}

# Set color of TCP data
$ns color 1 red

# Set color of UDP data
$ns color 2 blue

# Create TCP agent and attach it to H1
set tcp [new Agent/TCP]
$ns attach-agent $node(1) $tcp

# Create UDP agent and attach it to H2
set udp [new Agent/UDP]
$ns attach-agent $node(2) $udp

# Create a TCP sink and attach it to H4
set sink [new Agent/TCPSink]
$ns attach-agent $node(4) $sink

# Create a UDP sink and attach it to H5
set udpsink [new Agent/UDPSink]
$ns attach-agent $node(5) $udpsink

# Connect TCP agent to TCP sink
$ns connect $tcp $sink

# Connect UDP agent to UDP sink
$ns connect $udp $udpsink

# Set TCP data start and stop times
$ns at 0.1 "$tcp start"
$ns at 1.5 "$tcp stop"

# Set UDP data start and stop times
$ns at 0.2 "$udp start"
$ns at 1.3 "$udp stop"

# Bring link between SW1 and H5 down at 0.5 and bring it back up at 0.9
$ns at 0.5 "$link(5) down"
$ns at 0.9 "$link(5) up"

# Bring link between SW1 and H4 down at 0.7 and bring it back up at 1.2
$ns at 0.7 "$link(4) down"
$ns at 1.2 "$link(4) up"

# Stop the simulation at 2.0
$ns at 2.0 "finish"

$ns run

# ---------------------------------------------------------------