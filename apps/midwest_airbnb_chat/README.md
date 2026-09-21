# ISA 401 Job Scout Chat

**Ask a question in plain English, get the SQL and a table back**

A twelve-line [querychat](https://github.com/posit-dev/querychat) app built in ISA 401 (Miami University) on the job postings that [ChatISA](https://chatisa.fsb.miamioh.edu) Job Scout collected. It is the starting point for Assignment 05, where you rebuild it on the Airbnb data, deploy it to [Render](https://render.com) from your GitHub repository, and then improve it.

**Live app:** (paste your Render URL here once it is deployed, for example `https://job-scout-chat.onrender.com`)

---

## What is this app?

The app connects to a SQLite database (`data/scout.db`), hands the `scout_postings` table to querychat, and lets an LLM translate your question into SQL. Every answer shows the query it ran, so you can check the logic and reuse the SQL yourself.

**Example queries:**
- "How many of the postings are remote?"
- "Which ten companies have the most postings?"
- "Show the internship postings in Ohio."

---

## Dataset Information

**Dataset:** `scout_postings` table in `data/scout.db` (1,891 rows, 19 columns)
**Source:** ChatISA Job Scout, which harvested the postings from public job boards between July 29 and August 23, 2026 (the `source` column records the board: `activejobs` or `usajobs`)
**Data dictionary:** `data/data_desc.md` (started in class; you complete it in Assignment 05)
**Query rules for the LLM:** `data/extra_instructions.md` (one starter rule; you add more)

### Key Fields

| Field | Description |
|-------|-------------|
| `title` | Job title as it appeared on the board |
| `company` | Employer name |
| `location_city` | City of the posting (blank for 61 rows) |
| `location_state` | Two-letter state code (blank for 30 rows) |
| `remote` | `1` if the posting is remote, `0` otherwise |
| `category` | `fulltime`, `federal`, or `internship` |

---

## Required Secret

The app calls OpenAI (`gpt-5.6-luna (reasoning off)`) through [ellmer](https://ellmer.tidyverse.org/), so it needs one environment variable:

```bash
export OPENAI_API_KEY="your-api-key-here"
```

On Hugging Face Spaces, add it under **Settings > Variables and secrets** as a secret named `OPENAI_API_KEY`. Never commit the key; `.Renviron` is listed in `.gitignore` for that reason.

---

## Running Locally

**With R (4.6.0, querychat 0.3.0):**
```r
# from inside apps/job_scout_chat/
shiny::runApp(".", port = 7860)
```

**With Docker:**
```bash
docker build -t job_scout_chat .
docker run --rm -p 7860:7860 -e OPENAI_API_KEY=$OPENAI_API_KEY job_scout_chat
```

Then open http://localhost:7860.

---

## Technology Stack

- **[Shiny](https://shiny.posit.co/)** - Web application framework for R
- **[querychat](https://github.com/posit-dev/querychat)** - Natural language data querying
- **[ellmer](https://ellmer.tidyverse.org/)** - LLM client for R
- **[RSQLite](https://rsqlite.r-dbi.org/)** - SQLite driver for R

---

## Course Information

This application was developed for **ISA 401** at **Miami University**. The polished version of the same idea, built on BLS wage data, is the [OEWS Jobs Explorer](https://huggingface.co/spaces/fmegahed/querychat_demo).
