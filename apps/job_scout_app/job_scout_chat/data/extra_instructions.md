# Extra Instructions

Rules the LLM follows when it writes SQL for `scout_postings`.

- When the user asks about a state, match `location_state` by its two-letter code (for example, "Ohio" means `location_state = 'OH'`).

<!-- Add more rules below (Assignment 05 asks for at least three). Good candidates:
     how to treat `remote`, how to filter by `category`, how to search `title`
     and `description` case-insensitively, and how to parse `skills_json`. -->
