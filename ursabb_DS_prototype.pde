int ctrlModeVal=0;//0=stop, 1=screen joystick, 2=accelerometer, 3=controller
boolean enable=false;
boolean isEnabled=false;
boolean advanced=false;
boolean keyPushed=false;
boolean mousePushed=false;
byte arrayToSend[]=new byte[255];
byte wifiArrayCounter=0;
int arrayRecvd[]=new int [255];
UDP udp;  // define the UDP object
boolean tipped=false;
int ROBOT_ID=0;
int MODEL_NO=0;
float pitch=0.0;
int voltage=0;
int leftMotorSpeed=0;
int rightMotorSpeed=0;
byte numSendAux=0;
int[] auxSendArray=new int[20];
float pitchTarget;
int speedVal=100;
int turnSpeedVal=100;
byte numAuxRecv=0;
int[] auxRecvArray=new int[20];
float kP_angle=.01;
float kI_angle=0.0;
float kD_angle=0.0;
float kP_speed=.01;
float kI_speed=0.0;
float kD_speed=0.0;
float pitchOffset=0.0;
boolean recvdSettings=false;

OnScreenJoystick OSJ;
PVector s;

Slider kpa;
Slider kia;
Slider kda;
Slider kps;
Slider kis;
Slider kds;
Button ss;

void setup() {
  frameRate(25);
  fullScreen();
  background(0);
  udp = new UDP( this, 2521);
  udp.listen( true );
  orientation(LANDSCAPE);
  accelerometerAvail=setupAccelerometer();
  controllerAvail=setupController();
  OSJ=new OnScreenJoystick(width*2/3, (height-width/3), width/3, width/3, color(20), color(190));
  kpa=new Slider(width/3, height*.1, width/4, color(255), "PA", .001, 0, .500, height*.05);
  kia=new Slider(width/3, height*.2, width/4, color(255), "IA", 0, 0, .500, height*.05);
  kda=new Slider(width/3, height*.3, width/4, color(255), "DA", 0, 0, .500, height*.05);
  kps=new Slider(width/3, height*.4, width/4, color(255), "PS", .001, 0, .05, height*.05);
  kis=new Slider(width/3, height*.5, width/4, color(255), "IS", 0, 0, .05, height*.05);
  kds=new Slider(width/3, height*.6, width/4, color(255), "DS", 0, 0, .05, height*.05);
  ss=new Button(width/5, 0, height/10, height/10, color(255, 255, 0), true, "save settings");
}
void draw() {
  background(0);
  AdvButton(width/10, 0, height/10, height/10);
  if (advanced) {
    kP_angle=kpa.display(kP_angle);
    kI_angle=kia.display(kI_angle);
    kD_angle=kda.display(kD_angle);
    kP_speed=kps.display(kP_speed);
    kI_speed=kis.display(kI_speed);
    kD_speed=kds.display(kD_speed);
  }
  ss.display(false);
  String[] modes={"joystick", "tilt", "controller"};//0=stop hardcoded in
  boolean[] ok={true, accelerometerAvail, controllerAvail};
  ctrlModeVal= ControlModeSelector(ctrlModeVal, 4*width/5, 0, width/5, height/8, modes, ok);
  if (tipped) {
    enable=false;
  }
  enable=enableButton(enable, 4*width/5, height/6, width/5, height/6);
  if (ctrlModeVal==0) {
    speedVal=100;
    turnSpeedVal=100;
  }
  if (ctrlModeVal==1) {
    s=OSJ.run();
    speedVal=int(map(s.y, -1.0, 1.0, 0, 200));
    turnSpeedVal=int(map(s.x, -1.0, 1.0, 0, 200));
  }
  if (ctrlModeVal==2) {
    s=accelRead();
    speedVal=int(map(s.y, -1.0, 1.0, 0, 200));
    turnSpeedVal=int(map(s.x, -1.0, 1.0, 0, 200));
  }
  if (ctrlModeVal==3) {
    s=readCtrl();
    speedVal=int(map(s.y, -1.0, 1.0, 0, 200));
    turnSpeedVal=int(map(s.x, -1.0, 1.0, 0, 200));
  }
  comms();
  String[] msg={"recvdSettings", "enable", "robotEnabled", "speedVal", "turnSpeedVal", "kPA", "kIA", "kDA", "kPS", "kIS", "kDS", "tipped", "ROBOT_ID", "MODEL_NO", "pitch", "voltage", "leftMotorSpeed", "rightMotorSpeed", "pitchTarget", "pitchOffset"};
  String[] data={str(recvdSettings), str(enable), str(isEnabled), str(speedVal), str(turnSpeedVal), str(kP_angle), str(kI_angle), str(kD_angle), str(kP_speed), str(kI_speed), str(kD_speed), str(tipped), str(ROBOT_ID), str(MODEL_NO), str(pitch), str(map(voltage, 0, 255, 0, 1300)/100.00), str(leftMotorSpeed), str(rightMotorSpeed), str(pitchTarget), str(pitchOffset)};
  fscmdDisplayInfo(msg, data, 0, height/10, width/4, height*4/5, 19, 1);

  mousePushed=false;
  keyPushed=false;
}
void create() {
  addByte(byte(ctrlModeVal));
  addByte(byte(speedVal));
  addByte(byte(turnSpeedVal));
  addByte(byte(0));//don't send aux vars
  addBoolean(advanced);
  if (advanced) {
    addFloat(kP_angle);
    addFloat(kI_angle);
    addFloat(kD_angle);
    addFloat(kP_speed);
    addFloat(kI_speed);
    addFloat(kD_speed);
  }
  if (recvdSettings==false) {
    addByte(byte(1));
  } else if (ss.t) {
    ss.t=false;
    addByte(byte(2));
  } else {
    addByte(byte(0));
  }
}
void parse() {
  isEnabled=parseBl();
  tipped=parseBl();
  ROBOT_ID=parseBy();
  MODEL_NO=parseBy();
  pitch=parseFl();
  voltage=int(parseBy());
  leftMotorSpeed=parseIn();
  rightMotorSpeed=parseIn();
  pitchTarget=parseFl();
  pitchOffset=parseFl();
  parseBy();//don't recieve auxVars
  if (parseBl()) {
    kP_angle=parseFl();
    kI_angle=parseFl();
    kD_angle=parseFl();
    kP_speed=parseFl();
    kI_speed=parseFl();
    kD_speed=parseFl();
    recvdSettings=true;
  }
}
void mousePressed() {
  mousePushed=true;
}
void keyPressed() {
  keyPushed=true;
}
