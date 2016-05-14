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
      
deadlock prevention
  mutual exclusion
   must hold for non sharable resources
  hold and wait
    must guarantee that whenever a process requests a resource it does not hold any other resources
  no preemption
    if a process holding some resourcces requests another unavailable res, all currently held res are released
    the process will be restarted only when it can regain old and the new ones that were held
  circular wait
    impose a total ordering of all res types and require that each process requests res in an increasing order of enumeration

deadlon avoidance
  eliminating circular wait
    each thread states its max claim for every res type
    system runs the Bankers algorithm at each allocation request
  Bankers alg
    background
      set of controlled resources is known
      number of units is known
      each thread must decalre its max poss requirement of each res type
    when a request is made
      simulate request and all other requests
      try to reduce graph
        if can be, grant
        if not, block the thread and wait
        
safe state
  on request check if allocation leaves system in a safe state
    there exists a seq p1 p2 p3...
    such that for evey pi the res that pi can get res that it can request or pj j<i has those res
    
deadlock detection and recovery
  check peridically if there is a deadlock and eliminate it
  waitian wait-for graph, peridically check, if cycle exists then deadlock exists
  aboer all deadlocked
  abort one at a time
  
scheduling goals
  performance
    maximaze CPU utilization
    throughput requests completed/s
    average response time avgtime from submission to completion
    average waiting time avgtime from submisstion to start of exec
    minimize energy Joules/s
  fairness
    
types of schedulers
  pre-emptive
    can stop the thread and give it to someone else
    involves overhead
  non pre-emptive
    once given cant stop
    
FIFO/FCFS
  p1 24
  p2 3
  p3 3
  waiting time
  p1 0
  p2 24
  p3 27
  avg waiting time (0+24+27)/3 = 17
  order matters!
  convoy effect - short process behind long process
  avg response time can be poor
  may lead to poor utilization of other resources, poor overleap of CPU and IO
  
SJF shortest job first
  optimal average waiting time for A GIVEN SET, dont know what will arrive next, nor how long jobs will take
  needs to estimate the length - should be similar to the previous one
  preemptive version called shortest remaining time first
  
Round Robin RR
  give all some time, after completion move to the end of the queue
  time given has to be large with respect to the conext switch, otherwise overhead too high
  high time -> same as FIFO

Priority Scheduling
  priority integer number is associated with each process
  smallest int -> biggest priority, CPU gets that process
  starvation can occur, fix by agining, the longer process waits increase its priority
  
Multi level feedback queues MLFQ
  workloads tend to have increasing residual life - if you dont finish quickly you're probably a lifer
  hierarchy of queues, with priority ordering among the queues
  new quests enter the highest priority quest
  each queeus is scheduled RR
  reuqests are moved between queues based on exec history
  
UNIX scheduling
  is pretty much MLFQ

Memory access
  base and limit registers define the logical address space
  on every mem access generated in user mode CPU checks if within the bounds (base is inclusive base >= x && base + limit < x)\
  use logical/virtual addresses
    OS and hardware determines location is physical mem (translates logical to physical)

Memory management Unit MMU
  at runtime maps virtual to phys address
  simple scheme, value from relocation register is added to every address generated by a user process
  
Swapping
  swap from main mem to a backing sttore
  roll out roll in
    used for priority based scheduling alg
    lover priority process is swapped so that higer can use mem
  ready queue, ready to run processes which have mem images on disk
  should swapped out process get back to same mem?
    with MMU not
    but pending IO to/from processe's mem sapce
    double buffering, always transfer IO to kernel space then to the right place (adds overhead)
    
contiguous allocation
  os memory in low address
  user processes in high address
  each single contiguous section of mem
  
multiple partition allocation
  fixed partitions
    may have diff size but partition never changes
    internal fragementation, partition may be larger than needed
  variable partitions
    size changes dynamically   
    no internal fragmentation
    external fragmentation, holes are left scattered throught phys mem

dynamic storage allocation problem
  first fit 
    alloate the first hole that is big enough
  best fit
    allocate the smallest hole, has to search entire list, unless ordered
  worst fit
    allocate to the largest hole, has to search entire list

dealing with fragmentation
  segment the data, allow for spreading parts across diff partitions
    hardware segment table required
  copy data in order to cover holes
  
Paging
  address generated by CPU is divided into  
    page number
    page offset
  calc internal fragementation
    page size is 2mb, process size is 72mb and something
    so 2mb - something is left unused, on average 1/2 of frame is unused
    small size is not desireable, each table entry takes memory to track
  PTBR page table base register points to hte page table
  PTLR page table length register indicates size of the page table
  every data access requires two mem accesses
    one for the page table (lookup where the data is in the phys space)
    one for the data itself
  use special fast lookup hardware cache called associative memory or translation look-aside buffers TLBs
    used together with page table
    some TLBs store address spcae identifiers in each entry
      uniquely identifies each process
      provide address-space protection for the process
    acts like cache, on a miss value loaded into TLB
    some values are wired down for permanet fast access
    typically small 64 to 1024 entries
    calculate memory access time
      hit ratio % of times page number is found inside TLB
      0.8 * speed of TLB + 0.2 * speed of page table
  memory protection
    associate protection bit with each frame, that indicates if readonly/writeonly
    valid-invalid bit attached to each entry to indicate if is in the process's logical address space
    PTLR page table length register can also be used to determine if valid/invalid
  shared pages for read only data, or common for example used in communcation
  
hierarchical page tables
  break up the logical address space into multiple page tables, usuallly two level
  forward mapped page table, three parts, 
    index into the outer page table, 
    displacement within the page of the inner page table, 
    page offset
  with 64 can be three level paging scheme
  
hashed page tables
  common when >32bit
  page table contains a chain of elements hashing to the same location
  check chain until virtual page number mathces
  clustered page tables, entries refear to several pages

inverted page table
  track all physical pages
  one entry for each real page of memory
  decreased amount of memory required to store
  increased time needed to search the table
  
page tables also help with
  code is read only
  dereferencing a null pointer is caught by hardware
  shared libraries
  shared memory used as a mean of communcation, no syscall required
  
virtual memory
  paged virtual memory, use pages to manage virtual mem
  on page falut
    invalid reference -> abort
    just not in memory
      find free frame
      swap frame via IO
      reset tables to indicate page now in memory, set validation bit = v
      restart the instruction that wanted the page
  demanded pagning, only load what is necessary
  
page replacement, when no free page to write to evict page frames
  try to pick a page that wont be needed
  try to pick a page that was not modified, so no need to save to disk (clean pages)
  
  
FIFO replacement algorithm
  belady's anomaly, increasint the number of page frames may increase the number of page faults!
    
least recently used LRU
  use past knowledge to predict future
  associate time of last use with each page
  at regular interval
    if hasnt been used (ref bit = 0) incerement the counter
    if has been used (ref bit = 1) zero the counter
    zero ref bit
    page with highest counter is the least recently used
    
second-chance clock / not recently used NRU
  replace 'old enough' pages
  circural linked list of frames
    if ref bit is off swap
    if on turn off and move
    
allocation of frames among processes
  local
    each process is given a limit of pages it can use
    then every replacement alg is local
  global
    the one to swap is chosen among all pages regardless of the owner
    
working set
  WS(t,w) = {pages P such that P was referenced in the time interval (t,t-w)} under set semantics
    t time
    w working set window (mesaured in page refs)
    a page is in WS only if it was reference in the last w references
  working set has to be in the memory, otherwise heavy faulting
    
thrashing
  the system spends most of its time servicing page faults, little time doing actual work
  could be the case that replacement algorithm incompatible with program behavior
  could be that too many processes
  track Page fault frequency
    if actual rate too low take frames from the process
    if actual rate too high give frames to the process
    
disks
  large 1-dm array of logical blocks
  array is mapped onto the sectors of the disk
  performance
    seek - how fast arm moves
    rotation - waiting for the sector to rotate under head
    transfer
  seeks are expensive, disk requests are scheduled
  
FCFS
  just process the requests
  reasonable when load is low
  
SSTF shortest seek time first
  reasonable default
  minimize arm movement
  maximize request rate
  may cause starvation
  unfair towards middle blocks (blocks placed physically in the middle)
  
SCAN/elevator alhorithm
  move from end to the start
  if not uniformly dense or dense at the other end of the disk
  
C-SCAN
  same as SCAN but at the end it immediatelly comes back at the start without servicing middle guys
  
C-LOOK
  reasonable default
  as SCAN but goes as far as last request in each direction
  
OS file system
  hide hardware specific interface
  allocates disk blocks
  checks permissions
  maintains metadata
  diff access methods
    sequential access, one byte at a time
    direct access, any byte

protection system
  objects what
  principlas who
  action how read/write
  access control lists, keep list of principals with their allowed actions
  capabilities for each principal keep list of objects and principals allowed actions
  put users in groups put groups in ACLs
  
basic file system structure
  every file and directoru is represented by an inode indexnode
  contains
    metadata, file wner access rights
    location fot the file's blocks on disk
  each file is known by the number - inode number

directories
  is a flat file of fixed-size entries
  each entry consists of an inode number and a file name
  directories give the inode number of a file
  top part of the filesystem contains all of the inodes

how to organize blocks on a disk
  inode points to the first block of the file, then linked list
  inode constains a list of block numbers contatining the file (index)
  block list
    each inode constains 13 block pointers
    first 10 are direct pointers (pointers to 512B blocks of file data) can get 5120B
    11th can get to 128*512B 65kb
    12 can get to 128*128*512B 8mb
    13 can get to 128*128*128*512B 1gb
    max file size is little over 1gb (UNIX 7)
    chaninging block size varies max file size 1kb -- 17gb 4kb -- 4tb
  
definitions:
  -multiprogramming keeps multiple programs loaded in memory, overlaps IO with actual computation
  -timesharingOS multiple terminals into one machine, optimize response time, multiple users
  -policy what will be done
  -mechanism how to do it
