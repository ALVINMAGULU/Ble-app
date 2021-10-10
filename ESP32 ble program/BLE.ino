#include <BLEDevice.h>

#include <BLEServer.h>

#include <BLEUtils.h>

#include <BLE2902.h>

BLECharacteristic *characteristicTX;

bool deviceConnected = false;

const int LED = 2;

#define SERVICE_UUID   "ab0828b1-198e-4351-b779-901fa0e0371e”
#define CHARACTERISTIC_UUID_RX  "4ac8a682-9736-4e5d-932b-e9b31405049c"
#define CHARACTERISTIC_UUID_TX  "0972EF8C-7613-4075-AD52-756F33D4DA91"

void setup() {
    Serial.begin(115200);
    
     pinMode(LED, OUTPUT);
     
    BLEDevice::init("ESP32-BLE");
     BLEServer *server = BLEDevice::createServer();

     server->setCallbacks(new ServerCallbacks());

     BLEService *service = server->createService(SERVICE_UUID);

     characteristicTX = service->createCharacteristic(
                       CHARACTERISTIC_UUID_TX,
                       BLECharacteristic::PROPERTY_NOTIFY
                     );
 
    characteristicTX->addDescriptor(new BLE2902());

    BLECharacteristic *characteristic = service->createCharacteristic(
                                                      CHARACTERISTIC_UUID_RX,
                                                      BLECharacteristic::PROPERTY_WRITE
                                                    );
   characteristic->setCallbacks(new CharacteristicCallbacks());

    service->start();
    server->getAdvertising()->start();
}

void loop(){
   if (deviceConnected) {
    
   }
}

class CharacteristicCallbacks: public BLECharacteristicCallbacks {
     void onWrite(BLECharacteristic *characteristic) {
      std::string rxValue = characteristic->getValue(); 
       if (rxValue.length() > 0) {
 
               for (int i = 0; i < rxValue.length(); i++) {
             Serial.print(rxValue[i]);
               }
               Serial.println();
               //L1 liga o LED | L0 desliga o LED
               if (rxValue.find("L1") != -1) { 
             digitalWrite(LED, HIGH);
               }
               else if (rxValue.find("L0") != -1) {
             digitalWrite(LED, LOW);
               }

       }
      
     }
  };
  class ServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
 deviceConnected = true;
    };
 
    void onDisconnect(BLEServer* pServer) {
 deviceConnected = false;
    }
};
