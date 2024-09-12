test=`sqlplus -s hr/123456 <<eof
set heading off;
        set feedback off;
        set pagesize 0;
        set linesize 1000;
select * from emaster where employee_code=101;
eof
`

echo $test > /tmp/test
