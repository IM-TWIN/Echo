//script for data acquisition only
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEScan.h>
#include <BLEAdvertisedDevice.h>

#include "Wire.h"
#include <MPU6050_light.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <deque>
#include <math.h>
#include "Bluetooth_Lokahi.h"

//CONSTANTS
#define INTERVAL 33

int LED_BUILTIN = 2;
int LED_AIRPLANE = 32;
int LED_CAR = 25;
//info bt
//#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
//BLECharacteristic configCharacteristic("47c0a2d6-b3b8-405d-8303-848974b84e93", BLECharacteristic::PROPERTY_READ);
//BLECharacteristic logCharacteristic("beb5483e-36e1-4688-b7f5-ea07361b26a8", BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);

MPU6050 mpu(Wire);
using namespace std;

//varibili temporali ciclo acquisizione, 30 Hz
long prevMillis = 0;
unsigned long timestep = 0;
byte timestepByte = 0;
int durata = 0;
int prev_durata = 0;
bool identification = false;
void function_identify(bool identify);
void parse_commands(char* commands);
void function_(char* commands);
int current_function = 0;
bool send_diagnostic = false;


byte log_values[69];
float x = 0;
float y = 0;
float z = 0;
float Gx = 0;
float Gy = 0;
float Gz = 0;
float Ax = 0;
float Ay = 0;
float Az = 0;

void setup() {
  Serial.begin(115200);
  Wire.begin();
  byte status = mpu.begin();
  Serial.print(F("MPU9250 status: "));
  Serial.println(status);
  while (status != 0) {}  // stop everything if could not connect to MPU6050
  Serial.println(F("Calculating offsets, do not move MPU6050"));
  delay(1000);
  // mpu.upsideDownMounting = true; // uncomment this line if the MPU6050 is mounted upside-down
  mpu.calcOffsets();  // gyro and accelero
  Serial.println("Done!\n");
  pinMode(LED_AIRPLANE, OUTPUT);
  pinMode(LED_CAR, OUTPUT);
  digitalWrite(LED_AIRPLANE, LOW);  // Spegne il LED_AIRPLANE
  digitalWrite(LED_CAR, LOW);       // Spegne il LED_CAR
  setup_BLE_ESP32();

  delay(200);
}

int v = 100;
int ver = 1;
int stat = 0;

void loop() {

  long curMillis = millis();
  if (curMillis - prevMillis >= INTERVAL) {
    long int start = millis();
    //   1  SENSORS READINGS
    mpu.update();

    x = float(mpu.getAngleX());
    y = float(mpu.getAngleY());
    z = float(mpu.getAngleZ());
    Gx = float(mpu.getGyroX()); //+- 500 deg/s
    Gy = float(mpu.getGyroY());
    Gz = float(mpu.getGyroZ());
    Ax = float(mpu.getAccX());//+-2g
    Ay = float(mpu.getAccY());
    Az = float(mpu.getAccZ() - 1); // -1 compensa l'effetto della gravità
    //Serial.println(log_values[0]);
    
    // 2 TRANSMISSION
    log_values[0] = static_cast<byte>(mapfloat(Ax, -2, 2, 0, 255));  
    log_values[1] = static_cast<byte>(mapfloat(Ay, -2, 2, 0, 255));
    log_values[2] = static_cast<byte>(mapfloat(Az, -2, 2, 0, 255)); 
    log_values[3] = static_cast<byte>(mapAngleToByte(x));
    log_values[4] = static_cast<byte>(mapAngleToByte(y));
    log_values[5] = static_cast<byte>(mapAngleToByte(z));
    log_values[6] = static_cast<byte>(mapfloat(Gx, -500, 500, 0, 255));  
    log_values[7] = static_cast<byte>(mapfloat(Gy, -500, 500, 0, 255));
    log_values[8] = static_cast<byte>(mapfloat(Gz, -500, 500, 0, 255));


    //Serial.println(log_values[0]);

    logCharacteristic->setValue(log_values, 9);
    logCharacteristic->notify();
    std::string value = stringStreamCharacteristic->getValue();  // Simula una lettura
    Serial.print("Button Read Value: "); //1 for airplane (Y) 0 for Car (Y)
    Serial.println(value.c_str());
    if (!value.empty()) {
    int readValue = atoi(value.c_str());
    if (readValue == 0) {
      digitalWrite(LED_AIRPLANE, HIGH);
      digitalWrite(LED_CAR, LOW);
    } else if (readValue == 1) {
    digitalWrite(LED_AIRPLANE, LOW);
    digitalWrite(LED_CAR, HIGH);
  }
}

    //conteggio
    long int ende = millis();
    durata = ende - start;
    prev_durata = durata;
    prevMillis = curMillis;
    timestep++;
    // mi aspetto che cicli da 0 a 255
    timestepByte++;
  }
}



float mapfloat(float x, float in_min, float in_max, float out_min, float out_max) {
  return (float)(x - in_min) * (out_max - out_min) / (float)(in_max - in_min) + out_min;
}

float euler_to_byte(float angle_in_degrees) {
    // Normalizza l'angolo tra 0 e 360 gradi
    float normalized_angle = angle_in_degrees;
    while (normalized_angle >= 360.0) {
        normalized_angle -= 360.0;
    }
    while (normalized_angle < 0.0) {
        normalized_angle += 360.0;
    }
    
    // Mappa [0, 360] a [0, 255]
    float byte_value = (normalized_angle / 360.0) * 255.0;
    
    return byte_value;
}

float mapAngleToByte(float angle_degrees) {
    // Normalize angle to [0, 360) range
    while (angle_degrees >= 360.0) {
        angle_degrees -= 360.0;
    }
    while (angle_degrees < 0.0) {
        angle_degrees += 360.0;
    }

    // Map [0, 360) range to [0, 255] byte range centered around 128
    byte byte_value = (byte)((angle_degrees / 360.0) * 255 + 128) % 256;
    
    return byte_value;
}


void write_float(byte* buff, const float value) {
  const byte* addr = reinterpret_cast<const byte*>(&value);
  for (int i = 0; i != 4; i++)
    *buff++ = *addr++;
}


void parse_commands(char* commands) 
{

  Serial.print("[DEBUG][Lokahi.ino] parse_commands()\n\t");
  Serial.print("...parsing command, whole content is: ");
  Serial.print(commands); // NOT SURE IT IS CORRECT THE PRINT OF A CHAR POINTER, CHECK!
  Serial.print("\n\t");


  // splitting command in tokens separated by comma
  char* token = strtok(commands, ",");
  
 
  while (token != NULL) 
  {
    String command = String(token);

    if (command.startsWith("Lokahi_test")) 
    {
      Serial.print("Command: Lokahi test");
      Serial.println(command);
    } else if (command.startsWith("Lokahi_test_2")) {
      Serial.print("Command: Lokahi test_2");
      Serial.println(command);
    }
    else if (command.startsWith("Id"))  // THIS IS the identification on device during connect phase! Id0 means stop identity
    {
      Serial.print("Token is: ");
      Serial.println(command);

      command.remove(0, 2);
      int id = atoi(command.c_str());

      identification = id > 0;

      function_identify(identification);

      //this means that connection has been confirmed and we reset to initial function
      if (id == 0) 
      {

        //in LOKAHI still we have no reset() neither InitFunction()
        //reset();
        //InitFunction5();
      }else
      {
        Serial.print("[WARNING!] command not recognised!\n\n");
      }

    }  // ...and so on for other commands


    //last row of while loop
    token = strtok(NULL, ",");

  }  // close while loop, and function parse_commands() ends
}


void function_identify(bool enable)
{
  Serial.print("[DEBUG][Lokahi.ino] function_identify()\n\t");
  Serial.print("enable is: ");
  Serial.println(enable);
  Serial.println();
  
  
  if(enable)
  {

  }else
  {

  }
}

void Init_Function0()
{
  // TO BE FILLED FOT LOKAHI
  current_function = 0;
}
