IF OBJECT_ID ('Test', 'U') IS NOT NULL
DROP TABLE dbo.Test;
print 'create table test'
CREATE TABLE [dbo].[Test](
	[UserName] [nchar](10) NULL,
	[OfficeCode] [nchar](10) NULL
) ON [PRIMARY]
Print 'Get data from dbo.Users to push table test'
insert into dbo.test (UserName,OfficeCode)
select u.UserName,u.OfficeCode from 
dbo.Users u
where u.UserName like '%_.%' and u.OfficeCode is null


Print 'data from table test'
select * from dbo.test


Print 'Create temp table from Test table'

if OBJECT_ID('tempdb..#temp') is not null drop table #temp
select u.UserName,u.OfficeCode
into #temp 
from dbo.test u
where u.UserName like '%_.%' and u.OfficeCode is null

Print 'check data from temp table before updating'

select * from #temp

Print 'update temp table OfficeCode Field'

update #temp set OfficeCode=UPPER(left(UserName,3))


Print 'Check data from temp table after updating'
select * from #temp

Print 'Update data Test table '
update test set OfficeCode=u.OfficeCode
from #temp u 
where u.Username=test.UserName


Print 'check data table test'
select * from dbo.test


--truncate table test