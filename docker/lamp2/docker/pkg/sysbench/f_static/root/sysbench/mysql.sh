Prepare()
{
    #sysbench --test=oltp --oltp-table-size=1000000 --mysql-db=test --mysql-user=root --mysql-password=yourrootsqlpassword prepare
    sysbench --test=oltp_read_write --oltp-table-size=1000000 --mysql-db=test --mysql-user=root --mysql-password=yourrootsqlpassword prepare
}

Test()
{
    sysbench --test=oltp --oltp-table-size=1000000 --mysql-db=test --mysql-user=root --mysql-password=yourrootsqlpassword --max-time=60 --oltp-read-only=on --max-requests=0 --num-threads=8 run
}


Prepare
Test
