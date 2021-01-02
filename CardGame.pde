import java.util.*;
import java.lang.Math;

Random rng = new Random();

static final float globalScale = 1; //Works best for scale factor between 0.7 and 1.25

static final float cardWidth = globalScale * 100;
static final float cardHeight = 1.5*cardWidth;

PImage heart;
PImage diamond;
PImage spade;
PImage club;

Deck deck = new Deck();

void setup() {
  size(1920, 950);
  frameRate(100);

  heart = loadImage("heart.png");
  diamond = loadImage("diamond.png");
  spade = loadImage("spade.png");
  club = loadImage("club.png");

  deck.shuffleDeck();
}

void draw() {
  background(150, 200, 50);
  /*
   int initialX = 30;
   int initialY = 25;
   for (int i=0; i<4; i++) {
   for (int j=1; j<14; j++) {
   Card c = new Card(i, j, initialX, initialY);
   c.drawCard();
   initialX += (globalScale*cardWidth)+3;
   }
   initialY += (globalScale*cardHeight)+3;
   initialX = 30;
   }
   */

  deck.displayDeck();
}

public class Node {
  private Card data;
  private Node next;

  public Node(Card d) {
    data = d;
    next = null;
  }

  public Card getData() {
    return this.data;
  }
  public Node getNext() {
    return this.next;
  }

  public void addNext(Card n) {
    this.next = new Node(n);
  }

  public void removeFromList() {
    this.data=null;
    this.next=null;
  }

  public boolean hasNext() {
    return next!=null;
  }
}

public class Deck {
  private Node head; //Linked List of Cards
  private Node curr;
  private int len;

  public Deck() {
    head = new Node(null);
    curr = head;
    len = 0;
    for (int suit=0; suit<4; suit++) {
      for (int value=1; value<14; value++) {
        Card c = new Card(suit, value, 0, 0);
        curr.addNext(c);
        curr = curr.getNext();
        len++;
      }
    }
  }

  public void shuffleDeck() {
    Card[] tempList = new Card[52];
    int tempIndex = 0;
    for (int i=len; i>0; i--) {
      int rand = rng.nextInt(i)+1;
      if (head.hasNext()) {
        Node before = head;
        Node temp = head.getNext();
        for (int count=1; count<rand; count++) {
          before = temp;
          temp = temp.getNext();
        }
        tempList[tempIndex] = temp.getData();
        before.next = temp.getNext();
        temp.removeFromList();
        tempIndex++;
      }
    }
    //Re initialize the deck with the "shuffled" tempList of Cards
    Node current = head;
    for (int i=0; i<tempList.length; i++) {
      current.addNext(tempList[i]);
      current = current.getNext();
    }
  }

  public void displayDeck() {
    System.out.println(len);
    Node index = head.getNext();
    int count = 0;
    float initialX = 30;
    float initialY = 30;
    for (int i=0; i<len; i++) {
      Card c = index.getData();
      c.setX(initialX);
      c.setY(initialY);
      c.drawCard();
      initialX += (globalScale*cardWidth)+3;
      count++;
      if(count==13){
         initialX=30;
         initialY+=(globalScale*cardHeight)+3;
         count = 0;
      }
      index = index.getNext();
    }
  }
}

public class Card {
  private int suit; //0=heart, 1=diamond, 2=spade, 3=club
  private int value; //1=Ace, 2-10 = 1-10, 11=J, 12=Q, 13=K
  private float xCoord; //x Coordinate (top left corner)
  private float yCoord; //y Coordinate (top left corner)
  private float scale; //variable to change the size of the card
  private String stringValue; //String representation of the value

  public Card(int st, int val, int x, int y) {
    suit=st%4;
    value=val%14;
    xCoord = x;
    yCoord = y;
    scale = globalScale;
    if (value==1) {
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
  public float getX() {
    return xCoord;
  }
  public float getY() {
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
  public void setX(float x) {
    xCoord = x;
  }
  public void setY(float y) {
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
