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

BlackJack game = new BlackJack(3);

void setup() {
  size(1920, 950);
  frameRate(100);

  heart = loadImage("heart.png");
  diamond = loadImage("diamond.png");
  spade = loadImage("spade.png");
  club = loadImage("club.png");
  cardBack = loadImage("cardBack.png");
}

void draw() {
  background(150, 200, 50);

  game.drawGame();
}

void mouseClicked() {
  game.gameHitButtonPressed(mouseX, mouseY);
  game.nextPlayer(mouseX, mouseY);
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

  public Deck(int multipleDecks) {
    head = new Node(null);
    curr = head;
    len = 0;
    for (int i=0; i<multipleDecks; i++) {
      for (int suit=0; suit<4; suit++) {
        for (int value=0; value<13; value++) {
          Card c = new Card(suit, value, 0, 0);
          c.setFaceDown(false);
          curr.addNext(c);
          curr = curr.getNext();
          len++;
        }
      }
    }
  }

  public Node getHead() {
    return this.head;
  }

  public int getLength() {
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
  private int aceCount;
  private float xCoord; //Coordinates to be able to replicate multiple hands
  private float yCoord; //Multiple hands == multiple players
  private boolean dealer; //Special case for one hand which is designated as the dealer
  private boolean bust; //if sum>21 then player busted (bust=true)

  public BlackJackHand(float x, float y, boolean deal) {
    head = new Node(null);
    tail = head;
    sum = 0;
    aceCount = 0;
    xCoord = x;
    yCoord = y;
    dealer = deal;
    bust=false;
  }

  public void addCard(Card c) {
    this.tail.addNext(c);
    this.tail=this.tail.getNext();
    if (c.getValue()==1) {
      this.aceCount++;
    }
  }

  public Node getHead() {
    return this.head;
  }

  public int getSum() {
    return this.sum;
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

  public void checkBust() {
    if (sum>21) {
      if (this.aceCount>0) {
        sum -= 10;
        aceCount--;
        if (sum>21) {
          this.bust = true;
        }
      } else {
        this.bust = true;
      }
    } else {
      this.bust = false;
    }
  }

  public Deck hitButtonPressed(Deck deck, int x, int y) {
    if (!this.bust) {
      if ((x>=this.xCoord)&&(x<this.xCoord+cardWidth)) {
        if ((y>=cardHeight+this.yCoord+5)&&(y<=this.yCoord+5+((3*cardHeight/2)))) {
          if (deck.getLength()>1) {
            Card c = deck.takeCard();
            c.setFaceDown(false);
            this.addCard(c);
            this.incrementSum(c);
            this.checkBust();

            if (this.bust) {
              System.out.println("Bust!");
            }
          } else {
            System.out.println("Deck is empty");
          }
        }
      }
    }
    return deck;
  }

  public int standButtonPressed(int playerTurn, int x, int y) {
    if ((x>=this.xCoord+cardWidth+3)&&(x<this.xCoord+(2*cardWidth)+3)) {
      if ((y>=cardHeight+this.yCoord+5)&&(y<=this.yCoord+5+((3*cardHeight/2)))) {
        playerTurn++;
      }
    }
    return playerTurn;
  }

  public void displayHand() {
    float tempX = this.xCoord;
    float tempY = this.yCoord;
    Node curr = head;
    while (curr.hasNext()) {
      curr=curr.getNext();
      Card c = curr.getData();
      c.setX(tempX);
      c.setY(tempY);
      tempX += cardWidth+3;
      c.drawCard();
    }
    textSize(32);
    fill(#D2092B);

    // Hit&Stand buttons for each player
    if (!this.dealer) {
      fill(#D7CCAF);
      rect(this.xCoord, cardHeight+this.yCoord+5, cardWidth, cardHeight/2, 3);
      rect(this.xCoord+cardWidth+3, cardHeight+this.yCoord+5, cardWidth, cardHeight/2, 3);
      fill(#D2092B);
      textSize(30*(cardWidth/100));
      text("Hit", this.xCoord+(29*cardWidth/100), this.yCoord+cardHeight+(53*cardWidth/100));
      text("Stand", this.xCoord+cardWidth+(13*cardWidth/100), this.yCoord+cardHeight+(53*cardWidth/100));
      text("Score:"+this.getSum(), this.xCoord, this.yCoord+cardHeight+40+(cardHeight/2));
    } else {
      //Dealer hand
      fill(#D2092B);
      textSize(30*(cardWidth/100));
      text("Score:"+this.getSum(), this.xCoord, this.yCoord+cardHeight+40);
    }
  }
}
/* ************ END BLACKJACKHAND CLASS ************ */

/* ************ BLACKJACK CLASS ************ */
public class BlackJack {
  private Deck deck;
  private int numPlayers; //Number of players **NOT** counting the dealer
  private int playerTurn;
  private BlackJackHand[] playerHands;

  public BlackJack(int players) {
    deck = new Deck();
    deck.shuffleDeck();

    numPlayers = players;
    playerTurn = 0;

    playerHands = new BlackJackHand[numPlayers+1];

    int tempY = 50;
    for (int i=0; i<numPlayers; i++) {
      playerHands[i] = new BlackJackHand(100, tempY, false);
      tempY += ((3/2)*cardHeight)+150;
    }

    playerHands[numPlayers] = new BlackJackHand(1300, 50, true);

    for (int i=0; i<2*playerHands.length; i++) {
      Card c = deck.takeCard();
      if (i%(playerHands.length)==numPlayers) {
        // Card goes to the dealer
        this.playerHands[numPlayers].addCard(c);
      } else {
        // Card goes to next player in rotation
        c.setFaceDown(false);
        playerHands[i%playerHands.length].addCard(c);
        playerHands[i%playerHands.length].incrementSum(c);
        playerHands[i%playerHands.length].checkBust();
      }
    }
    this.playerHands[numPlayers].getHead().getNext().getData().setFaceDown(false);
    this.playerHands[numPlayers].incrementSum(this.playerHands[numPlayers].getHead().getNext().getData());
  }

  public Deck getDeck() {
    return this.deck;
  }
  public BlackJackHand[] getPlayerHands() {
    return this.playerHands;
  }
  public BlackJackHand getDealerHand() {
    return this.playerHands[numPlayers];
  }

  public void drawGame() {
    //Display players and dealer hands
    for (BlackJackHand player : playerHands) {
      player.displayHand();
    }
  }

  public void gameHitButtonPressed(int x, int y) {
    this.deck = playerHands[playerTurn%numPlayers].hitButtonPressed(this.deck, x, y);
  }

  public void nextPlayer(int x, int y) {
    this.playerTurn = this.playerHands[playerTurn].standButtonPressed(playerTurn, x, y);
    if (playerTurn==numPlayers) {
      BlackJackHand dealer = playerHands[numPlayers];
      Node curr = dealer.getHead().getNext();
      while (curr.hasNext()) {
        curr = curr.getNext();
        curr.getData().setFaceDown(false);
        dealer.incrementSum(curr.getData());
        dealer.checkBust();
      }
      while (playerHands[numPlayers].getSum()<17) {
        Card c = this.deck.takeCard();
        c.setFaceDown(false);
        dealer.addCard(c);
        dealer.incrementSum(c);
        dealer.checkBust();
      }
      playerTurn = 0;
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
