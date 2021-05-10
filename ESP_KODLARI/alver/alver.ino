//https://www.youtube.com/watch?v=gZhUi24_qms&ab_channel=ACROBOTIC
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <MFRC522.h>
#include <SPI.h>

//RFID pinleri
int RST_PIN = 9;
int SS_PIN = 10;
MFRC522 rfid(SS_PIN,RST_PIN);
byte ID[4] = {6,16,239,197};

const char *ssid = "SUPERONLINE_WiFi_4614";
const char *password = "t5CuNKueHphC";
IPAddress ip(192, 168, 1, 200);
IPAddress gateway(192, 168, 1, 1);
IPAddress subnet(255, 255, 255, 0);
ESP8266WebServer server(80);

String  resp;


void handleRoot()
{
    server.send(200, "text/html", "You are connected");
}

void setup() {
  Serial.begin(9600);
  SPI.begin();
  rfid.PCD_Init();

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
      delay(500);
      Serial.println("Connecting...");
  } 
  WiFi.config(ip, gateway, subnet);
  
  server.on("/update", handle);
  server.on("/otonom", handleOtonom);
  server.begin();
  //Serial.println("HTTP server started");  //TEST amaçlı
}

void handle(){
  server.send(200,"text/plain","CONNECTED");
    resp = server.arg("value");
    //veri = resp.substring(0,2).toInt();
    Serial.println(resp);
}

void handleOtonom(){
  if(Serial.available() > 0){
    String otonomDurum = Serial.read();
    if (otonomDurum == "ELLE"){
      //otonom iş bitince bu alttaki gidicek
      server.send(200,"text/plain","ELLE");
    }
  }
  delay(1);   //??????
}


void loop() {
  readKey();
  server.handleClient();
}

void readKey(){
  
   if(! rfid.PICC_IsNewCardPresent()){
       return;
    }
   if(! rfid.PICC_ReadCardSerial()){
       return;
    }
   if(rfid.uid.uidByte[0] == ID[0] &&
   rfid.uid.uidByte[1] == ID[1] &&
   rfid.uid.uidByte[2] == ID[2] &&
   rfid.uid.uidByte[3] == ID[3]){
    Serial.println("YAVAŞ!!!");
    printKey();
    delay(1000);
    }
   else{
    Serial.print("Yetkisiz KART!!!");
    printKey();
    }   
   rfid.PICC_HaltA();
  }
  
void printKey(){
  Serial.print("ID numarası: ");
  for(int i = 0; i < 4; i++){
    Serial.print(rfid.uid.uidByte[i]);
    Serial.print(" ");
    }
   Serial.println(" ");
  }
