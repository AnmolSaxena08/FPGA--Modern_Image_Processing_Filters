# ▶️ RUN.md — How to Execute the Project

This guide explains how to run the FPGA-based Image Processing Pipeline from input image to final output.

---

## 📌 Prerequisites

### 🔧 Software Required

* Python 3.x
* Xilinx Vivado (for simulation)
* Git (optional)

### 📦 Python Libraries

Install required packages:

```bash
pip install numpy opencv-python imageio
```

---

## 📁 Project Structure (Required)

Ensure your folders are organized as follows:

```text
FPGA-Image-Processing/
├── Python/
│   ├── rgb_input.py
│   └── jpg_output.py
│
├── Verilog/
│   ├── imageProcessTop.v
│   ├── imageControl.v
│   ├── lineBuffer.v
│   └── conv.v
│
├── Testbench/
│   └── tb.v
│
├── Data/
│   ├── input/
│   │   └── input.jpg
│   │
│   ├── intermediate/
│   │   └── image_rgb.txt
│   │
│   └── output_txt/
│       └── image_rgb_out.txt
│
├── Results/
│   ├── demo.gif
│   ├── input/
│   │   └── input.jpg
│   │
│   └── images/
│       └── (output images)
```

---

## ⚙️ Step 1: Convert Image → RGB Text

Run Python script to convert input image into pixel data:

```bash
Python Python/rgb_input.py
```

### 🔹 Output:

```text
Data/intermediate/image_rgb.txt
```

👉 This file contains RGB pixel values used as input for Verilog simulation.

---

## ⚙️ Step 2: Run Verilog Simulation (Vivado)

### Steps:

1. Open Vivado
2. Create a new project
3. Add files:

   * All `.v` files from `Verilog/`
   * Testbench file `Testbench/tb.v`
4. Set tb.v as Top Module
5. Run:

   ```text
   Run Simulation → Run Behavioral Simulation
   ```

---

### 🔹 Output Generated:

```text
Data/output_txt/image_rgb_out.txt
```

👉 This file contains processed pixel data from hardware pipeline.

---

## ⚙️ Step 3: Convert Output Text → Image

Run:

```bash
Python Python/jpg_output.py
```

### 🔹 Output:

```text
Results/images/
```

👉 Final processed images will be generated here.

---

## 🔍 Verification

* Check waveform in Vivado (`Docs/waveform.png`)
* Compare input vs output images
* Validate filter correctness visually

---

## ⚠️ Common Issues & Fixes

### ❌ Image not generating

✔ Check file paths in Python scripts
✔ Ensure input image exists

---

### ❌ Simulation not running

✔ Ensure `tb.v` is set as top module
✔ Check file inclusion in project

---

### ❌ Output text empty

✔ Verify input file path
✔ Check valid signal logic in testbench

---

### ❌ Images not visible in README

✔ Ensure correct relative paths
✔ Check case sensitivity (Docs vs docs)

---

## 🚀 Execution Flow Summary

```text
Input Image
   ↓
Python (RGB Conversion)
   ↓
Verilog Simulation (Vivado)
   ↓
Output Pixel Data
   ↓
Python (Image Reconstruction)
   ↓
Final Output Image
```

---

## ✅ Final Output

* Processed images → `Results/images/`
* Waveform → `Docs/waveform.jpg`

---

## 👨‍💻 Notes

* Designed for **educational and demonstration purposes**
* Optimized for **streaming architecture and FPGA simulation**
* Can be extended for real-time video processing

---
