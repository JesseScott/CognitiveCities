
// Imports
import ddf.minim.*;
import ddf.minim.analysis.*;

import processing.serial.*;
import cc.arduino.*;

// Declarations
Minim minim;
AudioInput in;
FFT fft;

int block = 512;
int step = 2;

Arduino arduino; 

void setup() {
  // Screen
  size(block, block);
  background(0);
  stroke(255);
  smooth();
  strokeCap(ROUND);
  
  // Arduino
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);

  // you might need to change the values here...
  for( int i = 25; i < 53; i++) {
    arduino.pinMode(i, Arduino.OUTPUT); 
  }
  
  // Minim
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, block * 2);
  fft = new FFT( in.bufferSize(), in.sampleRate() );
  fft.linAverages(30);
  
  
} // End

void draw() {
  // Minim
  fft.forward(in.mix);
  
  // Screen
  background(0);

  for( int i = 1; i < fft.avgSize(); i += step) {
      int PIN = i + step;
      //println("PIN " + PIN + " is "  + fft.getBand(i));
      
      // if the band is greater than a certain amount... else
      // might want to make i/4 a variable (where it says step and block) so you can adjust it easier
      if(fft.getBand(i) > i/4 ) {
        arduino.digitalWrite(24 + i, Arduino.HIGH);
      } else {
        arduino.digitalWrite(24 + i, Arduino.LOW); 
      }
      
      // this is where i draw the lines - 
      // you can take this out, but its good for reference
      strokeWeight(12);
      stroke(255);
      line(20+i*15, height, 20 + i*15, height - fft.getBand(i)*10);
    } 

  
} // End

void stop() {
  in.close();
  minim.stop();
  super.stop();
}