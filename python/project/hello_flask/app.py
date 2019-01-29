from flask import Flask
from flask import Request
		
app = Flask(__name__)

@app.route('/')
def index():
 fbID = request.args.get('fbID')
 username = request.args.get('username')
 return 'Hello, Flask!'

if __name__ == '__main__':
 app.run(debug=True)
