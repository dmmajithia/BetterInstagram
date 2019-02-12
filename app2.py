from flask import Flask
from flask import request
import pymysql
import json
		
app = Flask(__name__)
	
@app.route('/signup')
def signup():
	appID = request.args.get("appID")
	username = request.args.get("username")
	db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmaster")
	#db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "INSERT INTO user (appID, username) VALUES( %s, %s);" 
	#sql = "INSERT INTO user (appID, username) VALUES( '" + appID + "', '" + username + "');"
	try:
		cursor.execute(sql, (appID, username))
		db.commit()
		success = True
	except:
		db.rollback()
		success = False
	db.close()
	dic = {"success": success}
	js = json.dumps(dic)
	return js

@app.route('/connect_facebook')
def connect_facebook():
	appID = request.args.get("appID")
	fbID = request.args.get("fbID")
	db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmaster")
	#db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "UPDATE user SET facebook_id = %s WHERE appID = %s" 
	#sql = "UPDATE user SET facebook_id = '" + fbID + "' WHERE appID = '" + appID + "'"
	try:
		cursor.execute(sql, (fbID, appID))
		db.commit()
		success = True
	except:
		db.rollback()
		success = False
	db.close()
	dic = {"success": success}
	js = json.dumps(dic)
	return js

@app.route('/login')
def login():
	appID = request.args.get("appID")
	db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmaster")
	#db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "SELECT username FROM user WHERE appID = %s"
	try:
		cursor.execute(sql, appID)
		result = cursor.fetchone()
		db.commit()
		success = True
	except:
		db.rollback()
		success = False
	db.close()
	if success == False:
		dic = {"success": success}
	else:
		dic = {"success": success, "username": result[0]}
	js = json.dumps(dic)
	return js

@app.route('/set_bio')
def set_bio():
	appID = request.args.get("appID")
	bio = request.args.get("bio")
	db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmaster")
	#db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "UPDATE user SET bio = %s WHERE appID = %s" 
	try:
		cursor.execute(sql, (bio, appID))
		db.commit()
		success = True
	except:
		db.rollback()
		success = False
	db.close()
	dic = {"success": success}
	js = json.dumps(dic)
	return js

@app.route('/set_website')
def set_website():
	appID = request.args.get("appID")
	website = request.args.get("website")
	db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmaster")
	#db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "UPDATE user SET website = %s WHERE appID = %s" 
	try:
		cursor.execute(sql, (website, appID))
		db.commit()
		success = True
	except:
		db.rollback()
		success = False
	db.close()
	dic = {"success": success}
	js = json.dumps(dic)
	return js

@app.route('/set_location')
def set_location():
	appID = request.args.get("appID")
	location = request.args.get("location")
	db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmaster")
	#db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "UPDATE user SET location = %s WHERE appID = %s" 
	try:
		cursor.execute(sql, (location, appID))
		db.commit()
		success = True
	except:
		db.rollback()
		success = False
	db.close()
	dic = {"success": success}
	js = json.dumps(dic)
	return js

@app.route('/follow')
def follow():
	appID = request.args.get("appID")
	appID2 = request.args.get("appID2")
	db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmaster")
	#db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "INSERT INTO relationship (user_appid, follower_appid) VALUES( %s, %s); \
	       UPDATE user SET num_of_following =  num_of_following + 1 WHERE appID = %s; \
	       UPDATE user SET num_of_follower =  num_of_follower + 1 WHERE appID = %s" 
	try:
		cursor.execute(sql, (appID, appID2, appID, appID2))
		db.commit()
		success = True
	except:
		db.rollback()
		success = False
	db.close()
	dic = {"success": success}
	js = json.dumps(dic)
	return js

@app.route('/unfollow')
def unfollow():
	appID = request.args.get("appID")
	appID2 = request.args.get("appID2")
	db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmaster")
	#db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "DELETE FROM relationship WHERE (user_appid= %s AND follower_appid= %s);\
	       UPDATE user SET num_of_following =  num_of_following - 1 WHERE appID = %s; \
	       UPDATE user SET num_of_follower =  num_of_follower - 1 WHERE appID = %s" 
	try:
		cursor.execute(sql, (appID, appID2, appID, appID2))
		db.commit()
		success = True
	except:
		db.rollback()
		success = False
	db.close()
	dic = {"success": success}
	js = json.dumps(dic)
	return js


if __name__ == '__main__':
 app.run(debug=True)




