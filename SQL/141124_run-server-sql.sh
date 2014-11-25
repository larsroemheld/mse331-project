# Run a query.sql file on server in background. Output is piped to tmp, error log is written to error file.
nohup cat users_main.sql | sql enwiki > /tmp/lr_query_result.tsv 2> query_errors.txt &