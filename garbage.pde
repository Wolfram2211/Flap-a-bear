class garbages {
  int x,y,size;
  PImage pic;
  boolean used;
  garbages(int x, int y, int size, PImage pic) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.pic = pic;
    this.used=false;
  }
  boolean collide(float h){
    if (!used&&this.y<h+511/sizefactor/2 && this.y>h-511/sizefactor/2){//facing the star
      if (x<this.size/2+525/sizefactor){
        used = true;
        return true;
      }
    } else if(!used&&this.y<h+511/sizefactor/2+this.size/2 && this.y>h-511/sizefactor/2-this.size/2){
      if (dist(511/sizefactor,h-525/sizefactor/2, this.x, this.y)<this.size/2||dist(511/sizefactor,h+525/sizefactor/2, this.x, this.y)<this.size/2){
        used = true;
        return true;
      }
    }
    return false;
  }
  void disp(){
    if (!used){
    image(pic, x-this.size/2, y-this.size/2, float(this.size), float(this.size));
    }
  }
  void move(float spd){
    x-=spd;
  }
}
