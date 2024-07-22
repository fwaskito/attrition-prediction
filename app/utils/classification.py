from pandas import DataFrame
from app.utils.scaler import StandardScaler
from app.utils.knn import KnnClassifier


class Classifier:
    def __init__(self):
        self.k: int = 7
        self.train_df: DataFrame = None
        self.test_df: DataFrame = None
        self.test_id: list[str] = None

    def _encode_attribute(self):
        # Get nominal type attributes
        train_object_df = self.train_df.select_dtypes(include=["object"]).copy()
        train_object_df.drop("attrition", axis=1, inplace=True)
        test_object_df = self.test_df.select_dtypes(include=["object"]).copy()
        test_object_df.drop("attrition", axis=1, inplace=True)

        # Categorial attribute encoding
        categorical_names = train_object_df.columns
        for name in categorical_names:
            train_object_df[name] = train_object_df[name].astype("category")
            train_object_df[name] = train_object_df[name].cat.codes
            test_object_df[name] = test_object_df[name].astype("category")
            test_object_df[name] = test_object_df[name].cat.codes

        for name in categorical_names:
            self.train_df[name] = train_object_df[name]
            self.test_df[name] = test_object_df[name]

        self.train_df["attrition"] = self.train_df["attrition"].astype("category")

    def _prepare(self):
        # Data encoding
        self._encode_attribute()

        # Separate target attribute
        X_train = self.train_df.drop("attrition", axis=1).to_numpy()
        y_train = self.train_df.attrition
        X_test = self.test_df.drop("attrition", axis=1).to_numpy()

        # Scaling
        scaler = StandardScaler()
        X_train = scaler.fit_transform(X_train)
        X_test = scaler.transform(X_test)

        return X_train, X_test, y_train

    def predict(self):
        X_train, X_test, y_train = self._prepare()

        # Classification process
        classifier = KnnClassifier(self.k)
        classifier.fit(X_train, X_test, y_train)
        predict_labels = classifier.predict()

        # Map all prediction results to a dictionary
        predictions = {}
        for i in range(len(self.test_df)):
            predictions[self.test_id[i]] = predict_labels[i]

        return predictions

    def fit(self, train_df, test_df, test_id):
        self.train_df = train_df
        self.test_df = test_df
        self.test_id = test_id
