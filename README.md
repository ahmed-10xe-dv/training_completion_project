# **UVM Based Verification Of AXI-TO-AHB**  
# **Bridge** 
**Trainee Name:                                                                           [ Ahmed Raza](mailto:ahmed.raza@10xengineers.ai) ![](/images/Aspose.Words.dc60e07b-60ce-4f64-8dde-e30d484ba370.001.png)Manager:                                                                                    [ Rubab Fatima ](mailto:rubab@techhivesolutions.com)Tech Lead:                                                                                   [ Hassan Ashraf](mailto:hassan.ashraf@10xengineers.ai) Peer Mentor:                                                                              [ Abdullah Nadeem](mailto:abdullah.nadeem@10xengineers.ai)** 

**CONTENTS** 

1. [**INTRODUCTION.......................................................................................................................3](#_page1_x0.00_y72.43)** 
1. [AMBA AXI (Advanced eXtensible Interface).......................................................................... 4](#_page2_x0.00_y78.85) 
1. [Advanced High-performance Bus (AHB)..................................................................................5](#_page3_x0.00_y49.00) 
2. [**AXI TO AHB BRIDGE..............................................................................................................6](#_page4_x0.00_y67.40)** 
2. [**AXI TO AHB BRIDGE MicroArchitecture.............................................................................7](#_page5_x0.00_y49.00)** 
1. [AXI4 Slave Interface................................................................................................................. 7](#_page5_x0.00_y442.41) 
1. [AXI4 Write State........................................................................................................................8](#_page6_x0.00_y49.00) 
1. [AXI4 Read State Machine......................................................................................................... 8](#_page6_x0.00_y147.62) 
1. [AHB-Lite Master Interface........................................................................................................8](#_page6_x0.00_y233.59) 
1. [AHB State Machine................................................................................................................... 8](#_page6_x0.00_y367.45) 
1. [Timeout Module.........................................................................................................................8](#_page6_x0.00_y536.91) 
4. [**Features and Limitations of BRIDGE.....................................................................................**](#_page7_x0.00_y49.00)[10](#_page8_x0.00_y114.50) 
4. [**Testbench Architecture.............................................................................................................11](#_page9_x0.00_y61.65)** 
1. [Sequences and Sequence Items................................................................................................12](#_page10_x0.00_y80.81) 
2. [AHB AGENT...........................................................................................................................12](#_page10_x0.00_y342.73) 
2. [AXI AGENTS..........................................................................................................................12](#_page10_x0.00_y476.38) 
2. [AHB ENVIRONMENT...........................................................................................................12](#_page10_x0.00_y642.97) 
2. [AXI ENVIRONMENT............................................................................................................ 13](#_page11_x0.00_y86.95) 
2. [AXI-TO-AHB Environment.................................................................................................... 13](#_page11_x0.00_y231.39) 
2. [TEST........................................................................................................................................13](#_page11_x0.00_y375.84) 
2. [TESTBENCH TOP..................................................................................................................13](#_page11_x0.00_y522.14) 
6. [**DUT and AXI MASTER and AHB Slave Communication...................................................14](#_page12_x0.00_y61.65)** 
6. [**How Does the Test Start and End?..........................................................................................15](#_page13_x0.00_y61.65)** 
6. [**TEST PLAN...............................................................................................................................16](#_page14_x0.00_y61.65)** 
6. [**Assertions Plan..........................................................................................................................28](#_page26_x0.00_y61.65)** 

[**11. References................................................................................................................................ 30](#_page28_x0.00_y61.65)** 

1 

<a name="_page1_x0.00_y72.43"></a>**1.  INTRODUCTION** 

Integrated circuits have entered the era of System-on-Chip (SoC), a design paradigm where all components of a computer or electronic system are integrated onto a single chip.  These  components  may  include  digital,  analog,  mixed-signal,  and  often radio-frequency  functionalities,  all  implemented  on  a  unified  substrate.  With  the increasing complexity of designs, Intellectual Property (IP) integration has become an indispensable aspect of SoC development. The widespread adoption of various IPs has significantly  influenced  the  design  flow,  making  On-Chip  Buses  (OCBs)  a  critical component of modern SoC architectures.  

Among  the  numerous  OCB  standards  available,  the  Advanced  Microcontroller  Bus Architecture  (AMBA)  has  emerged  as  the  industry  standard  for  SoC  interconnects. AMBA enables efficient development of multiprocessor designs with a large number of controllers and peripherals. Despite its name, AMBA’s applications extend far beyond microcontroller devices. Since its introduction by ARM in 1996, the architecture has been widely adopted across Application-Specific Integrated Circuits (ASICs) and SoC designs, including applications processors in portable mobile devices such as smartphones. The earliest  AMBA  specifications  introduced  the  Advanced  System  Bus  (ASB)  and  the Advanced  Peripheral  Bus  (APB),  laying  the  groundwork  for  a  commonly  used  and versatile bus architecture. 

In its latest iterations, such as AMBA 4.0, the architecture supports high-speed, pipelined data  transfers  through  an  extensive  set  of  bus  signals,  making  the  verification  of AMBA-based embedded systems a technically challenging task. 

This project focuses on verifying an AXI to AHB bridge, which provides an interface between  the  high-performance  AXI  bus  and  the  high-bandwidth  AHB  domain peripherals. The AMBA AXI (Advanced eXtensible Interface) to AHB-Lite (Advanced High-Performance Bus) bridge translates AXI4 transactions into AHB-Lite transactions. It includes a slave interface that receives transactions from the AXI4 master, converts them  into  AHB  transactions,  and  initiates  them  on the AHB bus, ensuring seamless communication between the two bus protocols. 

1. **AMBA<a name="_page2_x0.00_y78.85"></a> AXI (Advanced eXtensible Interface)** 

The AMBA AXI protocol is designed for high-performance, high-frequency system architectures and incorporates features that make it well-suited for high-speed submicron interconnects. Its key features include: 

- **Separate  Address/Control  and  Data  Phases**:  Decoupling  address/control signaling from data transfer for enhanced efficiency. 
- **Support for Unaligned Data Transfers**: Facilitated by byte strobes, enabling flexible data handling. 
- **Burst-Based  Transactions**:  Transactions  are  initiated  with  a  single  start address, minimizing overhead. 
- **Independent Read and Write Channels**: Separate data channels optimize low-cost Direct Memory Access (DMA) operations. 
- **Multiple Outstanding Address Support**: Enhances throughput by enabling concurrent address transactions. 
- **Out-of-Order  Transaction  Completion**:  Allows  flexibility  in  completing transactions to optimize performance. 
- **Register Stage Integration**: Simplifies timing closure for complex designs. 

Additionally,  the  AXI  protocol  offers  optional  extensions  for  low-power  operation, enabling signaling to minimize energy consumption. 

The  AXI  protocol  operates  on  a  burst-based  transfer  model.  Each  transaction  is characterized by address and control information sent via the address channel, which defines  the  data  transfer's  parameters.  Data  exchange  between  the  master  and  slave occurs through five distinct channels: 

1. **Write Address Channel** 
1. **Write Data Channel** 
1. **Write Response Channel** 
1. **Read Address Channel** 
1. **Read Data Channel** 

For write transactions, where data flows from the master to the slave, the AXI protocol includes a dedicated write response channel. This channel allows the slave to confirm the completion  of  the  write  operation  to the master, ensuring robust communication and synchronization. 

2. **Advanced<a name="_page3_x0.00_y49.00"></a> High-performance Bus (AHB)** 

AMBA AHB-Lite is specifically designed to meet the demands of high-performance, synthesizable designs. It is a bus interface that supports a single bus master, enabling high-bandwidth operations. The protocol incorporates distinct address and data phases, achieving pipelining by overlapping these phases to optimize throughput. 

AHB-Lite integrates features essential for high-performance and high-frequency systems, such as: 

- **Burst Transfers**: Facilitates efficient handling of sequential data. 
- **Single-Clock Edge Operation**: Simplifies timing and ensures consistency. 
- **Non-Tristate Implementation**: Improves reliability and simplifies design. 
- **Wide Data Bus Configurations**: Supports data widths of 64, 128, 256, 512, and 1024 bits, catering to diverse application requirements. 

The  AHB-Lite  architecture  is  highly  pipelined,  making  it  ideal  for  high-throughput operations.  Common  AHB-Lite  slaves  include  internal  memory  devices,  external memory interfaces, and high-bandwidth peripherals. While low-bandwidth peripherals can also function as AHB-Lite slaves, they are generally placed on the AMBA Advanced Peripheral  Bus  (APB)  to  optimize  system  performance.  Bridging  between  the high-performance AHB-Lite bus and the APB is achieved through an AHB-Lite slave component  known  as  an  APB  bridge.  This  bridge  enables  seamless  communication between the two bus protocols, ensuring system integration and efficiency.

2. **AXI<a name="_page4_x0.00_y67.40"></a> TO AHB BRIDGE** 

   The AMBA (Advanced Microcontroller Bus Architecture) AXI (Advanced eXtensible Interface)  to  AHB-Lite  (Advanced  High-Performance  Bus)  Bridge  facilitates  the translation of AXI4 transactions into AHB-Lite transactions. It features a slave interface that receives AXI4 master transactions, converts them into AHB master transactions, and initiates these transactions on the AHB bus. 

   The AXI protocol employs five distinct channels: the write address channel, write data channel, write response channel, read address channel, and read data channel. The AXI clock operates independently of the AHB clock, and the bridge effectively converts AXI read and write transactions into their corresponding AHB read and write transactions. This  bridge  serves  as  an  interface  between  high-performance  AXI  processors  and high-bandwidth  AHB  peripherals,  such  as  memory  controllers,  DMA  controllers, touchpads, and SD cards. 

   Data transfer in all AXI channels utilizes a handshake mechanism. The master asserts the **VALID** signal to indicate the availability of valid address, control, or data information, while the slave asserts the **READY** signal when it is prepared to accept the information. 

   The  AHB  Bridge  buffers  address, control, and data signals from AXI4, drives AHB peripherals,  and  returns  data  and  response  signals  to  AXI4.  Address  decoding  is performed using an internal address map to select the appropriate peripheral. The bridge is designed to operate seamlessly when the AXI4 and AHB clocks have independent frequencies and phases. 

   For  every  AXI  channel,  invalid  commands  are  not  propagated.  Instead,  the  bridge generates error responses. For instance, if a peripheral being accessed does not exist, the bridge issues a **DECERR** (decode error) response via the response channel (read or write). If the target peripheral exists but asserts an error condition, the bridge returns a **SLVERR** (slave error) response. 

   The Design Under Test (DUT) utilized for verification in this project is the LogiCORE IP AXI  to AHB-Lite Bridge (v1.00a) from Xilinx, which exemplifies robust design and compliance with the described protocols. 

3. **AXI<a name="_page5_x0.00_y49.00"></a> TO AHB BRIDGE MicroArchitecture** 

   The  protocols  utilized  in  this  project  include  AXI4  and  AHB-Lite,  with  the IP generated in Vivado configured with the following parameters: a 32-bit data width, a 32-bit address width, a timeout value of 16, and the "**Enable Narrow Burst**" option activated. 

   ![](/images/Aspose.Words.dc60e07b-60ce-4f64-8dde-e30d484ba370.002.png)

1. **AXI4<a name="_page5_x0.00_y442.41"></a> Slave Interface** 

The AXI4 slave interface module provides a bidirectional interface, offering flexibility in configuration. The AXI4 address width is configurable between 32 and 64 bits, while the data bus width can be set to either 32 or 64 bits. The AXI4 to AHB-Lite Bridge supports consistent data width across both interfaces, ensuring seamless integration and communication. 

When simultaneous read and write transfer requests occur on the AXI4 interface, the bridge prioritizes the read request over the write request, optimizing performance for scenarios requiring faster data retrieval. 

2. **AXI4<a name="_page6_x0.00_y49.00"></a> Write State** 

` `The AXI4 Write State Machine is an integral component of the AXI4 slave interface module,  operating  on  the  AXI4  write  channels.  This  module  manages  AXI4  write operations and generates corresponding write responses. In the event of a bridge timeout, 

it concludes the AXI4 write transaction by issuing a SLVERR response. 

3. **AXI4<a name="_page6_x0.00_y147.62"></a> Read State Machine** 

` `The AXI4 Read State Machine is part of the AXI4 slave interface module, functioning on the AXI4 read channels. It governs AXI4 read operations and produces the appropriate read  responses.  Similar  to  the  write  state  machine,  if  a  bridge  timeout  occurs,  it 

<a name="_page6_x0.00_y233.59"></a>terminates the AXI4 read transaction with a **SLVERR** response.

4. **AHB-Lite Master Interface** 

`      `The AHB-Lite Master Interface module provides the interface for AHB-Lite operations. 

Configurable through the Vivado IDE, the AHB-Lite address width can range from 32 to 64 bits, while the data bus width can be either 32 or 64 bits. The AXI4 to AHB-Lite Bridge maintains uniform data widths across both the AXI4 and AHB-Lite interfaces, ensuring efficient data handling and compatibility.** 

5. **AHB<a name="_page6_x0.00_y367.45"></a> State Machine** 

The  AHB  State  Machine  resides  within  the  AHB-Lite  master  interface  module  and coordinates  data  transfers  between  the  AXI4  and  AHB-Lite  interfaces.  For  write operations initiated by the AXI4 interface, the state machine captures control signals and data from the AXI4 slave interface and transmits them as equivalent AHB-Lite write accesses.  Similarly,  it  conveys  AHB-Lite  write  responses  back  to  the  AXI4  slave interface. For read operations, it processes control signals from the AXI4 slave interface and facilitates equivalent AHB-Lite read accesses. The state machine also handles the transfer of AHB-Lite read data and read responses back to the AXI4 slave interface.** 

6. **Timeout<a name="_page6_x0.00_y536.91"></a> Module** 

` `The Timeout Module is designed to monitor and handle cases where the AHB-Lite slave does not respond to AHB transactions. It is parameterized to generate a timeout only if the configured parameter value is non-zero. When the AHB-Lite slave fails to respond, the module waits for a specified number of AXI4 clock cycles, as defined by the timeout parameter, before signaling a timeout. This mechanism ensures robust error handling and system reliability. 

4. **Features<a name="_page7_x0.00_y49.00"></a> and Limitations of BRIDGE** 
   #### The Xilinx AXI to AHB-Lite Bridge is a soft IP core that facilitates the communication between AXI and AHB-Lite interfaces. The key features and limitations of the bridge are as follows: 
1. **Features of Bridge** 
#### **AXI4 Slave Interface:** 
- Compliant with the AXI4 specification. 
- Supports a 1:1 synchronous clock ratio between AXI and AHB interfaces. 
- Functions as a 32/64-bit slave interface on 32/64-bit AXI4 buses. 
- Supports incrementing burst transfers with lengths ranging from 1 to 256. 
- Supports wrapping burst transfers of lengths 2, 4, 8, and 16. 
- Handles fixed burst transfers with lengths ranging from 1 to 16. 
- Allows  narrow  transfers,  such  as  8/16-bit  transfers  on  a  32-bit  bus  and 8/16/32-bit transfers on a 64-bit data bus. 
- Provides limited support for cache encoding and protection units. 
- Includes address/data phase timeout management. 
#### **AHB-Lite Master Interface:** 
- Interfaces with the AHB-Lite bus as a 32/64-bit master on 32/64-bit AHB-Lite systems. 
- Supports single burst transfers. 
- Capable of handling wrapping burst transfers with lengths of 4, 8, and 16, as well as undefined burst lengths. 
- Does not issue incrementing burst transfers across 1 kB address boundaries. 
- Provides limited protection control. 
- Supports narrow transfers, including 8/16-bit transfers on a 32-bit data bus and 8/16/32-bit transfers on a 64-bit data bus 
2. **Limitations of the AXI to AHB-Lite Bridge AXI4 Slave Interface:** 
- Data bus widths greater than 64 bits are not supported. 
- The bridge does not implement registers due to the lack of support for posted writes. 
- Operations such as locked, barrier, trust zone, and exclusive are not supported. 
- Out-of-order completion of read and write transactions is not supported. 
- Unaligned and sparse transfers (i.e., transfers with gaps in strobes) are not supported. 
- Responses  like  EXOKAY  and  DECERR  are  not  supported  for  AXI4 transactions. 
- Low-power state functionality is not supported. 
- Secure access operations are not supported. 
#### **AHB-Lite Master Interface:** 
- Data<a name="_page8_x0.00_y114.50"></a> bus widths greater than 64 bits are not supported. 
- Cacheable access is not supported. 
5. **Testbench<a name="_page9_x0.00_y61.65"></a> Architecture![](/images/Aspose.Words.dc60e07b-60ce-4f64-8dde-e30d484ba370.003.png)**

**Testbench Architecture** 

1. **Sequences<a name="_page10_x0.00_y80.81"></a> and Sequence Items**

The  **AHB  Sequence  Item**  represents  the  fundamental  unit  of  AHB  protocol  transactions, encapsulating attributes like address, data, control signals, and transaction types (read/write). It uses  UVM  macros  for  automation,  introspection,  and  randomization  to  ensure  diverse  test scenarios.  Constraints  on  critical  signals  like  HREADY  guarantee protocol compliance while 

enabling robust verification. The **AHB Sequence**, extending **uvm\_sequence**, generates and executes these transactions by using read and write operations. It verifies the DUT behavior by integrating randomized stimuli and response validation.

The  **AXI  Sequence  Item**  is  a  modular  UVM  component  for  AXI4  protocol  verification, encapsulating  key  transaction  attributes  like  address,  burst  type,  and  operation  type.  Its randomization and constraints ensure protocol adherence, while utility methods like awsize enhance  flexibility.  The  **axi\_rd\_addr\_sequence,  axi\_wr\_addr\_seq,  axi\_wr\_data\_seq, axi\_rd\_data\_seq, axi\_wr\_rsp\_seq** ,  built  on  **uvm\_sequence**,  uses  the  sequence  item  to generate AXI4 transactions, handling scenarios like varying burst lengths and aligned addresses. This  sequence  validates  the  AXI4 protocol's integrity and robustness by driving stimuli and 

capturing responses in a structured manner.** 

2. **AHB<a name="_page10_x0.00_y342.73"></a> AGENT** 

The ahb\_agent.sv file defines the ahb\_agent class, which integrates key components for the  AHB  verification  process,  including  the sequencer, driver, and monitor. The agent class inherits from uvm\_agent and utilizes a configuration object to set up the environment. In the build  phase,  it  checks  the  configuration  and  creates  instances  of  the driver, sequencer, and monitor, if the agent is active. During the connect phase, it connects the driver’s sequence item port to the sequencer’s sequence item export. If the agent is inactive, it logs a message indicating the agent’s passive state. The file ensures the proper initialization and connection of components 

to enable AHB verification. 

3. **AXI<a name="_page10_x0.00_y476.38"></a> AGENTS** 

` `The AXI agents consist of multiple agents, each designed to handle different aspects of the AXI protocol. The **Write Address Agent** and **Read Address Agent** manage the address phase of write and read transactions, respectively, while the **Write Data Agent** and **Read Data Agent** focus  on  the  data  phase  for  write  and read operations. Each agent is composed of its own sequencer, driver, and monitor, ensuring the correct generation of sequence items, driving of signals, and monitoring of transactions. Additionally, the **Write Response Agent** handles the response phase, verifying the correctness of write transactions. These agents work together to facilitate comprehensive AXI protocol verification, with each agent independently controlling its associated phase through dedicated components for sequencing, driving, and monitoring. 

4. **AHB<a name="_page10_x0.00_y642.97"></a> ENVIRONMENT** 

The  ahb\_environment  serves  as  the  environment  for  AHB-side  verification.  This  class manages the instantiation of the AHB agent and its connections within the testbench. In the build phase, the environment creates an instance of the ahb\_agent, which is responsible for driving and  monitoring  the  AHB  protocol.  During  the  connect  phase,  the  environment  sets  up  the necessary connections, though the specific connections for analysis ports to the scoreboard are 

not detailed in this version. This class ensures proper integration and management of the AHB agent, playing a central role in the overall AHB verification process. 

5. **AXI<a name="_page11_x0.00_y86.95"></a> ENVIRONMENT** 

The axi\_environment class, which serves as the environment for the AXI verification setup. This class is responsible for managing multiple AXI agents, including the Write Address, Read Address, Write Data, Read Data, and Write Response agents, each handling a specific phase of the AXI protocol. In the build phase, the environment creates instances of these agents, ensuring that all necessary components for AXI protocol verification are instantiated. During the connect phase,  the  environment  sets  up  the  connections  for  analysis  ports,  although  the  details  of connecting  these ports to the scoreboard are not included. This class plays a crucial role in managing the AXI agents and establishing the necessary connections to facilitate comprehensive AXI verification. 

6. **AXI-TO-AHB<a name="_page11_x0.00_y231.39"></a> Environment** 

The **axi2ahb\_env** serves as the environment for AXI-to-AHB protocol verification. This class manages the AXI and AHB environments, the virtual sequencer, and the scoreboard. In the build phase, it creates instances of the AXI environment, AHB environment, virtual sequencer, and scoreboard. During the connect phase, it establishes the necessary connections between the virtual sequencer and the sequencers of the AXI and AHB agents, enabling coordinated transaction generation  across  the  two  protocols.  The  AXI  monitor  analysis  ports  are  connected  to  the scoreboard for transaction comparison, and the AHB monitor is similarly connected to ensure proper  verification.  This  environment  ensures  seamless  interaction  between  AXI  and  AHB components while facilitating the verification of data transfers between the two protocols. 

7. **TEST<a name="_page11_x0.00_y375.84"></a>** 

The  **axi2ahb\_test**  implements  the  testbench  for  verifying  the  AXI  to  AHB  bridge functionality.  The  test  class  **axi2ahb\_test**  initializes  the  AXI-to-AHB  environment  and manages  the  execution  of  sequences  via  a  virtual  sequencer.  In  the  build  phase,  it  creates instances of the AXI2AHB environment, a virtual sequence, and configuration settings. The main phase of the testbench starts the sequence through the virtual sequencer, allowing the system to execute the test scenario. The test includes objections raised and dropped during the execution to manage the simulation flow. The file also provides for printing the topology at the end of the elaboration phase, ensuring the environment and sequence are set up correctly for the verification 

process. 

8. **TESTBENCH<a name="_page11_x0.00_y522.14"></a> TOP** 

The **tb\_top** serves as the top module for running the AXI-to-AHB bridge verification testbench. It is responsible for generating the clock and reset signals for the DUT (Device Under Test), instantiating  the  DUT,  and  managing  the  connections  to  the AXI and AHB interfaces. The module  includes  initial  blocks  for  clock  and  reset  signal  generation. It also instantiates the 

**axi\_ahblite\_bridge\_0** DUT, connecting the AXI interface signals to the appropriate DUT ports and the AHB interface signals for the AHB-to-AXI bridge verification. The test execution is triggered by calling **run\_test("axi2ahb\_test")** in the UVM testbench. The module also 

sets up the UVM configuration database to link the AXI and AHB virtual interfaces with the respective interface instances and includes waveform dumping for simulation analysis. 

6. **DUT<a name="_page12_x0.00_y61.65"></a> and AXI MASTER and AHB Slave Communication** 

![](/images/Aspose.Words.dc60e07b-60ce-4f64-8dde-e30d484ba370.004.jpeg)

The  diagram  illustrates  a  verification  environment  for  a  bridge  module  converting  AXI (Advanced  eXtensible  Interface)  transactions  to  AHB  (Advanced  High-performance  Bus) transactions.  The  left  section  features  the  AXI  domain,  where  AXI  sequences  generate transactions and interact with specialized drivers for different types of AXI operations. These drivers  include  the  Write  Address  Driver,  Write  Data  Driver,  Write Response Driver, Read Address Driver, and Read Data Driver. The drivers interface with the axi\_interface, which facilitates communication with the central AXI-to-AHB Bridge. The bridge plays a pivotal role in translating AXI protocol transactions into equivalent AHB protocol transactions. 

On the AHB domain side, the AHB driver handles the converted transactions and communicates with  the ahb\_interface. The driver interacts with AHB sequences, which drive specific transaction  scenarios  to  test  the  bridge's  functionality  comprehensively.  This  environment demonstrates  a  layered  and  modular  approach  to  protocol  verification,  ensuring  accurate translation between AXI and AHB. 

14** 

7. **How<a name="_page13_x0.00_y61.65"></a> Does the Test Start and End?** 

   In the testbench top, the verification process starts by calling the run\_test method, where the name of the specific test to be executed is provided. This test contains the handles of all the AXI and AHB sequences needed for simulation. During the main\_phase of the test, the sequences are started on their respective sequencers based on the test scenario being executed. For example, in a write operation, the phase.raise\_objection is used to signal the beginning of the test, ensuring the simulation does not terminate prematurely. The test executes multiple sequences concurrently in a fork-join block, such as starting the write address, write data, and write response sequences on their respective AXI agents while simultaneously executing the AHB sequence on the  AHB  agent.  Once  the  sequences  complete  or  a  specified  condition  is  met,  the 

   phase.drop\_objection is called, marking the end of the test. 

   Similarly, in a read operation, the test initiates the appropriate sequences in a fork-join block, such  as starting the read address sequence, read data sequence, and the corresponding AHB sequence. Additionally, a specific mechanism monitors the progress of the read operation, such as 

   counting the number of valid read responses (RVALID) on the AXI interface. This monitoring is implemented in a while loop within a forked thread, ensuring that the test waits for the expected number of read responses before concluding. Once the conditions are met or the forked processes complete, the test uses phase.drop\_objection to signal the end of the simulation, allowing 

   the  testbench  to  gracefully  exit.  This  structured  approach  ensures  that  both  write  and read 

   operations are executed and validated comprehensively. 

14** 


8. **TEST<a name="_page14_x0.00_y61.65"></a> PLAN**

**AXI to AHB Bridge Verification** 



|**TES T NO** |**TEST NAME** |**DESCRIPTION** |**FEATURE** |**STATUS** |**PASS/ FAIL** |**PASS/FAIL Criterion** |**Waveform** |
| :-: | - | - | - | - | -: | - | - |
|1 |reset\_chec k|Verifying DUT functionality during reset conditions. |Outputs of the DUT remain at predefined values |Completed|`  `PASS |Reset should set all the AXI and AHB signals to default values ||
|2 |basic\_write \_test|Generating FiXED busrt with DW (Data Width) 4 and Transfer Size 4 bytes |DUT converts it to a single write transaction of 4 bytes |Completed|`  `PASS |Data on AXI write data channel has been written on AHB slave |[basic_wri…](https://drive.google.com/file/d/1x38KznDhfs_anLE0lTO70iCaATKEL4Ov/view?usp=drive_link)|
|3 |fix\_wr\_beat 2\_test|Generating FIXED burst with 2 beats. Each beat has DW (Data Width) 4 and Transfer Size 4 bytes. |DUT converts it into two separate write transactions of 4 bytes each. |Completed|`  `PASS |Data on AXI write data channel has been written correctly to the AHB slave for both beats. |[fix_wr_b…](https://drive.google.com/file/d/1jgJft3O4UHPZA87wCmLA3G5T4EevIOow/view?usp=drive_link)|
|4 |fix\_wr\_beat 16\_test|Generating FIXED burst with 16 beats. Each beat has DW (Data Width) 4 and Transfer Size 4 bytes. |DUT converts it into 16 separate write transactions of 4 bytes each. |Completed|`  `PASS |Data on AXI write data channel has been written correctly to the AHB slave for all 16 beats. |[fix_wr_b…](https://drive.google.com/file/d/1jgJft3O4UHPZA87wCmLA3G5T4EevIOow/view?usp=drive_link)|
|5 |fix\_wr\_beat 19\_test|Generating FIXED burst with 19 beats. Each beat has DW (Data Width) 4 and Transfer Size 4 bytes. |DUT converts it into 15 separate write transactions of 4 bytes each and then 4 separate transactions utilizing the same IDs, as DUT only has 15 IDs |Completed|`  `PASS |Data on AXI write data channel has been written correctly to the AHB slave for all 19 beats. |[fix_wr_b…](https://drive.google.com/open?id=13x-TnRaEaYBGm3iCYZWMeJLs7s-z_mmX&usp=drive_copy)|
|6 |fix\_wr\_nrw 1\_beat15\_t est|Generating FIXED burst with 15 beats using narrow transfer. Each beat has DW (Data Width) 1 and Transfer Size 1 byte. |<p>DUT converts it into 15 separate write transactions, each with a data size of 1 </p><p>byte. </p>|Completed|`  `PASS |Data of 1 byte per beat on AXI write data channel has been correctly written to the AHB slave for all 15 beats. |[fix_wr_nr…](https://drive.google.com/open?id=18cmqQImWCxO9Y-LEs3DReYhK0Uh6WFne&usp=drive_copy)|
|7 |fix\_wr\_nrw 1\_beat15x 4\_test|Generating FIXED burst with 15 transactions, each containing 4 beats using narrow transfer. Each beat has DW (Data Width) 1 and Transfer Size 4 bytes. |DUT converts it into 15 separate transactions, each consisting of 4 beats with a total data size of 4 bytes per transaction. |Completed|`  `PASS |Data on AXI write data channel is correctly written to the AHB slave for all transactions and beats. |[fix_wr_nr…](https://drive.google.com/open?id=1UxgehRczCmaRPjQ4EJSBCEGfdw5FDsxm&usp=drive_copy)|

15** 



|8 |fix\_wr\_nrw 2\_beat15\_t est|Generating FIXED burst with 15 transactions, each containing 1 beat using narrow transfer. Each beat has DW (Data Width) 2 and Transfer Size 2 bytes. |DUT converts it into 15 separate transactions, each consisting of 1 beat with a total data size of 2 bytes per transaction. |Completed|`  `PASS |Data on AXI write data channel is correctly written to the AHB slave for all transactions. |[fix_wr_nr…](https://drive.google.com/open?id=13Rx31dimZl8e4P9efKHJUORJnmrGJeA8&usp=drive_copy)|
| - | :-: | :-: | :-: | - | - | :-: | - |
|9 |fix\_wr\_nrw 2\_beat15x 2\_test|<p>Generating FIXED burst with 15 transactions, each containing 2 beats </p><p>using narrow transfer. Each beat has a Data Lane Width (DW) of 2 </p><p>bytes and a total Transfer Size of 4 bytes per transaction. </p>|DUT converts it into 15 separate transactions, each consisting of 2 beats with a total data size of 4 bytes per transaction. |Completed|`  `PASS |Data on AXI write data channel is correctly written to the AHB slave for all transactions, ensuring correct address and data alignment. |[fix_wr_nr…](https://drive.google.com/open?id=1I8jHDFkxTX0TdkqclAQsNPqZS8CC5Pl2&usp=drive_copy)|
|10 |fix\_wr\_unal igned\_test|Generating FIXED burst with 2 transactions, each containing 1 beat using unaligned transfer. Each beat has a Data Lane Width (DW) of 4 bytes and a total Transfer Size of 4 bytes per transaction. |DUT processes 2 separate transactions, each with an unaligned address and writes 4 bytes per beat. DUT automatically aligns the address |Completed|`  `PASS |Data is correctly written to the AHB slave for all transactions on aligned address, ensuring proper handling of unaligned addresses. |[fix_wr_u…](https://drive.google.com/open?id=11S9N-a_h9ui4-44LWD501maXUzRh1S8J&usp=drive_copy)|
|11 |incr\_wr\_len 1\_test|Generating an INCR burst Write Address transaction with a single beat. The burst has a Data Lane Width (DW) of 4 bytes, and the Transfer Size is 4 bytes per transaction. |DUT processes a single INCR burst transaction, writing 4 bytes to the specified address. |Completed|`  `PASS |Data is correctly written to the AHB slave at the specified address |[incr_wr_l…](https://drive.google.com/open?id=1LFea4qpNgxlGg95D2ANEz5EzqEExATP2&usp=drive_copy)|
|12 |incr\_wr\_len 2\_test|Generating an INCR burst Write Address transaction with 2 beats. The burst has a Data Lane Width (DW) of 4 bytes, and the Transfer Size is 8 bytes for the transaction. |DUT processes an INCR burst transaction with a length of 2 beats, writing 8 bytes to the specified address. |Completed|`  `PASS |Data is correctly written across 2 beats to the AHB slave at the specified address, and address has been incremented according to the DATA WIDTH which is 4 bytes in this case. |[incr_wr_l…](https://drive.google.com/open?id=1iHCvhRhRm8OnXbbVYFi6zYfJuw99sPpW&usp=drive_copy)|

16** 

Generating an INCR ![](/images/Aspose.Words.dc60e07b-60ce-4f64-8dde-e30d484ba370.005.png)

Data is correctly written 

burst Write Address 

across 4 beats to the AHB 

transaction with 4  DUT processes an INCR 

slave at the specified 

incr\_wr\_len beats. The burst has a  burst transaction with a 

address, and address has 

13  Data Lane Width (DW)  length of 4 beats, writing  Completed  PASS  [incr_wr_l…](https://drive.google.com/open?id=1VI9gHnJm2KKzdQV55siSi2U1C3FrFpY5&usp=drive_copy)

4\_test been incremented 

of 4 bytes, and the  16 bytes to the specified 

according to the DATA 

Transfer Size is 16  address. 

WIDTH which is 4 bytes in 

bytes for the 

this case. 

transaction. 

Generating an INCR 

Data is correctly written 

burst Write Address 

across 8 beats to the AHB 

transaction with 8  DUT processes an INCR 

slave at the specified 

incr\_wr\_len beats. The burst has a  burst transaction with a 

address, and address has 

14  Data Lane Width (DW)  length of 8 beats, writing  Completed  PASS  [incr_wr_l…](https://drive.google.com/open?id=1Z2CVt2vqgJEO5chSuielvrqT-hzjfgnJ&usp=drive_copy)

8\_test been incremented 

of 4 bytes, and the  32 bytes to the specified 

according to the DATA 

Transfer Size is 32  address. 

WIDTH which is 4 bytes in 

bytes for the 

this case 

transaction. 

Generating an INCR 

burst Write Address 

transaction with 16  DUT processes an INCR  Data is correctly written 

incr\_wr\_len beats. The burst has a  burst transaction with a  across 16 beats to the AHB 

15  16\_test of 4 bytes, and the  64 bytes to the specified  address, with no alignment [ incr_wr_l… ](https://drive.google.com/open?id=1-Hud7cNNSmPzTpPBCL5S543FJdCsFwM0&usp=drive_copy)Data Lane Width (DW)  length of 16 beats, writing  Completed  PASS  slave at the specified 

Transfer Size is 64  address.  or burst errors. 

bytes for the 

transaction. 

Generating an INCR 

Data is correctly written 

burst Write Address  DUT processes an INCR 

across 50 beats to the AHB 

transaction with 50  burst transaction with a 

slave at the specified 

incr\_wr\_len beats. The burst has a  length of 50 beats, writing 

address, and address has 

16  Data Lane Width (DW)  198 bytes to the specified  Completed  PASS  [incr_wr_l…](https://drive.google.com/open?id=1uwoAz4k-adKD1fkwaz8P7c_FGG1VXVd3&usp=drive_copy)

50\_test been incremented 

of 4 bytes, and the  address. It manages the 

according to the DATA 

Transfer Size is 198  last bytes left 198%4 using 

WIDTH which is 4 bytes in 

bytes for the  the strobe 

this case 

transaction. 

Generating an INCR  DUT processes an INCR 

Data is correctly written 

burst Write Address  burst transaction with a 

across 13 beats to the AHB 

transaction with 13  length of 13 beats, writing 

slave at the specified 

incr\_wr\_len beats. The burst has a  49 bytes to the specified 

address, and address has 

17  Data Lane Width (DW)  address. DUT breaks all  Completed  PASS  [incr_wr_l…](https://drive.google.com/open?id=1RlmD6qM4vsxt99r3g2fmDm-Yda6A62k_&usp=drive_copy)

13\_test been incremented 

of 4 bytes, and the  transactions in 12x4 = 48 

according to the DATA 

Transfer Size is 49  bytes and 1 transaction 

WIDTH which is 4 bytes in 

bytes for the  with 1 byte to complete 49 

this case. 

transaction.  bytes 

17** 

Generating an INCR burst Write Address transaction with 5 ![](/images/Aspose.Words.dc60e07b-60ce-4f64-8dde-e30d484ba370.006.png)

incr\_wr\_len beats. The burst has a 18  Data Lane Width (DW) 

5\_test of 4 bytes, and the 

Transfer Size is 19 bytes for the 
transaction. 

DUT processes an INCR 

burst transaction with a  Data is correctly written 

length of 5 beats, writing  across 5 beats to the AHB 

19 bytes to the specified  slave at the specified 

address. DUT breaks the  address, and address has 

Completed  PASS  [incr_wr_l… ](https://drive.google.com/open?id=1Zfnv4QLJR6WjzwF0oCbgrmHkDbg_33fL&usp=drive_copy)transaction into 4x4 = 16  been incremented 

bytes and 1 transaction  according to the DATA 

with 3 bytes, and DUT  WIDTH which is 4 bytes in 

manages writting this using  this case. 

the strobe 

Generating an INCR 

burst Write Address 

transaction with 256  DUT processes an INCR  Data is correctly written 

incr\_wr\_len beats. The burst has a  burst transaction with a  across 256 beats to the 

19  256\_test of 4 bytes, and the  1024 bytes to the specified  address, with no alignment [ incr_wr_l…](https://drive.google.com/open?id=1lZMFIbwEEeS4WDK0_UySobkwIh_fqLBU&usp=drive_copy)

Data Lane Width (DW)  length of 256 beats, writing  Completed  PASS  AHB slave at the specified 

Transfer Size is 1024  address.  or burst errors. 

bytes for the 

transaction. 

Generating an INCR 

Data is correctly written to 

burst Write Address 

incr\_wr\_nr transaction with 4 beats  DbUuTrstptrroacnessascetsioannwIiNthCaR  tnhoe  isasduderessisn  ibny4teb-aelaigtsn,mweintht  

20  and a Data Lane Width  Completed  PASS  [incr_wr_l…](https://drive.google.com/open?id=1lZMFIbwEEeS4WDK0_UySobkwIh_fqLBU&usp=drive_copy)

w1\_test (DW) of 1 byte, writing  length of 4 beats, each  or burst handling. DUT is 

writing 4 bytes of data.  incrementing the addr with 

4 bytes in total to the 

1 byte (DW) 

address. 

Generating an INCR 

burst Write Address  DUT processes an INCR  Data is correctly written to 

incr\_wr\_nr transaction with 256  burst transaction with a  the address in 256 beats, 

21  w1\_len256 beats and a Data Lane  length of 256 beats, and all  Completed  PASS  with no issues in [ incr_wr_l…](https://drive.google.com/open?id=1lZMFIbwEEeS4WDK0_UySobkwIh_fqLBU&usp=drive_copy)

\_test Width (DW) of 1 byte,  beats writing 256 bytes of  byte-alignment or burst 

writing 256 bytes in  data.  handling. 

total. 

Generating an INCR 

22  win2c\_r\_lewnr8\_\_ntre transaction with 8 beats  leDbnUugTrtshtpotrrofac8nesbsaescaettsios.an7nwxIi2NthCaanRd  Completed  PASS  Dtahtea  aisdcdorerrsesctinly  8wbriettaetns ,t o [ incr_wr_l…](https://drive.google.com/open?id=1lZMFIbwEEeS4WDK0_UySobkwIh_fqLBU&usp=drive_copy)

burst Write Address 

and a Data Lane Width  ensuring no data loss or 

st (DW) of 2 bytes, writing  1 beat of 1 byte = 15 bytes  misalignment. 

of data. 

15 bytes in total. 

Generating an 

incremental Write  DUT processes 

Verify that the correct data 

incr\_wr\_mi Address transaction  incremental writes with 

sizes (1, 2, or 4 bytes) are 

23  with mixed data sizes  varying data sizes (1, 2, or  Completed  PASS  [incr_wr_l…](https://drive.google.com/open?id=1lZMFIbwEEeS4WDK0_UySobkwIh_fqLBU&usp=drive_copy)

xed\_test written sequentially without 

(1, 2, or 4 bytes) on the  4 bytes) and bursts across 

error. 

AXI Write Address  multiple beats. 

Channel. 

Generating an INCR burst Write Address 

incr\_wr\_nr transaction of length 2 

24  w2\_test on the AXI Write 

Address Channel with a narrow data lane width. 

DUT processes Write 

Verify that the transaction is 

transactions with narrow 

processed correctly with the 

data width (2 bytes) and  Completed  PASS  [incr_wr_l…](https://drive.google.com/open?id=1lZMFIbwEEeS4WDK0_UySobkwIh_fqLBU&usp=drive_copy)

specified burst, size, and 

burst size of 2 with correct 

beats. 

data size (4 bytes). 

18** 



|25 |incr\_wr\_1k b\_cross\_te st|Generating an INCR burst Write Address transaction of length 2 on the AXI Write Address Channel, crossing a 1KB boundary. |DUT processes Write transactions that cross a 1KB address boundary, with a burst type of INCR, data size of 16 bytes, and 4 beats. |Completed|`  `PASS |Verify the transaction crosses the 1KB boundary correctly and processes with the expected burst and data size. |[incr_wr_l…](https://drive.google.com/open?id=1lZMFIbwEEeS4WDK0_UySobkwIh_fqLBU&usp=drive_copy)|
| - | :-: | :-: | :-: | - | - | :-: | - |
|26 |incr\_wr\_un aligned\_tes t|Generating an INCR burst Write Address transaction of length 2 on the AXI Write Address Channel, with an unaligned address. |DUT handles Write transactions with unaligned addresses, burst type of INCR, data size of 8 bytes, and 2 beats. DUT aligns the address on AHB side |Completed|`  `PASS |<p>Verify that the transaction works correctly with an unaligned address (address is not aligned to 4-byte </p><p>boundary). And make sure DUT aligns the address on </p><p>AHB side </p>|[incr_wr_l…](https://drive.google.com/open?id=1lZMFIbwEEeS4WDK0_UySobkwIh_fqLBU&usp=drive_copy)|
|27 |incr\_wr\_nr w\_unaligne d\_test|Generating an INCR burst Write Address transaction of length 2 on the AXI Write Address Channel, with an unaligned address and narrow data lane. |DUT handles Write transactions with unaligned addresses, burst type of INCR, data size of 8 bytes, and 4 beats. DUT aligns addr on AHB side |Completed|`  `PASS |<p>Verify that the transaction works correctly with an unaligned address (address is not aligned to 2-byte </p><p>boundary) and narrow data lane width. And make sure </p><p>DUT aligns the address on AHB side </p>|[incr_wr_l…](https://drive.google.com/open?id=1lZMFIbwEEeS4WDK0_UySobkwIh_fqLBU&usp=drive_copy)|
|28 |wrp2\_wr\_t est|Generating a WRAP burst Write Address transaction with a data width of 4 bytes on the AXI Write Address Channel. |<p>DUT handles Write transactions with a WRAP burst, data width of 4 bytes, data size of 8 bytes, and 2 </p><p>beats. </p>|` `Completed|`  `PASS |Verify that the WRAP burst Write transaction works correctly with a data width of 4 bytes and the given data size. And DUT converts it to two single transactions |[wrp2_wr…](https://drive.google.com/open?id=1O5DAUlUH1-Zsu2kR4NIYPoaoIitdmEuq&usp=drive_copy)|
|29 |wrp4\_wr\_t est|Generating a WRAP burst Write Address transaction with a data width of 4 bytes on the AXI Write Address Channel. |<p>DUT handles Write transactions with a WRAP burst, data width of 4 bytes, data size of 16 bytes, and </p><p>4 beats. </p>|` `Completed|`  `PASS |Verify that the WRAP burst Write transaction works correctly with a data width of 4 bytes and the given data size. |[wrp4_wr…](https://drive.google.com/open?id=1D4Zcge2KemzYyum91aHZTcQ1fdbek_Jv&usp=drive_copy)|
|30 |wrp8\_wr\_t est|Generating a WRAP burst Write Address transaction with a data width of 4 bytes on the AXI Write Address Channel. |<p>DUT handles Write transactions with a WRAP burst, data width of 4 bytes, data size of 32 bytes, and </p><p>8 beats. </p>|` `Completed|`  `PASS |Verify that the WRAP burst Write transaction works correctly with a data width of 4 bytes and the given data size. |[wrp8_wr…](https://drive.google.com/open?id=1_LuM8dATv_NulHH8qK3BgLwzXZaakbX3&usp=drive_copy)|
|31 |wrp16\_wr\_ test|Generating a WRAP burst Write Address transaction with a data width of 4 bytes on the AXI Write Address Channel. |<p>DUT handles Write transactions with a WRAP burst, data width of 4 bytes, data size of 64 bytes, and </p><p>16 beats. </p>|` `Completed|`  `PASS |Verify that the WRAP burst Write transaction works correctly with a data width of 4 bytes and the given data size. |[wrp16_w…](https://drive.google.com/open?id=1tuK-l5HSzPGWeXd6DqsPrtqIm1mhHKc3&usp=chrome_ntp)|

19** 



|32 |wrp2\_wr\_n rw1\_test|Generating a WRAP burst Write Address transaction with a data width of 1 byte on the AXI Write Address Channel. |DUT handles Write transactions with a WRAP burst, data width of 1 byte, data size of 2 bytes, and 2 beats. |Completed|`  `PASS |<p>Verify that the WRAP burst Write transaction works </p><p>correctly with a data width of 1 byte and the given data size. And DUT converts it to two single transactions </p>|[wrp2_wr…](https://drive.google.com/open?id=1qj3jHkBWYhs9eqvWxyDPZ2owWPqz_Z9H&usp=drive_copy)|
| - | :-: | :-: | :-: | - | - | :-: | - |
|33 |wrp4\_wr\_n rw2\_test|Generating a WRAP burst Write Address transaction with a data width of 2 bytes on the AXI Write Address Channel. |<p>DUT handles Write transactions with a WRAP burst, data width of 2 bytes, data size of 8 bytes, and 4 </p><p>beats. </p>|` `Completed|`  `PASS |Verify that the WRAP burst Write transaction works correctly with a data width of 2 bytes and the given data size. |[wrp4_wr…](https://drive.google.com/open?id=1YDa4wtt6hhJTsTbzaqxbhXNLUvMbb81B&usp=drive_copy)|
|34 |wrp8\_wr\_n rw2\_test|Generating a WRAP burst Write Address transaction with a data width of 2 bytes on the AXI Write Address Channel. |<p>DUT handles Write transactions with a WRAP burst, data width of 2 bytes, data size of 16 bytes, and </p><p>8 beats. </p>|` `Completed|`  `PASS |Verify that the WRAP burst Write transaction works correctly with a data width of 2 bytes and the given data size. |[wrp8_wr…](https://drive.google.com/open?id=1PjDnKxdYkGSWmyfE_IZgt-m-mxEtaau9&usp=drive_copy)|
|35 |wrp16\_wr\_ nrw1\_test|Generating a WRAP burst Write Address transaction with a data width of 1 byte on the AXI Write Address Channel. |DUT handles Write transactions with a WRAP burst, data width of 1 byte, data size of 64 bytes, and 16 beats. |Completed|`  `PASS |<p>Verify that the WRAP burst Write transaction works </p><p>correctly with a data width of 1 byte and the given data size. </p>|[wrp16_w…](https://drive.google.com/open?id=1hmqGEzWNS1h0ol1LMwCBjBl77NRA4fZn&usp=drive_copy)|
|36 |wrp4\_wr\_ misaligned \_test|Generating a WRAP burst Write Address transaction with a misaligned address on the AXI Write Address Channel. |<p>DUT handles Write transactions with a WRAP burst, data width of 4 bytes, data size of 16 bytes, and 4 beats, with a misaligned </p><p>address. </p>|Completed|`  `PASS |Verify that the WRAP burst Write transaction works correctly with a misaligned address and the given parameters. |[wrp4_wr…](https://drive.google.com/open?id=1BmA_A0M4FuHXJi9Nk_ZBDArPYLolj4xV&usp=drive_copy)|
|37 |wr\_timeout \_test|Generating an INCR transaction and using the HREADY signal of AHB slave to control the behavior of DUT |DUT waits for slave to respond to the transactions sent by AXI master and if DUT doesn't respond the Master should assert the RESP to SLVERROR |Completed|`  `PASS |Verify that DUT does not wait indefinitely and generates the SLVERROR once the slave doesn't respond for 16 cycles |[wr_timeo…](https://drive.google.com/open?id=1Rrt4b1FxxagBIuWI3XI1uUAt35F2UROF&usp=drive_copy)|
|38 |wr\_slverr\_t est|Generating a write transaction with a slave sequence giving an error response |If the slave drives the error response after the write transaction, then the MASTER asserts the RESP with SLVERROR |Completed|`  `PASS |Verify that DUT generates the SLVERROR when the AHB Slave gives error sequence |[wr_slverr…](https://drive.google.com/open?id=1r92HeeUEBcako2kJn5Ez0nsax4flNpYa&usp=drive_copy)|
|39 |basic\_read \_test|Generating FiXED busrt with DW (Data Width) 4 and Transfer Size 4 bytes |DUT converts it to a single read transaction of 4 bytes |Completed|`  `PASS |Data on AHB Slave has been given to AXI READ channel |[basic_re…](https://drive.google.com/open?id=18sithKqlokveYqmNxNNT62yedMcMcpUl&usp=drive_copy)|
|40 |fix\_rd\_beat 2\_test|Generating FIXED burst with 2 beats. Each beat has DW (Data Width) 4 and Transfer Size 4 bytes. |DUT converts it into two separate read transactions of 4 bytes each. |Completed|`  `PASS |Data on AHB Slave has been given to AXI READ channel on both beats. |[fix_rd_be…](https://drive.google.com/open?id=1Fs7P9CdmU6JJLRRLxM-XY2UBYWyta6zO&usp=drive_copy)|

20** 

fix\_rd\_beat ![](/images/Aspose.Words.dc60e07b-60ce-4f64-8dde-e30d484ba370.007.png)41  16\_test

fix\_rd\_beat 42  19\_test

Generating FIXED 

burst with 16 beats.  DUT converts it into 16  Data on AHB Slave has 

Each beat has DW  separate read transactions  Completed  PASS  been given to AXI READ [ fix_rd_be… ](https://drive.google.com/open?id=19Lr_2bhZJr5iPGN97PVQ0ALd68lpkhnp&usp=drive_copy)(Data Width) 4 and  of 4 bytes each.  channel for all 16 beats. 

Transfer Size 4 bytes. 

DUT converts it into 15 

Generating FIXED 

separate read transactions 

burst with 19 beats.  Data on AHB Slave has 

of 4 bytes each and then 4 

Each beat has DW  Completed  PASS  been given to AXI READ [ fix_rd_be…](https://drive.google.com/open?id=1CvfnCCxYgZwmDtmpHnLc5zAfTaK4PN_H&usp=drive_copy)

separate transactions 

(Data Width) 4 and  channel for all 19 beats. 

utilizing the same IDs, as 

Transfer Size 4 bytes. 

DUT only has 15 IDs 

fix\_rd\_nrw 43  1\_beat15\_t est

fix\_rd\_nrw 44  1\_beat15x 4\_test

Generating FIXED burst with 15 beats using narrow transfer. Each beat has DW (Data Width) 1 and Transfer Size 1 byte. 

Generating FIXED burst with 15 
transactions, each containing 4 beats using narrow transfer. Each beat has DW (Data Width) 1 and Transfer Size 4 bytes. 

DUT converts it into 15 

separate read transactions,  Verify that the FIXED burst 

each with a data size of 4  read transaction works 

Completed  PASS  [fix_wr_nr… ](https://drive.google.com/open?id=1VnTIlAF16UfGyci8vUSI7wSbFyPptUPk&usp=drive_copy)byte. As DUT has no  correctly reading 4 bytes in 

functionality of narrow read  single transfer 

transfers 

DUT converts it into 15 

separate transactions, 

Verify that the FIXED burst 

each consisting of 4 beats 

read transaction works 

with a data size of 4 bytes  Completed  PASS  [fix_rd_nr…](https://drive.google.com/open?id=1Z_pGVghvHxx-_kA5Fm26uBu29EtaObKR&usp=drive_copy)

correctly reading 4 bytes in 

per transaction. As DUT 

single transfer 

has no functionality of 

narrow read transfers 

Generating FIXED 

burst with 15 

fix\_rd\_nrw transactions, each  DseUpTacraotnevterartnssiat cintitoon1s5,   Verify that the FIXED burst 

45  2\_beat15\_t containing 1 beat using  each consisting of 1 beat  Completed  PASS  read transaction works [ fix_rd_nr…](https://drive.google.com/open?id=1tbwPbizx-oGS29dccG3pCl3Z-p9T6vC1&usp=drive_copy)

est beat has DW (Data  with a total data size of 2  correctslyinrgelea dtrinagn s4febrytes in 

narrow transfer. Each 

bytes per transaction. 

Width) 2 and Transfer 

Size 2 bytes. 

Generating FIXED 

burst with 15 

DUT converts it into 15 

transactions, each 

separate transactions, 

fix\_rd\_nrw containing 2 beats  Verify that the FIXED burst 

each consisting of 2 beats 

46  2\_beat15x using narrow transfer.  read transaction works [ fix_rd_nr…](https://drive.google.com/open?id=1UXc4IZrIWCmvjqvLJ3eqkeGPWTjw6l8m&usp=drive_copy)

with a data size of 4 bytes  Completed  PASS 

Each beat has a Data  correctly reading 4 bytes in 

2\_test Lane Width (DW) of 2  single transfer 

per transaction. As DUT 

has no functionality of 

bytes and a total 

narrow read transfers 

Transfer Size of 4 bytes 

per transaction. 

Generating FIXED 

burst with 2 

transactions, each  DUT processes 2 separate  Data is correctly written to 

containing 1 beat using  transactions, each with an  the AHB slave for all 

fix\_rd\_unali unaligned transfer.  unaligned address and  transactions on aligned 

47  gned\_test Each beat has a Data  reads 4 bytes per beat.  Completed  PASS  address, ensuring proper [ fix_rd_un… ](https://drive.google.com/open?id=1zgldSb6gwFtHzUlFESHAlsD4QrRQAXDX&usp=drive_copy)Lane Width (DW) of 4  DUT automatically aligns  handling of unaligned 

bytes and a total  the address  addresses. 

Transfer Size of 4 bytes 

per transaction. 

21** 

Generating an INCR ![](/images/Aspose.Words.dc60e07b-60ce-4f64-8dde-e30d484ba370.008.png)

burst read Address 

transaction with a  DUT processes a single  Verify that data on AHB 

incr\_rd\_len single beat. The burst  INCR burst transaction,  Slave has been given to 

48  1\_test has a Data Lane Width  writing 4 bytes to the  Completed  PASS  AXI READ channel at the [ incr_rd_l… ](https://drive.google.com/open?id=1sew8AmHRHi0iimTpHMHc6qUW1J_d8h-T&usp=drive_copy)(DW) of 4 bytes, and  specified address.  specified address 

the Transfer Size is 4 

bytes per transaction. 

Verify that data on AHB 

Generating an INCR 

Slave has been given to 

burst read Address 

DUT processes an INCR  AXI READ channel across 

transaction with 2 

incr\_rd\_len burst transaction with a  2 beats at the specified 

beats. The burst has a 

49  length of 2 beats, reading 8  Completed  PASS  address, and address has [ incr_rd_l…](https://drive.google.com/open?id=1F3rb4wMDYRokTrtZQH2044-cVcRNeX5d&usp=drive_copy)

2\_test Data Lane Width (DW) 

bytes to the specified  been incremented 

of 4 bytes, and the 

address.  according to the DATA 

Transfer Size is 8 bytes 

WIDTH which is 4 bytes in 

for the transaction. 

this case. 

Generating an INCR  Verify that data on AHB 

burst read Address  Slave has been given to 

transaction with 4  DUT processes an INCR  AXI READ channel across 

incr\_rd\_len beats. The burst has a  burst transaction with a  4 beats at the specified 

50  Data Lane Width (DW)  length of 4 beats, reading  Completed  PASS  address, and address has [ incr_rd_l…](https://drive.google.com/open?id=19RY0Wf753_YYmQlCxLIED7rNl4thKg0k&usp=drive_copy)

4\_test of 4 bytes, and the  16 bytes to the specified  been incremented 

Transfer Size is 16  address.  according to the DATA 

bytes for the  WIDTH which is 4 bytes in 

transaction.  this case. 

Generating an INCR  Verify that data on AHB 

burst read Address  Slave has been given to 

transaction with 8  DUT processes an INCR  AXI READ channel across 

incr\_rd\_len beats. The burst has a  burst transaction with a  8 beats at the specified 

51  Data Lane Width (DW)  length of 8 beats, reading  Completed  PASS  address, and address has [ incr_rd_l…](https://drive.google.com/open?id=1ysnaiMINDvWTp32oqKgjMmwk_lGXuD83&usp=drive_copy)

8\_test of 4 bytes, and the  32 bytes to the specified  been incremented 

Transfer Size is 32  address.  according to the DATA 

bytes for the  WIDTH which is 4 bytes in 

transaction.  this case. 

Generating an INCR  Verify that data on AHB 

burst read Address  Slave has been given to 

transaction with 16  DUT processes an INCR  AXI READ channel across 

incr\_rd\_len beats. The burst has a  burst transaction with a  16 beats at the specified 

52  16\_test of 4 bytes, and the  64 bytes to the specified  been incremented [ incr_rd_l…](https://drive.google.com/open?id=1xr54lcoHJiu72F5wj131vsZzQ4gLaSIs&usp=drive_copy)

Data Lane Width (DW)  length of 16 beats, reading  Completed  PASS  address, and address has 

Transfer Size is 64  address.  according to the DATA 

bytes for the  WIDTH which is 4 bytes in 

transaction.  this case. 

22** 

Generating an INCR  Verify that data on AHB ![](/images/Aspose.Words.dc60e07b-60ce-4f64-8dde-e30d484ba370.009.png)

DUT processes an INCR 

burst read Address  Slave has been given to 

burst transaction with a 

transaction with 50  AXI READ channel across 

length of 50 beats, reading 

incr\_rd\_len beats. The burst has a  50 beats at the specified 

200 bytes instead of 198 

53  Data Lane Width (DW)  Completed  PASS  address, and address has [ incr_rd_l…](https://drive.google.com/open?id=10rlXybhioShdPOvUTHPkTpz5brx2VWGh&usp=drive_copy)

50\_test bytes to the specified 

of 4 bytes, and the  been incremented 

address as there is no 

Transfer Size is 198  according to the DATA 

concept of strobe in read 

bytes for the  WIDTH which is 4 bytes in 

case 

transaction.  this case. 

Generating an INCR  Verify that data on AHB 

DUT processes an INCR 

burst read Address  Slave has been given to 

burst transaction with a 

transaction with 13  AXI READ channel across 

length of 13 beats, reading 

incr\_rd\_len beats. The burst has a  13 beats at the specified 

52 bytes instead of 49 

54  Data Lane Width (DW)  Completed  PASS  address, and address has [ incr_rd_l…](https://drive.google.com/open?id=1zCLp9Pfsc4IkbtUJtqN0M-6j2wnLq1wO&usp=drive_copy)

13\_test bytes to the specified 

of 4 bytes, and the  been incremented 

address as there is no 

Transfer Size is 49  according to the DATA 

concept of strobe in read 

bytes for the  WIDTH which is 4 bytes in 

case 

transaction.  this case. 

Generating an INCR  Verify that data on AHB 

DUT processes an INCR 

burst read Address  Slave has been given to 

burst transaction with a 

transaction with 5  AXI READ channel across 

length of 5 beats, reading 

incr\_rd\_len beats. The burst has a  5 beats at the specified 

20 bytes instead of 19 

55  Data Lane Width (DW)  Completed  PASS  address, and address has [ incr_rd_l…](https://drive.google.com/open?id=1KZQHj2pj-rT8Bqv8Y89CU7qyxOnw3iqE&usp=drive_copy)

5\_test bytes to the specified 

of 4 bytes, and the  been incremented 

address as there is no 

Transfer Size is 19  according to the DATA 

concept of strobe in read 

bytes for the  WIDTH which is 4 bytes in 

case 

transaction.  this case. 

Generating an INCR  Verify that data on AHB 

burst read Address  Slave has been given to 

transaction with 256  DUT processes an INCR  AXI READ channel across 

incr\_rd\_len beats. The burst has a  burst transaction with a  256 beats at the specified 

56  Data Lane Width (DW)  length of 256 beats,  Completed  PASS  address, and address has [ incr_rd_l…](https://drive.google.com/open?id=1Efjc0x5X2Gncuu_pV1B-kBSnsop5N35Q&usp=drive_copy)

256\_test of 4 bytes, and the  reading 1024 bytes to the  been incremented 

Transfer Size is 1024  specified address.  according to the DATA 

bytes for the  WIDTH which is 4 bytes in 

transaction.  this case. 

DUT processes an INCR 

Generating an INCR  burst transaction with a 

burst read Address  length of 4 beats, each 

Verify that the INCR burst 

incr\_rd\_nr transaction with 4 beats  reading 4 bytes of data. 

read transaction works 

57  and a Data Lane Width  DUT has no functionality of  Completed  PASS  [incr_rd_n…](https://drive.google.com/open?id=13gaKoRGlaSasLk3DZCtwl58EbkuIVS5l&usp=drive_copy)

w1\_test correctly reading 4 bytes in 

(DW) of 1 byte, reading  handling the narrow read 

single transfer 

4 bytes in total to the  transfers, so it always 

address.  reads 4 bytes per 

transaction. 

23** 



|58 |incr\_rd\_nr w1\_len256 \_test|Generating an INCR burst read Address transaction with 256 beats and a Data Lane Width (DW) of 1 byte, reading 256 bytes in total. |DUT processes an INCR burst transaction with a length of 256 beats, and all beats reading 4 bytes of data in each byte. DUT has no functionality of handling the narrow read transfers, so it always reads 4 bytes per transaction. |Completed|`  `PASS |Verify that the INCR burst read transaction works correctly reading 4 bytes in single transfer |[incr_rd_n…](https://drive.google.com/open?id=1NaxzepOki6mA7hPmGvnuBYhOYQ0W0c_U&usp=drive_copy)|
| - | :-: | :-: | :-: | - | - | :-: | - |
|59 |incr\_rd\_nr w2\_len8\_te st|Generating an INCR burst read Address transaction with 8 beats and a Data Lane Width (DW) of 2 bytes, reading 15 bytes in total. |<p>DUT processes an INCR burst transaction with a </p><p>` `length of 8 beats. DUT has no functionality of handling the narrow read transfers, so it always reads 4 bytes </p><p>per transaction. </p>|Completed|`  `PASS |Verify that the INCR burst read transaction works correctly reading 4 bytes in single transfer |[incr_rd_n…](https://drive.google.com/open?id=1Ce1mb11wEU8GDdmb99lYArCKKzuyVE0X&usp=drive_copy)|
|60 |incr\_rd\_mi xed\_test|Generating an incremental read Address transaction with mixed data sizes (1, 2, or 4 bytes) on the AXI read Address Channel. |DUT processes incremental reads with varying data sizes (1, 2, or 4 bytes) and bursts across multiple beats. DUT has no functionality of handling the narrow read transfers, so it always reads 4 bytes per transaction. |Completed|`  `PASS |Verify that the INCR burst read transaction works correctly reading 4 bytes in single transfer |[incr_rd_…](https://drive.google.com/open?id=13I-X3cgcS5d1PnbPPx4C0lJqqVPP3Ary&usp=drive_copy)|
|61 |incr\_rd\_nr w2\_test|Generating an INCR burst read Address transaction of length 2 on the AXI read Address Channel with a narrow data lane width. |DUT has no functionality of handling the narrow read transfers, so it always reads 4 bytes per transaction. |Completed|`  `PASS |Verify that the INCR burst read transaction works correctly reading 4 bytes in single transfer |[incr_rd_n…](https://drive.google.com/open?id=12M_Z3vdjptRXTwSc9ryNy_Zl8rQ848B4&usp=drive_copy)|
|62 |incr\_rd\_1k b\_cross\_te st|Generating an INCR burst read Address transaction of length 2 on the AXI read Address Channel, crossing a 1KB boundary. |DUT processes read transactions that cross a 1KB address boundary, with a burst type of INCR, data size of 16 bytes, and 4 beats. |Completed|`  `PASS |Verify the transaction crosses the 1KB boundary correctly and processes with the expected burst and data size. |[incr_rd_1…](https://drive.google.com/open?id=1p3w7356SrbZy864FogTkBj6Mb345jtNM&usp=drive_copy)|
|63 |incr\_rd\_un aligned\_tes t|Generating an INCR burst read Address transaction of length 2 on the AXI read Address Channel, with an unaligned address. |DUT handles read transactions with unaligned addresses, burst type of INCR, data size of 8 bytes, and 2 beats. DUT aligns the address on AHB side |Completed|`  `PASS |<p>Verify that the transaction works correctly with an unaligned address (address is not aligned to 4-byte </p><p>boundary). And make sure DUT aligns the address on </p><p>AHB side </p>|[incr_rd_u…](https://drive.google.com/open?id=1NM36mpXai3UbFZFvv5bfJ1HtVf1pBlVH&usp=drive_copy)|

24** 

Verify that the transaction ![](/images/Aspose.Words.dc60e07b-60ce-4f64-8dde-e30d484ba370.010.png)

works correctly with an 

unaligned address (address 

Generating an INCR 

DUT handles read  is not aligned to 2-byte 

burst read Address 

transactions with unaligned  boundary) and narrow data 

win\_curn\_ardli\_gnnre addresses, burst type of  lane width. And make sure 

transaction of length 2 

64  on the AXI read  Completed  PASS  [incr_rd_n…](https://drive.google.com/open?id=1Nofo7k57J35LU-9b6VPHtOxMInUMSphw&usp=drive_copy)

INCR, data size of 8 bytes,  DUT aligns the address on 

d\_test and 4 beats. DUT aligns  AHB side. Also Verify that 

Address Channel, with 

an unaligned address 

addr on AHB side  the INCR burst read 

and narrow data lane. 

transaction works correctly 

reading 4 bytes in single 

transfer 

Generating a WRAP 

DUT handles read 

burst read Address 

transactions with a WRAP 

wrp2\_rd\_te transaction with a data 

65  st width of 4 bytes on the 

burst, data width of 4 bytes, Completed  PASS 

data size of 8 bytes, and 2 

AXI read Address 

beats. 

Channel. 

Generating a WRAP 

DUT handles read 

burst read Address 

transactions with a WRAP 

wrp4\_rd\_te transaction with a data 

66  st width of 4 bytes on the 

burst, data width of 4 bytes, Completed  PASS 

data size of 16 bytes, and 

AXI read Address 

4 beats. 

Channel. 

Generating a WRAP 

DUT handles read 

burst read Address 

transactions with a WRAP 

wrp8\_rd\_te transaction with a data 

67  st width of 4 bytes on the 

burst, data width of 4 bytes, Completed  PASS 

data size of 32 bytes, and 

AXI read Address 

8 beats. 

Channel. 

Generating a WRAP 

DUT handles read 

burst read Address 

transactions with a WRAP 

wrp16\_rd\_t transaction with a data 

68  est width of 4 bytes on the 

burst, data width of 4 bytes, Completed  PASS 

data size of 64 bytes, and 

AXI read Address 

16 beats. 

Channel. 

Verify that the WRAP burst 

read transaction works 

correctly with a data width [ wrp2_rd_…](https://drive.google.com/open?id=1UOhmZ8iP8flv6hqY0SEIvTLQhoqlmvme&usp=drive_copy)

of 4 bytes and the given 

data size. 

Verify that the WRAP burst 

read transaction works 

correctly with a data width [ wrp4_rd_…](https://drive.google.com/open?id=1PPhh8dVY16iPLC4zBWuEtQqykCUuZxXH&usp=drive_copy)

of 4 bytes and the given 

data size. 

Verify that the WRAP burst 

read transaction works 

correctly with a data width [ wrp8_rd_…](https://drive.google.com/open?id=11PNQ0Nqvux0tfSnA8K5Bh825xVev40XO&usp=drive_copy)

of 4 bytes and the given 

data size. 

Verify that the WRAP burst 

read transaction works 

correctly with a data width [ wrp16_rd…](https://drive.google.com/open?id=1wJB3eywNOLUcKr4arNgVf0hkmo81cLEv&usp=drive_copy)

of 4 bytes and the given 

data size. 

Generating a WRAP 

burst read Address  DUT has no functionality of  Verify that the WRAP burst 

wrp2\_rd\_nr transaction with a data  handling the narrow read  read transaction works 

69  w1\_test width of 1 byte on the  transfers, so it always  Completed  PASS  correctly reading 4 bytes in [ wrp2_rd_… ](https://drive.google.com/open?id=1yUj3ssKH--5_2kTJIF-YkRbf-MOQ2Ejy&usp=drive_copy)AXI read Address  reads 4 bytes  single transfer 

Channel. 

Generating a WRAP 

burst read Address  DUT has no functionality of  Verify that the WRAP burst 

wrp4\_rd\_nr transaction with a data  handling the narrow read  read transaction works 

70  w2\_test width of 2 bytes on the  transfers, so it always  Completed  PASS  correctly reading 4 bytes in [ wrp4_rd_… ](https://drive.google.com/open?id=1-rnlFbsoKJAogOWUEzGns-f7KnyaGURy&usp=drive_copy)AXI read Address  reads 4 bytes  single transfer 

Channel. 

25** 



|71 |wrp8\_rd\_nr w2\_test|Generating a WRAP burst read Address transaction with a data width of 2 bytes on the AXI read Address Channel. |DUT has no functionality of handling the narrow read transfers, so it always reads 4 bytes |Completed|`  `PASS |Verify that the WRAP burst read transaction works correctly reading 4 bytes in single transfer |[wrp8_rd_…](https://drive.google.com/open?id=1f4bBQEEj7X8Ewwzf5z4Pr8O86EYyWVId&usp=drive_copy)|
| - | :-: | :-: | :-: | - | - | :-: | - |
|72 |wrp16\_rd\_ nrw1\_test|Generating a WRAP burst read Address transaction with a data width of 1 byte on the AXI read Address Channel. |DUT has no functionality of handling the narrow read transfers, so it always reads 4 bytes |Completed|`  `PASS |Verify that the WRAP burst read transaction works correctly reading 4 bytes in single transfer |[wrp16_rd…](https://drive.google.com/open?id=1i2y-hYFudscNKK3FsEonQkNnmiRQkmvf&usp=drive_copy)|
|73 |wrp4\_rd\_m isaligned\_t est|Generating a WRAP burst read Address transaction with a misaligned address on the AXI read Address Channel. |<p>DUT handles read transactions with a WRAP burst, data width of 4 bytes, data size of 16 bytes, and 4 beats, with a misaligned </p><p>address. </p>|Completed|`  `PASS |Verify that the WRAP burst read transaction works correctly with a misaligned address and the given parameters. |[wrp4_rd_…](https://drive.google.com/open?id=1d_GlLCfpz4nkfGjMFR0CUrfkyqRvBwlR&usp=drive_copy)|
|74 |rd\_timeout \_test|Generating an INCR transaction and using the HREADY signal of AHB slave to control the behavior of DUT |DUT waits for slave to respond to the transactions sent by AXI master and if DUT doesn't respond the Master should assert the RESP to SLVERROR |Completed|`  `PASS |Verify that DUT does not wait indefinitely and generates the SLVERROR once the slave doesn't respond for 16 cycles |[rd_timeo…](https://drive.google.com/open?id=1e9eAVEm38lVyD_IU7lgdcz0iARMLZLeA&usp=drive_copy)|
|75 |basic\_rd\_wr \_test |Generating a basic fixed burst read write Address transaction with len 1 on the AXI read Address Channel. and Write Address Channel respectively |DUT handles read and write transactions with a fixed burst, data width of 4 bytes, data size of 4 bytes, and 1 beat. If both read and write transactions are given at the same time to DUT, it prioritizes the read. |Completed|`  `PASS |Verify that if both read and write transaction is given at the same time to DUT, it prioritizes the read |[basic_rd…](https://drive.google.com/open?id=1BkSDzsbnryO4lN_Xoht8yDeWM3nFy026&usp=drive_copy)|
|76 |incr\_rd\_wr \_len8\_test|Generating a INCR burst read write Address transaction with len 8 on the AXI read Address Channel. and Write Address Channel respectively |DUT handles read and write transactions with an INCR burst, data width of 4 bytes, data size of 32 bytes, and 8 beats. If both read and write transaction is given at the same time to DUT, it prioritizes the read |Completed|`  `PASS |Verify that if both read and write transaction is given at the same time to DUT, it prioritizes the read |[incr_rd_…](https://drive.google.com/open?id=1Ti23D33xDOTI5TieW4Vlz_hsvBoXSFAG&usp=drive_copy)|
|77 |rd\_wr\_priorit y\_test |Generating a transaction having both read and write on AXI read address and write address channels |If both read and write transaction is given at the same time to DUT, it prioritizes the read |Completed|`  `PASS |Verify that if both read and write transaction is given at the same time to DUT, it prioritizes the read |[incr_rd_…](https://drive.google.com/open?id=1Ti23D33xDOTI5TieW4Vlz_hsvBoXSFAG&usp=drive_copy)|

26** 

|<a name="_page26_x0.00_y61.65"></a>**9.  Assertions Plan** ||||||||
| - | :- | :- | :- | :- | :- | :- | :- |
|**AXI to AHB Bridge Verification** ||||||||
|**TYP E** |**TEST NO** |**TEST NAME** |**DESCRIPTION** |**FEATURE** |**STAT US** |**PA SS/ FAI L** |**PASS/FAIL Criterion** |
|AXI |1 |RESERVED\_BU RST |Verifies AWBURST does not have a reserved value (2'b11). |Ensures AWBURST is always valid. |Compl eted |PA SS |AWBURST should not equal 2'b11 when AWVALID is asserted. |
|AXI |2 |AXI\_ADDRESS\_ BOUNDARY |Verifies AWADDR is within a valid range (< 4095). |Prevents invalid address access. |Compl eted |PA SS |AWADDR must always be less than 4095 when AWVALID is asserted. |
|AXI |3 |ARVALID\_ARRE ADY\_HANDSHA KE |Checks proper handshake between ARVALID and ARREADY. |Ensures ARVALID remains asserted properly. |Compl eted |PA SS |ARVALID must remain high if ARREADY is low for one clock cycle. |
|AXI |4 |RVALID\_RREAD Y\_HANDSHAKE |Checks proper handshake between RVALID and RREADY. |Ensures RVALID remains asserted properly. |Compl eted |PA SS |RVALID must remain high if RREADY is low for one clock cycle. |
|AXI |5 |AWVALID\_AWR EADY\_HANDSH AKE |Checks proper handshake between AWVALID and AWREADY. |Ensures AWVALID remains asserted properly. |Compl eted |PA SS |AWVALID must remain high if AWREADY is low for one clock cycle. |
|AXI |6 |WVALID\_WREA DY\_HANDSHAK E |Checks proper handshake between WVALID and WREADY. |Ensures WVALID remains asserted properly. |Compl eted |PA SS |WVALID must remain high if WREADY is low for one clock cycle. |
|AXI |7 |BVALID\_BREAD Y\_HANDSHAKE |Checks proper handshake between BVALID and BREADY. |Ensures BVALID remains asserted properly. |Compl eted |PA SS |BVALID must remain high if BREADY is low for one clock cycle. |
|AH B |8 |HREADY\_CHEC K |Verifies stability of HADDR, HWRITE, and HWDATA when HREADY is low. |Ensures proper signal stability during wait states. |Compl eted |PA SS |HADDR, HWRITE, and HWDATA should not change when HREADY is low. |
|27** ||||||||

10. **Directory Structure** 

28** 

11. **References**

<a name="_page28_x0.00_y61.65"></a>29** 