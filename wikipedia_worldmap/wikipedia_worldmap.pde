// tobystereo20121002.pde
// 
// http://www.tobystereo.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * changing colors and size by moving the mouse
 * 	 
 * MOUSE
 * position x          : size
 * position y          : color
 * 
 * KEYS
 * s                   : save png
 * p                   : save pdf
 *
 *
 *  TODO: 
 *  implement all languages
 *  switch between 2d and 3d view
 *  zoom in and out
*/

import processing.pdf.*;
import java.util.*;

// GUI using controlP5
import controlP5.*;

  ControlP5 cp5;
  DropdownList d1, d2;
  int cnt = 0;

boolean savePDF = false;
long startMillis;
String language = "es";
String[] lang = {"ar","bg","ca","cs","da","de","en","eo","es","fa","fi","fr","gl","he","hu","id","it","ja","ko","lt","ms","nl","nn","no","pl","pt","ro","ru","sk","sl","sr","sv","tr","uk","vi","vo","war","zh"};
String message; 
boolean doLoop = true;
float pointSize = 0.5;
float rootPointSize = 0.5;

void setup() {
  size(displayWidth, displayHeight,P3D);
//  noCursor();
  startMillis = System.currentTimeMillis();
  println((System.currentTimeMillis() - startMillis) + " ms to loadStrings");
  
  cp5 = new ControlP5(this);
  // create a DropdownList
  d1 = cp5.addDropdownList("languageList")
          .setPosition(25, 50)
          .setHeight(height-100);
          ;
          
  customize(d1); // customize the first list
}


void draw() {
  // this line will start pdf export, if the variable savePDF was set to true 
  if (savePDF) beginRecord(PDF, language+"_##.pdf");

  colorMode(HSB, 360, 100, 100);
  rectMode(CENTER); 
  noStroke();
  if(doLoop){
    background(0,0,100);
    changeLanguage(language);
    doLoop = false;
  }

  // end of pdf recording
  if (savePDF) {
    savePDF = false;
    endRecord();
    pointSize = rootPointSize;
    doLoop = true;
  }
}


int currentLanguage;

void keyPressed() {
  if (key=='s' || key=='S') saveFrame(timestamp()+"_##.png");
  if (key=='p' || key=='P') {doLoop = true; savePDF = true; pointSize = 0.001;}
  if (keyCode == DOWN) { 
    currentLanguage = d1.getId();
    println(currentLanguage);
    if(currentLanguage<lang.length) {currentLanguage+=1;}
    d1.setIndex(currentLanguage);
    d1.setMousePressed(true);
    println(currentLanguage);
  }
  if (keyCode == UP) { 
    currentLanguage = d1.getId();
    if(currentLanguage>-1) {currentLanguage-=1;}
    d1.setId(currentLanguage);
    d1.setMousePressed(true);
    println(currentLanguage);
  }
}

//void mouseReleased() {
// if(d1.isOpen()) {
//   d1.setOpen(false);  
// }
//}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("$ty$tm$td_$tH$tM$tS", now);
}

void message(boolean loading, String country) {
  if(loading) {
   message = "loading..."; 
  } else {
   message = country;
  }
}

void changeLanguage(String language){
  message(true,"");
  String[] lines = loadStrings("data/csv/live_"+language+".csv");
  for (int i = 0; i < lines.length; i++) {
    // do something with each line:
    String[] words = split(lines[i], ',');
    float x = map(float(words[2]),-180,180,0,width);
    float y = map(float(words[1]),90,-90,0,height);
//    drawSphere(x,y);
  //  println(words[0]);
    fill(0);
    ellipse(x, y, pointSize, pointSize); 
//    rect(x,y,pointSize,pointSize);
  }
  message(false,language);
}

void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
//  ddl.setBackgroundColor(color(255,255,255,0));
  ddl.setItemHeight(18);
  ddl.setBarHeight(25);
  ddl.captionLabel().set("Select Language");
  ddl.captionLabel().style().marginTop = 8;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
  for (int i=0;i<lang.length;i++) {
    ddl.setColorLabel(color(map(i,0,lang.length,0,255),map(i,0,lang.length,0,255),map(i,0,lang.length,0,255)));
    ddl.addItem(lang[i],i);
  }
  ddl.scroll(0);
  ddl.setColorBackground(color(0,0,0,15));
  ddl.setColorActive(color(100, 0, 0, 100));
  ddl.setColorForeground(color(150, 0, 0,50));
  ddl.setColorLabel(color(255, 50, 50));
}

void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    int theIndex = int(theEvent.getGroup().getValue());
    language = lang[theIndex];
    doLoop = true;
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}

float PI = 3.14159265359;
float TWOPI = 6.28318530718;
float DE2RA = 0.01745329252;
float RA2DE = 57.2957795129;
float FLATTENING = 1.0/298.26;
float PIOVER2 = 1.570796326795;
int detail = 99999;
float radius = 100.0;

void drawSphere(float col, float row)
{
  pushMatrix();
  translate(width/2,height/2);

  fill(100,200,200,100);
  int NumLatitudes = detail;
  int NumLongitudes = detail;
  
  float start_lat = -90;
  float start_lon = 0.0;
  float R = radius;

  float lat_incr = 180.0 / NumLatitudes;
  float lon_incr = 360.0 / NumLongitudes;

  float phi1 = (start_lon + col * lon_incr) * DE2RA;
  float phi2 = (start_lon + (col + 1) * lon_incr) * DE2RA;

  float theta1 = (start_lat + row * lat_incr) * DE2RA;
  float theta2 = (start_lat + (row + 1) * lat_incr) * DE2RA;
    
  float[] u = new float[3];  
  u[0] = R * cos(phi1) * cos(theta1);    //x
  u[1] = R * sin(theta1);        //y
  u[2] = R * sin(phi1) * cos(theta1);    //z
  
  float[] v = new float[3];  
  v[0] = R * cos(phi1) * cos(theta2);    //x
  v[1] = R * sin(theta2);        //y
  v[2] = R * sin(phi1) * cos(theta2);    //z
  
  float[] w = new float[3];  
  w[0] = R * cos(phi2) * cos(theta2);    //x
  w[1] = R * sin(theta2);        //y
  w[2] = R * sin(phi2) * cos(theta2);    //z
  
  point(u[0],u[1],u[2]);

  popMatrix();
}
