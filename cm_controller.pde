//TODO: adjust range
import org.gamecontrolplus.*;
import net.java.games.input.*;
boolean controllerAvail=false;
ControlIO control;
ControlDevice gpad;
boolean setupController() {
  try {
    control = ControlIO.getInstance(this);
    println(control.getDevices());
    gpad=control.getDevice(control.getDevices().size()-1);
    if (gpad == null) {
      return false;
    }
  }
  catch(NoClassDefFoundError d) {
    return false;
  }
  catch(ExceptionInInitializerError e) {
    return false;
  }
  catch(NullPointerException f) {
    return false;
  }
  try {//test the controller
    gpad.getSlider("X Axis").getValue();
    gpad.getSlider("Y Axis").getValue();
  }
  catch(NullPointerException e) {
    return false;
  }
  return true;
}
PVector readCtrl() {
  return new PVector(gpad.getSlider("X Axis").getValue(), gpad.getSlider("Y Axis").getValue());
}
