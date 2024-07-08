from flask import request, session, render_template, flash, redirect, url_for
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

@bp.route('/employees/edit', methods=['POST'])
def edit_employee():
    _id = request.form.get('id')
    _age = request.form.get('age')
    #---- convert foreign key -----------------
    _departmant = request.form.get('department')
    _department_id = ''

    if _departmant.lower() == 'research & development':
        _department_id = 'DP1'
    elif _departmant.lower() == 'sales':
        _department_id = 'DP2'
    else:
        _department_id = 'DP3'
    #------------------------------------------
    _dist_from_home = request.form.get('dist_from_home')
    _edu = request.form.get('edu')
    _edu_field = request.form.get('edu_field')
    _env_sat = request.form.get('env_sat')
    _job_sat = request.form.get('job_sat')
    _marital_sts = request.form.get('marital_sts')
    _num_comp_worked = request.form.get('num_comp_worked')
    _salary = request.form.get('salary')
    _wlb = request.form.get('wlb')
    _years_at_comp = request.form.get('years_at_comp')

    values = [_age, _department_id, _dist_from_home, _edu, \
            _edu_field, _env_sat, _job_sat, _marital_sts, \
            _num_comp_worked, _salary, _wlb, _years_at_comp, _id]

    query = 'update_employee'
    conn = db().get_connection()
    cursor = conn.cursor()
    cursor.callproc(query, values)
    conn.commit()

    cursor.close()
    conn.close()

    flash(_id + '\'s data sucessfully updated.')
    return redirect(url_for('api.employees'))

@bp.route('/employees/delete', methods=['POST'])
def deleteData():
    _id = request.form.get('id')
    query = 'delete_employee'
    conn = db().get_connection()
    cursor = conn.cursor()
    cursor.callproc(query, [_id,])
    conn.commit()

    cursor.close()
    conn.close()

    flash('Employee' + _id + ' sucessfully deleted.')
    return redirect(url_for('api.employees'))