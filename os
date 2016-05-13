os:
  -resource allocator
  -control program
  -mediates hardware to software
    -abstracts hardware away as interfaces
    -programs request services via traps or exceptions
    -devices request attention via interrupts
  -sharing 
  -protection
    
architectures
  -server client
  -distributed
  -peer2peer
  -virtualization
  -cloud computing

privileged instructions only OS can use them (kernel mode)
  -directly acccess IO devices
  -manipulate memory state management
    -page table pointers
    -TLB loads
  -manupulate special mode bits
    -interrupt priority level
  -mode is sey by status bit in a protected processor register
  -syscall
    -lets user mode access IO
    -os verifies callers arguments
    -saves callers state
    -exec
    -returns to programm

program 'stops'  
  -interrupt, async, caused by an external device
  -exception sync, unexpected problem
  -trap sync, inteded transition to OS due to an instruction

monolithic
  -low cost of module interaction
  -hard to maintain, understand, modify
  -unreliable (no isolation)

layering
  -os as a set of layers
  -each layer presents an enhanced cm to the layer above
  -strict layering isnt flexible enough
  -poor performance

microkernels
  -minimize kernel
  -rest of OS as user-level processes
  -reliability
  -extension easy
  -poor perf
  
loadable kernel modules
  -perhabs best
  -core kernel always in place
  -other dynamically loaded
  -efficient
  -flexible

definitions:
  -multiprogramming keeps multiple programs loaded in memory, overlaps IO with actual computation
  -timesharingOS multiple terminals into one machine, optimize response time, multiple users
  -policy what will be done
  -mechanism how to do it
  
