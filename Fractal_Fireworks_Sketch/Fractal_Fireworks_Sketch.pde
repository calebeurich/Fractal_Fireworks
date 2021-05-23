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
  //position of Firework
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
    this.numRecur = numRecur - 1;

    //numParticles = ceil(random(10)) + 10;
    numParticles = 6;
    
    //soft colors
    theColor = color(random(3)*50 + 105,random(3)*50 + 105,random(3)*50 + 105);
    duration = ceil(random(3))*10 + 40;
    hidden = false;
    splitAngle = 360/numParticles;
    explosionTimer = 0;
    particleSize = random(4) + 2;

  }
  
    void display() {
      if (hidden){
        //do nothing
      }
      else{
        explosionCounter();
        // This method specifies our Firework will not have an outline.
        noStroke();

        // Specifies the color for the Firework.
        stroke(theColor);
        strokeWeight(particleSize);
        
        //explode();

      }
  }


  void explosionCounter(){
    if (explosionTimer < duration){
      explosionTimer += 0.25;
      if (explosionTimer == 25){
      //effectively recurse here
        recursiveExplode();
      }
      else{
        explode();
      }
    }
    else{
      //hide particles after exploding
      hidden = true;
      //explosionTimer = 10000.5;
    }
  }
  
  void explode(){
    for(int i = 0; i < numParticles + 1; i++){
      pushMatrix();
      translate(x,y);
      point(sin(radians(i*splitAngle))*explosionTimer,cos(radians(i*splitAngle))*explosionTimer);
      popMatrix();
    }
  }
  
  void recursiveExplode(){
    for(int i = 0; i < numParticles + 1; i++){
      //pushMatrix();
      //translate(x,y);
      createFirework(sin(radians(i*splitAngle))*explosionTimer,cos(radians(i*splitAngle))*explosionTimer, numRecur);
      //popMatrix();
    }
  }
}

void createFirework(float x, float y, int numRecur){
  if (numRecur>1)
  {
    // Create a Firework and add it to the current index in our array.
    // The Firework should be placed where the user clicked.
    theFireworks[currentFirework] = new Firework(x, y, numRecur - 1);
  
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
