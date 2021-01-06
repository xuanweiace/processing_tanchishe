class Snack {
  int max_length;
  int lives;
  ArrayList<PVector> pos;//默认从左上角0,0开始
  PVector virtual_tail;//虚拟尾巴的机制，来处理eatfood的情况。
  int grid_width;
  char direction;
  
  int[] body_color;
  int[] head_color;//已投入使用
  Snack(int init_length, int snake_grid_width, int[] snackbody_color, int[] snackhead_color, int snack_lives) {
    grid_width = snake_grid_width;
    direction = 'R';
    lives = snack_lives;
    body_color = new int[3];
    head_color = new int[3];
    pos = new ArrayList<PVector>();
    for(int i = 0; i<init_length; i++) {
      //默认从0,0开始的第一行
      pos.add(new PVector(init_length-i-1,0));
    }
    for(int i = 0; i<3; i++) {
      head_color[i] = snackhead_color[i];
      body_color[i] = snackbody_color[i];
    }
    
  }
  void init_pos() {
    int len = pos.size();
    direction = 'R';
    pos = new ArrayList<PVector>();
    for(int i = 0; i<len; i++) {
      pos.add(new PVector(len-i-1,0));
      //pos.set(i,new PVector(len-i-1,0));
    }
    //print("init_pos");
    //println(pos);
  }
  void display() {
    fill(head_color[0],head_color[1],head_color[2]);
    rect(pos.get(0).x*grid_width, pos.get(0).y*grid_width, grid_width, grid_width);
    fill(body_color[0],body_color[1],body_color[2]);
    for(int i = 1; i<pos.size(); i++) {
      PVector now_pos = pos.get(i);
      rect(now_pos.x*grid_width, now_pos.y*grid_width, grid_width, grid_width);
    }
  }
  int dir_char2int(char dir) {
    int ret = 0;
    switch (dir) {
      case 'R': ret = 0;break;
      case 'D': ret = 1;break;
      case 'L': ret = 2;break;
      case 'U': ret = 3;break;
    }
    return ret;
  }
  void move(){
    int[][] next = {{1,0},{0,1},{-1,0},{0,-1}};//R,D,L,U
    PVector start;
    int idx = dir_char2int(direction);
    start = new PVector(pos.get(0).x+next[idx][0],pos.get(0).y+next[idx][1]);
    virtual_tail = pos.get(pos.size()-1);
    for(int i = pos.size()-1; i>0; i--) {
      pos.set(i,pos.get(i-1));
    }
    pos.set(0,start);
    
  }
  boolean head_knock_myself() {
    //print("pos:");
    //println(pos);
    for(int i = 1; i<pos.size(); i++) {
      if(pos.get(i).x == pos.get(0).x && pos.get(i).y == pos.get(0).y) {
        //println("****************");
        //println(pos.get(i));
        //println(pos.get(0));
        //println("****************");
        return true;
      }
    } return false;
  }
  int get_length() {
    return pos.size();
  }
}
