class Ship {
  PImage image;
  String player;
  float xPosition;
  float yPosition;
  float direction;
  float speed;
  float turnSpeed;
  boolean shield;
  boolean forward;
  boolean left;
  boolean right;
  boolean beam;
  boolean leftRocket;
  boolean rightRocket;
  int hyperCooldown;
  int leftCooldown;
  int rightCooldown;
  int shieldEnergy;
  int frontHealth;
  int leftHealth;
  int rightHealth;
  int backHealth;
  ArrayList<ShipHitbox> hitboxes;
  Ship(PImage image, float xPosition, float yPosition, float direction, String player) {
    this.image = image;
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.direction = direction;
    this.player = player;
    hitboxes = new ArrayList<ShipHitbox>();
    hitboxes.add(new ShipHitbox("Front", 12));
    hitboxes.add(new ShipHitbox("Back", 12));
    hitboxes.add(new ShipHitbox("Left", 12));
    hitboxes.add(new ShipHitbox("Right", 12));
    speed = 3;
    turnSpeed = 0.03;
    forward = false;
    left = false;
    right = false;
    beam = false;
    leftRocket = false;
    rightRocket = false;
    hyperCooldown = 0;
    leftCooldown = 0;
    rightCooldown = 0;
    shield = false;
    shieldEnergy = 600;
    frontHealth = 800;
    leftHealth = 700;
    rightHealth = 700;
    backHealth = 600;
  }
  void fire() {
    if (hyperCooldown > 0 && frontHealth > 0) {
      hyperCooldown--;
    }
    if (leftCooldown > 0 && leftHealth > 0) {
      leftCooldown--;
    }
    if (rightCooldown > 0 && rightHealth > 0) {
      rightCooldown--;
    }
    if (beam == true && hyperCooldown == 0 && frontHealth > 0) {
      hyperCooldown = 120;
      if (player == "Player 1") {
        projectiles.add(new Projectile(beamSprite, xPosition, yPosition, 7, direction, 20, player2, 300));
      } else if (player == "Player 2") {
        projectiles.add(new Projectile(beamSprite, xPosition, yPosition, 7, direction, 20, player1, 300));
      }
    }
    if (leftRocket == true && leftCooldown == 0 && leftHealth > 0) {
      leftCooldown = 90;
      if (player == "Player 1") {
        for (float i=PI/16*5; i<=PI/16*11; i+=PI/16) {
          projectiles.add(new Projectile(missileSprite, xPosition, yPosition, 5, direction + PI + i, 10, player2, 100));
        }
      } else if (player == "Player 2") {
        for (float i=PI/16*5; i<=PI/16*11; i+=PI/16) {
          projectiles.add(new Projectile(missileSprite, xPosition, yPosition, 5, direction + PI + i, 10, player1, 100));
        }
      }
    }
    if (rightRocket == true && rightCooldown == 0 && rightHealth > 0) {
      rightCooldown = 90;
      if (player == "Player 1") {
        for (float i=PI/16*5; i<=PI/16*11; i+=PI/16) {
          projectiles.add(new Projectile(missileSprite, xPosition, yPosition, 7, direction + i, 10, player2, 100));
        }
      } else if (player == "Player 2") {
        for (float i=PI/16*5; i<=PI/16*11; i+=PI/16) {
          projectiles.add(new Projectile(missileSprite, xPosition, yPosition, 7, direction + i, 10, player1, 100));
        }
      }
    }
  }
  void shield() {
    if (shield == true && shieldEnergy >= 2) {
      shieldEnergy -= 2;
      if (shieldEnergy == 0) {
        shield = false;
      }
    } else if (shield == false && shieldEnergy < 600) {
      shieldEnergy += 1;
    }
  }
  void damage(int damage, String part) {
    if (shield == true) {
      if (damage <= shieldEnergy) {
        shieldEnergy -= damage;
      } else if (damage > shieldEnergy) {
        int leftover = damage - shieldEnergy;
        shieldEnergy = 0;
        if (part == "Front") {
          if (frontHealth < leftover) {
            frontHealth = 0;
          } else {
            frontHealth -= leftover;
          }
        } else if (part == "Left") {
          if (leftHealth < leftover) {
            leftHealth = 0;
          } else {
            leftHealth -= leftover;
          }
        } else if (part == "Right") {
          if (rightHealth < leftover) {
            rightHealth = 0;
          } else {
            rightHealth -= leftover;
          }
        } else if (part == "Back") {
          if (backHealth < leftover) {
            backHealth = 0;
          } else {
            backHealth -= leftover;
          }
        }
      }
    } else if (shield == false) {
      if (part == "Front") {
        if (frontHealth < damage) {
          frontHealth = 0;
        } else {
          frontHealth -= damage;
        }
      } else if (part == "Left") {
        if (leftHealth < damage) {
          leftHealth = 0;
        } else {
          leftHealth -= damage;
        }
      } else if (part == "Right") {
        if (rightHealth < damage) {
          rightHealth = 0;
        } else {
          rightHealth -= damage;
        }
      } else if (part == "Back") {
        if (backHealth < damage) {
          backHealth = 0;
        } else {
          backHealth -= damage;
        }
      }
    }
  }
  void move() {
    if (backHealth > 0) {
      if (forward) {
        xPosition += cos(direction)*speed;
        yPosition += sin(direction)*speed;
      }
      if (left) {
        if (direction < turnSpeed) {
          direction = direction+ 2*PI - turnSpeed;
        } else {
          direction -= turnSpeed;
        }
      }
      if (right) {
        direction = (direction+turnSpeed)%(2*PI);
      }
    }
    if(xPosition < 0){
      xPosition = 0;
    }
    else if(xPosition > width){
      xPosition = width;
    }
    if(yPosition < 0){
      yPosition = 0;
    }
    else if(yPosition > height){
      yPosition = height;
    }
    for (int i=0; i<hitboxes.size (); i++) {
      ShipHitbox a = hitboxes.get(i);
      if (a.type == "Front") {
        a.xPosition = xPosition + cos(direction)*18;
        a.yPosition = yPosition + sin(direction)*18;
      } else if (a.type == "Back") {
        a.xPosition = xPosition + cos(direction+PI)*18;
        a.yPosition = yPosition + sin(direction+PI)*18;
      } else if (a.type == "Right") {
        a.xPosition = xPosition + cos(direction+PI/2)*8;
        a.yPosition = yPosition + sin(direction+PI/2)*8;
      } else if (a.type == "Left") {
        a.xPosition = xPosition + cos(direction+PI*1.5)*8;
        a.yPosition = yPosition + sin(direction+PI*1.5)*8;
      }
    }
  }
  void display() {
    pushMatrix();
    translate(xPosition, yPosition);
    strokeWeight(2);
    stroke(192, 128);
    fill(0, 0);
    rotate(direction);
    image(image, 0, 0);
    if (shield == true && shieldEnergy > 0) {
      noStroke();
      fill(196, 196, 255, float(128)*(float(shieldEnergy)/600));
      ellipse(0, 0, 60, 60);
    }
    popMatrix();
  }
}

class ShipHitbox {
  float xPosition;
  float yPosition;
  String type;
  float radius;
  ShipHitbox(String type, float radius) {
    this.type = type;
    this.radius = radius;
  }
}

class Projectile {
  PImage image;
  float xPosition;
  float yPosition;
  float speed;
  float direction;
  float hitbox;
  Ship target;
  int damage;
  Projectile(PImage image, float xPosition, float yPosition, float speed, float direction, float hitbox, Ship target, int damage) {
    this.image = image;
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.speed = speed;
    this.direction = direction;
    this.hitbox = hitbox;
    this.target = target;
    this.damage = damage;
  }
  void display() {
    pushMatrix();
    translate(xPosition, yPosition);
    rotate(direction);
    image(image, 0, 0);
    popMatrix();
  }
  void move() {
    xPosition += cos(direction)*speed;
    yPosition += sin(direction)*speed;
  }
}

Ship player1;
Ship player2;
PImage space;
ArrayList<Projectile> projectiles;
PImage beamSprite;
PImage missileSprite;
String state;
String winner;
int health1;
int health2;

void setup() {
  frameRate(60);
  health1 = 0;
  health2 = 0;
  size(displayWidth, displayHeight);
  imageMode(CENTER);
  player1 = new Ship(loadImage("Blue Ship.png"), width/4, height/4, 0, "Player 1");
  player2 = new Ship(loadImage("Red Ship.png"), width/4*3, height/4*3, PI, "Player 2");
  space = loadImage("Space.png");
  space.resize(displayWidth, displayHeight);
  projectiles = new ArrayList<Projectile>();
  beamSprite = loadImage("Beam.png");
  missileSprite = loadImage("Missile.png");
  state = "Play";
}

void draw() {
  background(space);
  if (state == "Play") {
    player1.shield();
    player2.shield();
    player1.fire();
    player2.fire();
    player1.move();
    player2.move();
    player1.display();
    player2.display();
    if (projectiles.size() > 0) {
      for (int i=0; i<projectiles.size (); i++) {
        Projectile a = projectiles.get(i);
        a.display();
        a.move();
        if (a.xPosition < 0 || a.xPosition > width || a.yPosition < 0 || a.yPosition > height) {
          projectiles.remove(i);
          i++;
        }
        Ship b = a.target;
        println(b.player);
        for (int j=0; j<b.hitboxes.size (); j++) {
          ShipHitbox c = b.hitboxes.get(j);
          if (dist(a.xPosition, a.yPosition, c.xPosition, c.yPosition) <= a.hitbox + c.radius) {
            b.damage(a.damage, c.type);
            projectiles.remove(i);
            i++;
            break;
          }
          //          if ((angle > -45 && angle < 45) || (angle > 315 || angle < -45)) {
          //            b.damage(a.damage, "Back");
          //          } else if (angle <= -2*PI/8 && angle >= -2*PI/8*3) {
          //            b.damage(a.damage, "Left");
          //          } else if (angle > 135 && angle < 315) {
          //            b.damage(a.damage, "Front");
          //          } else if (angle >= 45 && angle <= 135) {
          //            b.damage(a.damage, "Right");
          //          }
        }
      }
    }
    fill(255);
    textSize(12);
    textAlign(RIGHT);
    text("Player 2", width-10, 10);
    text("Forward: [I]", width-10, 30);
    text("Left: [J]", width-10, 50);
    text("Right: [L]", width-10, 70);
    text("Beam: [P]", width-10, 90);
    text("Left Rockets: [U]", width-10, 110);
    text("Right Rockets: [O]", width-10, 130);
    text("Shield: [K]", width-10, 150);
    text("Shield: " + player2.shieldEnergy, width-10, 170);
    stroke(0, 128, 0);
    strokeWeight(8);
    line(width-10-player2.shieldEnergy/6, 190, width-10, 190);
    text("Front Armor: " + player2.frontHealth, width-10, 210);
    line(width-10-player2.frontHealth/6, 230, width-10, 230);
    text("Left Armor: " + player2.leftHealth, width-10, 250);
    line(width-10-player2.leftHealth/6, 270, width-10, 270);
    text("Right Armor: " + player2.rightHealth, width-10, 290);
    line(width-10-player2.rightHealth/6, 310, width-10, 310);
    text("Back Armor: " + player2.backHealth, width-10, 330);
    line(width-10-player2.backHealth/6, 350, width-10, 350);
    textAlign(LEFT);
    text("Player 1", 10, 10);
    text("Forward: [W]", 10, 30);
    text("Left: [A]", 10, 50);
    text("Right: [D]", 10, 70);
    text("Beam: [R]", 10, 90);
    text("Left Rockets: [Q]", 10, 110);
    text("Right Rockets: [E]", 10, 130);
    text("Shield: [S]", 10, 150);
    text("Shield: " + player1.shieldEnergy, 10, 170);
    stroke(0, 128, 0);
    strokeWeight(8);
    line(10, 190, player1.shieldEnergy/6+10, 190);
    text("Front Armor: " + player1.frontHealth, 10, 210);
    line(10, 230, player1.frontHealth/6+10, 230);
    text("Left Armor: " + player1.leftHealth, 10, 250);
    line(10, 270, player1.leftHealth/6+10, 270);
    text("Right Armor: " + player1.rightHealth, 10, 290);
    line(10, 310, player1.rightHealth/6+10, 310);
    text("Back Armor: " + player1.backHealth, 10, 330);
    line(10, 350, player1.backHealth/6+10, 350);
    health1 = player1.frontHealth + player1.rightHealth + player1.backHealth + player1.leftHealth;
    health2 = player2.frontHealth + player2.rightHealth + player2.backHealth + player2.leftHealth;
    if (health1 == 0 || health2 == 0) {
      state = "Finish";
    }
  } else if (state == "Finish") {
    textAlign(CENTER);
    fill(255);
    textSize(40);
    if (health1 > 0) {
      text("Victory for Player 1!", width/2, height/2);
    } else {
      text("Victory for Player 2!", width/2, height/2);
    }
  }
}

void keyPressed() {

  //Player 1

  if (key == 'w') {
    player1.forward = true;
  }
  if (key == 'a') {
    player1.left = true;
  }
  if (key == 'd') {
    player1.right = true;
  }
  if (key == 'r') {
    player1.beam = true;
  }
  if (key == 'q') {
    player1.leftRocket = true;
  }
  if (key == 'e') {
    player1.rightRocket = true;
  }
  if (key == 's') {
    player1.shield = true;
  }

  //Player 2

  if (key == 'i') {
    player2.forward = true;
  }
  if (key == 'j') {
    player2.left = true;
  }
  if (key == 'l') {
    player2.right = true;
  }
  if (key == 'p') {
    player2.beam = true;
  }
  if (key == 'u') {
    player2.leftRocket = true;
  }
  if (key == 'o') {
    player2.rightRocket = true;
  }
  if (key == 'k') {
    player2.shield = true;
  }
}

void keyReleased() {

  //Player 1

  if (key == 'w') {
    player1.forward = false;
  }
  if (key == 'a') {
    player1.left = false;
  }
  if (key == 'd') {
    player1.right = false;
  }
  if (key == 'r') {
    player1.beam = false;
  }
  if (key == 'q') {
    player1.leftRocket = false;
  }
  if (key == 'e') {
    player1.rightRocket = false;
  }
  if (key == 's') {
    player1.shield = false;
  }

  //Player 2

  if (key == 'i') {
    player2.forward = false;
  }
  if (key == 'j') {
    player2.left = false;
  }
  if (key == 'l') {
    player2.right = false;
  }
  if (key == 'p') {
    player2.beam = false;
  }
  if (key == 'u') {
    player2.leftRocket = false;
  }
  if (key == 'o') {
    player2.rightRocket = false;
  }
  if (key == 'k') {
    player2.shield = false;
  }
}

