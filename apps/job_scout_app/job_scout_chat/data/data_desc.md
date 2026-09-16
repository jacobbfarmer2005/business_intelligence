# ChatISA Job Scout Postings: Data Dictionary

**Dataset:** `scout_postings` table in `scout.db` (SQLite), 1,891 rows and 19 columns
**Source:** ChatISA Job Scout (https://chatisa.fsb.miamioh.edu), postings harvested from public job boards between July 29 and August 23, 2026
**Course:** ISA 401, Miami University

> One row is one job posting. Empty cells are stored as SQL `NULL`.

---

## Field Definitions

| Field | Type | Description |
|---|---|---|
| `id` | text | Primary key. A 36-character UUID that identifies the posting; unique across the table. |
| `title` | text | Job title exactly as it appeared on the job board (for example "Data Analyst - Remote"). Never empty. |
| `company` | text | Employer name as posted. Never empty. 1,042 distinct companies. |
| `location_city` | text | City of the posting (for example "Atlanta"). `NULL` for 61 rows. |
| `location_state` | text | Two-letter U.S. state code in upper case (for example "GA"). 46 distinct codes; `NULL` for 30 rows. |
| `remote` | integer | `1` if the posting is remote, `0` otherwise (127 remote rows). Stored as an integer, not a boolean. |

Continue the table for the remaining columns (Assignment 05): `source`, `external_id`, `fingerprint`, `category`, `apply_url`, `description`, `posted_at`, `harvested_at`, `last_seen_at`, `skills_json`, `taxonomy_version`, `active`, `visa_sponsorship`.
