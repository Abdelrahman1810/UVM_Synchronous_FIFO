# UVM FIFO Verification

## Design Overview
The UVM FIFO (First-In-First-Out) design under verification is a module that implements a FIFO buffer. The design file is located in the `DUT` folder and is named `FIFO.sv`.

## Verification Environment

### Simulation Setup
1. To observe the design behavior in the waveform, run the `run.do` script.
2. To extract all the reports, run the `run_extract_report.do` script.

### Configurable Parameters
Before running the simulation, you can modify the following loop variables in the `shared_pkg.sv` file:
- `HOBBIT_LOOP`
- `DWARF_LOOP`
- `HUMAN_LOOP`
- `GIANT_LOOP`
- `BOOM_LOOP`

### Design Files
- The `definitions.svh` file contains all the macros used in the program.
- The `assertion_defnition.txt` file in the `DUT` folder provides information about the assertions used in the design.

### Verification Components
- The `object` folder contains 5 sequence files.
- The `refrence` folder contains the reference model `FIFO_ref.sv` for the DUT.
- The design file `FIFO.sv` has several internal assertions.
- Each assertion has a corresponding cover statement, and the coverage report can be found in the `Directive_cover_report.txt` file in the `report` folder.

## Verification Plan

The verification plan consists of the following steps:

1. Activate the reset signal for the first 5 cycles.
2. Lock the reset signal.
3. Write only to make the FIFO full.
4. Write when the FIFO is full.
5. Read fewer times than the FIFO depth.
6. Constrain the read and write operations such that the write operation happens more often than the read operation.
    - The first loop has a constraint on the `data_in` signal, making it one bit higher.
    - The second loop has no constraint on the `data_in` signal.
7. Apply a synchronous toggle, where the read and write operations are equal but not equal to the same value twice in a row.
8. Read only to make the FIFO empty.
9. Read when the FIFO is empty.
10. Write only to make the FIFO before full.
11. Apply an asynchronous toggle, where the read and write operations are not equal but not equal to the same value twice in a row.
12. Read only.
13. Write only.
14. Unlock the reset signal.
15. Apply read and write operations at the same time, with the write operation happening less often than the read operation.
    - The first loop has a constraint on the `data_in` signal, making it one bit higher.
    - The second loop has no constraint on the `data_in` signal.
16. Activate the reset signal.
17. Randomize the read and write operations with no constraints.

## UVM Verification Flow

The UVM verification flow is organized in the `test.sv` file and consists of the following steps:

1. Create the `definitions.svh` file to contain all the definition macros used in the program.
2. Create the `shared_pkg.sv` file that has shared variables and sequences for assertions.
3. Create the interface.
4. Add the `FIFO.sv` design file in the `DUT` folder.
5. Create a golden model to check the DUT output.
6. Create an assertion file.
7. Create the `top.sv` file to:
    - Pass the data from the interface to the DUT and the reference model.
    - Bind the assertion file to the design.
    - Set the virtual interface to the database.
    - Run the UVM test.
8. Create a configuration class to get the virtual interface.
9. Create the `sequenceItem.sv` file:
    - Add variables and random variables.
    - Create `print_DUT()` and `print_REF()` methods.
    - Create a constraint block.
10. Create 9 FIFO sequence files to verify the design:
    - `FIFO_write_only_sequence.sv`
    - `FIFO_read_only_sequence.sv`
    - `FIFO_write_read_sequence.sv`
    - `FIFO_sync_toggle_sequence.sv`
    - `FIFO_Async_toggle_sequence.sv`
    - `FIFO_rst_sequence.sv`
    - `FIFO_random_sequence.sv`
11. Create the `driver.sv` file:
    - Create a virtual interface between the driver and the real interface.
    - Make the driver a producer to get the data.
    - Assign the data from the `sequenceItem` and pass it to the interface `inputs`.
12. Create the `monitor.sv` file:
    - Create a virtual interface between the monitor and the real interface.
    - Assign the data from the virtual interface and pass it to the monitor object from the `sequenceItem` (`inputs` and `outputs`).
    - Create an analysis port to send the data to the agent.
13. Create the `sequencer.sv` file.
14. Create the `agent.sv` file:
    - Get the configuration object from the database and pass it to the monitor and driver.
    - Make a connection between the monitor and the agent to send the data to the scoreboard and the coverage collector.
    - Make a connection between the sequencer and the driver.
15. Create the `env.sv` file:
    - Create components (agent, scoreboard, coverage collector).
    - Connect the agent to the scoreboard and coverage collector.
16. Create the `test.sv` file:
    - Get the virtual interface and pass it to the environment.
    - Create objects from the sequences.
    - Call the built-in function `raise_objection` to indicate that the test has started.
    - Run the sequence objects in the `run_phase` with the specific sequences explained in the PDF.
    - Create a component for the environment.
    - Call the built-in function `drop_objection` to indicate that the test has finished.

## Project Structure

The project contains the following components:

1. **Documentation**:
   - `FIFO_report.pdf`: Verification plan, flow, and code descriptions.
   - `FIFO_description.pdf`: Description of the FIFO design.

2. **Codes**:
   - **defines**:
     - `defines.svh`: Definition macros.
   - **interface**:
     - `interface.sv`: Interface code.
   - **Design**:
     - `FIFO.v`: Design code.
     - `assertion.sv`: SystemVerilog assertions for the design.
     - `assertion_defnition.txt`: Definitions for the used assertions.
   - **refrence**:
     - `FIFO_ref.sv`: Reference code.
   - **objects**:
     - `configration.sv`: Configuration database code.
     - **sequence_Item**:
       - `sequenceItem.sv`: Sequence item code with constraints.
     - **FIFO_sequence**:
       - `FIFO_reset_sequence.sv`
       - `FIFO_write_only_sequence.sv`
       - `FIFO_read_only_sequence.sv`
       - `FIFO_write_read_sequence.sv`
       - `FIFO_sync_toggle_sequence.sv`
       - `FIFO_Async_toggle_sequence.sv`
       - `FIFO_random_sequence.sv`
   - **shared_pkg**:
     - `shared_pkg.sv`: Shared package with all shared variables.
   - **top**:
     - `top.sv`: Top-level code.
     - **test**:
       - `test.sv`: Test code.
       - **env**:
         - `env.sv`: Environment code.
         - **coverage_collector**:
           - `coverage_collector.sv`: Coverage collector code.
         - **scoreboard**:
           - `scoreboard.sv`: Scoreboard code.
         - **agent**:
           - `agent.sv`: Agent code.
           - **driver**:
             - `driver.sv`: Driver code.
           - **monitor**:
             - `monitor.sv`: Monitor code.
           - **sequencer**:
             - `sequencer.sv`: Sequencer code.
3. **Reports**:
   - **html_code_cover_report**:
     - `index.html`: Code coverage HTML report
   - **Text Reports**:
     - `code_cover_FIFO.txt`: Code coverage text report
     - `covergroup_report.txt`: covergroup text report
     - `Directive_cover_report.txt`: Directive coverage text report
4. `run.do`: ruv the code and see the waveform
5. `run_extract_report.do`: ruv the code and extract cover reports

## Getting Started
To get started with this repository, follow these steps:
> [!IMPORTANT]
> You need to download [QuestaSim](https://support.sw.siemens.com/en-US/) first.

1. Clone the repository to your local machine using the following command:
```ruby
git clone https://github.com/Abdelrahman1810/UVM_FIFO.git
```
2. Open QuestaSim and navigate to the directory where the repository is cloned.
3. Compile the Verilog files by executing the following command in the QuestaSim transcript tap: 
```ruby
do run.do
```
This will compile All files in Codes folder.

## Contributing
If you find any issues or have suggestions for improvement, feel free to submit a pull request or open an issue in the repository. Contributions are always welcome!

## Contact info 💜

<a href="http://wa.me/201061075354" target="_blank"><img alt="LinkedIn" src="https://img.shields.io/badge/whatsapp-128C7E.svg?style=for-the-badge&logo=whatsapp&logoColor=white" /></a> 

<a href="https://www.linkedin.com/in/abdelrahman-mohammed-814a9022a/" target="_blank"><img alt="LinkedIn" src="https://img.shields.io/badge/linkedin-0077b5.svg?style=for-the-badge&logo=linkedin&logoColor=white" /></a>

Gmail : abdelrahmansalby23@gmail.com 📫

### this project from Eng.Kareem Waseem diploma
  <tbody>
    <tr>
      <td align="left" valign="top" width="14.28%">
      <a href="https://www.linkedin.com/in/kareem-waseem/"><img src="https://th.bing.com/th/id/OIP.gWfK4ytf9t3fZF2i2oE71QHaIi?rs=1&pid=ImgDetMain" width="100px;" alt="Kareem Waseem"/><br /><sub><b>Kareem Waseem</b></sub></a>
      <br /><a href="kwaseem94@gmail.com" title="Gmail">📧</a> 
      <a href="https://www.linkedin.com/in/kareem-waseem/" title="LinkedIn">🌍</a>
      <a href="https://linktr.ee/kareemw" title="Talks">📢</a>
      <a href="https://www.facebook.com/groups/319864175836046" title="Facebook grp">💻</a>
      </td>
    </tr>
  </tbody>
