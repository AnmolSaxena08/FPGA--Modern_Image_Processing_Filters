## 📌 Theoretical Background

### 🔹 FPGA-Based Image Processing

Digital image processing on FPGA enables **real-time performance** by exploiting **parallelism and pipelining**.
Unlike CPU-based systems, FPGA processes pixel data in a **streaming manner**, reducing latency and improving throughput.

---

### 🔹 Streaming Architecture

* Pixels are processed **as they arrive**
* No need to store the full image in memory
* Each stage works in parallel → **high throughput (~1 pixel/clock)**

---

### 🔹 Line Buffer & Sliding Window

* Stores previous rows of pixels
* Generates a **3×3 window** for filtering
* Eliminates need for full-frame storage

---

### 🔹 Convolution Operation

G(x,y) = \sum_{i=-1}^{1} \sum_{j=-1}^{1} K(i,j) \cdot I(x+i, y+j)

* Core operation for filters (edge, blur, sharpening)
* Implemented using **parallel multipliers and adders**

---

### 🔹 Fixed-Point Computation

* Avoids floating-point complexity
* Reduces hardware usage
* Maintains sufficient accuracy

---

## 🏗️ System Architecture

<p align="center">
  <img src="Docs/architecture.png" width="80%">
</p>

**Figure:** Block diagram of the FPGA-based image processing pipeline showing streaming data flow, line buffers, and filter module.

---

## ⚙️ Processing Pipeline Flow

```text
Input Image 
   → Python (RGB Conversion) 
   → Input Buffer 
   → Line Buffer (3×3 Window) 
   → Filter Module (Convolution) 
   → Output Buffer 
   → Output Image
```

👉 This pipeline enables **continuous streaming and parallel processing**, achieving near real-time performance.

---

## 📊 Results & Waveform Analysis

<p align="center">
  <img src="Docs/Waveform_01.jpg" width="80%">
</p>

**Figure:** Simulation waveform demonstrating:

* Pipeline latency
* Valid pixel streaming
* Input-output synchronization

---

## 🎥 Output Visualization (Demo)

<p align="center">
  <img src="Results/demo.gif" width="70%">
</p>

---

## 🖼️ Input vs Output Comparison

<p align="center">
  <table>
    <tr>
      <td align="center"><b>Input Image</b></td>
      <td align="center"><b>Output Image</b></td>
    </tr>
    <tr>
      <td><img src="Results/Filters/input.jpg" width="100%"></td>
      <td><img src="Results/Filters/Color_boost.jpg" width="100%"></td>
    </tr>
  </table>
</p>

<p align="center">
<b>Figure:</b> Comparative visual analysis of the input image (left) vs hardware-processed output (right).
</p>

---

## 💡 Skills Demonstrated

* **FPGA Design (Verilog HDL)** – RTL design, modular architecture
* **Digital Image Processing** – Filtering, pixel-level transformations
* **Streaming Architecture** – AXI-style valid/ready pipeline
* **Hardware Optimization** – Line buffers, fixed-point computation
* **Verification** – Testbench design, waveform analysis in Vivado
* **Hardware-Software Integration** – Python + Verilog workflow
* **Debugging & Simulation** – Functional validation using testbench

---

## 🔗 Direct Links (Quick Access)

* 📐 Architecture Diagram → [Docs/architecture.png](./Docs/architecture.png)
* 📊 Waveform → [Docs/Waveform_02.jpg](./Docs/Waveform_02.jpg)
* 🎥 Demo → [Results/demo.gif](./Results/demo.gif)
* 🖼️ Input Image → [Results/Filters/input.jpg](./Results/Filters/input.jpg)
* 🎨 Output Images → [Results/Filters](./Results/Filters/)

---
