# MATLAB Simulation of Convolutional Coding – CT-216 Course Project

## 🧠 Overview

This project is a MATLAB-based simulation of a digital communication system using Convolutional Coding and BPSK modulation over an AWGN channel. It focuses on the practical coding and performance analysis of Hard and Soft Decision Viterbi Decoding algorithms.

The simulation is implemented entirely in MATLAB (Live Script) and visualizes BER (Bit Error Rate) performance over 5000 trials for multiple coding configurations.

▶️ The project hence primarily emphasizes algorithm design, implementation accuracy, and result visualization.

---

## 👨‍💻 Team & Course Info

- Course: CT-216 – Introduction to Communication Systems  
- Institute: DA-IICT  
- Instructor: Prof. Yash Vasavada  
- Group: 9 (Lab Group 2)  
- Semester: Spring 2025

| Name           | ID         |
|----------------|------------|
| Yaksh Patel    | 202301089  |
| Jhil Patel     | 202301090  |
| Meet Patel     | 202301091  |
| Rajdeep Patel  | 202301092  |
| Neel Shah      | 202301093  |
| Yash Panchal   | 202301094  |
| Om Sutariya    | 202301096  |
| Deep Kakadiya  | 202301097  |
| Kirtan Chhatbar| 202301098  |
| Krish Malhotra | 202301099  |

---

## 🧰 MATLAB Code Highlights

📂 File: `G9_Convolution_5000_Simulations.mlx`

- Developed using MATLAB Live Script
- Modular design: Encoder, Channel, Decoder, Plotting
- 5000 Monte Carlo Simulations for each Eb/N₀
- Configurable code rate (r) and constraint length (K)
- Includes both Hard and Soft Decision Viterbi decoding
- Generates BER vs. Eb/N₀ plots (semilog)

### 🧩 Key Modules Implemented

1. Random binary input generator (1000 bits)
2. Convolutional Encoder using MATLAB's `convenc()`
3. BPSK Modulation (0 → +1, 1 → -1)
4. AWGN noise using `awgn()` function
5. Viterbi Decoders:
   - Hard Decision: `vitdec(..., 'hard')`
   - Soft Decision: `vitdec(..., 'unquant')`
6. Error calculation using `biterr()`
7. BER plot generation using `semilogy()`

### 💡 Tested Parameters

- Code rates: 1/2 and 1/3
- Constraint lengths: K = 3, 4, 6
- Eb/N₀ range: 0 to 10 dB
- 5000 simulations/config

---

## 📁 Files Provided

| File Name                          | Description                                       |
|-----------------------------------|---------------------------------------------------|
| `G9_Convolution_5000_Simulations.mlx` | MATLAB code (Live Script)                        |
| `G9_Convolution_5000_Simulations.pdf`| Code output and BER plots                        |
| `G9_Convolution_PPT.pdf`          | 10-slide presentation summarizing the project     |
| `G9_Report_CT216.pdf`             | Final report with background, method, results     |

---

## 🎯 Objectives

- Simulate convolutionally coded communication systems in MATLAB
- Compare Viterbi decoding (hard vs. soft) across different Eb/N₀
- Study BER performance based on code rates and constraint lengths
- Gain hands-on experience with digital error-control coding

---

## 🚀 Sample Result

At Eb/N₀ = 6 dB:
- r = 1/2, K = 3 → BER (Hard) ≈ 10⁻²
- r = 1/3, K = 6 → BER (Soft) ≈ 10⁻⁵

Soft decision decoding shows a 2–3 dB performance gain over hard decoding.
---
## 📊 Analysis

The simulation results clearly demonstrate the advantages of convolutional coding and soft decision decoding in noisy environments:

- Bit Error Rate (BER) drops significantly with increasing Eb/N₀ for all configurations, validating theoretical expectations.
- Soft Decision Decoding (SDD) consistently outperformed Hard Decision Decoding (HDD), showing a performance improvement of approximately 2–3 dB for the same BER.
- Among the configurations tested:
  - (r = 1/2, K = 3): Provided moderate error correction.
  - (r = 1/3, K = 4): Showed better BER with increased redundancy.
  - (r = 1/3, K = 6): Achieved the best performance, with BER dropping to 10⁻⁵ at Eb/N₀ = 6 dB using SDD.
- The waterfall behavior in BER curves highlights the threshold effect—where a slight increase in Eb/N₀ yields steep improvements in decoding reliability.
- The output plots from MATLAB (see Simulations.pdf) corroborate the expected performance trends from classical communication theory.

📈 Example BER Performance Plot:
![BER vs Eb/N0](https://drive.google.com/file/d/1ylR9D3k_8-qFJyPjZAENq0WK2uMAxJgS/view?usp=sharing)

These observations confirm that:
- Lower code rates (i.e., more redundancy) and longer constraint lengths lead to superior error correction.
- Soft decision decoding is more computationally intensive but significantly more effective in reducing errors.


---

## 📌 Conclusion

This simulation validates theoretical principles of convolutional coding and decoding using MATLAB. The comparative analysis of BER curves reinforces the role of code rate, constraint length, and decoder type in practical communication systems.

---

## 🔗 References

- A.J. Viterbi, “Error Bounds for Convolutional Codes,” IEEE
- Proakis, Digital Communications – BPSK & AWGN Theory
- MATLAB Docs: `convenc`, `vitdec`, `awgn`, `biterr`
- https://www.youtube.com/playlist?list=PLEvcKrs3Cncr62hoBymwX5lnLFlwGe9SX
