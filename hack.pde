import processing.serial.*;
import ddf.minim.*;
import ddf.minim.spi.*;
import http.requests.*;

Minim minim;
AudioPlayer player, button, crash, playing, coin;
Serial arduino;
String username="";
PImage img,grd;
ArrayList<attackers> atk_arr = new ArrayList<attackers>();
ArrayList<garbages> gbg_arr = new ArrayList<garbages>();
static float sizefactor=3.5;
float[] pos = new float[10];
float dat=0;
float rawdat = 0;
int ind = 0;
float average = 0;
int[][] p_vector={{800,600,0},{500,300,5},{900,200,-4}};
int[][] v_vector={{1,-2,1},{1,2,1},{1,2,1}};
int attack_period = 1800;
float speed = 8;
long curr=0;
long curr_off=900;
long play_time=0;
int size = 40;
String url = "http://ec2-35-72-3-8.ap-northeast-1.compute.amazonaws.com/Hack23/leaderboard.php";
PImage[] candidates = new PImage[10];
int score=0;
int delta_time1;
int score_multiplier=1;
enum State {start, transition, falling, playing, end};
State curr_state=State.start;

void setup(){
  fullScreen();
  background(255);
  smooth(2);
  arduino = new Serial(this, "/dev/cu.usbserial-120", 9600);
  arduino.clear();
  img = loadImage("1.png");
  grd = loadImage("bkground.jpg");
  candidates[0] = loadImage("attack1.png");
  candidates[1] = loadImage("attack2.png");
  candidates[2] = loadImage("attack3.png");
  candidates[3] = loadImage("attack4.png");
  candidates[4] = loadImage("bear.png");
  candidates[5] = loadImage("bear1.png");
  candidates[6] = loadImage("garbage1.png");
  candidates[7] = loadImage("garbage2.png");
  candidates[8] = loadImage("garbage3.png");
  candidates[9] = loadImage("garbage4.png");
  String rwdat = arduino.readStringUntil('\n');
  generateAttack();
  fill(255,255,111);
  minim = new Minim(this);

  player = minim.loadFile("start.mp3");
  button = minim.loadFile("button.mp3");
  crash = minim.loadFile("crash.mp3");
  coin = minim.loadFile("coin.mp3");
  player.play();
}


void draw(){
  switch (curr_state) {
    case start:
    background(15,15,25);
    image(candidates[0],width-800, height-600, 1200, 1200);
    image(candidates[4],p_vector[0][0], p_vector[0][1], 150, 150);
    pushMatrix();
    translate(p_vector[1][0],p_vector[1][1]);
    rotate(PI*p_vector[1][2]/100);
    image(candidates[5],0, 0, 150, 150);
    popMatrix();
    pushMatrix();
    translate(p_vector[2][0],p_vector[2][1]);
    rotate(-PI*p_vector[2][2]/160);
    image(candidates[5],0, 0, 150, 150);
    popMatrix();
    textSize(40);
    text("Click anywhere",200, height/2);
    for (int i=0;i<=2;i++){
      for (int j=0;j<=2;j++){
        p_vector[i][j]+=v_vector[i][j];
        if (p_vector[i][j]>height&&j!=2){
          v_vector[i][j]=-abs(v_vector[i][j]);
        } else if (p_vector[i][j]<0&&j!=2){
          v_vector[i][j]=abs(v_vector[i][j]);
        }
      }
    }
    break;
    case transition:
      player.close();
      button.play();
      for (int i = 0; i<=2; i++){
        v_vector[i][1]=-20;
      }
      curr_state=State.falling;
    break;
    case falling:
      background(15,15,25);
      image(candidates[0],width-800, height-600, 1200, 1200);
      image(candidates[4],p_vector[0][0], p_vector[0][1], 150, 150);
      pushMatrix();
      translate(p_vector[1][0],p_vector[1][1]);
      rotate(PI*p_vector[1][2]/100);
      image(candidates[5],0, 0, 150, 150);
      popMatrix();
      pushMatrix();
      translate(p_vector[2][0],p_vector[2][1]);
      rotate(-PI*p_vector[2][2]/160);
      image(candidates[5],0, 0, 150, 150);
      popMatrix();
      boolean stay = false;
      for (int i=0;i<=2;i++){
        v_vector[i][1]=v_vector[i][1]+1;
        if (p_vector[i][1]<height){
          stay = true;
        }
        for (int j=0;j<=2;j++){
          p_vector[i][j]+=v_vector[i][j];
        }
      }
      if (!stay){
        curr_state = State.playing;
        curr = millis();
        play_time = second();
        delta_time1 = millis();
      }
    break;
    
    case playing:
      background(15,15,25);
      score = score + (millis()-delta_time1)*score_multiplier;
      delta_time1 = millis();
      if (millis()-curr>attack_period){
        generateAttack();
        curr = millis();
        curr_off = curr - int(attack_period/2);
      }
      if (millis()-curr_off>attack_period){
        generateGarbage();
        curr_off = millis();
      }
      if (atk_arr.get(0).x<-100){
        atk_arr.remove(0);
      }
      if (gbg_arr.get(0).x<-100){
        gbg_arr.remove(0);
      }
      for (attackers temp: atk_arr){
        temp.move(speed);
        temp.disp();
        if (temp.collide(average)){
          curr_state=State.end;
          curr=millis();
        }
      }
      for (garbages temp: gbg_arr){
        temp.move(speed);
        temp.disp();
        if (temp.collide(average)){
          score_multiplier++;
          size=50;
          println(coin.position());
          println(coin.length());
          if ( coin.position() != 0 ) {
            coin.rewind();
            coin.play();
          }
          else {
            coin.play();
          }
        }
        
      }
      while (arduino.available() > 0) {
          String data = arduino.readStringUntil('\n');
          if (data != null) {
            try {
            rawdat = Float.parseFloat(data);
            } catch (NumberFormatException e){}
          }
      }
      if (rawdat>100 || rawdat<1){
      } else {
        dat = rawdat;
        float hi = map(dat,1,13,height+100,250);
        if (hi<150){
          hi=150;
        }
        if (hi>height-511/sizefactor/2){
          hi=height-511/sizefactor/2;
        }
        if (ind<9){
          ind++;
        } else {
          ind=0;
        }
        pos[ind]=hi;
      }
      float sum=0;
      for (int i = 0; i < pos.length; i++) {
        sum += pos[i];
      }
      average = sum / 10.0;
      drawBear(average);
      textAlign(CENTER);
      textSize(40);
      text("Score: "+score,width/2,70);
      textSize(size);
      text("Multiplier: "+score_multiplier,4*width/5,70);
      if (size>40){
        size-=2;
      }
      break;
      case end:
      crash.play();
      if (millis()-curr>3000){
        background(15,15,25);
        textSize(60);
        text("You've got "+score+" points.",width/2,height/2-200);
        textSize(40);
        text(username.equals("")?"Type a name\nPress return to record your score.":username,width/2,height/2);
      }
      break;
  }
}
void drawBear(float h){
  //rect(0, h-511/sizefactor/2, 525/sizefactor, 511/sizefactor); //debug only
  image(img, 0, h-511/sizefactor/2, 595/sizefactor, 511/sizefactor);
}
void generateAttack(){
  speed = 7+int(millis()/5000.0);
  println(speed);
  attack_period = int(13000/speed);
  int rand = int(random(200));
  attackers temp_atk = new attackers(width,height-int(random(700)),150+rand,150+rand-10,candidates[int(random(3))]);
  atk_arr.add(temp_atk);
}
void generateGarbage(){
  int rand = int(random(20));
  garbages temp_gbg = new garbages(width,height-int(random(700)),40+rand,candidates[6+int(random(2))]);
  gbg_arr.add(temp_gbg);
}
void mouseClicked(){
  if (curr_state == State.start) {
    curr_state = State.transition;
  }
}
void keyPressed(){
  if (curr_state == State.end) {
    println(int(key));
    if (int(key)==10){
      PostRequest post = new PostRequest(url);
      post.addData("username", username);
      post.addData("score", str(score));
      post.send();
      // Open the web browser after sending the request
      link(url);
    } else if (int(key)!=65535){
      username = username+key;
    }
  }
}
