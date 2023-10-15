class attackers {
  int x,y,pic_size,act_size;
  PImage pic;
  attackers(int x, int y, int pic_size, int act_size, PImage pic) {
    this.x=x;
    this.y=y;
    this.pic_size=pic_size;
    this.act_size=act_size;
    this.pic=pic;
  }
  boolean collide(float h){
    if (this.y<h+500/sizefactor/2 && this.y>h-500/sizefactor/2){//facing the star
      if (x<this.act_size/2+525/sizefactor){
        println(1);
        return true;
      } else {
        return false;
      }
    } else if(this.y<h+500/sizefactor/2+this.act_size/2 && this.y>h-500/sizefactor/2-this.act_size/2){
      if (dist(500/sizefactor,h-525/sizefactor/2, this.x, this.y)<this.act_size/2||dist(500/sizefactor,h+525/sizefactor/2, this.x, this.y)<this.act_size/2){
        println(2);
        return true;
      } else {
        return false;
      }
    } else {//missed
      return false;
    }
  }
  void disp(){
    image(pic, x-this.pic_size/2, y-this.pic_size/2, float(this.pic_size), float(this.pic_size));
    
  }
  void move(float spd){
    x-=spd;
  }
}
