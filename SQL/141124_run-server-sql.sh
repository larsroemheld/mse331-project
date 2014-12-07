# Run a query.sql file on server in background. Output is piped to tmp, error log is written to error file.
nohup cat 141203_Thanks-BeforeAfter_g1.sql | sql enwiki > group1.tsv 2> query_errors1.txt &
nohup cat 141203_Thanks-BeforeAfter_g2.sql | sql enwiki > group2.tsv 2> query_errors2.txt &
nohup cat 141203_Thanks-BeforeAfter_g3.sql | sql enwiki > group3.tsv 2> query_errors3.txt &
nohup cat 141203_Thanks-BeforeAfter_g4.sql | sql enwiki > group4.tsv 2> query_errors4.txt &
