# Splunk Lab: Part 1

[*(back to home)*](https://github.com/codepath/opencyber-splunk-lab)

Lab Parts:

0. [Set up the lab environment using Docker.](./lab_part0.md)
1. [Learn: Splunk Fundamentals](./lab_part1.md) (✅ You are here!)
2. [Apply: Investigating a Web Server Breach](./lab_part2.md)
3. [Challenge: SIEMsational CTF](./lab_part3.md)

## Part 1 | Learn: Splunk Fundamentals

**Estimated Time:** 60 minutes

**Environment:** Your web browser (`http://localhost:8000`)

**Tools Needed:** Splunk (running in Docker — see [Part 0](./lab_part0.md) for setup)

**[Back to home](https://github.com/codepath/opencyber-splunk-lab)**

## Instructions

### Step 0: What is Splunk?

Splunk is a **SIEM** — a *Security Information and Event Management* system. SIEMs collect, index, and search log data from many sources across an organization's infrastructure: servers, applications, network devices, and more. By centralizing all of that data, they make it possible to search across everything at once and identify potential security incidents quickly.

Think of Splunk as **a library for log data**. A library organizes books by genre, author, and title so you can find what you need without reading everything on the shelves. Splunk does the same for log data.

#### Key Terminology

To search Splunk effectively, you need to understand how it organizes data. For each term below, take a guess at what it means before clicking to reveal the answer.

<details>
  <summary><code>Index</code></summary>
  An index is like a <strong>library department</strong> — the top-level container for grouping related data. An organization might use separate indexes for different business units, or to keep log types separated by sensitivity or purpose.
</details>

<details>
  <summary><code>Sourcetype</code></summary>
  Sourcetype is like a <strong>book's genre</strong>. It identifies what kind of data an event contains — such as a web access log, a Linux auth log, or a CSV file.
</details>

<details>
  <summary><code>Source</code></summary>
  Source is like a <strong>book's author</strong>. It identifies where the data came from — a specific file path, a script, or a data input.
</details>

<details>
  <summary><code>Host</code></summary>
  Host is like a <strong>book's location on the shelf</strong>. It identifies which specific machine or device generated the data — usually the server or system name.
</details>

<details>
  <summary><code>Time</code></summary>
  Time is like a <strong>book's publication date</strong>. It identifies when the event was generated. (This is distinct from <code>_time</code>, which is when Splunk ingested the event — not always the same thing!)
</details>

In this lab, we'll primarily use `index` and `host` to target specific datasets. Feel free to reference this section any time you need a refresher.

### Step 1: Your First Search

- [ ] In the Splunk home screen, click on **Search & Reporting** in the left-hand app panel.

🎯 **Checkpoint 1**: You should see a search bar at the top of the page.

All Splunk searches follow the basic syntax: `index=MYINDEX [other fields]`.

- [ ] Type the following into the search bar:

  ```SPL
  index=main host="SalesData"
  ```

- [ ] In the time range dropdown, select **All Time**.
- [ ] Click the magnifying glass (or press Enter) to run the search.

You're now viewing events from the **Top Video Game Sales** dataset — global sales data for thousands of video game titles.

> [!NOTE]
> In a production environment you'd always set a specific time window, since every Splunk search actively uses CPU to retrieve data. For this lab, our datasets are small, so **All Time** is fine throughout.

🎯 **Checkpoint 2**: You should see a list of events from the SalesData host.

### Step 2: Exploring the Data

Splunk parsed each row of the CSV into a searchable **event**. Let's dig in.

> [!IMPORTANT]
> Before exploring events, switch Splunk to **Verbose Mode**. Look for the mode selector to the left of the search bar (it defaults to "Smart") and change it to **Verbose**. Smart Mode optimizes performance by suppressing some field extraction — Verbose Mode shows everything. You'll want it on for all investigation work in this lab.

- [ ] Click the arrow next to any event to expand it and see all of its fields.

You should see fields like `Genre`, `Name`, `Publisher`, `Platform`, `Year_of_Release`, and more. These are all searchable.

- [ ] Click the value next to **Genre** (for example, `Action`, `Sports`, or `Racing`) and select **Add to Search**.

Your search now filters to that specific genre, and the result count drops significantly.

- [ ] Look at the **Interesting Fields** panel on the left. Click on **Genre** — it shows only 1 unique value now, because you've filtered to one genre.

- [ ] From the Interesting Fields panel, click on **Rating** and choose **E** to narrow further.

- [ ] Try adding a **Platform** and a **Developer** of your choice.

- [ ] Finally, change your **Platform** value to `*`. In Splunk, `*` is a wildcard that matches any value.

> [!TIP]
> You've been building SPL (Search Processing Language) queries by clicking — but you can also type and edit them directly in the search bar. Try it: click into the search bar and modify a field value by hand.

🎯 **Checkpoint 3**: You should be able to build and modify searches using field filters and wildcards.

### Step 3: Stats and Visualizations

Browsing individual events is useful, but the real power of Splunk comes from **aggregating** and **visualizing** data.

#### The `stats` Command

`stats` summarizes your search results. Let's use it to answer a specific question:

> **Which gaming platform has the most titles in this dataset?**

- [ ] Clear your current search and run:

  ```SPL
  index=main host="SalesData" | stats count by Platform
  ```

  Notice the `|` (pipe) character — just like in Linux, Splunk uses pipes to chain one command into the next. Here we're piping our search results into `stats`.

- [ ] Add `| sort -count` to sort from highest to lowest:

  ```SPL
  index=main host="SalesData" | stats count by Platform | sort -count
  ```

- [ ] Add `| head 5` to limit to the top 5 results:

  ```SPL
  index=main host="SalesData" | stats count by Platform | sort -count | head 5
  ```

> [!NOTE]
> `head` and `tail` work just like their Linux equivalents. `head 5` returns the first 5 results; `tail 5` returns the last 5. Always sort first if you want meaningful top or bottom results.

#### Visualize the Results

- [ ] Click the **Visualization** tab (next to Statistics).
- [ ] Select **Pie Chart**.
- [ ] Switch to **Column Chart** to compare the view.
- [ ] Switch back to **Pie Chart**.

> [!TIP]
> The percentages in a pie chart reflect only the data your search returned — in this case, the top 5 platforms, not the full dataset. This is intentional and useful: you can generate focused visualizations for any subset of your data.

🎯 **Checkpoint 4**: You should have a pie chart showing the top 5 gaming platforms by title count.

### Step 4: Dashboards

Real-world searches can involve dozens of fields and piped commands — not something you want to rebuild from scratch every day. **Dashboards** let you collect multiple visualizations into a single view, making it easy to monitor what matters at a glance.

#### Create a Dashboard

- [ ] With your pie chart visible, click **Save As** → **New Dashboard**.
- [ ] Title it **"Video Game Statistics"** and click **Save**.

You're now on your new dashboard.

#### Add a Second Panel

- [ ] Click **Edit**, then **Add Panel**.
- [ ] Select **Statistics Table**.
- [ ] Set the time range to **All Time** and enter:

  ```SPL
  index=main host="SalesData" | stats count by Genre | sort -count
  ```

- [ ] Click the **Visualization** tab and select **Bar Chart**.
- [ ] Click **Add to Dashboard** and title this panel **"Top Genres"**.

#### Add a Third Panel

- [ ] Add one more panel using a field of your choice. Some worth exploring: `Critic_Score`, `Rating`, `Year_of_Release`, `Publisher`, `Developer`.
- [ ] Click **Save** when done.

🎯 **Checkpoint 5**: You should have a dashboard with at least three panels.

### Step 5: Reports and Security Data

**Reports** are saved searches that can be run on demand or on a recurring schedule — a staple of real SOC workflows. In this step, you'll switch to a security dataset and create your first security-focused report.

- [ ] In the Search & Reporting app, run the following (All Time):

  ```SPL
  index=main host="WebServer01"
  ```

This dataset contains authentication log entries from a Linux web server at PathCode Inc. It includes both successful and failed login attempts.

- [ ] Locate the **Message** field in the Interesting Fields panel on the left. Click it to see the available values.

- [ ] Add `Message="Failed password for"` to filter for failed login attempts only:

  ```SPL
  index=main host="WebServer01" Message="Failed password for"
  ```

- [ ] Identify the top source IPs responsible for failed logins:

  ```SPL
  index=main host="WebServer01" Message="Failed password for" | stats count by IP | sort -count
  ```

- [ ] Click the **Visualization** tab and select **Bar Chart**.

- [ ] Click **Save As** → **Report**, title it **"Top 10 Source IPs with Failed Login Attempts"**, and click **Save**.

🎯 **Checkpoint 6**: You should have a bar chart saved as a report, showing the top source IPs for failed login attempts against WebServer01.

You've completed Part 1! In [Part 2](./lab_part2.md), you'll use these skills — plus two new SPL commands — to investigate a suspected breach of this same server.
