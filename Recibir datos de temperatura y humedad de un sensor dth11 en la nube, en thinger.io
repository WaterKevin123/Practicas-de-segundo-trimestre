#include <WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>

// ---------- WIFI ----------
const char* ssid = "MECATRONICA_3ABC";
const char* password = "MEC2025@.";

// ---------- MQTT / THINGER ----------
const char* mqtt_server = "backend.thinger.io";
const int mqtt_port = 1883;

const char* user = "Kevin_Sacanecla";
const char* device = "Kevin";
const char* device_password = "123456";

// ---------- DHT ----------
#define DHTPIN 23
#define DHTTYPE DHT11

DHT dht(DHTPIN, DHTTYPE);
WiFiClient espClient;
PubSubClient client(espClient);

// Topic Thinger
String topic = "v1/users/" + String(user) + "/devices/" + String(device) + "/data/DHT11";

// ---------- FUNCIONES ----------
void setup_wifi() {
  delay(10);
  Serial.print("Conectando a ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi conectado");
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Conectando a MQTT...");
    // En Thinger.io por MQTT el ClientID suele ser el 'device' y el username el 'user'
    if (client.connect(device, user, device_password)) {
      Serial.println(" conectado");
    } else {
      Serial.print(" fallo, rc=");
      Serial.print(client.state());
      delay(2000);
    }
  }
}

// ---------- SETUP ----------
void setup() {
  Serial.begin(115200);
  dht.begin();
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
}

// ---------- LOOP ----------
void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  // Leer sensor
  float h = dht.readHumidity();
  float t = dht.readTemperature();

  if (isnan(h) || isnan(t)) {
    Serial.println("Error al leer el sensor DHT11");
  } else {
    // Crear JSON para Thinger.io
    String payload = "{\"humidity\":" + String(h) + ",\"temperature\":" + String(t) + "}";
    
    Serial.print("Enviando: ");
    Serial.println(payload);
    
    client.publish(topic.c_str(), payload.c_str());
  }

  delay(5000); // Esperar 5 segundos entre envíos
} // <--- ESTA ES LA LLAVE QUE FALTABA
