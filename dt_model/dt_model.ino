#include "decision_tree.h"
float inputFeatures[] = {
22.5882350, 13.7846353, 5.83300863, 4.09393570, 4.46439197, 3.99126867, 2.41611177, 0.719845798, 0.000006, 26.6581011, 39.1632931, 85.2854736, 51.1300991, 68.4314879, 64.7079060, 43.0157950, 2643.13726, 542.740148, 210.846361, 262.282313, 226.230668, 122.660799, 150.111395, 121.140552
    };
void setup() {
    // Inizializzazione della comunicazione seriale
    Serial.begin(115200);

    // Classificazione del vettore di input
    int classification = classify(inputFeatures);

    // Stampa della classe classificata
    Serial.print("Classified as: ");
    Serial.println(classification);
}

void loop() {
    // Il loop è vuoto in questo esempio
}