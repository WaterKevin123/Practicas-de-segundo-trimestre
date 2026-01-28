#include <WiFi.h>
#include <ThingerESP32.h>

/* ========= THINGER.IO ========= */
#define USERNAME "Kevin_Sacanecla"
#define DEVICE_ID "Kevin_Sacancela"
#define DEVICE_CREDENTIAL "123456"

/* ========= WIFI ========= */
#define SSID "MECATRONICA_3ABC"
#define SSID_PASSWORD "MEC2025@." // Cambia por tu clave real

/* ========= LED ========= */
#define LED1_PIN 2   // LED interno
#define LED2_PIN 4   // LED externo

ThingerESP32 thing(USERNAME, DEVICE_ID, DEVICE_CREDENTIAL);

void setup() {
  Serial.begin(115200);
  delay(1000);

  // Configurar pines
  pinMode(LED1_PIN, OUTPUT);
  pinMode(LED2_PIN, OUTPUT);

  digitalWrite(LED1_PIN, LOW);
  digitalWrite(LED2_PIN, LOW);

  // Conectar WiFi
  thing.add_wifi(SSID, SSID_PASSWORD);

  // Recursos para Thinger.io
  thing["led1"] << digitalPin(LED1_PIN);
  thing["led2"] << digitalPin(LED2_PIN);

  Serial.println("ESP32 iniciado. Controla los LEDs desde Thinger.io");
}

void loop() {
  thing.handle();
}
