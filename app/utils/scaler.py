import numpy as np


class StandardScaler:
    def __init__(self) -> None:
        self._X: np.ndarray = None
        self.n_column: int = 0
        self.means: list = []
        self.stdevs: list = []

    def _get_column_means(self):
        for i in range(self.n_column):
            self.means.append(np.mean(self._X[:, i]))

    def _get_column_stdevs(self):
        for i in range(self.n_column):
            self.stdevs.append(np.std(self._X[:, i]))

    def _standardize(self):
        for i in range(self.n_column):
            self._X[:, i] = (self._X[:, i] - self.means[i]) / self.stdevs[i]

    def transform(self, X: np.ndarray):
        self._X = X.astype(float)
        self._standardize()
        return self._X

    def fit_transform(self, X: np.ndarray):
        self._X = X.astype(float)
        self.n_column = X.shape[1]
        self._get_column_means()
        self._get_column_stdevs()
        self._standardize()
        return self._X

    def fit(self, X: np.ndarray):
        self._X = X.astype(float)
        self.n_column = X.shape[1]
        self._get_column_means()
        self._get_column_stdevs()
