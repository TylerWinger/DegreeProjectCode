
byte TX_BYTE = 170;

void setup() {
  Serial.begin(9600);

}

void loop() {
  if(Serial.available()){
    char data_rcvd = Serial.read();
    Serial.print(data_rcvd);
  }
  Serial.write("10101010");
}
