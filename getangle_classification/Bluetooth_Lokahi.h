


#ifndef BLUETOOTH_LOKAHI_H
#define BLUETOOTH_LOKAHI_H

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include "Arduino.h"  // VALERIO: why Arduino.h? Try to exlude it


// MAY 10, VALERIO: stringa sostituita con quella originariamente nel setup di Lokahi, chiamata SERVICE_UUID
//#define GENERAL_SERVICE_UUID "fc9f0a57-7ccb-458c-8caf-52d28befde93"
#define GENERAL_SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"


#define COMMAND_CHARACTERISTIC_UUID "1a33e440-fa7f-48ec-b887-f99663a70f58"
#define STRING_STREAM_CHARACTERISTIC_UUID "be90e30f-4cf7-4c98-9de7-e20df844156e"

//MAY 10: string substituted with the one in Lokahi.ino.
// The string MUST coincide with the one in Godot App
//#define LOG_CHARACTERISTIC_UUID "9af7a4fe-5d9c-11ec-bf63-0242ac130002"
#define LOG_CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"


#define DIAGNOSTIC_CHARACTERISTIC_UUID "abd59e89-707d-4772-953e-73d97cec7c22"

extern BLEService *generalService;
extern BLECharacteristic *commandCharacteristic;
extern BLECharacteristic *stringStreamCharacteristic;
extern BLECharacteristic *logCharacteristic;
extern BLECharacteristic *diagnosticCharacteristic;

// Callbacks used to perform actions everytime a client connects/disconnects

extern bool identification;
extern bool send_diagnostic;
extern void function_identify(bool);
extern void parse_commands(char *);
extern void Init_Function0();
extern BLEClient *pClient;

void setup_BLE_ESP32();

class ServerCallbacksHandler : public BLEServerCallbacks 
{
    
  void onConnect(BLEServer *pserver) 
  {
    // central connected event handler
    Serial.print("[DEBUG][Bluetooth_Lokahi.h] ServerCallbacksHandler OnConnect()\n\t");
  
    Serial.print("Connected event, device: ");

    Serial.println(pserver->getConnId());
    Serial.println();

    identification = true;
    function_identify(identification);
  }

  void onDisconnect(BLEServer *pserver) 
  {
    Serial.print("[DEBUG][Bluetooth_Lokahi.h] ServerCallbacksHandler onDisconnect() \n\t");
    // central disconnected event handler
    Serial.print("Disconnected event, device: ");
    Serial.println(pserver->getConnId());
    identification = false;
    function_identify(identification);
    send_diagnostic = false;
    //Serial.println("onDisconnect");
    Init_Function0();

    delay(300);
    BLEDevice::startAdvertising();
  }
};

class CharacteristicCallback : public BLECharacteristicCallbacks {
  //--------------------------------------------------
  void onWrite(BLECharacteristic *pCharacteristic) 
  {
    Serial.print("[DEBUG][Bluetooth_Lokahi.h] BLECharacteristicCallbacks() - OnWrite()\n\t");
    Serial.print("Characteristic Callback: Writing\n\t");
    String rxValue = pCharacteristic->getValue();
    Serial.print("characteristic value: ");
    Serial.print(rxValue.c_str());
    Serial.print("\n\t");
    

    if (pCharacteristic->getUUID().toString() == COMMAND_CHARACTERISTIC_UUID) 
    {
      Serial.println("Command arrived\n");
      parse_commands((char *)pCharacteristic->getData());
    }

    if (pCharacteristic->getUUID().toString() == STRING_STREAM_CHARACTERISTIC_UUID) 
    {
    }
  }

  //--------------------------------------------------
  void onRead(BLECharacteristic *pCharacteristic) {
    String uuid = pCharacteristic->getUUID().toString().c_str();
    Serial.print(" Characteristic Callback: Reading");
    Serial.println(uuid);
    String rxValue = pCharacteristic->getValue();

    //VALERIO: all these lines in the if were already commented
    // What is the use of this if? can we omit?
    if (pCharacteristic->getUUID().toString() == STRING_STREAM_CHARACTERISTIC_UUID) {
      // String stringSegment= streamBuffer.substring(0,20);
      // streamBuffer.remove(0,20);
      // Serial.print("String=");
      // Serial.println(stringSegment);
      // if(stringSegment!="")
      // {
      //   Serial.print("..setting value");
      //   pCharacteristic->setValue(stringSegment.c_str());
      // }
    }
  }
};

#endif
