from flask import request, session
from flask import render_template, flash, redirect, url_for
from pandas import DataFrame
from app.api.models.model import Prediction
from app.utils.classification import Classifier
from app.utils.helper import convert_attribute
from app.api import bp


@bp.route("/predictions", methods=["GET"])
def predictions():
    test_data = Prediction().get_test_data()
    convert_attribute(test_data)

    if session.get("predictions") is None:
        predictions = {}
        session["predictions"] = predictions

    return render_template(
        "prediction.html",
        test_data=test_data,
        page="prediction",
    )


@bp.route("/predictions/predict", methods=["POST"])
def predict():
    test_data = Prediction().get_test_data()
    train_df = DataFrame(Prediction().get_train_data())

    if request.form.get("predict_type") == "single":
        # Single data prediction
        id_ = request.form.get("id")

        # Get single test data
        for data in test_data:
            if data["id"] == id_:
                single_test_data = [data]
                break

        test_df = DataFrame(single_test_data)

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
        flash("Employee successfully predicted.")

        return redirect(url_for("api.predictions"))

    # Many data predictions
    predictions_sess = session.get("predictions")
    predicted_id = predictions_sess.keys()
    many_test_data = []

    for data in test_data:
        if data["id"] not in predicted_id:
            many_test_data.append(data)

    test_df = DataFrame(many_test_data)

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
    flash(str(len(test_id)) + " Employee successfully predicted.")

    return redirect(url_for("api.predictions"))


@bp.route("/predictions/reset", methods=["POST"])
def reset_prediction():
    Prediction().rest_test_data()
    session.pop("predictions", None)
    flash("All prediction data successfully reset.")

    return redirect(url_for("api.predictions"))
