import java.util.*;
import java.lang.Math;

static final float globalScale = 1; //Works best for scale factor between 0.7 and 1.25

static final float cardWidth = globalScale * 100;
static final float cardHeight = 1.5*cardWidth;

PImage heart;
PImage diamond;
PImage spade;
PImage club;

void setup() {
  size(1920, 950);
  frameRate(100);

  heart = loadImage("heart.png");
  diamond = loadImage("diamond.png");
  spade = loadImage("spade.png");
  club = loadImage("club.png");
}

void draw() {
  background(150, 200, 50);
  int initialX = 30;
  int initialY = 25;
  for (int i=0; i<4; i++) {
    for (int j=0; j<14; j++) {
      Card c = new Card(i, j, initialX, initialY);
      c.drawCard();
      initialX += (globalScale*cardWidth)+3;
    }
    initialY += (globalScale*cardHeight)+3;
    initialX = 30;
  }
}

public class Card {
  private int suit; //0=heart, 1=diamond, 2=spade, 3=club
  private int value; //0=Ace, 1-10 = 1-10, 11=J, 12=Q, 13=K
  private int xCoord; //x Coordinate (top left corner)
  private int yCoord; //y Coordinate (top left corner)
  private float scale; //variable to change the size of the card
  private String stringValue; //String representation of the value

  public Card(int st, int val, int x, int y) {
    suit=st%4;
    value=val%14;
    xCoord = x;
    yCoord = y;
    scale = globalScale;
    if (value==0) {
      stringValue = "A";
    } else if (value==11) {
      stringValue = "J";
    } else if (value==12) {
      stringValue = "Q";
    } else if (value==13) {
      stringValue = "K";
    } else {
      stringValue = ""+value;
    }
  }

  //Get methods
  public int getSuit() {
    return suit;
  }
  public int getValue() {
    return value;
  }
  public int getX() {
    return xCoord;
  }
  public int getY() {
    return yCoord;
  }
  public float getScale() {
    return scale;
  }

  //Set methods
  public void setSuit(int st) {
    suit = st;
  }
  public void setValue(int val) {
    value = val;
  }
  public void setX(int x) {
    xCoord = x;
  }
  public void setY(int y) {
    yCoord = y;
  }
  public void setScale(float scl) {
    scale = scl;
  }

  public void drawCard() {
    fill(230);
    stroke(0);
    rect(xCoord, yCoord, cardWidth*scale, cardHeight*scale, 6);
    if (this.suit==0) {
      //heart
      imageMode(CORNER);
      image(heart, this.xCoord, this.yCoord-6);
      if (this.scale<1) {
        heart.resize(0, 35);
      } else {
        heart.resize(0, 60);
      }

      textSize(32);
      fill(255, 0, 0);
      if (this.value==10) {
        text(this.stringValue, this.xCoord-17+(this.scale*cardWidth/2), this.yCoord+10+(this.scale*cardHeight/2));
      } else if (this.value==11) {
        text(this.stringValue, this.xCoord-3+(this.scale*cardWidth/2), this.yCoord+10+(this.scale*cardHeight/2));
      } else {
        text(this.stringValue, this.xCoord-10+(this.scale*cardWidth/2), this.yCoord+10+(this.scale*cardHeight/2));
      }
    } else if (this.suit==1) {
      //diamond
      imageMode(CORNER);
      image(diamond, this.xCoord, this.yCoord-6);
      if (this.scale<1) {
        diamond.resize(0, 35);
      } else {
        diamond.resize(0, 60);
      }

      textSize(32);
      fill(255, 0, 0);
      if (this.value==10) {
        text(this.stringValue, this.xCoord-17+(this.scale*cardWidth/2), this.yCoord+10+(this.scale*cardHeight/2));
      } else if (this.value==11) {
        text(this.stringValue, this.xCoord-3+(this.scale*cardWidth/2), this.yCoord+10+(this.scale*cardHeight/2));
      } else {
        text(this.stringValue, this.xCoord-10+(this.scale*cardWidth/2), this.yCoord+10+(this.scale*cardHeight/2));
      }
    } else if (this.suit==2) {
      //spade
      imageMode(CORNER);
      image(spade, this.xCoord, this.yCoord-6);
      if (this.scale<1) {
        spade.resize(0, 35);
      } else {
        spade.resize(0, 60);
      }

      textSize(32);
      fill(0);
      if (this.value==10) {
        text(this.stringValue, this.xCoord-17+(this.scale*cardWidth/2), this.yCoord+10+(this.scale*cardHeight/2));
      } else if (this.value==11) {
        text(this.stringValue, this.xCoord-3+(this.scale*cardWidth/2), this.yCoord+10+(this.scale*cardHeight/2));
      } else {
        text(this.stringValue, this.xCoord-10+(this.scale*cardWidth/2), this.yCoord+10+(this.scale*cardHeight/2));
      }
    } else {
      //club
      imageMode(CORNER);
      image(club, this.xCoord, this.yCoord-6);
      if (this.scale<1) {
        club.resize(0, 35);
      } else {
        club.resize(0, 60);
      }

      textSize(32);
      fill(0);
      if (this.value==10) {
        text(this.stringValue, this.xCoord-17+(this.scale*cardWidth/2), this.yCoord+10+(this.scale*cardHeight/2));
      } else if (this.value==11) {
        text(this.stringValue, this.xCoord-3+(this.scale*cardWidth/2), this.yCoord+10+(this.scale*cardHeight/2));
      } else {
        text(this.stringValue, this.xCoord-10+(this.scale*cardWidth/2), this.yCoord+10+(this.scale*cardHeight/2));
      }
    }
  }
}
