from flask import Flask
from flask import request
import pymysql
		
app = Flask(__name__)

@app.route('/')
def index():
 fbID = request.args.get('fbID')
 username = request.args.get('username')
 db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmaster")
 cursor = db.cursor()
 sql = "INSERT INTO user (username, facebook_id) VALUES( '" + username + "', '" + fbID + "');"
 try:
  cursor.execute(sql)
  db.commit()
 except:
  db.rollback()
 db.close()
 return 'Hello, Flask!'

if __name__ == '__main__':
 app.run(debug=True)
