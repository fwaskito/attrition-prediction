from flask import session, render_template, redirect, url_for, flash
from psycopg2.extras import RealDictCursor
from app.models.database import Database
from app.forms import SigninForm
from app.api import bp

@bp.route('/login', methods=['GET', 'POST'])
def login():
    form = SigninForm()
    if form.validate_on_submit():
        try:
            _username = form.username.data
            _password = form.password.data

            query = "select * from sppk.user where username='"+_username + "';"
            conn = Database().get_connection()
            cursor = conn.cursor(cursor_factory=RealDictCursor)
            cursor.execute(query)
            data = cursor.fetchall()

            if len(data) > 0:
                if str(data[0]['password']) == str(_password):
                    session['user'] = data[0]
                    return redirect(url_for('api.employees'))
                else:
                    flash("Password not valid!")
                    return render_template('login.html', form=form)
            else:
                flash("Username not valid!")
                return render_template('login.html', form=form)

        except Exception as e:
            print("Execption: ", e)
            return render_template('error.html', error=str(e))

    return render_template('login.html', form=form)

@bp.route('/logout')
def logout():
    session.pop('user', None)
    session.pop('predictions', None)
    return redirect(url_for('api.main'))