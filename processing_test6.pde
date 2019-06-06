import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;
import android.content.Context;
import android.content.DialogInterface;
import android.app.Dialog;
import android.app.AlertDialog;
import android.widget.Toast;
import ketai.sensors.*;
import oscP5.*;
//import android.os.Message;



KetaiBluetooth bt;
String info = "";
KetaiList klist;
ArrayList<String> devicesDiscovered = new ArrayList();

void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
  println("Creating KetaiBluetooth");
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}
byte[] val_read  =new byte[1]; 
byte[] val_write =new byte[1];  
String read_recv = "";
KetaiSensor sensor;
float accelerometerX, accelerometerY, accelerometerZ;
float rotationX, rotationY, rotationZ;
int y=640;
byte[] s1;
int new_time;
int old_time=0;
byte[] old_s={0};
void setup() {
  //System.out.print("fullscreen");
  fullScreen();
  sensor = new KetaiSensor(this);
  sensor.start();
  smooth();
  ellipseMode(RADIUS);
  textSize(50);
  strokeWeight(5);
  bt.start();
  klist = new KetaiList(this, bt.getPairedDeviceNames());
  //System.out.println("run here!1");
}

void draw() { 
  background(78, 93, 75);
  text("Accelerometer: \n" +
    "x: " + nfp(accelerometerX, 1, 3) + "\n" +
    "y: " + nfp(accelerometerY, 1, 3) + "\n" +
    "z: " + nfp(accelerometerZ, 1, 3) + "\n" +
    "Gyroscope: \n" +
    "rx: " + nfp(rotationX, 1, 3) + "\n" +
    "ry: " + nfp(rotationY, 1, 3) + "\n" +
    "rz: " + nfp(rotationZ, 1, 3), 0, 0, width, height);
  //s1=(byte)((int)(accelerometerX*10));
  s1=("{\"accelermeter\":["+nfp(accelerometerX, 1, 3)+","+nfp(accelerometerY, 1, 3)+
  ","+nfp(accelerometerZ, 1, 3)+"],\"rotation\":["+nfp(rotationX, 1, 3)+
  ","+nfp(rotationY, 1, 3)+","+nfp(rotationZ, 1, 3)+"]}").getBytes();
  //text(read_recv+"!",320,1150);
  text("read String:",300,1150);
  String[] t2 = read_recv.split(" ");
  String t1 = "";
  for(int i = 0;i<t2.length;i++){
    if(t2[i].length()>=2)
  t1+=(char)(Integer.parseInt(t2[i],16));}
  text(t1+"?",320,1210);
  new_time= millis();
  if((new_time-old_time)>100){
  if(s1!=old_s){
    val_write = s1;
    bt.broadcast(val_write);
    //myactivity.usbdriver.WriteData(val_write,s1.length);
    old_s = s1;}
    old_time=new_time;
}
}


String getBluetoothInformation()
{
  String btInfo = "Server Running: ";
  btInfo += bt.isStarted() + "\n";
  btInfo += "Discovering: " + bt.isDiscovering() + "\n";
  btInfo += "Device Discoverable: "+bt.isDiscoverable() + "\n";
  btInfo += "\nConnected Devices: \n";

  ArrayList<String> devices = bt.getConnectedDeviceNames();
  for (String device : devices)
  {
    btInfo+= device+"\n";
  }

  return btInfo;
}

void onAccelerometerEvent(float x, float y, float z)
{
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}
 
 void onGyroscopeEvent(float x, float y, float z)
{
  rotationX = x;
  rotationY = y;
  rotationZ = z;
}
