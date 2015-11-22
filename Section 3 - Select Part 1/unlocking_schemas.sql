Conn / as sysdba

-- you can check the list of users in the database using
Select username from dba_users;

-- Unlocking Accounts:
Conn / as sysdba
Alter user hr identified by “hr”;
Alter user oe identified by “oe”;
Alter user pm identified by “pm”;
Alter user sh identified by “sh”;
Alter user ix identified by “ix”;




