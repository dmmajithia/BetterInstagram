from flask import Flask
from flask import request
import pymysql
import json
import os
import base64
import datetime
import time

import os
from flask import redirect, url_for
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = './pictures/'
ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'])

app = Flask(__name__)


@app.route('/')
def index():
    return ("Hello, Better Instagram!")


@app.route('/login/signup')
def signup():
    appID = request.args.get("appID")
    username = request.args.get("username")
    # db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql = "INSERT INTO user (appID, username) VALUES( %s, %s);"
    sql2 = "SELECT max(user_id) From user"
    # sql = "INSERT INTO user (appID, username) VALUES( '" + appID + "', '" + username + "');"
    try:
        cursor.execute(sql, (appID, username))
        cursor.execute(sql2)
        result = cursor.fetchone()
        db.commit()
        dic = {"success": True, "user_id": result[0]}
    except:
        db.rollback()
        dic = {"success": False}
    db.close()
    js = json.dumps(dic)
    return js


@app.route('/login/check_username')
def check_username():
    username = request.args.get("username")
    # db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql = "SELECT username From user WHERE username = %s"
    # sql = "INSERT INTO user (appID, username) VALUES( '" + appID + "', '" + username + "');"
    try:
        cursor.execute(sql, username)
        result = cursor.fetchone()
        db.commit()
    except:
        db.rollback()
    db.close()
    if result == None:
        dic = {"existed": False}
    else:
        dic = {"existed": True}
    js = json.dumps(dic)
    return js


@app.route('/profile/connect_facebook')
def connect_facebook():
    user_id = request.args.get("user_id")
    fbID = request.args.get("fbID")
    # db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql = "UPDATE user SET facebook_id = %s WHERE user_id = %s"
    # sql = "UPDATE user SET facebook_id = '" + fbID + "' WHERE appID = '" + appID + "'"
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


@app.route('/login/login')
def login():
    appID = request.args.get("appID")
    # db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
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


@app.route('/other/delete_user')
def delete_user():
    user_id = request.args.get("user_id")
    # db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
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


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/profile/upload_picture', methods=["GET", "POST"])
def upload_file():
    dic = {}
    user_id = request.args.get("user_id")
    if not os.path.exists("./pictures/" + user_id):
        os.mkdir("./pictures/" + user_id)
    timestr = str(datetime.datetime.now()).replace(' ', '_')

    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            # flash('No file part')
            return request.files
            # return "file not in request.files"
        file = request.files['file']
        # if user does not select file, browser also
        # submit a empty part without filename
        if file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            try:
                filename = secure_filename(timestr + '_' + file.filename)
                filepath = UPLOAD_FOLDER + user_id
                # return(filepath)
                file.save(os.path.join(filepath, filename))
                # dic = {"success": True, "file_name": os.path.join(filepath, filename)}
                dic = {"success": True, "file_name": filename}
                # return redirect(url_for('upload_file', filename=filename))
            except:
                dic = {"success": False}
    js = json.dumps(dic)
    return js


@app.route('/profile/set_profile_picture')
def set_profile_picture():
    user_id = request.args.get("user_id")
    file_name = request.args.get("file_name")
    # db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
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


@app.route('/profile/set_bio')
def set_bio():
    user_id = request.args.get("user_id")
    bio = request.args.get("bio")
    # db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
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


@app.route('/profile/set_website')
def set_website():
    user_id = request.args.get("user_id")
    website = request.args.get("website")
    # db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
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


@app.route('/profile/set_location')
def set_location():
    user_id = request.args.get("user_id")
    location = request.args.get("location")
    # db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
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


@app.route('/search/search_username')
def search_username():
    username = request.args.get("username")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql = "SELECT user_id FROM user WHERE username = %s"
    try:
        cursor.execute(sql, username)
        result = cursor.fetchone()
        db.commit()
        dic = {"success": True, "user_id": result[0]}
    except:
        db.rollback()
        dic = {"success": False}
    db.close()
    js = json.dumps(dic)
    return js



@app.route('/relationship/follow')
def follow():
    # user_id follow user_id2
    user_id = request.args.get("user_id")
    user_id2 = request.args.get("user_id2")
    # db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql1 = "INSERT INTO relationship (user_id, follower_id) VALUES( %s, %s)"
    sql2 = "UPDATE user SET num_of_following =  num_of_following + 1 WHERE user_id = %s"
    sql3 = "UPDATE user SET num_of_follower =  num_of_follower + 1 WHERE user_id = %s"
    try:
        cursor.execute(sql1, (user_id2, user_id))
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


@app.route('/relationship/unfollow')
def unfollow():
    # user_id unfollow user_id2
    user_id = request.args.get("user_id")
    user_id2 = request.args.get("user_id2")
    # db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql1 = "DELETE FROM relationship WHERE (user_id= %s AND follower_id= %s)"
    sql2 = "UPDATE user SET num_of_following =  num_of_following - 1 WHERE user_id = %s"
    sql3 = "UPDATE user SET num_of_follower =  num_of_follower - 1 WHERE user_id = %s"
    try:
        cursor.execute(sql1, (user_id2, user_id))
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


# ----------------------
# @app.route('/upload_picture')
# def upload_picture():
# 	user_id = request.args.get("user_id")
# 	picture = request.args.get("picture")
# 	if not os.path.exists("./"+user_id):
# 		os.mkdir("./"+user_id)
# 	timestr = str(datetime.datetime.now()).replace(' ','_')
# 	try:
# 		file = open("./"+ user_id +"/" +  timestr + ".jpg", "wb")
# 		#os.chown("./"+ user_id +"/" +  timestr + ".jpg", int(os.environ['SUDO_UID']),int(os.environ['SUDO_GID']))
# 		file.write(base64.b64decode(picture))
# 		file.close()
# 		dic = {"success": True, "file_name": "./"+ user_id +"/" + timestr + ".jpg"}
# 	except:
# 		dic = {"success": False}
# 	js = json.dumps(dic)
# 	return js

@app.route('/profile/get_profile_data')
def get_profile_data():
    user_id = request.args.get("user_id")
    user_id2 = request.args.get("user_id2")
    # db = pymysql.connect("ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", "dbmasteruser", "12345678", "dbmast")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql1 = "SELECT username, facebook_id, bio, website, location, profile_picture, \
	       num_of_post, num_of_following, num_of_follower FROM user WHERE user_id = %s"
    sql2 = "SELECT user_id FROM relationship WHERE user_id = %s AND follower_id = %s"
    try:
        cursor.execute(sql1, user_id2)
        result = cursor.fetchone()
        cursor.execute(sql2, (user_id2, user_id))
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
        dic = {"success": True, "username": result[0], "fbID": result[1], "bio": result[2], "website": result[3],
               "location": result[4],
               "profile_picture_url": result[5], "num_of_post": result[6], "num_of_following": result[7],
               "num_of_follower": result[8], "is_followed": is_followed}
    db.close()
    js = json.dumps(dic)
    return js


@app.route('/relationship/get_user_followers')
def get_user_followers():
    user_id = request.args.get("user_id")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql = "SELECT U.user_id, U.username, U.profile_picture FROM user U WHERE U.user_id \
           IN (SELECT R.follower_id FROM relationship R WHERE R.user_id = %s ORDER BY time DESC);"
    try:
        cursor.execute(sql, user_id)
        result = cursor.fetchall()
        success = True
        db.commit()
    except:
        db.rollback()
        success = False
    if success == False:
        dic = {"success": False}
    else:
        followers_list = []
        for i in range(len(result)):
            followers_list.append({"user_id": result[i][0], "username": result[i][1], "profile_picture": result[i][2]})
        dic = {"success": True, "followers": followers_list}
    db.close()
    js = json.dumps(dic)
    return js


@app.route('/relationship/get_user_followings')
def get_user_followings():
    user_id = request.args.get("user_id")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql = "SELECT U.user_id, U.username, U.profile_picture FROM user U WHERE U.user_id \
            IN (SELECT R.user_id FROM relationship R WHERE R.follower_id = %s ORDER BY time DESC);"
    try:
        cursor.execute(sql, user_id)
        result = cursor.fetchall()
        success = True
        db.commit()
    except:
        db.rollback()
        success = False
    if success == False:
        dic = {"success": False}
    else:
        following_list = []
        for i in range(len(result)):
            following_list.append({"user_id": result[i][0], "username": result[i][1], "profile_picture": result[i][2]})
        dic = {"success": True, "followings": following_list}
    db.close()
    js = json.dumps(dic)
    return js


@app.route('/feed/get_activity_feed')
def get_activity_feed():
    user_id = request.args.get("user_id")
    last_post_id = request.args.get("last_post_id")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql = "SELECT P.post_id FROM post P WHERE P.user_id in (SELECT R.user_id FROM relationship R WHERE R.follower_id = %s)\
                                              AND P.post_id < %s ORDER BY P.post_id DESC LIMIT 10"
    try:
        cursor.execute(sql, (user_id, last_post_id))
        result = cursor.fetchall()
        success = True
        db.commit()
    except:
        db.rollback()
        success = False
    if success == False:
        dic = {"success": False}
    else:
        dic = {"success": True, "post_id": [result[i][0] for i in range(len(result))]}
    db.close()
    js = json.dumps(dic)
    return js


@app.route('/post/get_likes')
def get_likes():
    post_id = request.args.get("post_id")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql = "SELECT A.activity_user_id, U.username, A.activity_time FROM activity A, user U WHERE A.post_id = %s \
           AND A.activity_user_id = U.user_id AND A.is_like = 1"
    try:
        cursor.execute(sql, post_id)
        result = cursor.fetchall()
        success = True
        db.commit()
    except:
        db.rollback()
        success = False
    if success == False:
        dic = {"success": False}
    else:
        likes_list = []
        for i in range(len(result)):
            likes_list.append({"user_id": result[i][0], "username": result[i][1], "timestamp": result[i][2]})
        dic = {"success": True, "likes": likes_list}
    db.close()
    js = json.dumps(dic)
    return js


@app.route('/post/get_comments')
def get_comments():
    post_id = request.args.get("post_id")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql = "SELECT A.activity_user_id, U.username, A.text, A.activity_time FROM activity A, user U WHERE A.post_id = %s\
           AND A.activity_user_id = U.user_id AND A.is_like = 0"
    try:
        cursor.execute(sql, post_id)
        result = cursor.fetchall()
        success = True
        db.commit()
    except:
        db.rollback()
        success = False
    if success == False:
        dic = {"success": False}
    else:
        comments_list = []
        for i in range(len(result)):
            comments_list.append(
                {"user_id": result[i][0], "username": result[i][1], "text": result[i][2], "timestamp": result[i][3]})
        dic = {"success": True, "comments": comments_list}
    db.close()
    js = json.dumps(dic)
    return js

@app.route('/post/get_post_data')
def get_post_data():
    post_id = request.args.get("post_id")
    db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
    cursor = db.cursor()
    sql = "SELECT user_id, file_url, caption, post_time, mood, location, num_of_like, num_of_comment FROM post WHERE post_id = %s"
    sql2 = "SELECT hashtag FROM hashtag WHERE post_id = %s"
    sql3 = "SELECT tag_user_id FROM peopletag WHERE post_id = %s"
    try:
        cursor.execute(sql, post_id)
        result = cursor.fetchone()
        cursor.execute(sql2, post_id)
        result2 = cursor.fetchall()
        cursor.execute(sql3, post_id)
        result3 = cursor.fetchall()
        success = True
        db.commit()
    except:
        db.rollback()
        success = False
    if success == False:
        dic = {"success": False}
    else:
        dic = {"success": True, "user_id":result[0], "file_name":result[1], "caption":result[2], "mood":result[4],
               "timestamp":result[3], "location":result[5], "hashtags":[result2[i][0] for i in range(len(result2))],
               "tags":[result3[i][0] for i in range(len(result3))], "num_of_comments":result[7], "num_of_likes":result[6]}
    db.close()
    js = json.dumps(dic)
    return js

@app.route('/post/add_post')
def add_post():
    user_id = request.args.get("user_id")
    file_url = request.args.get("file_url")
    caption = request.args.get("caption")
    timestamp = request.args.get("timestamp")
    #mood = request.args.get("mood")
    location = request.args.get("location")
    hashtags = request.args.get('hashtags')
    tags = request.args.get('tags')

    ntime = int(timestamp.split(".")[0])
    nhour = time.strftime("%H", time.localtime(ntime))
    i = int(nhour)
    mood = str(255-10*i)+",70,70"

    db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
    cursor = db.cursor()

    sql = "INSERT INTO post (user_id, file_url, caption, post_time, location, mood) VALUES (%s, %s, %s, %s, %s, %s);"
    sql2 = "SELECT LAST_INSERT_ID();"

    if hashtags is not None:
        hash_tag_list = hashtags.split(',')
        sql3 = "INSERT INTO hashtag (post_id, hashtag) VALUES (%s, %s)"
        for i in range(len(hash_tag_list)-1):
            sql3 = sql3 + ", (%s, %s) "

    if tags is not None:
        people_tag_list = tags.split(',')
        sql4 = "INSERT INTO peopletag (post_id, tag_user_id) VALUES (%s, %s)"
        for i in range(len(people_tag_list)-1):
            sql4 = sql4 + ", (%s, %s) "

    sql5 = "UPDATE user SET num_of_post =  num_of_post + 1 WHERE user_id = %s"
    try:
        cursor.execute(sql, (user_id, file_url, caption, timestamp, location, mood))
        cursor.execute(sql2)
        post_id = cursor.fetchone()[0]

        if hashtags is not None:
            # sql3
            para_sql3 = tuple()
            for i in range(len(hash_tag_list)):
                para_sql3 += (post_id, hash_tag_list[i],)
            cursor.execute(sql3, para_sql3)
        if tags is not None:
            # sql4
            para_sql4 = tuple()
            for i in range(len(people_tag_list)):
                para_sql4 += (post_id, people_tag_list[i],)
            cursor.execute(sql4, para_sql4)
        cursor.execute(sql5, user_id)
        db.commit()
        success = True
    except:
        db.rollback()
        success = False

    db.close()

    dic = {"success": success}
    js = json.dumps(dic)
    return js
    
@app.route('/post/get_posts')
def get_posts():
    user_id = request.args.get("user_id")
    last_post_id = request.args.get("last_post_id")
    db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
    cursor = db.cursor()
    sql = "SELECT post_id FROM post  WHERE user_id = %s\
           AND post_id < %s ORDER BY post_id DESC LIMIT 10"
    try:
        cursor.execute(sql, (user_id, last_post_id))
        result = cursor.fetchall()
        success = True
        db.commit()
    except:
        db.rollback()
        success = False
    if success == False:
        dic = {"success": False}
    else:
        dic = {"success": True, "post_id": [result[i][0] for i in range(len(result))]}
    db.close()
    js = json.dumps(dic)
    return js

@app.route('/post/add_like')
def add_like():
    post_id = request.args.get("post_id")
    activity_user_id = request.args.get("user_id")
    timestamp = request.args.get("timestamp")
    db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
    cursor = db.cursor()
    sql = "INSERT INTO activity (post_id, activity_user_id, is_like, activity_time) VALUES( %s, %s, %s, %s)"
    sql2 = "UPDATE post SET num_of_like =  num_of_like + 1 WHERE post_id = %s"
    try:
        cursor.execute(sql, (post_id, activity_user_id, 1, timestamp))
        cursor.execute(sql2, post_id)
        dic = {"success": True}
        db.commit()
    except:
        db.rollback()
        dic = {"success": False}
    db.close()
    js = json.dumps(dic)
    return js

@app.route('/post/add_comment')
def add_comment():
    post_id = request.args.get("post_id")
    activity_user_id = request.args.get("user_id")
    timestamp = request.args.get("timestamp")
    text = request.args.get("text")
    db = pymysql.connect(host = "localhost", user = "root", password = "123456", db = "dbbig")
    cursor = db.cursor()
    sql = "INSERT INTO activity (post_id, activity_user_id, is_like, text,activity_time) VALUES( %s, %s,%s, %s, %s)"
    sql2 = "UPDATE post SET num_of_comment =  num_of_comment + 1 WHERE post_id = %s"
    try:
        cursor.execute(sql, (post_id, activity_user_id, 0,text, timestamp))
        cursor.execute(sql2, post_id)
        dic = {"success": True}
        db.commit()
    except:
        db.rollback()
        dic = {"success": False}
    db.close()
    js = json.dumps(dic)
    return js

@app.route('/search/search_name')
def search_name():
    username = request.args.get("username")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql = "SELECT user_id, username, profile_picture FROM user WHERE username LIKE %s LIMIT 5"
    try:
        cursor.execute(sql, username + "%")
        result = cursor.fetchall()
        success = True
        db.commit()
    except:
        db.rollback()
        success = False
    if success == False:
        dic = {"success": False}
    else:
        users_list = []
        for i in range(len(result)):
            users_list.append({"user_id": result[i][0], "username": result[i][1], "profile_picture": result[i][2]})
        dic = {"success": True, "users": users_list}
    db.close()
    js = json.dumps(dic)
    return js

@app.route('/search/search_hashtag')
def search_hashtag():
    hashtag = request.args.get("hashtag")
    last_post_id = request.args.get("last_post_id")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql = "SELECT H.post_id FROM hashtag H, post P WHERE H.hashtag = %s ORDER BY P.num_of_like DESC LIMIT 4"
    sql2 = "SELECT post_id FROM hashtag WHERE hashtag = %s ORDER BY post_id DESC LIMIT 20"
    sql3 = "SELECT post_id FROM hashtag WHERE hashtag = %s AND post_id < %s ORDER BY post_id DESC LIMIT 24"
    try:
        if last_post_id == "0":
            cursor.execute(sql, hashtag)
            result = cursor.fetchall()
            cursor.execute(sql2, hashtag)
            result2 = cursor.fetchall()
            post_list = [result[i][0] for i in range(len(result))]
            post_list = post_list + [result2[i][0] for i in range(len(result2))]
        else:
            cursor.execute(sql3, (hashtag, last_post_id))
            result = cursor.fetchall()
            post_list = [result[i][0] for i in range(len(result))]
        success = True
        db.commit()
    except:
        db.rollback()
        success = False
    if success == False:
        dic = {"success": False}
    else:
        dic = {"success": True, "post_id": post_list}
    db.close()
    js = json.dumps(dic)
    return js

@app.route('/search/search_location')
def search_location():
    location = request.args.get("location")
    last_post_id = request.args.get("last_post_id")
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql = "SELECT post_id FROM post WHERE location = %s ORDER BY post_id DESC LIMIT 24"
    sql2 = "SELECT post_id FROM post WHERE location = %s AND post_id < %s ORDER BY post_id DESC LIMIT 24"
    try:
        if last_post_id == "0":
            cursor.execute(sql, location)
            result = cursor.fetchall()
        else:
        	cursor.execute(sql2, (location, last_post_id))
        	result = cursor.fetchall()    	
        success = True
        db.commit()
    except:
        db.rollback()
        success = False
    if success == False:
        dic = {"success": False}
    else:
        dic = {"success": True, "post_id":  [result[i][0] for i in range(len(result))]}
    db.close()
    js = json.dumps(dic)
    return js

@app.route('/search/search_tophashtag')
def search_tophashtag():
    db = pymysql.connect(host="localhost", user="root", password="123456", db="dbbig")
    cursor = db.cursor()
    sql = "SELECT hashtag FROM hashtag GROUP BY hashtag ORDER BY COUNT(hashtag) DESC LIMIT 5"
    try:
        cursor.execute(sql)
        result = cursor.fetchall() 	
        success = True
        db.commit()
    except:
        db.rollback()
        success = False
    if success == False:
        dic = {"success": False}
    else:
        dic = {"success": True, "hashtags":  [result[i][0] for i in range(len(result))]}
    db.close()
    js = json.dumps(dic)
    return js

if __name__ == '__main__':
    app.run(debug=True)
