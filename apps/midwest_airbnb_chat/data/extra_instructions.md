# Extra Instructions

Rules the LLM follows when it writes SQL for `listings`.

* `price` is the nightly price in U.S. dollars. When the user asks what something costs, use `price` and round money to whole dollars in the answer.
* `host\_is\_superhost` is a boolean \[t=true; f=false]. When the user asks if a host is a superhost, return `host\_is\_superhost` and define "yes" for t=true and "no" not f=false.
* `instant\_bookable` is a boolean \[t=true; f=false] that defines whether the guest can automatically book the listing without the host requiring to accept their booking request, and is an indicator of a commercial listing. When the user asks if a listing is instantly bookable, return `instant\_bookable` and define "yes" for t=true and "no" not f=false.
* `reviews\_per\_month` is The average number of reviews per month the listing has over the lifetime of the listing. Psuedocoe/\~SQL: IF scrape\_date - first\_review <= 30 THEN number\_of\_reviews ELSE number\_of\_reviews / ((scrape\_date - first\_review + 1) / (365/12)). When calculating reviews per month, ignore NULL values.

