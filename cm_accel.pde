import ketai.sensors.*;
KetaiSensor sensor;
boolean accelerometerAvail=false;
float oriXRead, oriYRead, oriZRead;
boolean setupAccelerometer() {
  boolean worked=true;
  try {
    sensor = new KetaiSensor(this);
    sensor.start();
  }
  catch(NoClassDefFoundError e) {
    worked=false;
  }
  return worked;
}
PVector accelRead() {
  return new PVector(constrain(map(oriYRead, -7, 7, -1, 1), -1, 1), constrain(map(oriZRead, -6, 6, -1, 1), -1, 1));
}
void onGravityEvent(float x, float y, float z) {
  oriXRead = x;
  oriYRead = y;
  oriZRead = z;
}
