# Splunk Lab: Part 0

[*(back to home)*](https://github.com/codepath/opencyber-splunk-lab)

Lab Parts:

0. [Set up the lab environment using Docker.](./lab_part0.md) (✅ You are here!)
1. [Learn: Splunk Fundamentals](./lab_part1.md)
2. [Apply: Investigating a Web Server Breach](./lab_part2.md)
3. [Challenge: SIEMsational CTF](./lab_part3.md)

## Part 0 | Set up the lab environment using Docker

**Estimated Time:** 15 minutes

**Environment:** Your own computer

**Tools Needed:** Docker, a web browser

## Instructions

- [ ] Make sure you have Docker installed and running on your computer.
  - **Mac**: [Download Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)
  - **Windows**: [Download Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/)
  - **Linux**: [Install Docker Engine](https://docs.docker.com/engine/install/) (or [Docker Desktop for Linux](https://docs.docker.com/desktop/install/linux/))
  - Once installed, open Docker Desktop and confirm it's running before continuing.

- [ ] Open a terminal on your computer:
  - **Mac**: Open **Terminal** (search "Terminal" in Spotlight with ⌘+Space)
  - **Windows**: Open **Command Prompt** or **PowerShell** (search either in the Start menu)
  - **Linux**: Open your system's terminal emulator

- [ ] Run the lab container with:

  ```bash
  docker run --rm -it -p 8000:8000 -v splunk-lab-data:/opt/splunk/var --platform linux/amd64 ghcr.io/codepath/opencyber-splunk-lab:latest
  ```

- [ ] Watch your terminal. **On first start**, Splunk initializes and indexes the lab data — this takes about **90 seconds**. You'll see a "Splunk is ready!" message when it's done. Subsequent starts are faster (~30 seconds).

- [ ] Open your web browser and navigate to `http://localhost:8000`.

- [ ] Log in with:
  - **Username:** `admin`
  - **Password:** `codepath`

If you can see the Splunk home screen, you are ready to [**proceed to Part 1**](./lab_part1.md).

> [!IMPORTANT]
> Keep your terminal open for the entire lab — closing it stops the container. Your work (dashboards, saved searches, and indexed data) **persists between sessions** via the named volume, so you can safely stop and restart without losing progress.

> [!TIP]
> If you see a warning about `FROM --platform flag should not use constant value "linux/amd64"` during the build, you can safely ignore it. This is intentional — Splunk Enterprise has no native arm64 package, so we pin to amd64 explicitly. It runs fine on Apple Silicon under Rosetta 2.

> [!TIP]
> If you have issues pulling the image, you can build it manually by cloning this repository and running:
>
> ```bash
> git clone https://github.com/codepath/opencyber-splunk-lab.git
> cd opencyber-splunk-lab
> docker build --platform linux/amd64 -t opencyber-splunk-lab:local -f docker/Dockerfile .
> docker run --rm -it -p 8000:8000 -v splunk-lab-data:/opt/splunk/var --platform linux/amd64 opencyber-splunk-lab:local
> ```
