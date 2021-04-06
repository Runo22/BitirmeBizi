//https://www.youtube.com/watch?v=gZhUi24_qms&ab_channel=ACROBOTIC

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

const char *ssid = "kullanıcı adı";
const char *password = "1234";
IPAddress ip(192, 168, 1, 200);
IPAddress gateway(192, 168, 1, 1);
IPAddress subnet(255, 255, 255, 0);
ESP8266WebServer server(80);

float CurrentSpeed = 0.0;
float TargetSpeed = 0.0;


void handleRoot()
{
    server.send(200, "text/html", "You are connected");
}

void setup()
{
    Serial.begin(9600);

    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Serial.print("*");
    }

    WiFi.config(ip, gateway, subnet);
    Serial.println(WiFi.localIP());

    server.on("/update", handle);
    server.begin();
    // Serial.println("HTTP server started");
}

void handle(){
    resp = server.arg("value");
    yon = resp.substring(0, 1).toInt();
    //araca gönderilen hedef hız
    hiz = resp.substring(1);

    switch (yon)
    {
    case 0:
        dur();
        break;
    case 1:
        ileri();
        break;
    case 2:
        sol();
        break;
    case 3:
        geri();
        break;
    case 4:
        sag();
        break;    
    default:
        dur();
        break;
    }
}



void dur(){
    server.send(200,"text/plain","dur");
    Serial.println("dur");
    //TODO motor dur kodu
}
void ileri(){
    server.send(200,"text/plain","ileri");
    Serial.println("ileri");
    //TODO motor ileri kodu
}
void sol(){
    server.send(200,"text/plain","sol");
    Serial.println("sol");
    //TODO motor sol kodu
}
void geri(){
    server.send(200,"text/plain","geri");
    Serial.println("geri");
    //TODO motor geri kodu
}
void sag(){
    server.send(200,"text/plain","sag");
    Serial.println("sag");
    //TODO motor sag kodu
}


void loop()
{
    server.handleClient();
}