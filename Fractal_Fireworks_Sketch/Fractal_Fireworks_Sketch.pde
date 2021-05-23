/*
Caleb Eurich
CSCI 3725
M9
5/24/2021

This system creates recursive fractal fireworks. On mouse click, a recursion level from 1 to 5 is randomized which favors smaller numbers. 
Fireworks explode particles and those particles turn into new fireworks according to their recursion level. 
*/

// create array of fireworks
Firework [] theFireworks = new Firework[10000];

// How many fireworks we have already created
int numFireworks = 0;

// The current index position in the firework array
int currentFirework = 0;


void setup() {
  size(500, 500, P3D);
}

/*
function to continuously draw
*/
void draw() {
  // Clear the background.
  background(0, 0, 0);
   
  // Draw all fireworks that have been created.
  for (int i = 0; i < numFireworks; i++)
  {
    theFireworks[i].display();
  }
}

/*
creates a firework on mouse clock that has a lower chance to be a larger firework
*/
void mouseClicked()
{
  // Create a Firework and add it to the current index in our array.
  // The Firework should be placed where the user clicked.

  //generate a random number and decide size proportionately
  float fireworkType = random(1);
  int levelToRecur = 1;
  if (fireworkType > 0.99){
  levelToRecur = 5;
  }
  else if (fireworkType > 0.95){
  levelToRecur = 4;
  }
  else if (fireworkType > 0.8){
  levelToRecur = 3;
  }
  else if (fireworkType > 0.5){
  levelToRecur = 2;
  }
  
    //  initialize firework with recursion decided above upon click
  theFireworks[currentFirework] = new Firework(mouseX, mouseY, levelToRecur);

  // Increase the current index to get ready for the next Firework.
  currentFirework++;

  // Increase our total fireworks in play, if we haven't filled the array yet.
  if (numFireworks < theFireworks.length)
  {
    numFireworks++;
  }

  // Did we just use our last slot?  If so, we can reuse old slots.
  if (currentFirework >= theFireworks.length)
  {
    currentFirework = 0;
  }
}

/*
Firework class. Contains position, number of particles, explosion duration, particle color, split angle, explosion timer, particle size, if hidden, and number of recursions.
Most variables are randomized, some are done fractally based on their recursion number.
*/
class Firework{
  //initialize Firework variables
  private float x;
  private float y;
  private int numParticles;
  private int duration;
  private color theColor;
  private float splitAngle;
  private float explosionTimer;
  private float particleSize;
  private boolean hidden;
  private int numRecur;
  

  //firework constructor that takes position and recursion number
  Firework(float x, float y, int numRecur) {

    // Store x and y
    this.x = x;
    this.y = y;
    
    //reduce numRecur for recursive construction
    this.numRecur = numRecur - 1;

    //initialize numParticles
    numParticles = ceil(random(8)) + 3;
    
    //initialize and choose color scheme
    //an option where later particles are less opaque
    //theColor = color(random(150) + 105, random(3) * 50 + 105, random(3) * 50 + 105, 105 + (numRecur * 50));
    
    //Another option I prefer where later particles are more red
    theColor = color(250 - (50 * numRecur), random(3) * 50 + (30 * numRecur), random(3) * 50 + (30 * numRecur));
    
    //initialize variables randomizing most
    duration = ceil(random(30)) + (numRecur * 20);
    hidden = false;
    splitAngle = 360/numParticles;
    explosionTimer = 0;
    //particleSize = random(5) + 1;
    //later fireworks are smaller
    particleSize = numRecur * 2 + 1;

  }
    //simple display method for the firework object that does nothing if hidden or displays the firework particles and runs the explosion counter to manage time
    void display() {
      if (hidden){
        //do nothing
      }
      else{
         // Specifies the color for the Firework.
        stroke(theColor);
        strokeWeight(particleSize);
        
        //run the explosion counter to keep track of time and know when to explode or recurse
        explosionCounter();
      }
  }

  /*
  this method checks how long the firework has been exploding and tells when to hide or recursively explode.
  */
  void explosionCounter(){
    //check if firework is done exploding
    if (explosionTimer < duration){
      explosionTimer += 0.25;
      //after a short period of time, recursively explode
      //later fireworks explode faster
      if (explosionTimer == 20 * numRecur){
      //recurse and hide old firework
        recursiveExplode();
        hidden = true;
      }
      else{
        //continue exploding normally
        explode();
      }
    }
    else{
      //hide particles after exploding and not recuring
      hidden = true;
    }
  }
  /*
   this method keeps track of particles moving away from explosion center
  */
  void explode(){
    //slowly move aprticles apart at the correct angle based on firework start location and the explosion timer
    for(int i = 0; i < numParticles + 1; i++){
      pushMatrix();
      translate(x,y);
      point(sin(radians(i * splitAngle)) * explosionTimer, cos(radians(i * splitAngle)) * explosionTimer);
      popMatrix();
    }
  }
  /*
  this method causes the existing firework particles to explode into new fireworks in place
  */
  void recursiveExplode(){
    for(int i = 0; i < numParticles + 1; i++){
      //create a new firework at the place of each old particle with one layer less of recursion left
      createFirework(sin(radians(i * splitAngle)) * explosionTimer + x ,cos(radians(i * splitAngle)) * explosionTimer + y, numRecur);
    }
  }
}

/*
calls the firework constructor only if the bottom level of recursion has not yet been reached.
*/
void createFirework(float x, float y, int numRecur){
  if (numRecur > 0)
  {
    // Create a Firework and add it to the current index in our array.
    // The Firework should be placed where the user clicked.
    theFireworks[currentFirework] = new Firework(x, y, numRecur);
  
    // Increase the current index to get ready for the next Firework.
    currentFirework++;
  
    // Increase our total fireworks in play, if we haven't filled the array yet.
    if (numFireworks < theFireworks.length)
    {
      numFireworks++;
    }
  
    // Did we just use our last slot?  If so, we can reuse old slots.
    if (currentFirework >= theFireworks.length)
    {
      currentFirework = 0;
    }
  }

}
