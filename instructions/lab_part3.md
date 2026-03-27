# Splunk Lab: Part 3

[*(back to home)*](https://github.com/codepath/opencyber-splunk-lab)

Lab Parts:

0. [Set up the lab environment using Docker.](./lab_part0.md)
1. [Learn: Splunk Fundamentals](./lab_part1.md)
2. [Apply: Investigating a Web Server Breach](./lab_part2.md)
3. [Challenge: SIEMsational CTF](./lab_part3.md) (✅ You are here!)

## Part 3 | Challenge: SIEMsational CTF

**Estimated Time:** 120 minutes

**Environment:** Your web browser (`http://localhost:8000`)

**Tools Needed:** Splunk (running in Docker — see [Part 0](./lab_part0.md) for setup)

**[Back to home](https://github.com/codepath/opencyber-splunk-lab)**

## Instructions

### Overview

Welcome to the SIEMsational CTF — a Capture the Flag challenge where every flag is a fact buried in real data.

There are two datasets to work with:

| Dataset | How to search it | Description |
|---|---|---|
| Netflix catalog | `index=main host=Netflix` | Netflix titles, ratings, and metadata |
| PathCode malware investigation | `index=pathcode` | Server logs from a suspected breach at PathCode Inc. |

### Scoring

- Netflix questions are worth **1 point** each (10 questions, 10 points total)
- Malware investigation questions are worth **2 points** each (5 questions, 10 points total)
- **Goal**: reach **10 points** by answering questions from either category, in any order
- **Stretch**: answer all 15 questions for a perfect score of **20 points**

> [!NOTE]
> For all searches in this challenge, set the time range to **All Time**.

---

## Netflix Data

**Dataset:** `index=main host=Netflix`

Each event in this dataset represents a single title in the Netflix catalog. Relevant fields include `type`, `title`, `country`, `release_year`, `rating`, `duration`, `listed_in`, and `date_added`.

> [!NOTE]
> Field values in this dataset are **exact matches**. For example, `listed_in="Docuseries"` returns only titles cataloged exclusively under that genre — titles that also appear in other genres will have a different `listed_in` value. Use the **Interesting Fields** panel to browse the actual values before writing your search.

<details>
  <summary>Questions (1 point each)</summary>

  1. How many TV shows on Netflix are in the Docuseries genre?

  2. How many movies on Netflix have a rating of TV-PG?

  3. How many movies on Netflix were released in the year 2020?

  4. What is the longest duration by season on Netflix, and what is its TV rating?

  5. How many movies on Netflix are rated PG-13 and listed in Action & Adventure?

  6. How many movies and TV shows on Netflix have their country of origin as Turkey?

  7. Which release year had the most movies rated G? (Not TV-G — movies only.)

  8. What two TV-Y7 rated shows were released in 2019 and added to Netflix on November 22, 2019?

  9. Which year had the most TV shows *(not movies!)* from the United States?

  10. What is the oldest TV show by release year on Netflix?

</details>

> [!TIP]
> Stuck on a search? Use the **Interesting Fields** panel to explore available values for any field, or ask an AI assistant to help you work through the SPL syntax — just make sure you understand what each part of the query is doing before running it.

---

## Malware Investigation

*An attacker has gotten into PathCode Inc.'s systems. They logged into a server and uploaded a file called `EvilScript.exe`. Your job: figure out who did it, how they got in, and whether anyone else is involved.*

**Dataset:** `index=pathcode`

This index contains logs from four sources:

| Host | Description |
|---|---|
| `BluecoatProxy01` | Web proxy logs |
| `failedlogins64` | Failed login attempts |
| `uploadedhashes` | File upload records with MD5 hashes |
| `webserver02` | Web server access logs |

Search across all four with `index=pathcode`, or narrow to a specific host by adding `host=BluecoatProxy01` (etc.) to your search.

<details>
  <summary>Questions (2 points each)</summary>

  11. What was the IP address that uploaded the malware? (MD5 hash: `3AADBF7E527FC1A050E1C97FEA1CBA4D`)

  12. What usernames did that IP address attempt to log in as? Which username was used to successfully upload the file?

  13. What was the User Agent string of the attacker at the time of the successful file upload?

  14. Did any other users upload a file around the same time? If so, who — and what was their IP address?

  15. Looking at the uploaded hashes: what were the filenames uploaded by the two users? Which one appears to be malicious?

</details>

<details>
  <summary>💡 Hints</summary>

  - Start with the MD5 hash in question 11 — find the event where it appears, and work outward from there.
  - Use `host=` filters to target the most relevant log source for each question.
  - Build searches incrementally: start broad, confirm the field names, then add filters to narrow down.
  - `| table` is useful for getting a clean view of the specific fields you care about.

</details>
