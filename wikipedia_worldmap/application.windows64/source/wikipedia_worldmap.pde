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
String languageA = "es";
String languageB = "ca";
String[] lang = {"ar","bg","ca","cs","da","de","en","eo","es","fa","fi","fr","gl","he","hu","id","it","ja","ko","lt","ms","nl","nn","no","pl","pt","ro","ru","sk","sl","sr","sv","tr","uk","vi","vo","war","zh"};
String[] lang_label = {
  "ar Arabic",
  "bg Bulgarian",
  "ca Catalan",
  "cs Czech",
  "da Danish",
  "de German",
  "en English",
  "eo Esperanto",
  "es Spanish",
  "fa Farsi",
  "fi_Finnish",
  "fr French",
  "gl Galician",
  "he Hebrew",
  "hu Hungarian",
  "id Indonesian",
  "it Italian",
  "ja Japanese",
  "ko Korean",
  "lt Lithuanian",
  "ms Malay",
  "nl Dutch",
  "nn Nyorsk",
  "no Norwegian",
  "pl Polish",
  "pt Portugese",
  "ro Romanian",
  "ru Russian",
  "sk Slovak",
  "sl Slovenian",
  "sr Serbian",
  "sv Swedish",
  "tr Turkish",
  "uk Ukrainian",
  "vi Vietnamese",
  "vo Volapük",
  "war Waray",
  "zh Chinese Simplified"
};
String message; 
boolean doLoop = true;
float rootPointSize = 7; // 0.5
float pointSize = rootPointSize;
color mapcolorA, mapcolorB;
float rootMapOpacity = 1.0;
float mapOpacity = rootMapOpacity;
color colorA, colorB;
int colorA_h, colorA_s, colorA_b, colorB_h, colorB_s, colorB_b;


void setup() {
  colorMode(HSB, 360, 100, 100, 100);
  size(displayWidth, displayHeight,P3D);
  blendMode(BLEND);
//  noCursor();
  smooth();
  startMillis = System.currentTimeMillis();
  println((System.currentTimeMillis() - startMillis) + " ms to loadStrings");
  
  colorA_h = 175;
  colorA_s = 100;
  colorA_b = 100;
  colorA = color(colorA_h, colorA_s, colorA_b); // cyan  
  
  colorB_h = 300;
  colorB_s = 100;
  colorB_b = 100;
  colorB = color(colorB_h, colorB_s, colorB_b); // magenta
  
  
  cp5 = new ControlP5(this);
  // create a DropdownList
  d1 = cp5.addDropdownList("languageListA")
          .setPosition(25, 50)
          .setHeight(height-100);
          ;
          
  customize(d1); // customize the first list
  
  d2 = cp5.addDropdownList("languageListB")
          .setPosition(125, 50)
          .setHeight(height-100);
          ;
          
  customize(d2); // customize the first list
  
  
  
}


void draw() {
  // this line will start pdf export, if the variable savePDF was set to true 
  if (savePDF) beginRecord(PDF, languageA + "+" + languageB + "_##.pdf");

  colorMode(HSB, 360, 100, 100);
  rectMode(CENTER); 
  noStroke();
  if(doLoop){
    background(0,0,100);
    changeLanguageA(languageA);
    changeLanguageB(languageB);
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
  if (key=='s' || key=='S') saveFrame(languageA + "+" + languageB + "_##.jpg");
  if (key=='p' || key=='P') {doLoop = true; savePDF = true; pointSize = 0.001;}
  if (keyCode == LEFT) { // comma
    if (mapOpacity >= rootMapOpacity+10) {
      mapOpacity -= 10;  
      doLoop = true;
    }
  }
  if (keyCode == RIGHT) { // period
    if (mapOpacity >= rootMapOpacity+mapOpacity) {
      mapOpacity += 10;  
      doLoop = true;
    }
    
  }
  if (key==']') { 
    pointSize += 2.0;
    doLoop = true;
  }
  if (key=='[') {
    if(pointSize >= 2.5){
      pointSize -= 2.0;  
    } else {
      pointSize = rootPointSize; 
    }
    doLoop = true;
  }
  if (key=='0') {
    pointSize = rootPointSize;
    doLoop = true;
  }
}

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

void changeLanguageA(String language){
  message(true,"");
  String[] lines = loadStrings("data/csv/live_"+language+".csv");
  for (int i = 0; i < lines.length; i++) {  
    // do something with each line:
    String[] words = split(lines[i], ',');
    float x = map(float(words[2]),-180,180,0,width);
    float y = map(float(words[1]),90,-90,0,height);
    fill(colorA, mapOpacity);
    ellipse(x, y, pointSize, pointSize); 
  }
  message(false,language);
}

void changeLanguageB(String language){
  message(true,"");
  String[] lines = loadStrings("data/csv/live_"+language+".csv");
  for (int i = 0; i < lines.length; i++) {  
    // do something with each line:
    String[] words = split(lines[i], ',');
    float x = map(float(words[2]),-180,180,0,width);
    float y = map(float(words[1]),90,-90,0,height);
    fill(colorB, mapOpacity);
    ellipse(x, y, pointSize, pointSize); 
  }
  message(false,language);
}

void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  
  if(ddl == d1)
  {
  //  ddl.setBackgroundColor(color(255,255,255,0));
    ddl.setItemHeight(18);
    ddl.setBarHeight(25);
    ddl.captionLabel().set("Select Language A");
    ddl.captionLabel().style().marginTop = 8;
    ddl.captionLabel().style().marginLeft = 3;
    ddl.valueLabel().style().marginTop = 3;
    for (int i=0;i<lang_label.length;i++) {
      ddl.addItem(lang_label[i],i);
    }
    ddl.scroll(0);
    ddl.setColorBackground(color(0,0,0,15));
    println(colorA_h + " " + colorA_s + " " + colorA_b + " " + "1");
    println(color(colorA_h, colorA_s, colorA_b, 1));
    ddl.setColorActive(color(colorA_h, colorA_s, colorA_b, 1));
    ddl.setColorForeground(color(colorA_h, colorA_s, colorA_b, 1));
    ddl.setColorLabel(color(colorA_h, colorA_s, colorA_b));
  }
  else if (ddl == d2)
  {
    ddl.setItemHeight(18);
    ddl.setBarHeight(25);
    ddl.captionLabel().set("Select Language B");
    ddl.captionLabel().style().marginTop = 8;
    ddl.captionLabel().style().marginLeft = 3;
    ddl.valueLabel().style().marginTop = 3;
    for (int i=0;i<lang_label.length;i++) {
      ddl.addItem(lang_label[i],i);
    }
    ddl.scroll(0);
    ddl.setColorBackground(color(0,0,0,15));
    ddl.setColorActive(color(colorB_h, colorB_s, colorB_b, 1));
    ddl.setColorForeground(color(colorB_h, colorB_s, colorB_b, 1));
    ddl.setColorLabel(color(colorB_h, colorB_s, colorB_b));
  }
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
    if(theEvent.getGroup() == d1) {
      int theIndex = int(theEvent.getGroup().getValue());
      languageA = lang[theIndex];
      doLoop = true;  
    } else if(theEvent.getGroup() == d2) {
      int theIndex = int(theEvent.getGroup().getValue());
      languageB = lang[theIndex];
      doLoop = true;
    }
    
    
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}


