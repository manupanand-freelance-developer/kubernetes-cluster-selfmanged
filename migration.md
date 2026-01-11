# NVIDIA DeepStream Migration Guide (RHEL → Ubuntu / Modern Stack)

This document combines **migration recommendations** and **kernel/OS guidance** for upgrading to newer NVIDIA DeepStream versions when using **A30 / A100 GPUs**.

---

## 1. Current Situation (Problem Summary)

* **OS**: RHEL 8.10
* **Kernel**: 4.3 (very old / unsupported)
* **GPUs**: NVIDIA A30, A100
* **Goal**:

  * Upgrade to **newer DeepStream versions**
  * Reduce container image size
  * Maintain production stability

### Key Risk

> **Kernel 4.3 is a hard blocker** for modern NVIDIA drivers, CUDA, TensorRT, and DeepStream.

Even if DeepStream runs in containers, **NVIDIA drivers depend on the host kernel**.

---

## 2. NVIDIA Support Reality Check

Modern DeepStream versions require:

| Component     | Minimum / Recommended               |
| ------------- | ----------------------------------- |
| Linux Kernel  | ≥ **5.4** (recommended 5.14 / 5.15) |
| NVIDIA Driver | 535+ (550+ recommended)             |
| CUDA          | 12.x                                |
| TensorRT      | 8.6+                                |
| DeepStream    | 6.4 / 7.x                           |

❌ Kernel 4.3 is **not supported**

---

## 3. What NOT to Do

* ❌ Keep kernel 4.3 and upgrade DeepStream
* ❌ Pin very old CUDA for A100/A30
* ❌ Install DeepStream manually on bare Ubuntu/RHEL without containers

These approaches lead to:

* Driver install failures
* Runtime crashes
* Poor performance
* No security updates

---

## 4. Recommended Migration Strategies (Ranked)

### 🥇 Option 1 (BEST): Container-first Migration on RHEL 8.10

**Keep RHEL, fix the kernel, run DeepStream only in containers**.

**Host OS**:

* RHEL 8.10
* Kernel **5.14 (RHEL default)**
* NVIDIA Driver 550+
* NVIDIA Container Toolkit

**Architecture**:

```
RHEL 8.10 (kernel 5.14)
└── Docker / Podman
    └── DeepStream runtime container
```

**Why this is best**:

* Minimal OS disruption
* Clean rollback
* NVIDIA-supported
* Ideal for DevOps / MLOps workflows

---

### 🥈 Option 2: Fresh OS Install (Cleanest)

If you can reinstall the OS:

| OS               | Verdict                    |
| ---------------- | -------------------------- |
| Ubuntu 22.04 LTS | ⭐ Best NVIDIA reference OS |
| RHEL 9.x         | ⭐ Enterprise-grade         |
| Rocky Linux 9    | ⭐ Community alternative    |

---

### 🥉 Option 3: Stay on Old DeepStream (Not Recommended)

* DeepStream 5.x
* Old CUDA
* No security patches

❌ Dead-end

---

## 5. Ubuntu 22.04 Kernel Details

### Default Kernel (GA)

Ubuntu 22.04 LTS ships with:

```
Linux kernel 5.15.x
```

Check your kernel:

```bash
uname -r
```

Example:

```
5.15.0-9x-generic
```

This kernel is:

* Fully supported by NVIDIA
* Stable for A30 / A100
* Ideal for DeepStream 6.4+

---

### Optional: HWE (Hardware Enablement) Kernels

Ubuntu 22.04 also supports newer kernels via HWE:

| Ubuntu Release | Kernel |
| -------------- | ------ |
| 22.04.1        | 5.15   |
| 22.04.2        | 5.19   |
| 22.04.3        | 6.2    |
| 22.04.4        | 6.5    |
| 22.04.5        | 6.8    |

Install HWE:

```bash
sudo apt install linux-generic-hwe-22.04
```

⚠️ Not required for DeepStream unless you have very new hardware.

---

## 6. Recommended Production Version Matrix

| Component     | Recommended                 |
| ------------- | --------------------------- |
| OS            | Ubuntu 22.04 / RHEL 8.10    |
| Kernel        | 5.15 (Ubuntu) / 5.14 (RHEL) |
| NVIDIA Driver | 550+                        |
| CUDA          | 12.2 – 12.4                 |
| TensorRT      | 8.6+                        |
| DeepStream    | 6.4 / 7.x                   |

---

## 7. Migration Checklist (High Level)

### Step 1: Fix Kernel (Mandatory)

```bash
uname -r
```

Ensure kernel ≥ 5.14

---

### Step 2: Install NVIDIA Driver

```bash
nvidia-smi
```

Verify A30 / A100 detected

---

### Step 3: Install Container Stack

```bash
sudo apt install docker.io
sudo systemctl enable --now docker
```

Install NVIDIA container runtime and test:

```bash
docker run --rm --gpus all nvidia/cuda:12.4.1-base nvidia-smi
```

---

### Step 4: Run DeepStream Runtime Image

```bash
docker run --rm --gpus all \
  nvcr.io/nvidia/deepstream:6.4-runtime \
  deepstream-app --version-all
```

---

## 8. Final Verdict

> **Your kernel is the real blocker, not DeepStream.**

Once you move to:

* Kernel **5.14 / 5.15**
* Modern NVIDIA drivers

Your **A30/A100 GPUs are perfectly suited** for the latest DeepStream releases.

---

## 9. Strong Recommendation

For lowest risk and best long-term stability:

> **Ubuntu 22.04 (kernel 5.15) + NVIDIA Driver 550+ + DeepStream runtime containers**

This setup is widely used in production and aligns with NVIDIA’s reference architecture.

---

**Author note**: This guide is written with a DevOps / MLOps production mindset — container-first, reproducible, and upgrade-safe.
