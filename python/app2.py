from flask import Flask
from flask import request
import pymysql
import json
import os
import base64 
import datetime
		
app = Flask(__name__)
	
@app.route('/signup')
def signup():
	appID = request.args.get("appID")
	username = request.args.get("username")
	#db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
	db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
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
	user_id = request.args.get("user_id")
	fbID = request.args.get("fbID")
	#db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
	db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "UPDATE user SET facebook_id = %s WHERE user_id = %s" 
	#sql = "UPDATE user SET facebook_id = '" + fbID + "' WHERE appID = '" + appID + "'"
	try:
		cursor.execute(sql, (fbID, user_id))
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
	#db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
	db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "SELECT username, user_id FROM user WHERE appID = %s"
	try:
		cursor.execute(sql, appID)
		result = cursor.fetchone()
		db.commit()
	except:
		db.rollback()
	db.close()
	if result == None:
		dic = {"success": False}
	else:
		dic = {"success": True, "username": result[0], "user_id": result[1]}
	js = json.dumps(dic)
	return js

@app.route('/deleteuser')
def deleteuser():
	user_id = request.args.get("user_id")
	#db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
	db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "DELETE FROM user WHERE user_id = %s"
	try:
		cursor.execute(sql, user_id)
		db.commit()
		success = True
	except:
		db.rollback()
		success = False
	db.close()
	dic = {"success": success}
	js = json.dumps(dic)
	return js

@app.route('/set_bio')
def set_bio():
	user_id = request.args.get("user_id")
	bio = request.args.get("bio")
	#db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
	db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "UPDATE user SET bio = %s WHERE user_id = %s" 
	try:
		cursor.execute(sql, (bio, user_id))
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
	user_id = request.args.get("user_id")
	website = request.args.get("website")
	#db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
	db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "UPDATE user SET website = %s WHERE user_id = %s" 
	try:
		cursor.execute(sql, (website, user_id))
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
	user_id = request.args.get("user_id")
	location = request.args.get("location")
	#db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
	db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "UPDATE user SET location = %s WHERE user_id = %s" 
	try:
		cursor.execute(sql, (location, user_id))
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
	user_id = request.args.get("user_id")
	user_id2 = request.args.get("user_id2")
	#db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
	db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql1 = "INSERT INTO relationship (user_id, follower_id) VALUES( %s, %s)"
	sql2 = "UPDATE user SET num_of_following =  num_of_following + 1 WHERE user_id = %s"
	sql3 = "UPDATE user SET num_of_follower =  num_of_follower + 1 WHERE user_id = %s" 
	try:
		cursor.execute(sql1, (user_id, user_id2))
		cursor.execute(sql2, user_id)
		cursor.execute(sql3, user_id2)
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
	user_id = request.args.get("user_id")
	user_id2 = request.args.get("user_id2")
	#db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
	db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql1 = "DELETE FROM relationship WHERE (user_id= %s AND follower_id= %s)"
	sql2 = "UPDATE user SET num_of_following =  num_of_following - 1 WHERE user_id = %s"
	sql3 = "UPDATE user SET num_of_follower =  num_of_follower - 1 WHERE user_id = %s"
	try:
		cursor.execute(sql1, (user_id, user_id2))
		cursor.execute(sql2, user_id)
		cursor.execute(sql3, user_id2)
		db.commit()
		success = True
	except:
		db.rollback()
		success = False
	db.close()
	dic = {"success": success}
	js = json.dumps(dic)
	return js

@app.route('/upload_picture')
def upload_picture():
	user_id = request.args.get("user_id")
	picture = request.args.get("picture")
	if not os.path.exists("./"+user_id):
		os.mkdir("./"+user_id)
	timestr = str(datetime.datetime.now()).replace(' ','_')
	try:
		file = open("./"+ user_id +"/" +  timestr + ".jpg", "wb")
		#os.chown("./"+ user_id +"/" +  timestr + ".jpg", int(os.environ['SUDO_UID']),int(os.environ['SUDO_GID']))
		file.write(base64.b64decode(picture))
		file.close()
		dic = {"success": True, "file_name": "./"+ user_id +"/" + timestr + ".jpg"}
	except:
		dic = {"success": False}
	js = json.dumps(dic)
	return js


@app.route('/set_profile_picture')
def set_profile_picture():
	user_id = request.args.get("user_id")
	file_name = request.args.get("file_name")
	#db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
	db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql = "UPDATE user SET profile_picture = %s WHERE user_id = %s" 
	try:
		cursor.execute(sql, (file_name, user_id))
		db.commit()
		success = True
	except:
		db.rollback()
		success = False
	db.close()
	dic = {"success": success}
	js = json.dumps(dic)
	return js

@app.route('/get_profile_data')
def get_profile_data():
	user_id = request.args.get("user_id")
	user_id2 = request.args.get("user_id2")
	#db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
	db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
	cursor = db.cursor()
	sql1 = "SELECT username, facebook_id, bio, website, location, profile_picture, \
	       num_of_post, num_of_following, num_of_follower FROM user WHERE user_id = %s" 
	sql2 = "SELECT user_id FROM relationship WHERE user_id = %s AND follower_id = %s"
	try:
		cursor.execute(sql1, user_id2)
		result = cursor.fetchone()
		cursor.execute(sql2, (user_id, user_id2))
		result2 = cursor.fetchone()
		db.commit()
	except:
		db.rollback()
		dic = {"success": False}
	if result == None:
		dic = {"success": False}
	else:
		if result2 == None:
			is_followed = False
		else:
			is_followed = True
		dic = {"success": True, "username": result[0], "fbID": result[1], "bio": result[2], "website": result[3], "location": result[4], 
		       "profile_picture_url":result[5], "num_of_post": result[6], "num_of_following": result[7], "num_of_follower": result[8], "is_follwed": is_followed}
	db.close()
	js = json.dumps(dic)
	return js

# @app.route('/add_post')
# def add_post():
# 	user_id = request.args.get("user_id")
# 	file_name = request.args.get("file_name")
# 	caption = request.args.get("caption")
# 	mood = request.args.get("mood")
# 	timestamp = request.args.get("timestamp")
# 	location = request.args.get("location")
# 	hashtags = request.args.get("hashtags")
# 	tags = request.args.get("tags")
# 	#db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
# 	db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
# 	cursor = db.cursor()
# 	sql1 = "INSERT INTO post (user_id, filename, caption, mood, post_time, location) VALUES( %s, %s, %s, %s, %s, %s)"
# 	sql2 = "INSERT INTO hashtags (user_id, filename, caption, mood, post_time, location) VALUES( %s, %s, %s, %s, %s, %s)"
# 	try:
# 		cursor.execute(sql, (user_id, file_name, caption, mood, timestamp, location))
# 		success = True
# 		db.commit()
# 	except:
# 		db.rollback()
# 		success = False
# 	db.close()
# 	dic = {"success": success}
# 	js = json.dumps(dic)
# 	return js

# def get_post_data():
# 	user_id = request.args.get("user_id")
# 	db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
# 	#db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
# 	cursor = db.cursor()
# 	sql = "INSERT INTO post (user_id, file_name, caption, mood, post_time, location, hashtags, tags) VALUES( %s, %s, %s, %s, %s, %s, %s, %s)"
# 	try:
# 		cursor.execute(sql, appID)
# 		result = cursor.fetchone()
# 		db.commit()
# 		dic = {"success": True, "username": result[0], "fbID": result[1], "bio": result[2], "website": result[3], "location": result[4], 
# 	       "profile_picture_url":result[5], "num_of_post": result[6], "num_of_following": result[7], "num_of_follower": result[8]}
# 	except:
# 		db.rollback()
# 		dic = {"success": False}
# 	db.close()
# 	js = json.dumps(dic)
# 	return js

if __name__ == '__main__':
	app.run(debug=True)




