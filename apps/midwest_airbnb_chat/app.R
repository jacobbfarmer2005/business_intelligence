library(shiny)
library(bslib)

# ---- Data and model-------------------------
con = DBI::dbConnect(RSQLite::SQLite(), "data/midwest_airbnb.db")
onStop(function() DBI::dbDisconnect(con))

client = ellmer::chat_openai(
  model  = "gpt-5.6-luna",
  params = ellmer::params(reasoning_effort = "none")
)

qc = querychat::querychat(
  con, "listings",
  client             = client,
  tools              = c("filter", "query", "visualize"),
  greeting           = "Ask me about 14,887 Airbnb listings in Chicago, Columbus, and the Twin Cities.",
  data_description   = "data/data_desc.md",
  extra_instructions = "data/extra_instructions.md"
)

# ---- Theme: lake blue + prairie gold ---------------------------------------
app_theme = bs_theme(
  version      = 5,
  bg           = "#FFFFFF",
  fg           = "#1C2733",
  primary      = "#1D5D8C",   # Great Lakes blue
  secondary    = "#5B6B7A",   # slate
  warning      = "#C8961E",   # prairie gold
  success      = "#3F7D4E",   # field green
  base_font    = font_google("Source Sans 3", local = FALSE),
  heading_font = font_google("Libre Franklin", local = FALSE),
  code_font    = font_google("JetBrains Mono", local = FALSE),
  "border-radius" = "0.4rem"
)

# ---- UI ---------------------------------------------------------------------
ui = page_navbar(
  title        = "Midwest Airbnb Explorer",
  window_title = "Midwest Airbnb Explorer",
  theme        = app_theme,
  sidebar      = qc$sidebar(),
  
  nav_panel(
    "Explore",
    card(
      fill = FALSE,
      card_header(textOutput("query_title", inline = TRUE)),
      verbatimTextOutput("sql")
    ),
    card(
      full_screen = TRUE,
      card_header("Listings"),
      DT::DTOutput("table")
    )
  ),
  
  nav_panel(
    "About",
    card(
      card_header("About this app"),
      markdown("
This app lets you ask plain-English questions about **14,887 Airbnb listings**
in Chicago, Columbus, and the Twin Cities, taken from
[Inside Airbnb](https://insideairbnb.com/)'s July 2026 snapshots.

**How it works.** Type a question in the chat on the left. A language model
reads the data dictionary, writes a SQL query against the `listings` table,
and runs it. The query appears on the Explore tab so you can check exactly
what was asked of the data, and the matching rows appear below it.

**Try asking:**

- What is the median nightly price by city?
- Which neighborhoods in Chicago have the most entire-home listings?
- Show only Columbus listings with a rating above 4.9 and at least 50 reviews.

**Limits.** The model can misread a question. Always check the SQL before
trusting a number.

Built by Jacob with R, Shiny, querychat, and ellmer. Deployed on Render.
      ")
    )
  )
)

# ---- Server -----------------------------------------------------------------
server = function(input, output, session) {
  qc_vals = qc$server()
  
  output$query_title = renderText({
    title = qc_vals$title()
    if (is.null(title) || title == "") "All listings" else title
  })
  
  output$sql = renderText({
    sql = qc_vals$sql()
    if (is.null(sql) || sql == "") "SELECT * FROM listings" else sql
  })
  
  output$table = DT::renderDT({
    DT::datatable(
      qc_vals$df(),
      rownames = FALSE,
      options  = list(pageLength = 10, scrollX = TRUE)
    )
  })
}

shinyApp(ui, server)