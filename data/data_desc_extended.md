# Midwest Airbnb, Extended: Data Dictionary

**Dataset:** `midwest_airbnb_extended.db` (SQLite), three tables
**Source:** Inside Airbnb (https://insideairbnb.com/get-the-data/): the detailed `listings.csv.gz`, `calendar.csv.gz`, and `reviews.csv` files for Chicago, Columbus, and the Twin Cities metro area. Column meanings follow Inside Airbnb's data dictionary and assumptions (https://insideairbnb.com/data-assumptions/).
**Course:** ISA 401, Miami University. Built by `scripts/make_midwest_airbnb_extended.py`.

> This file is separate from `midwest_airbnb.db` (Assignments 04 and 05) so that earlier work keeps running. The `listings` table is identical in both files.

---

## Table `listings` (14,887 rows, 29 columns)

One row per listing that showed a nightly price on the snapshot date. Same columns as the Assignment 05 data dictionary you wrote; `id` is the key that links to the two tables below. Two columns are empty in every row of this snapshot and should be documented as such: `host_since` and `instant_bookable`.

## Table `availability_monthly` (158,741 rows, 4 columns)

One row per listing per **full calendar month** in the year after the snapshot (July 2026 through May 2027). Built from Inside Airbnb's calendar file, which records for every listing and every night whether the night is available.

| Field | Type | Description |
|---|---|---|
| `id` | text | Listing id; joins to `listings.id`. |
| `month` | text | Calendar month as `YYYY-MM`, for example `2026-10`. |
| `nights_in_month` | integer | Number of nights in that month (28 to 31). |
| `nights_available` | integer | Nights the listing could still be booked on the snapshot date. |

**Caveats.** A night that is not available is either already booked or blocked by the host; Inside Airbnb cannot tell the two apart, so `nights_in_month - nights_available` is an upper bound on bookings. 456 listings do not appear in the calendar file and have no rows here. The 2026 calendar files carry no nightly price, so prices by date are not available.

## Table `reviews_monthly` (142,388 rows, 3 columns)

One row per listing per month in which it received at least one review, for the 24 full months before the snapshot (July 2024 through June 2026). Built from Inside Airbnb's review dates.

| Field | Type | Description |
|---|---|---|
| `id` | text | Listing id; joins to `listings.id`. |
| `month` | text | Month of the review dates as `YYYY-MM`. |
| `reviews` | integer | Number of reviews the listing received that month. |

**Caveats.** Months with zero reviews have no row, so a listing with no reviews at all is absent from the table. Inside Airbnb uses reviews as a proxy for completed stays (roughly half of guests leave a review); treat monthly review counts as a demand signal, not a booking count.
