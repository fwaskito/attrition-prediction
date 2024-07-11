from flask import request, session, render_template, flash, redirect, url_for
import pandas as pd
from psycopg2.extras import RealDictCursor
from app.models.database import Database as db
from app.utils.classification import Classifier
from app.api import bp


@bp.route("/prediction", methods=["GET"])
def prediction():
    query = "get_test_data"
    conn = db().get_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.callproc(query)
    test_data = cursor.fetchall()

    cursor.close()
    conn.close()

    if session.get("predictions") is None:
        predictions = {}
        session["predictions"] = predictions

    return render_template("prediction.html", test_data=test_data, page="prediction")


@bp.route("/prediction/predict", methods=["POST"])
def predict():
    # Get all test data
    query = "get_test_data"
    conn = db().get_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.callproc(query)
    test_data = cursor.fetchall()

    # Get train data
    query = "get_train_data"
    conn = db().get_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.callproc(query)
    train_df = pd.DataFrame(cursor.fetchall())

    cursor.close()
    conn.close()

    if request.form.get("predict_type") == "single":
        # Single data prediction
        id_ = request.form.get("id")

        # Get single test data
        for data in test_data:
            if data["id"] == id_:
                single_test_data = [data]
                break

        test_df = pd.DataFrame(single_test_data)

        # Separate unique attribute (ID)
        train_df.drop("id", axis=1, inplace=True)
        test_id = test_df["id"].values.tolist()
        test_df.drop("id", axis=1, inplace=True)

        # Classification using k-NN with value k=7
        classifier = Classifier()
        classifier.fit(train_df, test_df, test_id)
        predictions = classifier.predict()

        predictions_sess = session.get("predictions")
        predictions_sess[id_] = predictions[id_]
        session["predictions"] = predictions_sess
        flash("1 employee successfully predicted.")

        return render_template("prediction.html", test_data=test_data)

    # Many data predictions
    predictions_sess = session.get("predictions")
    predicted_id = predictions_sess.keys()

    many_test_data = []
    for data in test_data:
        if data["id"] not in predicted_id:
            many_test_data.append(data)

    test_df = pd.DataFrame(many_test_data)

    # Separate unique attribute (ID)
    train_df.drop("id", axis=1, inplace=True)
    test_id = test_df["id"].values.tolist()
    test_df.drop("id", axis=1, inplace=True)

    # Attrition prediction using k-NN with value k=7
    classifier = Classifier()
    classifier.fit(train_df, test_df, test_id)
    predictions = classifier.predict()

    for id_ in test_id:
        predictions_sess[id_] = predictions[id_]

    session["predictions"] = predictions_sess

    flash(str(len(test_id)) + " employee successfully predicted.")

    return render_template("prediction.html", test_data=test_data)


@bp.route("/prediction/reset", methods=["POST"])
def save_prediction():
    query = "reset_test_data"
    conn = db().get_connection()
    cursor = conn.cursor()

    cursor.callproc(query)
    conn.commit()

    cursor.close()
    conn.close()

    flash("All prediction data successfully reset.")
    session.pop("predictions", None)

    return redirect(url_for("api.prediction"))
