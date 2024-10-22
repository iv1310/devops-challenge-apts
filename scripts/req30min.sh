#!/bin/bash

# Variables for profile, log group, and query string
profile="aws-bible"                                                                            # Specify your AWS profile
log_group="/aws/apigateway/simple-http-logs"                                                   # Specify the log group name
query_string='fields @timestamp, @message, @logStream, @log | sort @timestamp desc | limit 10' # Specify your query

# Start time (30 minutes ago) and end time (now) in epoch time format
start_time=$(date -v-30M "+%s")
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
