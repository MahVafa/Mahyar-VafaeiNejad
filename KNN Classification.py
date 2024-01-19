import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn import metrics
from sklearn.metrics import plot_confusion_matrix
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import SGDClassifier
from sklearn.model_selection import StratifiedShuffleSplit
from sklearn import datasets
# Preparing Iris dataset
iris = datasets.load_iris()
iris_df = pd.DataFrame(
    iris.data, 
    columns=iris.feature_names
    )
iris_df['target'] = iris.target
target_names = {
    0:'setosa',
    1:'versicolor', 
    2:'virginica'
}
iris_df['target_names'] = iris_df['target'].map(target_names)
# Distance Function
def Distance(X,Y):
    return np.sqrt(np.sum((X-Y)**2))
n = int(input('Please Enter number of neighbors for classification: '))
split = StratifiedShuffleSplit(n_splits=1,test_size=0.2,random_state=42)
test_set = []
train_set = []
for train_indices , test_indices in split.split(iris_df,iris_df['target']):
    test_set = iris_df.loc[test_indices]
    train_set = iris_df.loc[train_indices]
Knn_pred_set = test_set.copy()
Knn_pred_set.drop(['sepal length (cm)','sepal width (cm)','petal length (cm)','petal width (cm)','target'], axis = 1, inplace = True)
C = pd.DataFrame(0, index = test_set.index, columns = ['setosa','versicolor','virginica'])
C1 = pd.DataFrame(0, index = range(1), columns = ['setosa','versicolor','virginica'])
# Accuracy for test set
def Knn_Criteria():
    distance_mat = np.zeros((test_set.shape[0],train_set.shape[0]))
    for i in range(distance_mat.shape[0]):
        for k in range(distance_mat.shape[1]):
            distance_mat[i,k] = Distance(test_set.iloc[i,0:4],train_set.iloc[k,0:4])
    min_args = np.argsort(distance_mat)[:,0:n]
    min_vals = np.sort(distance_mat)[:,0:n]
    Knn_labels = pd.DataFrame(index = range(min_args.shape[0]), columns = range(min_args.shape[1]))
    for l in range(min_args.shape[0]):
        for c in range(min_args.shape[1]):
            Knn_labels.iloc[l,c] = train_set.iloc[min_args[l,c],5]
    for c1 in range(Knn_labels.shape[0]):
        for c2 in range(Knn_labels.shape[1]):
            if Knn_labels.iloc[c1,c2] == 'setosa':
                C.iloc[c1,0] += 1
            elif Knn_labels.iloc[c1,c2] == 'versicolor':
                C.iloc[c1,1] += 1
            else:
                C.iloc[c1,2] += 1 
    Knn_pred_set['My_Knn_Pred'] = C.idxmax(axis=1)
    Accuracy,a = [0,0]
    for i in range(Knn_pred_set.shape[0]):
        if Knn_pred_set.iloc[i,0] != Knn_pred_set.iloc[i,1]:
            a += 1
    Accuracy = (1-(a/test_set.shape[0]))*100
    return distance_mat, min_vals, min_args, Knn_labels, C, Knn_pred_set, Accuracy
# KNN Function   
def Knn_Predictor(X):
   distance_mat1 = np.zeros((X.shape[0],train_set.shape[0]))
   for k in range(distance_mat1.shape[1]):
          distance_mat1[0,k] = Distance(X,np.array(train_set.iloc[k,0:4]))
   min_args = np.argsort(distance_mat1)[:,0:n]
   min_vals = np.sort(distance_mat1)[:,0:n]
   Knn_labels = pd.DataFrame(index = range(1), columns = range(min_args.shape[1]))
   for l in range(min_args.shape[0]):
       for c in range(min_args.shape[1]):
           Knn_labels.iloc[l,c] = train_set.iloc[min_args[l,c],5]
   for c1 in range(Knn_labels.shape[1]):
       if Knn_labels.iloc[0,c1] == 'setosa':
             C1.iloc[0,0] += 1
       elif Knn_labels.iloc[0,c1] == 'versicolor':
             C1.iloc[0,1] += 1
       else:
             C1.iloc[0,2] += 1
   KNN_prediction =  C1.idxmax(axis=1)
   return distance_mat1, min_vals, min_args, Knn_labels, C1, KNN_prediction
