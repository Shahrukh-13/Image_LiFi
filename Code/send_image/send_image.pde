import java.awt.Dimension;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import javax.imageio.ImageIO;
import java.io.IOException;
import org.apache.commons.codec.binary.Base64;
import processing.video.*;
import processing.serial.*;

Serial port;
Capture cam;

PImage img;
String result ;
void setup()
{
  size(800,480);
  frameRate(30);
  port = new Serial(this, "COM8", 9600);    // Replace COM8 with your COM port number 
  delay(1000); 
  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
    
    cam = new Capture(this, cameras[1]);  // Select the Lowest resolution of the webcam from the list
    
    // Start capturing the images from the camera
    cam.start();
  }
}
 
void draw()
{
         if (cam.available() == true) {
    cam.read();
         }
        image(cam,0,0,width,height);
}
void EncodePImageToBase64(PImage i_Image)
 {
    result = null;
   
    BufferedImage buffImage = (BufferedImage)i_Image.getNative();
    ByteArrayOutputStream out = new ByteArrayOutputStream();
     try
    {
    ImageIO.write(buffImage, "JPG", out);
    byte[] bytes = out.toByteArray();
    result = Base64.encodeBase64String(bytes);
    out.close();
     }
     catch (IOException e) {
            e.printStackTrace();
        }
 }
 
 void mousePressed()
 {

  image(cam,0,0,width,height);
  EncodePImageToBase64(cam);
  String message="<"+result+"?"+"F\n";
  port.write(message);
  
 }
