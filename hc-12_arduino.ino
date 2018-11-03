#include <SoftwareSerial.h>
#include <MPU6050_tockn.h>
#include <Wire.h>

MPU6050 mpu6050(Wire);
long timer=0;

SoftwareSerial HC12(7, 6); // HC-12 TX Pin, HC-12 RX Pin
void setup() {
  Serial.begin(9600);             // Serial port to computer
  HC12.begin(9600);               // Serial port to HC12
  Wire.begin();
  mpu6050.begin();
  mpu6050.setGyroOffsets(-0.78,-1.56,-0.13);
}
void loop() {
  mpu6050.update();
  int x= mpu6050.getAngleX();
  while (x>=-45 && x<=45) {
    mpu6050.update();
    x= mpu6050.getAngleX();
    Serial.print("RAW:");
    Serial.println(x);
    if(millis() - timer > 2000){   //Position will be sent every 2  sec after the readings settle down 
      HC12.write(x);      // Send that data to HC-12
      timer = millis();
    }
  }
}
