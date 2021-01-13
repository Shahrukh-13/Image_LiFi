import processing.serial.*;
import java.awt.Dimension;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import javax.imageio.ImageIO;
import java.io.IOException;
import org.apache.commons.codec.binary.Base64;

Serial port;
String res;
PImage result;
void setup()
{
 size(680, 480);
 //print(Serial.list()[0]);
  //String portName = Serial.list()[1];
  port = new Serial(this, "COM10", 9600);
  delay(1000); 
}
  
void draw() {
  //res=null;
  while (port.available() > 0) {
     res = port.readStringUntil('\n');   
  }
  if(res!=null)
  {
  String resmes=res.substring(res.indexOf("<")+1,res.indexOf("?"));
  DecodePImageFromBase64(resmes);
  //println(resmes);
  }
}

void  DecodePImageFromBase64(String i_Image64)
 {
   result = null;
   byte[] decodedBytes = Base64.decodeBase64(i_Image64);
 
   ByteArrayInputStream in = new ByteArrayInputStream(decodedBytes);
        try
    {
   BufferedImage bImageFromConvert = ImageIO.read(in);
   BufferedImage convertedImg = new BufferedImage(bImageFromConvert.getWidth(),     bImageFromConvert.getHeight(), BufferedImage.TYPE_INT_ARGB);
   convertedImg.getGraphics().drawImage(bImageFromConvert, 0, 0, null);
   result = new PImage(convertedImg);
    }
         catch (IOException e) {
            e.printStackTrace();
        }
        image(result,0,0,width,height);
 }
