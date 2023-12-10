from flask import Flask , render_template , request , session ,redirect ,url_for , flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin 
from werkzeug.security import generate_password_hash , check_password_hash
from flask_login import login_user , logout_user , LoginManager , login_manager
from flask_login import current_user , login_required
from datetime import datetime
from sqlalchemy import create_engine , text
from flask_mail import Mail
import json


# with open('config.json','r') as c :
#     params = json.load(c)["params"]


#MY DB Connection
local_server = True
app=Flask(__name__)
app.secret_key='Sandip'
app.config['SQLALCHEMY_DATABASE_URI']='mysql://root:@localhost/hmdbms'
db = SQLAlchemy(app)

#SMTP MAIL SERVER SETTING
# app.config.update(
#     MAIL_SERVER ="smtp.gmail.com",
#     MAIL_PORT = '465',
#     MAIL_USER_SSL = True,
#     MAIL_USERNAME = params['gmail-user'],
#     MAIL_PASSWORD = params['gmail-password']
# )



mail = Mail(app)

#This is for getting user access
login_manager = LoginManager(app)
login_manager.login_view = 'login'
login_manager.login_message = 'Please login to access this page'


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))




#here we will create db model i.e. tables
class Test(db.Model):
    id=db.Column(db.Integer(), primary_key=True)
    name=db.Column(db.String(100))
    email=db.Column(db.String(100))

class User(UserMixin ,db.Model):
    id = db.Column(db.Integer(), primary_key=True)
    username = db.Column(db.String(100))
    email = db.Column(db.String(100) , unique = True)
    password = db.Column(db.String(1000))


class Patients(db.Model):
    pid = db.Column(db.Integer(),primary_key=True)
    email = db.Column(db.String(100))
    name = db.Column(db.String(100))
    gender = db.Column(db.String(100))
    slot = db.Column(db.String(100))
    disease =db.Column(db.String(100))
    time = db.Column(db.Time(), nullable=False)
    date = db.Column(db.Date(), nullable=False)
    dept = db.Column(db.String(100))
    number = db.Column(db.String(15))

class Doctors(db.Model):
    did = db.Column(db.Integer(),primary_key=True)
    email = db.Column(db.String(100))
    name = db.Column(db.String(100))
    dept = db.Column(db.String(100))

class Trigr(db.Model):
    tid = db.Column(db.Integer(),primary_key=True)
    pid = db.Column(db.Integer())
    email = db.Column(db.String(100))
    name = db.Column(db.String(100))
    action = db.Column(db.String(100))
    timestamp = db.Column(db.String(100))
    

class Contact(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    email = db.Column(db.String(100) , unique = True)
    message = db.Column(db.String(500))




#here we will specify endpoints here 
@app.route("/")
def index():
    return render_template('index.html')
    
@app.route("/doctors", methods=["POST", "GET"])
def doctors():
    if request.method == "POST":
        email = request.form.get('email')
        doctorname = request.form.get('doctorname')
        dept = request.form.get('dept')
        query = text(f"INSERT INTO `doctors` (`email`, `doctorname`, `dept`) VALUES ('{email}', '{doctorname}', '{dept}')")
        db.session.execute(query)
        flash("Registered Successfully", "success")

    return render_template('doctors.html')


@app.route("/patients", methods=["POST", "GET"])
@login_required
def patients():
    doct = db.session.execute(text("SELECT * FROM doctors"))
    if request.method == "POST":
        email = request.form.get('email')
        name = request.form.get('name')
        gender = request.form.get('gender')
        slot = request.form.get('slot')
        disease = request.form.get('disease')
        time = request.form.get('time')
        date = request.form.get('date')
        dept = request.form.get('dept')
        number = request.form.get('number')
        
        patient = Patients(email=email, name=name, gender=gender, slot=slot, disease=disease, time=time, date=date, dept=dept, number=number)
        db.session.add(patient)
        db.session.commit()
        
        flash("Booking Confirmed", "info")
        return redirect(url_for('patients'))
    else:
        return render_template('patients.html', doct=doct)


@app.route("/booking")
@login_required
def booking():
    em = current_user.email
    query = db.session.execute(text(f"SELECT * FROM `patients` WHERE email = '{em}'"))
    return render_template('booking.html', query=query)

@app.route("/edit/<string:pid>", methods=['POST', 'GET'])
@login_required
def edit(pid):
    posts = Patients.query.filter_by(pid=pid).first()
    if request.method == "POST":
        email = request.form.get('email')
        name = request.form.get('name')
        gender = request.form.get('gender')
        slot = request.form.get('slot')
        disease = request.form.get('disease')
        time = request.form.get('time')
        date = request.form.get('date')
        dept = request.form.get('dept')
        number = request.form.get('number')
        
        query = text(f"UPDATE `patients` SET `email` = '{email}', `name` = '{name}', `gender` = '{gender}', `slot` = '{slot}', `disease` = '{disease}', `time` = '{time}', `date` = '{date}', `dept` = '{dept}', `number` = '{number}' WHERE `patients`.`pid` = {pid}")
        db.session.execute(query)
        db.session.commit()
        
        flash("Slot is updated", "success")
        return redirect('/booking')

    return render_template('edit.html', posts=posts)


@app.route("/delete/<string:pid>", methods=["POST", "GET"])
@login_required
def delete(pid):
    query = text("DELETE FROM `patients` WHERE `patients`.pid = :pid")
    db.session.execute(query, {"pid": pid})
    db.session.commit()
    flash('Slot Deleted Successfully', 'danger')
    return redirect('/booking')

@app.route("/signup" , methods=["POST","GET"])
def signup():
    if request.method == "POST":
        username =request.form.get("username") 
        email = request.form.get("email")
        password =request.form.get("password")
        user = User.query.filter_by(email = email).first()
        if user :
            flash("Email already Exist","warning")
            return render_template('signup.html')
        encpassword=generate_password_hash(password)
        newuser=User(username=username,email=email,password=encpassword)
        db.session.add(newuser)
        db.session.commit()
        flash("Sign in Successfully , Please Log in","success")
        return render_template('login.html')

    return render_template('signup.html')


@app.route("/login" , methods=['POST','GET'])
def login():
    if request.method == "POST":
        email = request.form.get("email")
        password =request.form.get("password")
        user = User.query.filter_by(email=email).first()

        if user and check_password_hash(user.password , password):
            login_user(user)
            flash("Login Successfull","primary")
            return redirect(url_for("index"))
        else :
            flash("Invalid Creditionals","danger")
            return render_template('login.html')
    return render_template('login.html')

@app.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

@app.route('/details')
@login_required
def details():
    query = text('SELECT * FROM `trigr`')
    posts = db.session.execute(query)
    return render_template('trigers.html', posts=posts)


@app.route('/search', methods=['POST', 'GET'])
@login_required
def search():
    if request.method == "POST":
        query = request.form.get('search')
        dept = Doctors.query.filter_by(dept=query).first()
        if dept:
            flash("Doctor is Available", "info")
        else:
            flash("Doctor is Not Available", "danger")
    return redirect(url_for('index'))



@app.route("/test")
def test_view():
    return render_template('test.html')
    try:
        a = Test.query.all()
        return 'My Database is Connected'
    except:
        return 'My Database is Not Connected'


@app.route("/privacy")
def privacy():
    return render_template('privacy.html')

@app.route("/terms")
def terms():
    return render_template('terms.html')

@app.route("/faq")
def faq():
    return render_template('faq.html')

@app.route('/contact', methods=['POST', 'GET'])
def contact():
    if request.method == "POST":
        name = request.form.get('name')
        email = request.form.get('email')
        message = request.form.get('message')
        query = text("INSERT INTO contact (name, email, message) VALUES (:name, :email, :message)")
        db.session.execute(query, {'name': name, 'email': email, 'message': message})
        db.session.commit()
        flash("Thank you for your message!", "success")
        return redirect(url_for('thankyou'))
    else:
        return render_template('contact.html')


@app.route('/thankyou')
def thankyou():
    return render_template('thankyou.html')

app.run(debug=True)



