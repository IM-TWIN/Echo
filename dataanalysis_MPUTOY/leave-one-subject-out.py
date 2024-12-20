#import libraries and functions
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, StratifiedKFold, GridSearchCV
from sklearn.preprocessing import MinMaxScaler
from sklearn.utils import shuffle
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense, Dropout
from tensorflow.keras.callbacks import EarlyStopping
from tensorflow.keras.utils import to_categorical
from tensorflow.keras.optimizers import Adam
import tensorflow as tf
from tensorflow.keras.regularizers import l2
from keras.callbacks import EarlyStopping
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report
#!pip install scikit-learn --upgrade
from keras import Model
from sklearn.decomposition import PCA
from scipy import signal
from sklearn.tree import DecisionTreeClassifier
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.feature_selection import SelectFromModel
import joblib
from sklearn.model_selection import GridSearchCV
from sklearn.tree import export_text

def subtract_first_row(df):
    cols_to_subtract = ['Eulerx', 'Eulery', 'Eulerz', 'Accx', 'Accy', 'Accz', 'Gyrox', 'Gyroy', 'Gyroz']
    cols_to_subtract = list(set(cols_to_subtract) & set(df.columns))
    first_row_numeric = df.loc[df.index[0], cols_to_subtract].astype(np.float64)  # Conversione a float64
    df_subtracted = df.copy()
    df_subtracted.loc[:, cols_to_subtract] = df_subtracted.loc[:, cols_to_subtract].subtract(first_row_numeric, axis='columns')
    df_subtracted.reset_index(drop=True, inplace=True)
    return df_subtracted

def remove_walking(df):
  df['label'] = pd.to_numeric(df['label'])
  # Remove rows with Label == 2 (walking)
  df = df[df['label'] != 2].copy()
  # Reset index
  df.reset_index(drop=True, inplace=True)
  return df
  
def sort_df_by_label(df):
    # Convert 'label' column to numeric before sorting
    df['label'] = pd.to_numeric(df['label'])  
    df = df.sort_values(by='label')
    df.reset_index(drop=True, inplace=True)
    return df

def create_windows(data, window_size):
    num_rows = len(data)
    if num_rows <= window_size:
        raise ValueError("La dimensione della finestra è maggiore o uguale al numero di righe nel dataset.")
    # Pre-alloca X e y
    n_windows = num_rows - window_size
    n_features = data.shape[1] - 1  # Numero di caratteristiche (escludendo la colonna di etichette)
    X = np.empty((n_windows, window_size, n_features), dtype=data.iloc[:, :-1].values.dtype)
    y = np.empty(n_windows, dtype=data.iloc[:, -1].values.dtype)
    for i in range(n_windows):
        X[i] = data.iloc[i:i + window_size, :-1].values
        y[i] = data.iloc[i + window_size - 1, -1]
    return X, y

def calculate_fft(X):
    X_fft = []
    for timeseries in X:
        fft_features = []
        for i in range(timeseries.shape[1]):  # Itera su ogni feature
            fft_result = np.fft.fft(timeseries[:, i])  # FFT per la i-esima feature
            fft_magnitude = np.abs(fft_result[:len(fft_result)//2])  # Prendi la magnitudine dei valori complessi e usa solo metà dello spettro
            fft_features.append(fft_magnitude.astype(float))
        X_fft.append(np.hstack(fft_features))  # Concatenazione delle fft di tutte le feature AVRÒ 3 SPETTRI DA 8 BINS CIASCUNO
    return np.array(X_fft)

def majority_voting(predictions, window_size=5): #dimesione finestrra usata su esp32
    voted_predictions = []
    for i in range(len(predictions) - window_size + 1):
        window = predictions[i : i + window_size]
        # Trova l'etichetta più frequente nella finestra
        most_frequent_label = np.bincount(window).argmax()
        voted_predictions.append(most_frequent_label)
    return np.array(voted_predictions)

def rimuovi_primi_campioni(df, num_campioni=50):

    etichette = df['label'].unique()  # Ottieni etichette di classe univoche
    df_filtrato = df.copy()  # Crea una copia per evitare di modificare il DataFrame originale
    for etichetta in etichette:
        # Trova l'indice in cui questa etichetta appare per la prima volta
        primo_indice = df_filtrato['label'][df_filtrato['label'] == etichetta].index[0]
        # Rimuovi 'num_campioni' a partire da questo indice
        indici_da_rimuovere = list(range(primo_indice, min(primo_indice + num_campioni, len(df_filtrato))))
        df_filtrato.drop(indici_da_rimuovere, inplace=True)

    df_filtrato.reset_index(drop=True, inplace=True)  # Reimposta l'indice
    return df_filtrato

def export_tree_to_c(classifier):
    tree_rules = export_text(classifier, feature_names=[f"features[{i}]" for i in range(len(classifier.feature_importances_))])
    
    c_code = "int classify(float features[]) {\n"
    for line in tree_rules.splitlines():
        if line.startswith("|"):
            continue  # Ignora i prefissi dell'output di export_text
        line = line.strip()
        if line.endswith(":"):
            continue  # Ignora le linee finali che non contengono condizioni
        condition = line.split(" ")[0]
        threshold = line.split("<=")[1].strip()
        class_label = line.split(":")[-1].strip()
        c_code += f"    if ({condition} <= {threshold}) {{\n"
        c_code += f"        return {class_label};\n"
        c_code += "    }\n"
    c_code += "}\n"
    return c_code

#import and cleaning
df1 = pd.read_csv('/content/drive/MyDrive/MPUTOYDATA/dati_andrea.csv')
df2 = pd.read_csv('/content/drive/MyDrive/MPUTOYDATA/dati_christian.csv')
df3 = pd.read_csv('/content/drive/MyDrive/MPUTOYDATA/dati_giovanni.csv')
df4 = pd.read_csv('/content/drive/MyDrive/MPUTOYDATA/dati_beste(con rana).csv')
df5 = pd.read_csv('/content/drive/MyDrive/MPUTOYDATA/dati_valerio.csv')
df6 = pd.read_csv('/content/drive/MyDrive/MPUTOYDATA/dati_giampiero.csv')
df7 = pd.read_csv('/content/drive/MyDrive/MPUTOYDATA/dati_flavio(con rana).csv')
df8 = pd.read_csv('/content/drive/MyDrive/MPUTOYDATA/dati_andrea_rana.csv')
df9 = pd.read_csv('/content/drive/MyDrive/MPUTOYDATA/dati_giovanni_rana.csv')
df10 = pd.read_csv('/content/drive/MyDrive/MPUTOYDATA/dati_valerio_rana.csv')
df11 = pd.read_csv('/content/drive/MyDrive/MPUTOYDATA/dati_christian_rana.csv')
df12 = pd.read_csv('/content/drive/MyDrive/MPUTOYDATA/dati_giampiero_rana.csv')

#removing all the data before the start of the protocol - run only one time!! - prima delle operazioni ok
df1 = df1[df1['label'] != 'Null']
df2 = df2[df2['label'] != 'Null']
df3 = df3[df3['label'] != 'Null']
df4 = df4[df4['label'] != 'Null']
df5 = df5[df5['label'] != 'Null']
df6 = df6[df6['label'] != 'Null']
df7 = df7[df7['label'] != 'Null']
df8 = df8[df8['label'] != 'Null']
df9 = df9[df9['label'] != 'Null']
df10 = df10[df10['label'] != 'Null']
df11 = df11[df11['label'] != 'Null']
df12 = df12[df12['label'] != 'Null']

df1 = subtract_first_row(df1)
df2 = subtract_first_row(df2)
df3 = subtract_first_row(df3)
df4 = subtract_first_row(df4)
df5 = subtract_first_row(df5)
df6 = subtract_first_row(df6)
df7 = subtract_first_row(df7)
df8 = subtract_first_row(df8)
df9 = subtract_first_row(df9)
df10 = subtract_first_row(df10)
df11 = subtract_first_row(df11)
df12 = subtract_first_row(df12)

df1 = remove_walking (df1)
df2 = remove_walking (df2)
df3 = remove_walking (df3)
df5 = remove_walking (df5)
df6 = remove_walking (df6)

#dataset
s1 = pd.concat([df1,df8], ignore_index = True)
s1 = rimuovi_primi_campioni(s1)
s2 = pd.concat([df2,df11], ignore_index = True)
s2 = rimuovi_primi_campioni(s2)
s3 = pd.concat([df3,df9], ignore_index = True)
s3 = rimuovi_primi_campioni(s3)
s4 = df4
s4 = rimuovi_primi_campioni(s4)
s5 = pd.concat([df5,df10], ignore_index = True)
s5 = rimuovi_primi_campioni(s5)
s6 = pd.concat([df6,df12], ignore_index = True)
s6 = rimuovi_primi_campioni(s6)
s7 = df7
s7 = rimuovi_primi_campioni(s7)

subjects = [s1, s2, s3, s4, s5, s6, s7]

for i in range(len(subjects)):
  print(f"Elaborazione soggetto {i + 1}...")  # Stampa di progresso
  #divisione del dataset in training e test
  df_test = subjects[i]
  df_train = pd.concat([subjects[j] for j in range(len(subjects)) if j != i], ignore_index=True)


  #feature selezionate Eulerx, Eulery, Gyroz - provare con Eulerz
  df_train = df_train[['Eulerx','Eulery','Gyroz','label']]
  df_train.loc[:,'label'] = df_train['label'].astype(int)
  n_features = len(df_train.columns) - 1
  n_classes = df_train['label'].nunique()
  window_size = 16
  X_train, y_train = create_windows(df_train, window_size)
  y_train = to_categorical(y_train, num_classes=n_classes)
  y_train = np.argmax(y_train, axis=1)
  X_train_fft = calculate_fft(X_train)

  df_test = df_test[['Eulerx','Eulery','Gyroz','label']]
  df_test.loc[:, 'label'] = df_test['label'].astype(int)
  X_test, y_test = create_windows(df_test, window_size)
  y_test = to_categorical(y_test, num_classes=n_classes)
  y_test = np.argmax(y_test, axis=1)
  X_test_fft = calculate_fft(X_test)

  #addestramento modello
  model = DecisionTreeClassifier(criterion='entropy', max_depth=10, min_samples_leaf=2,
                       min_samples_split=2)
  model.fit(X_train_fft, y_train)

  #test del modello con majority voting e mostro risulati del soggetto
  y_test_pred_dt = model.predict(X_test_fft)
  voted_true_classes = majority_voting(y_test)
  voted_predictions = majority_voting(y_test_pred_dt)
  min_length = min(len(voted_predictions), len(voted_true_classes))
  voted_predictions = voted_predictions[:min_length]
  voted_true_classes = voted_true_classes[:min_length]
  accuracy = accuracy_score(voted_true_classes, voted_predictions)
  print(f'Accuracy of Subject #: {accuracy}')
  classification_rep = classification_report(voted_true_classes, voted_predictions)
  print(f'Classification Report:\n{classification_rep}')
  conf_matrix = confusion_matrix(voted_true_classes, voted_predictions)
  print(f'Confusion Matrix:\n{conf_matrix}')
  class_names = ['airplane', 'car', 'frog', 'ignoring']
  fig, ax = plt.subplots()
  disp = ConfusionMatrixDisplay(confusion_matrix=conf_matrix, display_labels=class_names)
  disp.plot(cmap="Oranges", ax=ax, colorbar=False)
  ax.xaxis.set_ticks_position('top')
  ax.xaxis.set_label_position('top')
  ax.set_xlabel('Predicted Class', fontsize=12, labelpad=20)
  ax.set_ylabel('True Class', fontsize=12)
  plt.xticks(rotation=45)
  plt.yticks(rotation=45)
  ax.set_facecolor('white')
  plt.tight_layout()
  plt.show()