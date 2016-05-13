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
  -data structure to keep track of a process state (process control block PCB or process descriptor)
    -when process is running the state is in the CPU
    -when OS takes over data is saved to the PCB
    -context switch when from one process to another
  -exectution state
    -ready, waitining to be assigned to a CPU
    -running, exectuing on a CPU
    -waitinig 'blocked' waiting for an event IO/message from another process
    -collection of queues that represent state of all processes in the system, PCBs are moved between the queues

threads:
  -part of the process (so code data and files are shared)
  -concurrent (many threads on a single)
  -parallel (multi core system)
  -has private stack and CPU state (registers)
  -a sequential execution stream within a process
  -cheap communication to other threads of the process

multithreading
  -useful for
    -handling concurent events (web servers)
    -building parallel programs (matrix multiply)
  -useful also on a uniprocessor
  -faster better cheaper than creating new processes
  
kernel threads
  -OS creates them
  -TID's
  -allocation on execution stack within the process address space
  -thread control block
  -OS can overlap IO and computation INSIDE the process
  -cheaper than processes
  -still expensive, they require system call
    
user threads
  -library linked to the program manages the threads
  -no need to manipulate address spaces (only kernel can anyway)
  -fastttt! 10-100x times than kernel threads
  -small TCB tread control block
  -no sys calls involved
  -thread should use yields(), willing to give up CPU
  -preemption:
    -scheduler preriodically interrupots threads, by sending signla (like software interpurt but OS to user-level
  -in order to work with IO, kernel threads should still be used, pool of them can be used for different operations
  
forking:
  -dont copy parent's address space, child promise that wont change - vfork
  -copy on write, chreate new address space with mapping to the old
  -if either parent or child write to the table, exception OS adjusts tables

Synchronisation:
  -instructions executed by a single thread are totally ordered
  -in absence of sync, instructions of distinct threads must be considered simultaneous
  -critical sections, squences of instructions that may get incorrect resulsts if executed simultaneously
  -race consition, result dependent on timing
  -mutual exclustion, not simultaneouse
  -interleavings, when one thread is context switched to another that also works on the data first one worked

correct critial section requirements:
  -mutual exclustion, at most one thread in the critical section
  -progress, thread outside of critical can't prevent another thread to enter critical
  -bounded waitining (no starvation), eventually will enter the critical
  -performance, overhead of entering and exiting is small with respect to the work being done by it
  
mutex
  -while(turn !=i){}turn = I;
  -busy-wait problem
  -lock
    -acquire(), does not return until the caller gets the lock
    -release()

spinlock
  -the caller busy-waits or spins for lock to be released, wasteful
  -acquire/release must be atomic
  -need help from hardware atomic instructions test-and-set
  
semaphore
  -wait()
  -signal()
  -counting semaphore - integer value can range over an unrestricted domain
  -binary semaphore - integer value only 0/1, same as lock
  -each semaphore has an associated queue of threads
  -no busy waiting
  -threads are blocked at the level of program logic
  
monitors
  -synchronization code is added by the compiler
  -a class in which every method automatically asquires a lock on entry and relesaeses it on exit
  -producer wants to produce but full now what?!?
  -condition variables
    -wait(c)
      releases lock
      wait for someone else to signal condition
    signal(c)
      wake up at most one waiting thread
    boardcast(c)
      wake up all waiting threads
      
deadlock
  mutual exclusion
  hold and wait
  no preemption
  circular wait

definitions:
  -multiprogramming keeps multiple programs loaded in memory, overlaps IO with actual computation
  -timesharingOS multiple terminals into one machine, optimize response time, multiple users
  -policy what will be done
  -mechanism how to do it
