from flask import session, render_template
from psycopg2.extras import RealDictCursor
from app.models.database import Database as db
from app.api import bp

@bp.route('/employees', methods=['GET'])
def employees():
    if session.get('user'):
        query = 'get_employees'
        conn = db().get_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.callproc(query)
        employees_data = cursor.fetchall()
        cursor.close()
        conn.close()

        return render_template('home.html', employees = employees_data)

    return render_template('error.html', error='Unauthorized Access')