int LED = 13;
int pin[6];
int val[6];

void setup() {
  Serial.begin(9600);
  pinMode(LED, OUTPUT);
  for(int i=0; i<6; i++){
    pin[i] = i+4;
  }
  for(int i=0; i<6; i++){
    pinMode(pin[i], INPUT_PULLUP);
  }
  for (int i=0; i<6; i++){
    val[i] = 0;
  }
}

void loop() {
  for (int i=0; i<6; i++){
    val[i] = digitalRead(pin[i]);
  }
  for (int i=0; i<5; i++){
    Serial.print(val[i]);
    Serial.print(",");
  }
  Serial.println(val[5]);
  if (digitalRead(pin[0]) == HIGH) {
    digitalWrite(13, HIGH);   // set the LED on
  }else{
    digitalWrite(13, LOW);    // set the LED off
  }
  //Serial.write(val);
   delay(100);
}
