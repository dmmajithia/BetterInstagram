from flask import Flask
from flask import request
import pymysql
import json
		
app = Flask(__name__)

@app.route('/')
def index():
 fun = request.args.get('function')
 fbID = request.args.get('fbID')
 username = request.args.get('username')
 if fun == "check":
 	db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmaster")
 	cursor = db.cursor()
 	sql = "SELECT user_id, username, facebook_id  from user WHERE facebook_id = '" + fbID + "'"
 	try:
  	  cursor.execute(sql)
  	  result = cursor.fetchone()
  	  db.commit()
 	except:
  	  db.rollback()
 	db.close()
 	if result == None:
 		dic = {'status': False}
 	else:
 		dic = {'status': True,'user_id':result[0], 'username':result[1], 'facebook_id':result[2]}
 	js = json.dumps(dic)
 	return js
 elif fun =="insert":
 	db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmaster")
 	cursor = db.cursor()
 	sql = "INSERT INTO user (username, facebook_id) VALUES( '" + username + "', '" + fbID + "');"
 	try:
  	  cursor.execute(sql)
  	  db.commit()
 	except:
  	  db.rollback()
 	db.close()


if __name__ == '__main__':
 app.run(debug=True)




