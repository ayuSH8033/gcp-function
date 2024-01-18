
Get_User_details = """
SELECT "_id" ,"rolename", "createdat", "updatedat" ,  "username", "userurl", "emailid"
FROM usermanagement."user" WHERE _id = %s;
	"""
