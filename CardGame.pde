import java.util.*;
import java.lang.Math;

Random rng = new Random();

static final float cardWidth = 100;
static final float cardHeight = 1.5*cardWidth;

PImage heart;
PImage diamond;
PImage spade;
PImage club;
PImage cardBack;

Deck deck = new Deck();
BlackJack game = new BlackJack();

void setup() {
  size(1920, 950);
  frameRate(100);

  heart = loadImage("heart.png");
  diamond = loadImage("diamond.png");
  spade = loadImage("spade.png");
  club = loadImage("club.png");
  cardBack = loadImage("cardBack.png");


  //deck.shuffleDeck();
}

void draw() {
  background(150, 200, 50);

  game.drawGame();
  //game.getDeck().displayDeck();
}

void mouseClicked(){
  game.hitButtonPressed(mouseX,mouseY);
}




/* ************ NODE CLASS ************ */
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

  public void changeNext(Node n) {
    this.next = n;
  }

  public void removeFromList() {
    this.data=null;
    this.next=null;
  }

  public boolean hasNext() {
    return next!=null;
  }
}
/* ************ END NODE CLASS ************ */

/* ************ DECK CLASS ************ */
public class Deck {
  private Node head; //Linked List of Cards
  private Node curr;
  private int len;

  public Deck() {
    head = new Node(null);
    curr = head;
    len = 0;
    for (int suit=0; suit<4; suit++) {
      for (int value=0; value<13; value++) {
        Card c = new Card(suit, value, 0, 0);
        curr.addNext(c);
        curr = curr.getNext();
        len++;
      }
    }
  }

  public Node getHead() {
    return this.head;
  }
  
  public int getLength(){
     return this.len; 
  }

  public void shuffleDeck() {
    Card[] tempList = new Card[len];
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

  public Card takeCard() {
    //Draw a card from the top of the deck (removing it), and return that card
    if (this.head.hasNext()) {
      Card c = this.head.getNext().getData();
      this.head.changeNext(this.head.getNext().getNext());
      len--;
      return c;
    } else {
      System.out.println("Deck is empty");
      return null;
    }
  }

  public void displayDeck() {
    Node index = head.getNext();
    int count = 0;
    float initialX = 30;
    float initialY = 30;
    for (int i=0; i<len; i++) {
      Card c = index.getData();
      c.setX(initialX);
      c.setY(initialY);
      c.drawCard();
      initialX += cardWidth+3;
      count++;
      if (count==13) {
        initialX=30;
        initialY+=cardHeight+3;
        count = 0;
      }

      index = index.getNext();
    }
  }
}
/* ************ END DECK CLASS ************ */

/* ************ BLACKJACKHAND CLASS ************ */
public class BlackJackHand {
  private Node head;
  private Node tail;
  private int sum;
  private boolean hasAce;

  public BlackJackHand() {
    head = new Node(null);
    tail = head;
    sum = 0;
    hasAce = false;
  }

  public void addCard(Card c) {
    this.tail.addNext(c);
    this.tail=this.tail.getNext();
    if (c.getValue()==1) {
      this.hasAce = true;
    }
  }

  public void incrementSum(Card c) {
    if ((c.getValue()<=10)&&(c.getValue()>1)) {
      // Number card (2-10)
      sum += c.getValue();
      return;
    } else if (c.getValue()==11 || c.getValue()==12 || c.getValue()==13) {
      // Jack, Queen, or King
      sum += 10;
      return;
    } else {
      // Ace
      sum += 11;
      return;
    }
  }

  public boolean checkBust() {
    if (sum>21) {
      if (this.hasAce) {
        sum -= 10;
        if (sum>21) {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  public void displayHand(float xVal, float yVal) {
    Node curr = head;
    while (curr.hasNext()) {
      curr=curr.getNext();
      Card c = curr.getData();
      c.setX(xVal);
      c.setY(yVal);
      xVal += cardWidth+3;
      c.drawCard();
    }
  }
}
/* ************ END BLACKJACKHAND CLASS ************ */

/* ************ BLACKJACK CLASS ************ */
public class BlackJack {
  private Deck deck;
  private BlackJackHand playerHand;
  private BlackJackHand dealerHand;

  public BlackJack() {
    deck = new Deck();
    deck.shuffleDeck();

    playerHand = new BlackJackHand();
    dealerHand = new BlackJackHand();

    for (int i=0; i<4; i++) {
      Card c = deck.takeCard();
      if (i%2==0) {
        c.setFaceDown(false);
        playerHand.addCard(c);
      } else {
        if (i==1) {
          c.setFaceDown(false);
        }
        dealerHand.addCard(c);
      }
    }
  }

  public Deck getDeck() {
    return this.deck;
  }
  public BlackJackHand getPlayerHand() {
    return this.playerHand;
  }
  public BlackJackHand getDealerHand() {
    return this.dealerHand;
  }

  public void drawGame() {
    //Display player and dealer hands
    this.playerHand.displayHand(100,100);
    this.dealerHand.displayHand(1500,100);
    
    fill(#D7CCAF);
    rect(100,cardHeight+105,cardWidth,cardHeight/2,3);
    rect(cardWidth+103,cardHeight+105,cardWidth,cardHeight/2,3);
    fill(#D2092B);
    textSize(30);
    text("Hit",127,cardHeight+154);
    text("Stand",211,cardHeight+154);
  }
  
  public void hitButtonPressed(int x, int y){
    if((x>=100)&&(x<100+cardWidth)){
       if((y>=cardHeight+105)&&(y<=105+((3*cardHeight/2)))){
         if(this.deck.getLength()>1){
           Card c = this.deck.takeCard();
           c.setFaceDown(false);
           playerHand.addCard(c);
         }else{
            System.out.println("Deck is empty"); 
         }
       }
    }
  }
}
/* ************ END BLACKJACK CLASS ************ */

/* ************ CARD CLASS ************ */
public class Card {
  private int suit; //0=heart, 1=diamond, 2=spade, 3=club
  private int value; //1=Ace, 2-10 = 1-10, 11=J, 12=Q, 13=K
  private float xCoord; //x Coordinate (top left corner)
  private float yCoord; //y Coordinate (top left corner)
  private String stringValue; //String representation of the value
  private boolean faceDown;

  public Card(int st, int val, float x, float y) {
    suit=st%4;
    value=(val%13)+1;
    xCoord = x;
    yCoord = y;
    faceDown = true;
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

  public boolean getFaceDown() {
    return faceDown;
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
  public void setFaceDown(boolean b) {
    faceDown=b;
  }

  public void drawCard() {
    fill(230);
    stroke(0);
    rect(xCoord, yCoord, cardWidth, cardHeight, 6);
    if (faceDown) {
      imageMode(CENTER);
      cardBack.resize((int)cardWidth*2, 0);
      image(cardBack, this.xCoord+(cardWidth/2), this.yCoord+(cardHeight/2));
    } else {
      if (this.suit==0) {
        //heart
        imageMode(CORNER);
        heart.resize(0, 60);

        image(heart, this.xCoord, this.yCoord-6);

        textSize(32);
        fill(255, 0, 0);
        if (this.value==10) {
          text(this.stringValue, this.xCoord-17+(cardWidth/2), this.yCoord+10+(cardHeight/2));
        } else if (this.value==11) {
          text(this.stringValue, this.xCoord-3+(cardWidth/2), this.yCoord+10+(cardHeight/2));
        } else {
          text(this.stringValue, this.xCoord-10+(cardWidth/2), this.yCoord+10+(cardHeight/2));
        }
      } else if (this.suit==1) {
        //diamond
        imageMode(CORNER);

        diamond.resize(0, 60);

        image(diamond, this.xCoord, this.yCoord-6);

        textSize(32);
        fill(255, 0, 0);
        if (this.value==10) {
          text(this.stringValue, this.xCoord-17+(cardWidth/2), this.yCoord+10+cardHeight/2);
        } else if (this.value==11) {
          text(this.stringValue, this.xCoord-3+(cardWidth/2), this.yCoord+10+(cardHeight/2));
        } else {
          text(this.stringValue, this.xCoord-10+(cardWidth/2), this.yCoord+10+(cardHeight/2));
        }
      } else if (this.suit==2) {
        //spade
        imageMode(CORNER);

        spade.resize(0, 60);

        image(spade, this.xCoord, this.yCoord-6);

        textSize(32);
        fill(0);
        if (this.value==10) {
          text(this.stringValue, this.xCoord-17+(cardWidth/2), this.yCoord+10+(cardHeight/2));
        } else if (this.value==11) {
          text(this.stringValue, this.xCoord-3+(cardWidth/2), this.yCoord+10+(cardHeight/2));
        } else {
          text(this.stringValue, this.xCoord-10+(cardWidth/2), this.yCoord+10+(cardHeight/2));
        }
      } else {
        //club
        imageMode(CORNER);

        club.resize(0, 60);

        image(club, this.xCoord, this.yCoord-6);

        textSize(32);
        fill(0);
        if (this.value==10) {
          text(this.stringValue, this.xCoord-17+(cardWidth/2), this.yCoord+10+(cardHeight/2));
        } else if (this.value==11) {
          text(this.stringValue, this.xCoord-3+(cardWidth/2), this.yCoord+10+(cardHeight/2));
        } else {
          text(this.stringValue, this.xCoord-10+(cardWidth/2), this.yCoord+10+(cardHeight/2));
        }
      }
    }
  }
}
/* ************ END CARD CLASS ************ */
