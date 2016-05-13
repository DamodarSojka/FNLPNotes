os:
  -resource allocator
  -control program
  -mediates hardware to software
    abstracts hardware away as interfaces
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


definitions:
  -multiprogramming keeps multiple programs loaded in memory, overlaps IO with actual computation
  -timesharingOS multiple terminals into one machine, optimize response time, multiple users
