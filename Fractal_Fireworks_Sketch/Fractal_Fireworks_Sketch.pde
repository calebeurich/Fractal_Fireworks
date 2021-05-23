// create array of fireworks
Firework [] theFireworks = new Firework[10000];

// How many fireworks we have already created
int numFireworks = 0;

// The current index position in the firework array
int currentFirework = 0;


void setup() {
  size(500, 500, P3D);
}


void draw() {
  // Clear the background.
  background(0, 0, 0);
   
  // Draw all fireworks that have been created.
  for (int i = 0; i < numFireworks; i++)
  {
    theFireworks[i].display();
  }
  
}

  // If the user clicks...
void mouseClicked()
{
  // Create a Firework and add it to the current index in our array.
  // The Firework should be placed where the user clicked.
  //  initialize firework with recursion level 3 upon click
  theFireworks[currentFirework] = new Firework(mouseX, mouseY, 3);

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
  


  Firework(float x, float y, int numRecur) {

    // Store x and y
    this.x = x;
    this.y = y;
    //reduce numRecur for recursive construction
    this.numRecur = numRecur - 1;

    //initialize numParticles
    numParticles = ceil(random(8)) + 3;
    
    //initialize variables randomizing most
    theColor = color(random(3) * 50 + 105, random(3) * 50 + 105, random(3) * 50 + 105);
    duration = ceil(random(30)) + 40;
    hidden = false;
    splitAngle = 360/numParticles;
    explosionTimer = 0;
    //particleSize = random(5) + 1;
    //later fireworks are smaller
    particleSize = numRecur * 2 + 1;

  }
  
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
  
  void explode(){
    //slowly move aprticles apart at the correct angle based on firework start location and the explosion timer
    for(int i = 0; i < numParticles + 1; i++){
      pushMatrix();
      translate(x,y);
      point(sin(radians(i * splitAngle)) * explosionTimer, cos(radians(i * splitAngle)) * explosionTimer);
      popMatrix();
    }
  }
  
  void recursiveExplode(){
    for(int i = 0; i < numParticles + 1; i++){
      //create a new firework at the place of each old particle with one layer less of recursion left
      createFirework(sin(radians(i * splitAngle)) * explosionTimer + x ,cos(radians(i * splitAngle)) * explosionTimer + y, numRecur);
    }
  }
}

// calls the firework constructor only if the bottom level of recursion has not yet been reached.
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
