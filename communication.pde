// import UDP library
import hypermedia.net.*;

void comms() {
  wifiArrayCounter=0;
  create();
  byte[] tosend=new byte[wifiArrayCounter];
  for (int i=0; i<wifiArrayCounter; i++) {
    tosend[i]=arrayToSend[i];
  }
  udp.send(tosend, "10.25.21.255", 2521);
}

void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  for (int i=0; i<data.length; i++) {
    arrayRecvd[i]=(256+data[i])%256;
  }
  wifiArrayCounter=0;
  parse();
}
void addBoolean(boolean d) {
  if (d) {
    arrayToSend[wifiArrayCounter]=1;
  } else {
    arrayToSend[wifiArrayCounter]=0;
  }
  wifiArrayCounter++;
}
void addByte(byte d) {
  arrayToSend[wifiArrayCounter]=d;
  wifiArrayCounter++;
}
void addInt(int d) {
  arrayToSend[wifiArrayCounter] = byte((d & 0xFF));
  wifiArrayCounter++;
  arrayToSend[wifiArrayCounter] = byte(((d >>> 8) & 0xFF));  
  wifiArrayCounter++;
  arrayToSend[wifiArrayCounter] = byte(((d >>> 16) & 0xFF));  
  wifiArrayCounter++;
  arrayToSend[wifiArrayCounter] = byte(((d >>> 24) & 0xFF));  
  wifiArrayCounter++;
}
void addFloat(float d) {
  int bits = Float.floatToIntBits(d);
  arrayToSend[wifiArrayCounter] = (byte)(bits & 0xFF);  
  wifiArrayCounter++;
  arrayToSend[wifiArrayCounter] = (byte)((bits >>> 8) & 0xFF);  
  wifiArrayCounter++;
  arrayToSend[wifiArrayCounter] = (byte)((bits >>> 16) & 0xFF);  
  wifiArrayCounter++;
  arrayToSend[wifiArrayCounter] = (byte)((bits >>> 24) & 0xFF);
  wifiArrayCounter++;
}
boolean parseBl() {
  boolean d;
  d=arrayRecvd[wifiArrayCounter]==1;
  wifiArrayCounter++;
  return d;
}
int parseBy() {
  int d;
  d=int(arrayRecvd[wifiArrayCounter]);
  wifiArrayCounter++;
  return d;
}
int parseIn() {
  int d = (arrayRecvd[wifiArrayCounter+3]<<24)+(arrayRecvd[wifiArrayCounter+2]<<16)+(arrayRecvd[wifiArrayCounter+1]<<8)+arrayRecvd[wifiArrayCounter];
  wifiArrayCounter++;
  wifiArrayCounter++;
  wifiArrayCounter++;
  wifiArrayCounter++;
  return d;
}
float parseFl() {
  String hexint=hex(byte(arrayRecvd[wifiArrayCounter+3]))+hex(byte(arrayRecvd[wifiArrayCounter+2]))+hex(byte(arrayRecvd[wifiArrayCounter+1]))+hex(byte(arrayRecvd[wifiArrayCounter]));
  float d = Float.intBitsToFloat(unhex(hexint)); 
  wifiArrayCounter++;
  wifiArrayCounter++;
  wifiArrayCounter++;
  wifiArrayCounter++;
  return d;
}
