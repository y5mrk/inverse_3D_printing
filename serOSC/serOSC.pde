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
int temp = -1;
String vs = "";

int SIZE = 20;
Ripple[] ripples = new Ripple[SIZE];

PFont myFont;

void setup() {
  size(displayWidth, displayHeight);
  ip = "127.0.0.1";
  port = 11112;

  myPort = new Serial(this, "/dev/cu.usbmodem1421", 9600);
  oscP5 = new OscP5(this, port);
  address = new NetAddress(ip, port);

  colorMode(HSB, 100);
  background(0);
  smooth();
  frameRate(30);

  for (int i=0; i<6; i++) {
    val[i] = 0;
  }

  for (int i=0; i<SIZE; i++) {
    ripples[i] = new Ripple();
  }

  myFont = createFont("NotoSansCJKjp-Thin", 200);
  textFont(myFont);
}

void draw() {
  background(0);
  OscMessage message1 = new OscMessage("/digital/pin");

  if (val[0]==0 && val[1]==0 && val[2]==0 && val[3]==0 && val[4]==0 && val[5]==0) {
    message1.add(-1);
  }
  for (int i=0; i<6; i++) {
    if (val[i] == 1) {
      message1.add(i);
    }
  }
  oscP5.send(message1, address);

  for (int i=0; i<6; i++) {
    if (val[i] == 1) {
      if (i != temp) {
        ripples[0].init(int(random(0, width)), int(random(0, height)), random(5, 15), int(random(10, 80)));
      }
      temp = i;
    }
  }
  for (int i=0; i<SIZE; i++) {
    if (ripples[i].getFlag()) {
      ripples[i].move();
      ripples[i].rippleDraw();
    }
  }

  textSize(55);
  textAlign(CENTER, TOP);
  text("Inverse 3D printing", width/2, 40);
  textSize(35);
  textAlign(LEFT, CENTER);
  text("♪ Concept", width/10, 180);
  text("♪ How to play", width/10, 560);
  textSize(25);
  text("- ”逆3Dプリント”", width/20*3, 250);
  text("→ 編み物を編んでいくと3Dプリンターの音が流れる", width/40*7, 310);
  text("→ 3Dプリンターの出力中の挙動と、編み物の編んでいく手順が似ている（下の層から", width/40*7, 370);
  text("作っていくところ）と思ったのでその二つを組み合わせてみた。", width/40*8, 420);
  text("- 編み物 × 音楽", width/20*3, 480);
  text("- 編み途中の作品の一番上の段の縁をかぎ棒で触れると音が流れ、演奏できます。", width/20*3, 630);
  text("- 3Dプリンターの動きのように縁をなぞるようにすると良い感じで音が流れます。", width/20*3, 690);
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

