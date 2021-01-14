import java.util.*;
import java.lang.Math;

Random rng = new Random();

// Set width of the cards
// Card height is fixed proportionally to width
static final float cardWidth = 100;
static final float cardHeight = 1.5*cardWidth;

// Prepare to load the images for all 4 suits and card backs
PImage heart;
PImage diamond;
PImage spade;
PImage club;
PImage cardBack;

// Create a new game of BlackJack
BlackJack game = new BlackJack(3);

void setup() {
  size(1920, 950);
  frameRate(100);

  // Load the images for all 4 suits and card backs
  heart = loadImage("heart.png");
  diamond = loadImage("diamond.png");
  spade = loadImage("spade.png");
  club = loadImage("club.png");
  cardBack = loadImage("cardBack.png");
}

void draw() {
  // Set the background color
  background(150, 200, 50);

  // Run the current game
  game.drawGame();
}

void mouseClicked() {
  // Check if the hit button was pressed for the current player
  game.gameHitButtonPressed(mouseX, mouseY);
  // Check if the stand button was pressed for the current player 
  game.nextPlayer(mouseX, mouseY);
}




/* ************ NODE CLASS ************ */
// Class for Nodes that will make up a linked list (Deck of cards)
public class Node {
  private Card data; // The data value fo the node will be a card
  private Node next; // Next node in the linked list (null if current node is the last node)

  public Node(Card d) {
    // Constructor for the Node class
    data = d;
    next = null;
  }
  
  // Get methods
  public Card getData() {
    return this.data;
  }
  public Node getNext() {
    return this.next;
  }
  
  // When traversing the linked list, check to see if there are any cards left
  public boolean hasNext() {
    return next!=null;
  }

  // addNext() used to add a Node to the end of the list (extend the linked list)
  public void addNext(Card n) {
    this.next = new Node(n);
  }

  // changeNext() primarily used to remove a card from the deck/linked list
  public void changeNext(Node n) {
    this.next = n;
  }

  // Remove any references to cards in the deck or other nodes in the linked list
  public void removeFromList() {
    this.data=null;
    this.next=null;
  }
}
/* ************ END NODE CLASS ************ */

/* ************ DECK CLASS ************ */
public class Deck { //Linked List of Cards
  private Node head; // Head node used as a reference (no data value)
  private Node curr; // Indexing Node used to traverse through the linked list
  private int len; // Length of the linked list (not counting the head node)

  public Deck() { // Constructor for the deck of cards
    head = new Node(null);
    curr = head;
    len = 0;
    // Create new cards and add them to the deck
    for (int suit=0; suit<4; suit++) { // 4 suits
      for (int value=0; value<13; value++) { // 13 values per suit
        Card c = new Card(suit, value, 0, 0);
        curr.addNext(c); // Add a new node with the newly created card
        curr = curr.getNext(); // Indexing node set to the newly created node
        len++; // Since a card(node) was added, increment the length by 1
      }
    }
  }

  public Deck(int multipleDecks) { // Similiar constructor as above, but with a custom number of decks (not just 1 single deck)
    head = new Node(null);
    curr = head;
    len = 0;
    if(multipleDecks<1){multipleDecks=1;} //Number of decks cannot be negative or zero (need at least 1 deck)
    
    for (int i=0; i<multipleDecks; i++) { // Create a custom amount of decks combined as one big deck of cards
      for (int suit=0; suit<4; suit++) { // 4 suits
        for (int value=0; value<13; value++) { // 13 values per suit
          Card c = new Card(suit, value, 0, 0);
          curr.addNext(c); // Add a new node with the newly created card
          curr = curr.getNext(); // Indexing node set to the newly created node
          len++; // Since a card(Node) was added, increment the length by 1
        }
      }
    }
  }

  // Get methods
  public Node getHead() {
    return this.head;
  }

  public int getLength() {
    return this.len;
  }

  // Custom made shuffle method to shuffle the deck of cards
  public void shuffleDeck() {
    Card[] tempList = new Card[len]; // Create a temporary array of cards to hold cards as they are removed from the deck
    int tempIndex = 0; // Index for the temporary array created above
    for (int i=len; i>0; i--) { // Iterate through the deck, picking random numbers from 1 to len inclusive
      int rand = rng.nextInt(i)+1; // Get a random index
      if (head.hasNext()) { // Precautionary check to make sure there are still cards in the deck (this should always be true)
        // Keep track of 2 nodes, the node we want to remove, and the node that comes before it
        Node before = head; 
        Node temp = head.getNext();
        for (int count=1; count<rand; count++) { // For loop to traverse the linked list until we have reached the randomly selected index
          before = temp;
          temp = temp.getNext();
        }
        tempList[tempIndex] = temp.getData(); // Now that there is a reference to our randomly selected card, add the card to the temp array at the temp index
        tempIndex++; // Increment the index of the temp array
        before.next = temp.getNext(); // Change the next node of the previous node to the next node (effectively skipping the node we want to remove)
        temp.removeFromList(); // The linked list is still intact, go ahead and remove the randomly chosen node from the linked list
      }
    }
    // Re initialize the deck with the "shuffled" tempList of Cards
    Node current = head; // Use a index node, initialize it at the head node of the linked list
    for (int i=0; i<tempList.length; i++) { // Iterate through the temp array
      current.addNext(tempList[i]); // Add the current element to the end of the linked list/deck
      current = current.getNext(); // Update index node to the newly created node
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
      text("Score:"+this.getSum(), this.xCoord, this.yCoord+cardHeight+(40*cardWidth/100)+(cardHeight/2));
    } else {
      //Dealer hand
      fill(#D2092B);
      textSize(30*(cardWidth/100));
      text("Score:"+this.getSum(), this.xCoord, this.yCoord+cardHeight+(40*cardWidth/100));
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
      tempY += ((3/2)*cardHeight)+(150*(cardWidth/100));
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
        if((cardWidth/100)>=1){
          heart.resize(0, 60);
        }else{
           heart.resize(0,30); 
        }
        

        image(heart, this.xCoord, this.yCoord-6);

        textSize(32*cardWidth/100);
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

        if((cardWidth/100)>=1){
          diamond.resize(0, 60);
        }else{
           diamond.resize(0,30); 
        }

        image(diamond, this.xCoord, this.yCoord-6);

        textSize(32*cardWidth/100);
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

        if((cardWidth/100)>=1){
          spade.resize(0, 60);
        }else{
           spade.resize(0,30); 
        }

        image(spade, this.xCoord, this.yCoord-6);

        textSize(32*cardWidth/100);
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

        if((cardWidth/100)>=1){
          club.resize(0, 60);
        }else{
           club.resize(0,30); 
        }

        image(club, this.xCoord, this.yCoord-6);

        textSize(32*cardWidth/100);
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
