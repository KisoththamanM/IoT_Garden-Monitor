#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>

#define SOIL_PIN 32   // Capacitive Soil Moisture sensor pin
#define DHTPIN 33 // Temperature and Humidity sensor
#define DHTTYPE    DHT22
DHT_Unified dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  delay(1000);
  dht.begin();
  sensor_t sensor;
  dht.temperature().getSensor(&sensor);
  dht.humidity().getSensor(&sensor);
}

void loop() {
  delay(1000);

  sensors_event_t event;
  // Get humidity event and print its value.
  dht.temperature().getEvent(&event);
  if (isnan(event.temperature)) {
    Serial.println(F("Error reading temperature!"));
  }
  else {
    Serial.print(F("Temperature: "));
    Serial.print(event.temperature);
    Serial.println(F("°C"));
  }
  // Get humidity event and print its value.
  dht.humidity().getEvent(&event);
  if (isnan(event.relative_humidity)) {
    Serial.println(F("Error reading humidity!"));
  }
  else {
    Serial.print(F("Humidity: "));
    Serial.print(event.relative_humidity);
    Serial.println(F("%"));
  }

  // Capacitive soil moisture sensor
  int soilValue = analogRead(SOIL_PIN);
  Serial.print("Soil ADC Value: ");
  Serial.println(soilValue);
}
