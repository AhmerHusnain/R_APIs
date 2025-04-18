# Check and install required libraries if missing
required_packages <- c("plumber", "httr", "jsonlite")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

# Load libraries
library(plumber)
library(httr)
library(jsonlite)

# Define the API endpoint
#* @post /subscribe
function(req, res) {
  payload <- fromJSON(req$postBody)
  email <- payload$email
  
  # Create the payload for the Klaviyo API request
  payload_klaviyo <- sprintf('{
    "data": {
      "type": "profile-subscription-bulk-create-job",
      "attributes": {
        "profiles": {
          "data": [
            {
              "type": "profile",
              "attributes": {
                "email": "%s",
                "subscriptions": {
                  "email": {
                    "marketing": {
                      "consent": "SUBSCRIBED"
                    }
                  }
                }
              }
            }
          ]
        },
        "historical_import": false
      },
      "relationships": {
        "list": {
          "data": {
            "type": "list",
            "id": "RaXDEe"
          }
        }
      }
    }
  }', email)  # Insert the email from the request into the payload
  
  # URL for Klaviyo API
  url <- "https://a.klaviyo.com/api/profile-subscription-bulk-create-jobs"
  
  # Send the POST request to Klaviyo API
  response <- VERB(
    "POST", url, 
    body = payload_klaviyo, encode = "raw",
    add_headers(
      revision = "2025-04-15",
      Authorization = "Klaviyo-API-Key pk_16ddbbb84f851f02eab2f6d66d3b0295b9"
    ),
    content_type("application/vnd.api+json"),
    accept("application/vnd.api+json")
  )
  
  # Set response status and return the response content
  res$status <- status_code(response)
  content(response, "text")
}

# Create and run the API

# Save this file as 'klaviyo_api.R'

