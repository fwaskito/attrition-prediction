from math import sqrt
from collections import Counter
from numpy import ndarray
from pandas import DataFrame


class KnnClassifier:
    def __init__(self, k: int):
        self.k: int = k
        self.X_train: ndarray = None
        self.X_test: ndarray = None
        self.y_train: DataFrame = None

    def get_euclidean_dist(self, a, b):
        sum_of_square = 0
        for pa, pb in zip(a, b):
            dist_square = (pa - pb) ** 2
            sum_of_square += dist_square

        return sqrt(sum_of_square)

    def get_minkowski_dist(self, a, b, p=1):
        dimension = len(a)
        distance = 0

        for d in range(dimension):
            distance += abs(a[d] - b[d]) ** p

        return distance ** (1 / p)

    def predict(self):
        y_predict = []

        # Prediction for each test instance
        for test_point in self.X_test:
            distances = []

            # Find the distance between i-th sample and each training sample
            for train_point in self.X_train:
                dist = self.get_euclidean_dist(test_point, train_point)
                distances.append(dist)

            distances_df = DataFrame(
                data=distances, columns=["dist"], index=self.y_train.index
            )

            # Sorting distances
            sorted_distance_df = distances_df.sort_values(by=["dist"], axis=0)

            # Get k shortest distances
            nn_df = sorted_distance_df.iloc[: self.k]

            # Get k labels of the shortest training sample
            counter = Counter(self.y_train[nn_df.index])
            prediction = counter.most_common()[0][0]

            y_predict.append(prediction)

        return y_predict

    def fit(self, X_train, X_test, y_train):
        self.X_train = X_train
        self.y_train = y_train
        self.X_test = X_test
