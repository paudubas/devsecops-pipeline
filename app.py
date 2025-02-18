from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "<h1>Welcome to the DevSecOps Secure App</h1>"

@app.route('/vulnerable')
def vulnerable():
    user_input = "<script>alert('XSS Vulnerability');</script>"
    return f"User input: {user_input}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
