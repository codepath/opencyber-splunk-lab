# Splunk Lab: Part 2

[*(back to home)*](https://github.com/codepath/opencyber-splunk-lab)

Lab Parts:

0. [Set up the lab environment using Docker.](./lab_part0.md)
1. [Learn: Splunk Fundamentals](./lab_part1.md)
2. [Apply: Investigating a Web Server Breach](./lab_part2.md) (✅ You are here!)
3. [Challenge: SIEMsational CTF](./lab_part3.md)

## Part 2 | Apply: Investigating a Web Server Breach

**Estimated Time:** 45 minutes

**Environment:** Your web browser (`http://localhost:8000`)

**Tools Needed:** Splunk (running in Docker — see [Part 0](./lab_part0.md) for setup)

**[Back to home](https://github.com/codepath/opencyber-splunk-lab)**

## Instructions

> [!IMPORTANT]
> The lab data is historical. Set your Splunk time range to **All Time** before running any search, or you will get 0 results. The time picker is in the top-right corner of the Search bar.

### Scenario

PathCode Inc.'s security team has flagged unusual activity in the `WebServer01` authentication logs. As the on-call SOC analyst, your job is to investigate: characterize the attack, identify the threat actor, and determine whether any logins succeeded.

This part introduces two new SPL commands:

| Command | What it does |
|---|---|
| `timechart` | Bins events by time and plots frequency as a chart |
| `table` | Displays specific fields as a clean, column-based view |

### Step 1: Get Your Bearings

Before investigating, orient yourself with the data.

- [ ] Run the following search with **All Time** selected:

  ```SPL
  index=main host="WebServer01"
  ```

- [ ] Note how many total events are in the dataset.
- [ ] Expand a few events and browse the **Interesting Fields** panel. The `Message` and `IP` fields will be central to this investigation.

🎯 **Checkpoint 1**: You should see events from WebServer01 and have a sense of the available fields.

### Step 2: Map the Attack Timeline

Before asking *who* attacked, ask *when*. Understanding the timeline lets you scope the incident and spot when activity spiked.

`timechart` automatically bins events by time and counts them — no need to specify a time field yourself.

- [ ] Run:

  ```SPL
  index=main host="WebServer01" | timechart count
  ```

- [ ] Click the **Visualization** tab and select **Line Chart**.

Can you spot any spikes in activity? Those moments are likely when the attack intensified.

🎯 **Checkpoint 2**: You should see a line chart with at least one visible spike in activity.

### Step 3: Break Down the Event Types

Not every event in an auth log is suspicious. Before narrowing in, get the full picture.

- [ ] Run:

  ```SPL
  index=main host="WebServer01" | stats count by Message
  ```

What fraction of total events are failed login attempts? What other event types exist?

🎯 **Checkpoint 3**: You should see a breakdown of event types and their counts.

### Step 4: Identify the Top Attacking IPs

Now zoom in on the failed logins and rank the source IPs.

- [ ] Run:

  ```SPL
  index=main host="WebServer01" Message="Failed password for" | stats count by IP | sort -count | head 10
  ```

**Make a note of the IP at the top of the list** — that's your primary suspect.

🎯 **Checkpoint 4**: You should have a ranked list of IPs generating the most failed login attempts.

### Step 5: Check for Successful Logins

Failed logins are noisy but not necessarily dangerous on their own. The critical question is whether any logins *succeeded*.

The `table` command displays specific fields as named columns — useful when you want to inspect individual events cleanly, rather than aggregated counts.

- [ ] Run:

  ```SPL
  index=main host="WebServer01" Message="Accepted password for" | table _time IP
  ```

> [!TIP]
> `_time` is Splunk's built-in timestamp field. Fields starting with `_` are Splunk internals — others include `_raw` (the original event text) and `_indextime` (when Splunk ingested the event).

Take note of any IPs that appear here.

🎯 **Checkpoint 5**: You should be able to see whether any logins succeeded, and from which IPs.

### Step 6: Profile Your Suspect

Cross-reference your findings: did your primary suspect from Step 4 appear in the successful logins from Step 5?

- [ ] Run a targeted search for the suspect IP. Replace `[suspect_ip]` with the IP you found in Step 4:

  ```SPL
  index=main host="WebServer01" IP="[suspect_ip]" | stats count by Message
  ```

This shows the complete story of what that IP did on the server — every event type it generated, and how many times.

🎯 **Checkpoint 6**: You should be able to answer: did the top attacking IP successfully log in to WebServer01?

### Step 7: Build Your Findings Dashboard

Document your investigation. Create a new dashboard called **"WebServer01 Breach Investigation"** and add three panels:

- [ ] **Activity Timeline** — your `timechart` search from Step 2
- [ ] **Top Attacking IPs** — your `stats count by IP` search from Step 4
- [ ] **Successful Logins** — your `table` search from Step 5

> [!TIP]
> Refer to [Part 1](./lab_part1.md) if you need a refresher on creating dashboards and adding panels.

🎯 **Checkpoint 7**: You should have a three-panel dashboard that tells the full story of the incident — who attacked, how many times, and whether they got in.

In [Part 3](./lab_part3.md), you'll apply everything you've learned without guided steps in a CTF challenge across two new datasets.
