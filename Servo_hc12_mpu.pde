 /*
 *  Program for visualizing rotation data about the three IMU axes as calculated by the raw data coming from MPU6050 
 */

import processing.serial.*;

Serial  myPort;
short   portIndex = 1; // Index of serial port in list (varies by computer)
int     lf = 10;       //ASCII linefeed
String  inString;      //String for testing serial communication

// x,y coordinates of circles 1, 2, 3 (pitch, roll, yaw)
int cx[] = {250, 550};
int cy[] = {200, 200};

// circle diameters
int d   = 200; 

// Data from dmp and complementary filters
float raw[] = new float[3];
float cmp[] = new float[3];
float m=0;

/*
 * Draws a line of length len, centered at x, y at the specified angle
 */
void drawLine(int x, int y, int len, float angle) {
  if (angle>-44 && angle<44){
    pushMatrix();
    translate(x, y);
    rotate(angle);
    line(-len/2, 0, len/2, 0);
    popMatrix();
  }
}

void drawLine2(int x, int y, int len, float angle) {
  if (angle>0 && angle<178){
    pushMatrix();
    translate(x, y);
    rotate(angle);
    line(-len/2, 0, 0, 0);
    popMatrix();
  }
}
float getServoPos(){
  float value= raw[0];
  m = map(value, -45, 45, 0, 180);
  return m;
}

void setup() {
  
  // Set up the main window
  size(900, 400);
  //background(0);
  
  // Set up serial port access
  //  println("in setup");
  //  println(Serial.list());
  //  println(" Connecting to -> " + Serial.list()[portIndex]);
  myPort = new Serial(this,"COM3", 9600);
  myPort.clear();
  myPort.bufferUntil(lf);
}

void draw() {
  
  background(0);
  
  // Draw the three background circles
  noStroke();
  fill(225);
  for (int i = 0; i < 1; i++) {
    ellipse(cx[i], cy[i], d, d);
  }
    for (int i = 1; i < 2; i++) {
     arc(cx[i], cy[i], d,d, PI, 2*PI);
  }
  
  // Draw the lines representing the angles
  for (int i = 0; i < 1; i++) {
    strokeWeight(3);
    stroke(255, 0, 0);
    drawLine(cx[i], cy[i], d, radians(cmp[i]));
    stroke(#2EBDF0);
    drawLine(cx[i], cy[i], d, radians(raw[i]));
  }
  for (int i = 1; i < 2; i++) {
    strokeWeight(3);
    stroke(255, 0, 0);
    drawLine2(cx[i], cy[i], d, radians(getServoPos()));
  }
  
  // Draw the explanatory text
  textSize(20);
  fill(#FFFFFF);
  text("CONTROLLING SERVO USING MPU6050",200, 20);
  
   fill(#2EBDF0);
  text("Pitch Angle", cx[0]-60, 75);
  fill(#FF0000);
  text("Servo Position", cx[1]-60, 75);
  
  for (int i = 0; i < 1; i++) {
    fill(#2EBDF0);
    String str = String.format("%5.1f", raw[i]);
    text(str, cx[i]-22, 350);
  }
  for (int i = 1; i < 2; i++) {
    fill(#FF0000);
    String str = String.format("%5.1f", m);
    text(str, cx[i]-22, 350);
  }
  
}


/*
 *  Read and process data from the serial port
 */
void serialEvent(Serial myPort) {
  inString = myPort.readString();
  
  try {
    // Parse the data
    //println(inString);
    String[] dataStrings = split(inString, ':');
    if (dataStrings.length == 2) {
     if (dataStrings[0].equals("RAW")) {
        for (int i = 0; i < dataStrings.length - 1; i++) {
          raw[i] = float(dataStrings[i+1]);
        }        
      } else {
        println(inString);
      }
    }
  } catch (Exception e) {
    println("Caught Exception");
  }
  
}
