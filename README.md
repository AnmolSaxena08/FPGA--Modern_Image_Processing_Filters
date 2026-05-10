## 🏗️ System Architecture

<p align="center">
  <img src="docs/architecture.png" width="80%">
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
  <img src="docs/waveform.png" width="80%">
</p>

**Figure:** Simulation waveform demonstrating:

* Pipeline latency
* Valid pixel streaming
* Input-output synchronization

---

## 🎥 Output Visualization (Demo)

<p align="center">
  <img src="results/demo.gif" width="70%">
</p>

**Figure:** Comparative visual analysis of input vs hardware-processed output using multiple filters.

---

## 🖼️ Input vs Output Comparison

<p align="center">
  <img src="results/input/input.jpg" width="35%">
  <img src="results/images/edge_detection.bmp" width="35%">
</p>

**Figure:** Example showing original input image (left) and processed output (right).

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

* 📐 Architecture Diagram → `docs/architecture.png`
* 📊 Waveform → `docs/waveform.png`
* 🎥 Demo GIF → `results/demo.gif`
* 🖼️ Input Image → `results/input/input.jpg`
* 🎨 Output Images → `results/images/`

---
