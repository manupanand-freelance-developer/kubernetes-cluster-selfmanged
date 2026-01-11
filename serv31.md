# RHEL 8.10 Server Upgrade Readiness – bialsrv-cctv031

## Current Situation
- **OS**: Red Hat Enterprise Linux 8.10 (Ootpa)
- **Kernel**: 4.18.0-305.el8.x86_64 (very old, 2021)
- **Workload focus**: Docker, Kubernetes, NVIDIA GPU (A100), CUDA, DeepStream / AI workloads
- **Risk**: Kernel, NVIDIA, container, and Kubernetes stacks are out of sync with modern GPU and cloud-native requirements.

This document lists **critical software components that MUST be upgraded or revalidated when upgrading the kernel**, with **recommended target versions**.

---

## Kernel Upgrade Recommendation (Foundation)

| Component | Current | Recommended |
|---------|--------|-------------|
| Kernel | 4.18.0-305 | **RHEL 8.10 latest kernel (4.18.0-553+)** OR **ELRepo kernel-lt 5.4** |
| Cgroups | v1 | **v2 (preferred for modern Kubernetes & Docker)** |
| XFS | Old userspace | Update via `xfsprogs` with kernel upgrade |

> ⚠️ NVIDIA, Docker, and Kubernetes stability depends directly on kernel compatibility.

---

## Critical GPU / NVIDIA Stack (HIGHEST PRIORITY)

| Software | Current Version | Recommended Version |
|-------|-----------------|---------------------|
| NVIDIA Driver | Legacy (A100 compatible but old) | **535.x or 550.x (Production Branch)** |
| CUDA | Implicit / older | **CUDA 12.2 – 12.4** |
| NVIDIA Container Toolkit | Older | **1.15+** |
| libnvidia-container | Older | **Latest matching driver** |
| NVML | Old | Comes with new driver |
| NCCL | Old | **2.18+** |
| DeepStream | Older | **DeepStream 6.4+ (CUDA 12 based)** |

> ❗ NVIDIA drivers **must be reinstalled after kernel upgrade**.

---

## Container Runtime Stack

| Software | Current | Recommended |
|-------|--------|-------------|
| Docker Engine | 25.0.1 | ✅ OK (keep updated) |
| containerd | 1.6.x | **1.7.x+** |
| runc | 1.1.11 | **1.1.12+** |
| docker-compose | 2.24.2 | **2.27+** |
| buildx | 0.12.1 | **0.14+** |
| Storage Driver | overlay2 | OK |
| Logging Driver | json-file | OK |

> Kernel upgrade + cgroup v2 improves container performance and stability.

---

## Kubernetes Stack (Very Important)

| Component | Current | Recommended |
|---------|--------|-------------|
| kubeadm | Old | **1.28 – 1.30** |
| kubelet | Old | **Match kubeadm** |
| kubectl | Old | **Match kubeadm** |
| cri-tools | Old | **1.28+** |
| CNI Plugins | Old | **Calico / Cilium latest** |

> Kubernetes **1.24+ strongly prefers cgroup v2**.

---

## System & Security Components

| Software | Current | Recommended |
|--------|--------|-------------|
| SELinux | Enabled | Keep enforcing |
| audit | Old | Update with OS |
| firewalld | Old | Latest EL8 |
| nftables | Old | Latest EL8 |
| OpenSSL | 1.1.x | **3.x (if apps allow)** |
| systemd | Old | Latest EL8 |
| tuned | Old | Latest EL8 |

---

## Dev / Runtime Toolchains

| Tool | Current | Recommended |
|-----|--------|-------------|
| Python | 3.6 + 3.11 | Prefer **3.11 only** |
| GCC | 8.x | **11 or 12 (AppStream)** |
| Go | Old | **1.22+** |
| Java | Mixed | **OpenJDK 17 or 21** |
| perf / systemtap | Old | Match kernel |

---

## Filesystems & Performance

| Component | Current | Recommended |
|---------|--------|-------------|
| xfsprogs | Old | Latest |
| numactl | Old | Latest |
| irqbalance | Old | Latest |
| tuned-profiles | Default | GPU / latency tuned profile |

---

## Mandatory Actions After Kernel Upgrade

1. Reinstall **NVIDIA driver**
2. Reinstall **nvidia-container-toolkit**
3. Restart Docker & containerd
4. Validate:
   - `nvidia-smi`
   - `docker run --gpus all nvidia/cuda:12.4.0-base nvidia-smi`
5. Reconfigure Kubernetes cgroup driver
6. Validate GPU topology & NUMA

---

## Strong Recommendation

If this server is **GPU-first (A100, DeepStream, ML, Kubernetes)**:

👉 **Consider moving to RHEL 9.4+**
- Kernel 5.14
- Native cgroup v2
- Better NVIDIA & Kubernetes support
- Longer future support

---

## Summary

**Kernel upgrade is mandatory.**
Without upgrading NVIDIA, Kubernetes, and container stack **together**, instability is guaranteed.

This README should be used as the **upgrade checklist** for this server.

---
