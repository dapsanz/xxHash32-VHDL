# Deliverables

This folder contains the completed deliverables for the project. 
Each subfolder corresponds to a specific part of the design, verification, and analysis process.

---

## Folder Structure

### 1_assumptions
Contains `assumptions.pdf`, which documents all assumptions and simplifications used in the design.

---

### 2_block_diagrams
Contains the system block diagrams.

**Subfolders:**
- **A_detailed** – Detailed block diagrams of the design.
- **B_simplified** – Simplified block diagrams with reduced complexity.

All block diagrams are provided in PDF format and were created in **MS Visio**. 

---

### 3_interface
Contains the interface diagram showing the separation between the **Datapath** and **Controller**.

---

### 4_ASM_charts
Contains the PDF for handwritten ASM charts describing the controller behavior.

---

### 5_source_code
Contains all synthesizable VHDL source files.

Also includes:
- `source_list.txt`, listing all VHDL files in bottom-up synthesis order

---

### 6_verification
Contains all materials used to verify functional correctness.

Includes:
- Modified reference software used to generate test vectors
- All test vector files
- All testbenches used at different levels of hierarchy
- A verification report describing tools used, verification strategy, test results, and analysis of any incorrect behavior

---

### 7_timing_analysis
Contains `timing.pdf`, which documents:
- Execution-time formulas (in clock cycles) for major operations
- Throughput analysis where applicable
- Simulation-based confirmation of timing behavior
- Identification of which formulas were validated and at what circuit level

---

### 8_results
Contains `results.pdf`, presenting post-place-and-route results for the highest-level verified entity targeting a **Xilinx Artix-7 FPGA**.

Includes:
- Resource utilization (LUTs, slices, flip-flops, BRAMs, DSPs, I/O pins)
- Timing results (minimum clock period and maximum clock frequency)
- Analysis, observations, and conclusions

---


