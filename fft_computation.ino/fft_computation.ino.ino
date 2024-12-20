#include <Arduino.h>
#include <arduinoFFT.h>

#define SAMPLES 16            // Numero di campioni
#define SAMPLING_FREQUENCY 30 // Frequenza di campionamento in Hz

double vReal[SAMPLES]; // Vettore per le componenti reali
double vImag[SAMPLES]; // Vettore per le componenti immaginarie
ArduinoFFT<double> FFT = ArduinoFFT<double>(vReal, vImag, SAMPLES, SAMPLING_FREQUENCY);

void setup() {
  Serial.begin(115200);
  
  // Dati di input: x, y, z
  double inputX[SAMPLES] = {
    -70.588236, -43.137255, -70.588236, -11.764706, 35.294117, 
    11.764706, 23.529411, 82.352941, 188.235294, 207.843137, 
    286.274509, 364.705882, 282.352941, 172.549020, 39.215686, 
    43.137255
  };
  
  double inputY[SAMPLES];
  double inputZ[SAMPLES];
  
  // Copia i dati di inputX in inputY e inputZ
  for (int i = 0; i < SAMPLES; i++) {
    inputY[i] = inputX[i];
    inputZ[i] = inputX[i];
  }

  // Array per memorizzare le magnitudini concatenate
  double magnitudes[3 * (SAMPLES / 2)];

  // Funzione per calcolare la FFT e ottenere le magnitudini
  auto calculateFFT = [](double input[], double magnitudes[], int offset) {
    for (int i = 0; i < SAMPLES; i++) {
      vReal[i] = input[i];
      vImag[i] = 0.0; // La parte immaginaria è zero
    }
    FFT.compute(FFTDirection::Forward);
    FFT.complexToMagnitude();
    for (int i = 0; i < SAMPLES / 2; i++) {
      magnitudes[offset + i] = vReal[i];
    }
  };

  // Calcola la FFT per ogni canale e concatena le magnitudini
  calculateFFT(inputX, magnitudes, 0);
  calculateFFT(inputY, magnitudes, SAMPLES / 2);
  calculateFFT(inputZ, magnitudes, SAMPLES);

  // Stampa le magnitudini concatenate
  Serial.println("Magnitudini calcolate:");
  for (int i = 0; i < 3 * (SAMPLES / 2); i++) {
    Serial.print(magnitudes[i]);  ////magnitude va in ingresso al decision tree - se non va ricontrollare i dati
    Serial.print(" ");
  }
  Serial.println();

  while (1); // Loop infinito
}

void loop() {
  // Il loop rimane vuoto poiché il calcolo FFT è fatto solo una volta
}
