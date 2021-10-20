/*
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleWrite.cpp
    Ported to Arduino ESP32 by Evandro Copercini
*/

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>


#define SERVICE_UUID        "ab0828b1-198e-4351-b779-901fa0e0371e"
#define CHARACTERISTIC_UUID_TX "4ac8a682-9736-4e5d-932b-e9b31405049c"
#define CHARACTERISTIC_UUID_RX "0972EF8C-7613-4075-AD52-756F33D4DA91"
int LED = 2;


int val = 0;
 BLECharacteristic *txCharacteristic;
 BLECharacteristic *rxCharacteristic;

class MyCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *rxCharacteristic) {
      std::string value = rxCharacteristic->getValue();

      if (value.length() > 0) {
        if (value.find("L1") != -1) { 
             digitalWrite(LED, HIGH);
               }
         if (value.find("L0") != -1) { 
             digitalWrite(LED, LOW);
               }
      
      }
      
    }
    
};

void setup() {
  Serial.begin(115200);
  pinMode(LED, OUTPUT);

  BLEDevice::init("ESP32-BLE");
  BLEServer *pServer = BLEDevice::createServer();

  BLEService *pService = pServer->createService(SERVICE_UUID);

                 txCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID_TX,
                                         BLECharacteristic::PROPERTY_READ 
                                      
                                       );
                 rxCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID_RX,
                                        
                                         BLECharacteristic::PROPERTY_WRITE
                                       );

  txCharacteristic->setCallbacks(new MyCallbacks());
  rxCharacteristic->setCallbacks(new MyCallbacks());
 // pCharacteristic->setValue("Hello World");
  pService->start();

  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();
}

void loop() {
   delay(2000);
 val ++;
  char value [8];

dtostrf(val, 2, 2, value); 


  txCharacteristic->setValue(value);
 
}
