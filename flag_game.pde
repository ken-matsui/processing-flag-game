int num = 30;
boolean gameOver = false;

Enemy[] enemy;
Me me;
Flag[] flag;

void setup() {
  size(800, 500);

  enemy = new Enemy[num];
  for (int i = 0; i < num; ++i)
    enemy[i] = new Enemy();

  me = new Me();

  flag = new Flag[3];
  for (int i = 0; i < 3; ++i)
    flag[i] = new Flag();
}

void draw() {
  background(255);

  for (int i = 0; i < num; ++i) {
    if(gameOver != true)
      enemy[i].update();
    enemy[i].display();
  }
  
  if(gameOver != true)
    me.update();
  me.display();

  // Check hit
  for (int i = 0; i < num; ++i) {
    if (enemy[i].hit(me.pos))
      gameOver = true;
  }

  // Flag
  for (int i = 0; i < 3; ++i) {
    flag[i].hit(me.pos);
    flag[i].display();
  }

  if (flag[0].hitted && flag[1].hitted && flag[2].hitted) {
    flag[0].reInit();
    flag[1].reInit();
    flag[2].reInit();
  }
  
  if(gameOver == true) {
    fill(5, 255, 100);
    textSize(80);
    text("GameOver", 200, 280);
  }
}

class Me {
  // Postion, Velocity
  PVector pos, vel;
  // Radius
  float rad = 20;

  Me() {
    // Instance
    pos = new PVector(mouseX, mouseY);
    vel = new PVector();
  }

  void update() {
    // Distance between Current position and Mouse position.
    vel.set(mouseX - pos.x, mouseY - pos.y);
    // 3.0 is velocity.
    pos.add(vel.normalize().mult(3.0));
  }

  void display() {
    fill(0, 0, 0);
    ellipse(pos.x, pos.y, rad, rad);
  }
}

class Enemy {
  // Postion, Velocity
  PVector pos, vel;
  // Radius
  float rad = 20;

  Enemy() {
    // Instance
    float tempX = random(rad/2.0, width - rad/2.0);
    float tempY = random(rad/2.0, height - rad/2.0);

    pos = new PVector(tempX, tempY);
    vel = new PVector(random(-3.0, 3.0), random(-3.0, 3.0));
  }

  void update() {
    pos.add(vel);

    // Reflection
    if (pos.x < 0 + rad/2.0 || pos.x > width - rad/2.0)
      vel.x = -vel.x;
    if (pos.y < 0 + rad/2.0 || pos.y > height - rad/2.0)
      vel.y = -vel.y;
  }

  void display() {
    fill(255, 0, 0);
    ellipse(pos.x, pos.y, rad, rad);
  }

  boolean hit(PVector _pos) {
    if (pos.x + rad/2.0 > _pos.x && pos.x - rad/2.0 < _pos.x)
      if (pos.y + rad/2.0 > _pos.y && pos.y - rad/2.0 < _pos.y)
        return true;
      else
        return false;
    else
      return false;
  }
}

class Flag {
  PVector pos;
  boolean hitted = false;

  Flag() {
    pos = new PVector(random(width), random(height));
  }

  void display() {
    fill(hitted ? color(200, 100, 255) : 0);
    noStroke();

    rect(pos.x, pos.y, 5, 35);
    ellipse(pos.x + 3, pos.y + 39, 30, 5);
    triangle(pos.x + 5, pos.y, pos.x + 5, pos.y + 15, pos.x + 30, pos.y + 8);
  }

  void hit(PVector _pos) {
    if (pos.x + 20.0 > _pos.x && pos.x - 20.0 < _pos.x) {
      if (pos.y + 50.0 > _pos.y && pos.y - 10.0 < _pos.y) {
        hitted = true;
      } else {
        if (hitted != true)
          hitted = false;
      }
    } else {
      if (hitted != true)
        hitted = false;
    }
  }

  void reInit() {
    pos.set(random(width), random(height));
    hitted = false;
  }
}