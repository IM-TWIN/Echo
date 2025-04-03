import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.animation as animation
#fare attenzione, la rec deve essere la prima rispetto all'accensione device e app, senno timer non parte da 0
# Carica il file CSV
df = pd.read_csv('/home/giampiero/Desktop/logtest_downsampled.csv')
#RICORDARSI CHE IL LOG FILE DEVE AVERE UN DOWNSAMPLING A 20 HZ!!!! (DA 30,3) OPPURE IL VIDEO SCALATO A 30.
#cancellare fino a primo valore dopo Result = 9 manualmente, magari farlo automaticamente??? cosi quando sono in kden live basta che faccio concidere il finale
# dei due video e sono sincronizzati. il timer partesul video dal primo valore dopo result=9, ma in post si puo creare un video che simuli i primi n secondi con grafico nuovo
#modifica richiesta da valerio, plottare anche i valori 9, cambiare label su asse y con nomi classi (9=null)
# Elimina le righe corrispondenti al frame 30
#df = df[df['Frames'] != 30].reset_index(drop=True)

# Estrai la colonna 'Result' e le informazioni temporali
results = df['Result']
minutes = df['Minutes']
seconds = df['Seconds']
frames = df['Frames']

# Imposta la figura per il grafico
fig, ax = plt.subplots()
line, = ax.plot([], [], lw=2)
ax.set_xlim(0, len(results))
ax.set_ylim(min(results) - 1, max(results) + 1)
ax.set_xlabel('Frame')
ax.set_ylabel('Result')
ax.set_title('Animazione del Risultato')

# Aggiungi un testo per il timer
timer_text = ax.text(0.05, 0.95, '', transform=ax.transAxes, fontsize=12, verticalalignment='top')

# Funzione di inizializzazione
def init():
    line.set_data([], [])
    timer_text.set_text('')
    return line, timer_text

# Funzione di animazione
def animate(i):
    x = range(i + 1)
    y = results[:i + 1]
    line.set_data(x, y)
    
    # Usa i valori esatti dalle colonne 'min', 'sec', 'frame'
    current_time = f"{int(minutes[i]):02d}:{int(seconds[i]):02d}:{int(frames[i]):02d}"
    timer_text.set_text(current_time)
    
    return line, timer_text

# Crea l'animazione
ani = animation.FuncAnimation(fig, animate, init_func=init, frames=len(results), interval=50, blit=True)
ani.save('provasinc.mp4', writer='ffmpeg')
# Mostra il grafico
plt.show()

# Mostra il grafico
plt.show()


