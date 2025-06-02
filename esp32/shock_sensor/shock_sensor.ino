
#include <WiFi.h>
#include <HTTPClient.h>
#include <Arduino.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <esp_ipc.h>


const char* ssid = ".";           // Nome da Rede Wi-Fi
const char* password = "Flamengo";  // Senha da Rede Wi-Fi
// const int shock_sensor = 4;            // Pino ADC no ESP32
const char* server = "http://api.thingspeak.com/update";
const char* apiKey = "RBP2DDP3D6QSLHNO";  // chave de escrita da API

// Module
int led = 2;           // LED output pin
int shock_sensor = 4;  // Sensor input pin
int value;             // Temporary variable

void readDataFromModule(void* parameters) {
  for (;;) {
    value = digitalRead(shock_sensor);  // Read current signal from sensor
    if (value == HIGH) {
      digitalWrite(led, HIGH);  // Turn on LED
      delay(1000);
    } else {
      digitalWrite(led, LOW);  // Turn off LED
    }
    Serial.println("Value: ");
    Serial.println(value);
    vTaskDelay(1000 / portTICK_PERIOD_MS);
  }
}

void setup() {
  Serial.begin(9600);
  delay(500);
  WiFi.begin(ssid, password);
  Serial.print("Conectando-se ao Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi conectado!");

  // Module
  pinMode(led, OUTPUT);              // Initialize output pin
  pinMode(shock_sensor, INPUT);      // Initialize sensor pin
  digitalWrite(shock_sensor, HIGH);  // Activate internal pull-up resistor

  xTaskCreate(
    readDataFromModule,
    "Read data from the module",
    2000,
    NULL,
    2,
    NULL);
}


void loop() {


  int digitalValue = digitalRead(shock_sensor);
  Serial.print("Valor lido do ADC: ");
  Serial.println(digitalValue);
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    String url = String(server) + "?api_key=" + apiKey + "&field1=" + String(digitalValue);
    http.begin(url);
    int httpResponseCode = http.GET();
    if (httpResponseCode > 0) {
      Serial.print("Código de resposta HTTP: ");
      Serial.println(httpResponseCode);
    } else {
      Serial.print("Erro ao enviar dados: ");
      Serial.println(http.errorToString(httpResponseCode).c_str());
    }
    http.end();
  } else {
    Serial.println("WiFi desconectado. Tentando reconectar...");
    WiFi.begin(ssid, password);
  }

  delay(15000);  // Intervalo de 15s (mínimo permitido pelo ThingSpeak)
}
