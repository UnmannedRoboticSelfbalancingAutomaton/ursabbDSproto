import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

KetaiBluetooth bt;

void comms() {
  commsArrayCounter=0;
  create();
  byte[] tosend=new byte[commsArrayCounter+1];
  for (int i=0; i<commsArrayCounter; i++) {
    tosend[i]=byte(arrayToSend[i]);
    println(tosend[i]);
  }
  tosend[commsArrayCounter]=byte(255);
  bt.broadcast(tosend);
}

void onBluetoothDataEvent(String who, byte[] data) {
  background(50, 0, 0);
  text(who, 50, 50);
  for (int i=0; i<data.length; i++) {
    text(data[i], 100, 100+i*40);
  }
}

void setupComms() {
  bt = new KetaiBluetooth(this);
  bt.start();
  bt.connectToDeviceByName(bt.getPairedDeviceNames().get(0));
}

void addBoolean(boolean d) {
  if (d) {
    arrayToSend[commsArrayCounter]=byte(129);
  } else {
    arrayToSend[commsArrayCounter]=byte(128);
  }
  commsArrayCounter++;
}
void addByte(byte d) {
  arrayToSend[commsArrayCounter]=byte(d&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte(d>>>4);
  commsArrayCounter++;
}
void addInt(int d) {
  arrayToSend[commsArrayCounter]=byte(d&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte((d>>>4)&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte((d>>>8)&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte((d>>>12)&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte((d>>>16)&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte((d>>>20)&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte((d>>>24)&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte((d>>>28)&0x7F);
  commsArrayCounter++;
}
void addFloat(float d) {
  arrayToSend[commsArrayCounter]=byte((byte)d&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte(((byte)d>>>4)&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte(((byte)d>>>8)&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte(((byte)d>>>12)&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte(((byte)d>>>16)&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte(((byte)d>>>20)&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte(((byte)d>>>24)&0x7F);
  commsArrayCounter++;
  arrayToSend[commsArrayCounter]=byte(((byte)d>>>28)&0x7F);
  commsArrayCounter++;
}
boolean parseBl() {
  boolean d;
  d=arrayRecvd[commsArrayCounter]==129;
  commsArrayCounter++;
  return d;
}
int parseBy() {
  int d;
  d=int(arrayRecvd[commsArrayCounter]);
  commsArrayCounter++;
  return d;
}
int parseIn() {
  int d = (arrayRecvd[commsArrayCounter+3]<<24)+(arrayRecvd[commsArrayCounter+2]<<16)+(arrayRecvd[commsArrayCounter+1]<<8)+arrayRecvd[commsArrayCounter];
  commsArrayCounter++;
  commsArrayCounter++;
  commsArrayCounter++;
  commsArrayCounter++;
  return d;
}
float parseFl() {
  String hexint=hex(byte(arrayRecvd[commsArrayCounter+3]))+hex(byte(arrayRecvd[commsArrayCounter+2]))+hex(byte(arrayRecvd[commsArrayCounter+1]))+hex(byte(arrayRecvd[commsArrayCounter]));
  float d = Float.intBitsToFloat(unhex(hexint)); 
  commsArrayCounter++;
  commsArrayCounter++;
  commsArrayCounter++;
  commsArrayCounter++;
  return d;
}
