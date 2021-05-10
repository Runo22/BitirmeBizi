#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

const char *ssid = "kullanıcı adı";
const char *password = "1234";



ESP8266WebServer server(80);  //BU ve ip kısımını uygulmada girilecek

void handleRoot()
{
    server.send(200, "text/html", "You are connected");
}

void setup()
{
    Serial.begin(9600);

    //Trying to connect to the WiFi
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Serial.print("*");
    }

    // Setting IP Address to 192.168.1.200, you can change it as per your need, you also need to change IP in Flutter app too.
    // Es ist Miami Yaccine onur benim Y***ramı yesin

    IPAddress ip(192, 168, 1, 200);
    IPAddress gateway(192, 168, 1, 1);
    IPAddress subnet(255, 255, 255, 0);
    WiFi.config(ip, gateway, subnet);
    Serial.println(WiFi.localIP());

    server.on("/0", dur);
    server.on("/1", ileri);
    server.on("/2", sol);
    server.on("/3", geri);
    server.on("/4", sag);
    server.on("/hiz/slw", slw);
    server.on("/hiz/slw", slw);
    server.on("/hiz/slw", slw);
    server.begin();
    Serial.println("HTTP server started");
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
