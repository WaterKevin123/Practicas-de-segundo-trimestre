#include <WiFi.h>
#include <ThingerESP32.h>

/* ========= THINGER.IO ========= */
#define USERNAME "Kevin_Sacanecla"
#define DEVICE_ID "Kevin_Sacancela"
#define DEVICE_CREDENTIAL "Sacancela5"

/* ========= WIFI ========= */
#define SSID "MECATRONICA_3ABC"
#define SSID_PASSWORD "MEC2025@."

/* ========= RELE ========= */
#define RELE_PIN 5   // Puedes usar GPIO5 (recomendado)

ThingerESP32 thing(USERNAME, DEVICE_ID, DEVICE_CREDENTIAL);

void setup() {
  Serial.begin(115200);
  delay(1000);

  pinMode(RELE_PIN, OUTPUT);
  digitalWrite(RELE_PIN, HIGH);  // Relé apagado (si es activo en LOW)

  thing.add_wifi(SSID, SSID_PASSWORD);

  // Control desde Thinger
  thing["rele"] << digitalPin(RELE_PIN);

  Serial.println("ESP32 iniciado. Controlando rele desde Thinger.io");
}

void loop() {
  thing.handle();
}