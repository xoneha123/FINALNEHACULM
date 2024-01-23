boolean gameStart = false;
int score = 0;

float x = 150;
float y = 150;
float speedX;
float speedY;
int leftColor = 128;
int rightColor = 128;
int diam;
int rectSize = 150;
float diamHit;
int difficulty = 0;  // 0: No difficulty chosen, 1: Easy, 2: Medium, 3: Hard
PImage ballImage;
PImage backgroundImage;
ArrayList<PowerUp> powerUps;

void setup() {
  size(500, 500);
  noStroke();
  smooth();
  ellipseMode(CENTER);
  backgroundImage = loadImage("background.jpg");
  startScreen();
  ballImage = loadImage("ball.png");
  powerUps = new ArrayList<PowerUp>();
}

void startScreen() {
  background(200);

  // Display start text
  fill(0);
  textSize(30);
  textAlign(CENTER, CENTER);
  text("Choose Difficulty", width / 2, height / 2 - 50);

  // Easy button
  fill(0, 255, 0); // Green
  rect(width / 4 - 50, height / 2, 100, 40);
  fill(0);
  textSize(20);
  text("Easy", width / 4, height / 2 + 20);

  // Medium button
  fill(255, 255, 0); // Yellow
  rect(width / 2 - 50, height / 2, 100, 40);
  fill(0);
  text("Medium", width / 2, height / 2 + 20);

  // Hard button
  fill(255, 0, 0); // Red
  rect(3 * width / 4 - 50, height / 2, 100, 40);
  fill(0);
  text("Hard", 3 * width / 4, height / 2 + 20);
}

void draw() {
  if (gameStart) {
    // Game is running
    game();
  }
}

void game() {
  image(backgroundImage, 0, 0, width, height);

  fill(128, 128, 128);
  diam = 20;
  image(ballImage, x, y, diam, diam);

  // Display and update power-ups
  for (int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp powerUp = powerUps.get(i);
    powerUp.display();
    powerUp.update();

    // Check for collision with the ball
    if (powerUp.collides(x, y, diam)) {
      applyPowerUp(powerUp.getType());
      powerUps.remove(i);
    }
  }

  fill(leftColor);
  rect(0, 0, 20, height);
  fill(rightColor);
  rect(width - 30, mouseY - rectSize / 2, 10, rectSize);

  fill(0);
  textSize(20);
  textAlign(RIGHT, TOP);  // Set text alignment to right, top
  text("Score: " + score, width - 10, 10);  // Display score in the right upper corner
  
  x = x + speedX;
  y = y + speedY;

  if (x > width - 30 && x < width - 20 && y > mouseY - rectSize / 2 && y < mouseY + rectSize / 2) {
    speedX = speedX * -1;
    x = x + speedX;
    rightColor = 0;
    fill(random(0, 128), random(0, 128), random(0, 128));
    diamHit = random(75, 150);
    ellipse(x, y, diamHit, diamHit);
    rectSize = rectSize - 10;
    rectSize = constrain(rectSize, 10, 150);
    score++; // Increase the score when the bar is hit
  } else if (x < 25) {
    speedX = speedX * -1.1;
    x = x + speedX;
    leftColor = 0;
  } else {
    leftColor = 128;
    rightColor = 128;
  }

  if (x > width) {
    gameStart = false;
    x = 150;
    y = 150;
    startScreen();  // After each round, display difficulty selection
  }

  if (y > height || y < 0) {
    speedY = speedY * -1;
    y = y + speedY;
  }
  
  // Spawn a power-up every second
  if (frameCount % 60 == 0) {
    powerUps.add(new PowerUp(random(width), random(height)));
  }
}

void mousePressed() {
  if (!gameStart) {
    // Check difficulty selection when the game is not started
    if (mouseY > height / 2 && mouseY < height / 2 + 40) {
      if (mouseX > width / 4 - 50 && mouseX < width / 4 + 50) {
        difficulty = 1;  // Easy
      } else if (mouseX > width / 2 - 50 && mouseX < width / 2 + 50) {
        difficulty = 2;  // Medium
      } else if (mouseX > 3 * width / 4 - 50 && mouseX < 3 * width / 4 + 50) {
        difficulty = 3;  // Hard
      }
      startGame();
    }
  }
}

void startGame() {
  gameStart = true;
  setDifficultyParameters();
}

void setDifficultyParameters() {
  // Set speed parameters based on the difficulty level
  if (difficulty == 1) {
    speedX = random(1, 2);
    speedY = random(1, 2);
  } else if (difficulty == 2) {
    speedX = random(3, 5);
    speedY = random(3, 5);
  } else if (difficulty == 3) {
    speedX = random(6, 8);
    speedY = random(6, 8);
  }
}

void applyPowerUp(int type) {
  // Implement the effects of different power-ups based on their type
  // For example, you can increase paddle size, decrease paddle size, etc.
  switch (type) {
    case 1:
      rectSize += 20;  // Increase paddle size
      break;
    case 2:
      rectSize -= 20;  // Decrease paddle size
      break;
    // Add more cases for different power-up types
  }
}

class PowerUp {
  float x, y;
  int type;  // 1: Increase paddle size, 2: Decrease paddle size (Add more types as needed)

  PowerUp(float x, float y) {
    this.x = x;
    this.y = y;
    this.type = int(random(1, 3)); // Randomly assign a type
  }

  void display() {
    // Display the power-up based on its type
    if (type == 1) {
      // Green for size increase
      fill(0, 255, 0);
    } else if (type == 2) {
      // Red for size decrease
      fill(255, 0, 0);
    }
    ellipse(x, y, 20, 20); // Adjust size based on type
    // Draw a symbol or any indication for the power-up (for example, a plus sign for size increase or a minus sign for size decrease)
    if (type == 1) {
      // Draw a plus sign for size increase
      stroke(0);
      line(x - 5, y, x + 5, y);
      line(x, y - 5, x, y + 5);
    } else if (type == 2) {
      // Draw a minus sign for size decrease
      stroke(0);
      line(x - 5, y, x + 5, y);
    }
  }

  void update() {
    // Update the position or animation of the power-up if needed
    // For example, you can make it move or rotate
  }

  boolean collides(float playerX, float playerY, int playerSize) {
    // Check for collision with the player's paddle
    float distance = dist(x, y, playerX, playerY);
    return (distance < (playerSize / 2 + 10)); // Adjust collision radius
  }

  int getType() {
    return type;
  }
}
