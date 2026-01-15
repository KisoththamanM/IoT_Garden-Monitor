#include <WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>

#define DHTPIN 33 //Temperature and Humidity sensor
#define DHTTYPE DHT22
#define SOIL_PIN 32 //Capacitive soil moisture sensor
#define RELAY_PIN 26

const char* ssid = "Wifi";
const char* password = "***********";
const char* mqtt_server = "broker.hivemq.com";

unsigned long lastSendTime = 0;
const unsigned long interval = 1000;


WiFiClient espClient;
PubSubClient client(espClient);
DHT dht(DHTPIN, DHTTYPE);

void setupWiFi() {
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
  }
}

void mqttCallback(char* topic, byte* payload, unsigned int length) {
  String msg = "";
  for (int i = 0; i < length; i++) {
    msg += (char)payload[i];
  }

  if (String(topic) == "iot/irrigation/pump") {
    //Relay is ON when Relay pin is LOW
    if (msg == "ON") {
      digitalWrite(RELAY_PIN,LOW);
      client.publish("iot/irrigation/pump/status", "ON");
    } else if (msg == "OFF") {
      digitalWrite(RELAY_PIN, HIGH);
      client.publish("iot/irrigation/pump/status", "OFF");
    }
  }
}

void reconnectMQTT() {
  while (!client.connected()) {
    if (client.connect("esp32_irrigation")) {
      client.subscribe("iot/irrigation/pump");
    } else {
      delay(2000);
    }
  }
}

void setup() {
  Serial.begin(9600);

  pinMode(RELAY_PIN, OUTPUT);
  digitalWrite(RELAY_PIN, HIGH);

  dht.begin();
  setupWiFi();

  client.setServer(mqtt_server, 1883);
  client.setCallback(mqttCallback);
  Serial.println("Ready");
}

void loop() {

  unsigned long currentMillis = millis();
 
  if (currentMillis - lastSendTime >= interval) {
    lastSendTime = currentMillis;
    
    if (!client.connected()) {
      reconnectMQTT();}
      client.loop();

    float temp = dht.readTemperature();
    float hum = dht.readHumidity();
    double soilPercent = (3300-analogRead(SOIL_PIN))/23;

    String payload = String(temp) + "," + String(hum) + "," + String(soilPercent);
    client.publish("iot/irrigation/sensor", payload.c_str());
  }
}
