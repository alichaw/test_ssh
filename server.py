from flask import Flask, request, render_template
import mysql.connector

app = Flask(__name__)

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '1234',
    'database': 'test'
}

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':

        content = request.form['content']

        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("INSERT INTO texts (content) VALUES (%s)", (content,))
        conn.commit()
        cursor.close()
        conn.close()

        return 'Text successfully saved to database!'

    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True, port=8000)
