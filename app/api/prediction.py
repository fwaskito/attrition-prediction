from flask import request, session, render_template, flash, redirect, url_for
import pandas as pd
from psycopg2.extras import RealDictCursor
from app.models.database import Database as db
from app.utils.classification import Classifier
from app.api import bp

@bp.route('/prediction', methods=['GET'])
def prediction():
    query = 'get_test_data'
    conn = db().get_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.callproc(query)
    test_data = cursor.fetchall()

    cursor.close()
    conn.close()

    if session.get('predictions') == None:
        predictions = {}
        session['predictions'] = predictions

    return render_template('prediction.html', test_data = test_data)

@bp.route('/prediction/predict', methods=['POST'])
def predict():
    # Get all test data
    query = 'get_test_data'
    conn = db().get_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.callproc(query)
    test_data = cursor.fetchall()

    # Get train data
    query = 'get_train_data'
    conn = db().get_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.callproc(query)
    train_df = pd.DataFrame(cursor.fetchall())

    cursor.close()
    conn.close()

    if request.form.get('predict_type') == 'single':
        # Single data prediction
        _id = request.form.get('id')

        # Get single test data
        for data in test_data:
            if data['id'] == _id:
                single_test_data = [data]
                break

        test_df = pd.DataFrame(single_test_data)

        # Separating train and test data
        train_df.drop('id', axis=1, inplace=True)
        test_id = test_df['id'].values.tolist()
        test_df.drop('id', axis=1, inplace=True)

        # Attrition classification using k-NN with value k=7
        cls = Classifier()
        predictions = cls.get_classification(train_df, test_df, test_id, k=7)

        predictions_sess = session.get('predictions')
        predictions_sess[_id] = predictions[_id]
        session['predictions'] = predictions_sess
        flash(str(len(test_id)) + " data sucessfully predicted.")

        return render_template('prediction.html', test_data=test_data)

    # Many data predictions
    predictions_sess = session.get('predictions')
    predicted_id = predictions_sess.keys()

    many_test_data = []
    for data in test_data:
        if data['id'] not in predicted_id:
            many_test_data.append(data)

    test_df = pd.DataFrame(many_test_data)

    # Separatin the indetifier of train and test data
    train_df.drop('id', axis=1, inplace=True)
    test_id = test_df['id'].values.tolist()
    test_df.drop('id', axis=1, inplace=True)

    # Attrition prediction using k-NN with value k=7
    cls = Classifier()
    predictions = cls.get_classification(train_df, test_df, test_id, k=7)

    for id in test_id:
        predictions_sess[id] = predictions[id]

    session['predictions'] = predictions_sess
    flash(str(len(test_id)) + " data sucessfully predicted.")

    return render_template('prediction.html', test_data = test_data)

@bp.route('/prediction/save', methods=['POST'])
def save_prediction():
    predictions_sess = session.get('predictions')
    predicted_id = predictions_sess.keys()

    query = 'set_employee_attrition'
    conn = db().get_connection()
    cursor = conn.cursor()

    for id in predicted_id:
        cursor.callproc(query, [id, predictions_sess[id]])
        conn.commit()

    cursor.close()
    conn.close()

    flash(str(len(predicted_id))+' prediction data sucessfully saved.')
    session.pop('predictions', None)
    return redirect(url_for('api.prediction'))