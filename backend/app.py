from flask import Flask, request, render_template
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///tourists.db'
db = SQLAlchemy(app)

class Tourist(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    contact = db.Column(db.String(50))
    itinerary = db.Column(db.String(200))

@app.route('/')
def home():
    return "Flask is working 🚀"

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == "POST":
        name = request.form.get("name")
        contact = request.form.get("contact")
        itinerary = request.form.get("itinerary")

        tourist = Tourist(name=name, contact=contact, itinerary=itinerary)
        db.session.add(tourist)
        db.session.commit()

        return f"Tourist {name} registered successfully ✅ with ID {tourist.id}"
    else:
        return render_template("form.html")
    
@app.route('/tourists')
def tourists():
    tourists = Tourist.query.all()
    return render_template("tourists.html", tourists=tourists)


with app.app_context():
    db.create_all()

if __name__ == "__main__":
    app.run(debug=True)
