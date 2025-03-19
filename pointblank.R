library(pointblank)
# Provide table with many data types for testing; dttm, date, int, chr, dbl, lgl
data(small_table)
small_table

# WIll load table if rule passed is TRUE; all values in a are less than 10
small_table |>
  col_vals_lt(a, value = 10)

# # Will not load table if rule passed is FALSE; not all values in a are less than 10
# try:
#   small_table |>
#     col_vals_lt(a, value = 5)
# except:
#   pass

# Chaining validation rules
small_table |>
  col_vals_lt(a, value = 10) |>
#   col_vals_between(d, left = 0, right = 5000) |> # Error: Exceedance of failed test units where values in `d` should have been between `0` and `5000`
  col_vals_between(d, left = 0, right = 10000) |>
  col_vals_in_set(f, set = c("low", "mid", "high")) |>
  col_vals_regex(b, regex = "^[0-9]-[a-z]{3}-[0-9]{3}$") # Regex validation; must start with 0-9, then dash, then 3 letters, then dash, then 3 numbers

# Create the agent, apply validation rules
agent_setup <- small_table |>
  create_agent() |>
  col_vals_lt(a, value = 10) |>
  col_vals_between(d, left = 0, right = 5000) |>
  col_vals_in_set(f, set = c("low", "mid", "high")) |>
  col_vals_regex(b, regex = "^[0-9]-[a-z]{3}-[0-9]{3}$")

# Interrogate agent on validation process; requires print(agent) if not using positron
# .pb_combined is boolean if all columns pass; useful for EDA
agent <- agent_setup |>
  interrogate()
print(agent)

# Provide observations that pass
print(get_sundered_data(agent, type = "pass"))

# Provide observations that fail
print(get_sundered_data(agent, type = "fail"))

# Provide all observations; creates a .ph_combined column that you can use in a downstream process
print(get_sundered_data(agent, type = "combined"))

print(get_data_extracts(agent))
