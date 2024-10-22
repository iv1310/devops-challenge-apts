#!/bin/bash

# Variables for profile, log group, and query string
profile="aws-bible"                          # Specify your AWS profile
log_group="/aws/apigateway/simple-http-logs" # Specify the log group name
query_string='fields @timestamp, status, @message, @logStream
| filter status >= 500 and status <= 599
| sort @timestamp desc
| limit 10' # Query for status code 500-599

# Start time (12 hours ago) and end time (now) in epoch time format
start_time=$(date -v-12H "+%s")
end_time=$(date "+%s")

# Start the CloudWatch Logs Insights query
QUERY_ID=$(aws logs start-query \
  --profile $profile \
  --log-group-name $log_group \
  --start-time $start_time \
  --end-time $end_time \
  --query-string "$query_string" |
  jq -r '.queryId')

echo "Query started (query id: $QUERY_ID), please hold ..." && sleep 5 # give it some time to query

# Fetch and display the query results
aws --profile $profile logs get-query-results --query-id $QUERY_ID
