# Simple_OperatingSystem_ASM (PingOS)

A simple operating system written in Assembly language. This project demonstrates the fundamentals of low-level programming, bootloaders, and interacting with computer hardware directly.

---

## ✨ Features

* **Custom Bootloader:** A handcrafted 512-byte bootloader that resides in the first sector of the storage media.
* **Real Mode Execution:** Runs in 16-bit Real Mode, interacting directly with BIOS interrupts (like `int 0x10` for video services).
* **Hardware Direct Output:** Bypasses standard operating systems to print text and characters directly to the screen.
* **Minimal Footprint:** Optimized for size and performance, focusing on the core essentials of system startup.

---

## 🛠 Tools and Software Used

* **Language:** Assembly (x86)
* **Assembler:** [NASM](https://nasm.us/) (Netwide Assembler) - Used to compile `.asm` source code into machine-readable `.bin` files.
* **Emulator:** [QEMU](https://www.qemu.org/) - Used to run and test the OS in a virtual environment.
* **Version Control:** [Git](https://git-scm.com/) & [GitHub](https://github.com/) - For source code management and tracking changes.
* **Editor:** [Visual Studio Code](https://code.visualstudio.com/) - The primary IDE for writing code and managing the project workflow.

---

## 🚀 Getting Started

### Prerequisites

Ensure you have **NASM** and **QEMU** installed and added to your system's environment variables (PATH).

### Compilation

To compile the source code into a binary file, run the following command in your terminal:

```bash
nasm -f bin main.asm -o main.bin

```

### Running the OS

To boot the compiled binary using the QEMU emulator:

```bash
qemu-system-x86_64 -drive format=raw,file=main.bin

```

---

## 📁 Project Structure

* `main.asm`: The primary source code containing the bootloader logic and OS entry point.
* `main.bin`: The compiled binary output (executable by the CPU/Emulator).
* `.gitignore`: Prevents compiled binaries and system files from being tracked by Git.

---

## 🛠 Progress Log

* [x] Initial Bootloader logic implemented.
* [x] Successful character output to screen.
* [x] Repository connected to GitHub.
* [ ] Keyboard input handling (Upcoming).
* [ ] Basic Shell/Command interface (Planned).

---

## 📜 License

This project is open-source and available under the MIT License.
