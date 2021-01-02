import java.util.*;
import java.lang.Math;

static float cardWidth = 100;
static float cardHeight = 1.5*cardWidth;

PImage heart;
PImage diamond;
PImage spade;
PImage club;

void setup() {
  size(750, 750);
  frameRate(100);

  heart = loadImage("heart.png");
  club = loadImage("club.png");
}

void draw() {
  background(150, 200, 50);
  Card card = new Card(0, 0, 100, 100, 1);
  Card card1 = new Card(3, 0, 203, 100, 1);
  card.drawCard();  
  card1.drawCard();
}

public class Card {
  private int suit; //0=heart, 1=diamond, 2=spade, 3=club
  private int value; //0=Ace, 1-10 = 1-10, 11=J, 12=Q, 13=K
  private int xCoord; //x Coordinate (top left corner)
  private int yCoord; //y Coordinate (top left corner)
  private float scale; //variable to change the size of the card

  public Card(int st, int val, int x, int y, float scl) {
    suit=st;
    value=val;
    xCoord = x;
    yCoord = y;
    scale = scl;
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
      image(heart, this.xCoord, this.yCoord-3);
      heart.resize(0, 60);
    } else if (this.suit==1) {
      //diamond
    } else if (this.suit==2) {
      //spade
    } else {
      //club
      imageMode(CORNER);
      image(club, this.xCoord, this.yCoord-3);
      club.resize(0, 60);
    }
  }
}
