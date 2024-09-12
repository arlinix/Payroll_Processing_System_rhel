test=`sqlplus -S hr/123456 <<eof
select * from tab where tname='EMAST';
eof
`
echo $test
if [ "`echo $test`" == "`cat t_file`" ]
then
echo "AYA IF M"
sqlplus -S hr/123456 <<eof
create table emast(eid int, name varchar(10));
eof
fi
