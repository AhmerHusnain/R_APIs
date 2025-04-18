# THEN CREATE A SEPARATE RUNNER FILE (e.g., 'run_api.r'):
pr <- plumber::plumb("plumber.R")
pr$run(host = "0.0.0.0", port = 8080)