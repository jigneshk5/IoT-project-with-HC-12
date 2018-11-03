#include <SoftwareSerial.h>
#include <Servo.h> 
 
Servo myservo;
SoftwareSerial HC12(4,5); // HC-12 TX Pin, HC-12 RX Pin
void setup() {
  Serial.begin(9600);             // Serial port to computer
  myservo.attach(2);               // D4 to control signal
  HC12.begin(9600);               // Serial port to HC12
}
void loop() {
  int pos;
  while (HC12.available()) {        // If HC-12 has data
    pos = HC12.read();
    Serial.print("Position: ");
    Serial.println(pos);
    myservo.write(pos);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
  }
}
