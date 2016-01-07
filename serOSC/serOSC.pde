import processing.serial.*;
import processing.opengl.*;
import oscP5.*;
import netP5.*;

Serial myPort;
OscP5 oscP5;
NetAddress address;

int port;
String ip;

int val [] = new int [6];


String vs = "";


//int sa = 0;

void setup() {
  size(100, 100);
  ip = "127.0.0.1";
  port = 11112;
  
  myPort = new Serial(this, "/dev/cu.usbmodem1421", 9600);
  oscP5 = new OscP5(this, port);
  address = new NetAddress(ip, port);

  for (int i=0; i<6; i++) {
    val[i] = 0;
  }
}

void draw() {
  background(255);
  OscMessage message1 = new OscMessage("/digital/pin");
//  message1.add(0);
  for (int i=0; i<6; i++) {
    if (val[i] == 1){
      message1.add(i);
    }
//    message1.add("/pin"+i);
//    message1.add(val[i]);
  }
  oscP5.send(message1, address);
//  for (int i=0; i<val.length; i++) {
//    println(val[i]);
//  }
//println(val);
}

void serialEvent(Serial p) {
   vs = p.readStringUntil('\n');

  if (vs != null) {
    vs = trim(vs);
    String [] value = split(vs, ','); 

    if (value.length > 5) {
      for (int i=0; i<value.length; i++) {
        val[i] =int(value[i]);
      }
    }
  }
}
