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
  
process:
  -name is process ID (PID)
  -abstraction of execution
  -sequential process
    -an address space
    -single thread
  -consists of
    -address space
      -the code instructions
      -data for the running program
    -CPU state
      -program counter PC
      -the stack pointer
      -general purpose registers
    -OS resources
      -open files
      -network connections
    -data structure to keep track of a process state
      -process control block PCB or process descriptor
      -when process is running the state is in the CPU
      -when OS takes over data is saved to the PCB
      -context switch when from one process to another
    -exectution state
      -ready, waitining to be assigned to a CPU
      -running, exectuing on a CPU
      -waitinig 'blocked' waiting for an event IO/message from another process
      -collection of queues that represent state of all processes in the system, PCBs are moved between the queues

forking:
  -dont copy parent's address space, child promise that wont change - vfork
  -copy on write, chreate new address space with mapping to the old
  -if either parent or child write to the table, exception OS adjusts tables

definitions:
  -multiprogramming keeps multiple programs loaded in memory, overlaps IO with actual computation
  -timesharingOS multiple terminals into one machine, optimize response time, multiple users
  -policy what will be done
  -mechanism how to do it
  
