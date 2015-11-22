/*
2. Read access to tables in our sample schemas
As shown in the video, we want to make sure that each of our 6 accounts (scott, hr, pm, oe, ix, sh) has
read access on the other users’ tables. Prepare the script for each of the schemas and run it to give the
grants.
*/

grant select on CUSTOMERS to scott, hr, ix, oe, pm, sh;
grant select on WAREHOUSES to scott, hr, ix, oe, pm, sh;
grant select on ORDER_ITEMS to scott, hr, ix, oe, pm, sh;
grant select on ORDERS to scott, hr, ix, oe, pm, sh;
grant select on INVENTORIES to scott, hr, ix, oe, pm, sh;
grant select on PRODUCT_INFORMATION to scott, hr, ix, oe, pm, sh;
grant select on PRODUCT_DESCRIPTIONS to scott, hr, ix, oe, pm, sh;
grant select on CATEGORIES to scott, hr, ix, oe, pm, sh;


/*
4. Grantor, Grantee and Grantable

These terms can be a little confusing a first. Read through the oracle documentation and see if you can
completely understand what the three terms mean.
Can you figure out who the grantor and grantee is in this SQL statement?
grant select on oe.customers to scott;
*/

--The grantor depends on who is currently logged in, issuing the grant. Usually, it is the owner or the admin user, SYS.
-- if OE logs in and issues the grant
	Grantor : OE
	Grantee : scott
	Grantable: No
-- If the command is run with the grant option like below, then GRANTABLE column would be 'YES' indicating scott could pass on the grant to a different user
-- select gratn
	Grantor : OE
	Grantee : scott
	Grantable: No






