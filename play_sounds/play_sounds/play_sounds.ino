// paste mp3 folder in a microSD card!!! use this code to test audio and the correct number of selected track!!!! 1->airplane 2->car 3->walking 4->ingnoring

#include "DFRobotDFPlayerMini.h"

DFRobotDFPlayerMini player; // Crea l'oggetto Player

const int potPin = 34; // Pin analogico a cui è collegato il potenziometro
int potValue = 0;      // Variabile per memorizzare il valore letto dal potenziometro
int volume = 0;       // Variabile per memorizzare il volume
int currentTrack = 0; // Traccia corrente da riprodurre
unsigned long trackStartTime = 0; // Tempo di inizio della riproduzione
bool trackPlaying = false; // Stato di riproduzione della traccia

void setup() {
  Serial.begin(9600); // Inizializza la porta seriale per il debug
  Serial2.begin(9600, SERIAL_8N1, 16, 17); // Inizializza la Serial2 con RX=16 e TX=17

  Serial.println("Connecting to DFplayer");

  while (!player.begin(Serial2)) {
    Serial.print(".");
    delay(1000);
  }

  Serial.println(" DFplayer connected!");

  // Imposta un volume iniziale
  volume = 20;
  player.volume(volume); // Imposta il volume iniziale
}

void loop() {
  // Leggi il valore del potenziometro
  potValue = analogRead(potPin);
  
  // Mappa il valore del potenziometro (0-4095) nell'intervallo del volume (0-30)
  volume = map(potValue, 0, 4095, 0, 30);

  // Imposta il volume del DFPlayer Mini
  player.volume(volume);

  Serial.print("Volume: ");
  Serial.println(volume);

  // Controlla se ci sono dati disponibili sulla porta seriale
  if (Serial.available()) {
    int input = Serial.parseInt(); // Legge un numero intero dalla seriale
    Serial.print("Received input: ");
    Serial.println(input);

    // Controlla l'input e avvia la riproduzione della traccia corrispondente
    switch (input) {
      case 1:
      case 2:
      case 3:
      case 4:
        currentTrack = input;
        player.play(currentTrack); // Riproduci la traccia selezionata
        trackStartTime = millis(); // Registra il tempo di inizio della riproduzione
        trackPlaying = true;
        Serial.print("Playing track ");
        Serial.println(currentTrack);
        break;
      default:
        Serial.println("Invalid input! Please enter a number between 1 and 4.");
        break;
    }
  }

  // Gestisci il termine della riproduzione
  if (trackPlaying) {
    unsigned long elapsedTime = millis() - trackStartTime;
    if (elapsedTime >= 5000) { // 5000 ms = 5 secondi
      Serial.println("Track finished.");
      trackPlaying = false;
    } else {
      Serial.print("Elapsed time: ");
      Serial.println(elapsedTime);
    }
  }

  // Aggiungi un breve delay per evitare una lettura seriale eccessiva
  delay(10);
}
