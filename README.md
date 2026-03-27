# Splunk Lab

This is the README documentation for the Splunk Lab, produced and maintained by [CodePath.org](https://codepath.org).

## Quick Start

Want to jump into the lab? Navigate to the [Part 0 Instructions](./instructions/lab_part0.md) to get started!

## About this Lab

The Splunk Lab is designed to teach you how to use a SIEM (Security Information and Event Management) system to search, analyze, and investigate log data. You'll gain hands-on experience querying real datasets with Splunk's Search Processing Language (SPL), building dashboards, and applying your skills to a simulated security incident investigation.

### Learning Objectives

- Understand how SIEMs organize and index log data
- Write SPL queries to search, filter, aggregate, and visualize events
- Investigate a simulated web server breach using authentication logs
- Apply SIEM skills in an open-ended CTF challenge across multiple datasets

### Lab Activities

0. [Set up the lab environment using Docker.](./instructions/lab_part0.md)
1. [Learn: Splunk Fundamentals](./instructions/lab_part1.md)
2. [Apply: Investigating a Web Server Breach](./instructions/lab_part2.md)
3. [Challenge: SIEMsational CTF](./instructions/lab_part3.md)

## Technical Details

### Provided Tools

Students interact with Splunk entirely through a web browser at `http://localhost:8000`. No command-line tools are required beyond Docker to start the container.

The Docker image includes:

- **Splunk Enterprise 9.0.4** — pre-configured with admin credentials and a Free license
- **Pre-indexed datasets** — lab data is automatically indexed on first container start (~90 seconds), including:
  - Netflix titles catalog
  - Top Video Game sales data
  - WebServer01 authentication logs
  - PathCode Inc. malware investigation logs (web proxy, failed logins, file upload hashes)

### Running the Lab

```bash
docker run --rm -it -p 8000:8000 -v splunk-lab-data:/opt/splunk/var ghcr.io/codepath/opencyber-splunk-lab:latest
```

> **Note:** The named volume (`splunk-lab-data`) persists your indexed data and dashboards between sessions. Your work is safe if you stop and restart the container.
