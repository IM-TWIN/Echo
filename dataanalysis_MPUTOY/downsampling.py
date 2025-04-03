
import pandas as pd
import numpy as np

file_path = "/home/giampiero/Desktop/logtest.csv"  # Modifica con il percorso corretto
output_path = "/home/giampiero/Desktop/logtest_downsampled.csv"

# Nomi delle colonne presenti nel CSV
timer_cols = ['Minutes', 'Seconds', 'Frames']
label_cols = ['label', 'Activity', 'Result']

# Leggi il file CSV (verifica se ha un header appropriato)
df = pd.read_csv(file_path)

# Se non esiste la colonna "Minutes", rinomina le prime 6 colonne
if 'Minutes' not in df.columns:
    df = df.iloc[:, :6]
    df.columns = timer_cols + label_cols

# Converte le colonne del timer in numerico
for col in timer_cols:
    df[col] = pd.to_numeric(df[col], errors='coerce')

# Elimina righe con valori non validi nelle colonne timer
df = df.dropna(subset=timer_cols).reset_index(drop=True)

# Calcola il tempo totale in secondi
# Ipotizzando 30.3 fps per il calcolo dei secondi dai frame
df['time'] = df['Minutes'] * 60 + df['Seconds'] + df['Frames'] / 30.3

# Ordina il DataFrame in base al tempo
df = df.sort_values('time').reset_index(drop=True)

# Crea il nuovo asse temporale a 20 Hz (step = 0.05 secondi)
t_start = df['time'].iloc[0]
t_end   = df['time'].iloc[-1]
n_samples = int(np.floor((t_end - t_start) * 20)) + 1
new_time = np.linspace(t_start, t_start + (n_samples - 1) * (1/20), n_samples)

# Crea un DataFrame con il nuovo asse temporale
df_new = pd.DataFrame({'time': new_time})

# Esegui il downsampling usando merge_asof (il campione originale più vicino per ciascun nuovo timestamp)
df_downsampled = pd.merge_asof(df_new, df, on='time', direction='nearest')

# Aggiorna i timer in base al nuovo time (campionamento a 20 Hz)
df_downsampled['Minutes'] = (df_downsampled['time'] // 60).astype(int)
df_downsampled['Seconds'] = (df_downsampled['time'] % 60).astype(int)
# Calcola i frame a 20 fps: i valori saranno da 0 a 19
df_downsampled['Frames'] = np.floor((df_downsampled['time'] % 1) * 20).astype(int)

# Riordina le colonne: timer, label, e la colonna time
cols_out = ['Minutes', 'Seconds', 'Frames'] + label_cols + ['time']
df_downsampled = df_downsampled[cols_out]


# Salva il risultato in un nuovo CSV
df_downsampled.to_csv(output_path, index=False)

# Visualizza le prime righe e un riepilogo
print(df_downsampled.head(10))
print(f"Originale: {len(df)} righe; Downsampled: {len(df_downsampled)} righe")
print(f"Downsampling completato e file salvato come {output_path}'")
