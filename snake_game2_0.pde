int draw_times = 0;
int catch_times = 0;
int map_width;
int map_grid_nums;//地图的方格数量
int grid_width = 20;
boolean is_playing;
String Color = "#F71E1E";
Snack snack;
int best_score;
boolean food_eaten;
int food_x = 5,food_y = 3;
int sleep = 99999;
int last_keypressed_time = 0;
int stop_time = 0;
int rate = 1;
boolean setting = false;
void setup()
{
  background(0);
  size(800, 800);
  map_width = width;
  map_grid_nums = map_width / grid_width;
  int[] snackbody_color = {0,0,255};
  int[] snackhead_color = {0,127,207};
  snack = new Snack(5, grid_width, snackbody_color, snackhead_color, 3);
  snack.display();
  frameRate(5*rate);
  setting = true;
  show_first_start();
  is_playing = false;
}
void draw(){
  if(millis() - stop_time < 3000) return;//判断睡眠
  //println(sleep);
  if(is_playing) {
    draw_times ++;
    background(40);
    snack.move();
    if(keyPressed == false) {
      last_keypressed_time = millis();
      frameRate(5*rate);
    }
   
    if(snack.pos.get(0).x == food_x && snack.pos.get(0).y == food_y) {
      food_eaten = true;
      snack.pos.add(snack.virtual_tail);
    }
    draw_food(map_grid_nums);
    
    snack.display();  
    //撞墙那块，有点小bug
    if(is_knock_wall() || is_knock_self()) {
      //println("@@@@@@@@");
      snack.lives--;
      println(snack.lives);
      frameRate(5&rate);
      show_life_down();
      sleep = 0;
      snack.init_pos();
      stop_time = millis();
    }    
    if(snack.lives == 0) is_playing = false;
    if(is_playing == false) show_game_over();//不能放到外面，不然刚开始就结束了，不知道他怎么写的。
  }
  

}
boolean is_knock_wall() {
  PVector now_snack_head_pos = snack.pos.get(0);
  //print("now_snack_head_pos: ");
  //println(snack.pos);
  
  if(now_snack_head_pos.x < 0 || now_snack_head_pos.y < 0 || now_snack_head_pos.x >= map_grid_nums || now_snack_head_pos.y >= map_grid_nums) return true;
  else return false;
}
boolean is_knock_self() {
  return snack.head_knock_myself();
}

void draw_food(int max_width)
{
  int food_out = 0; //判断食物是否在体内

  //食物填充颜色
  fill(#F71E1E); 
  //如果食物被吃掉，则随机生成一个
  if (food_eaten) {
    while (food_out == 0){
      food_out = 1;
      food_x = int(random(0, max_width));
      food_y = int(random(0, max_width));
      for(int i = 0; i<snack.pos.size(); i++){
        if ( food_x == snack.pos.get(i).x && food_y == snack.pos.get(i).y ) {
          food_out = 0;
        }
      }
    }
  }
  rect(food_x*grid_width, food_y*grid_width, grid_width, grid_width);
  food_eaten = false;
}

void keyPressed(){
  if(is_playing == false && key == 'r') {//重启游戏
    int[] snackbody_color = {0,0,255};
    int[] snackhead_color = {0,127,207};
    snack = new Snack(5, grid_width, snackbody_color, snackhead_color,3);
    setting = true;
    show_setting();
    return;
  }
  if(setting == true && key == 'e') {
    rate = 1;
    setting = false;
    is_playing = true;
  }
  if(setting == true && key == 'h') {
    rate = 3;
    setting = false;
    is_playing = true;
  }  
  //加入这个机制可以避免一个frameRate里面点了多次方向键，导致蛇直接反向跑。
  if(catch_times == draw_times) return;
  catch_times = draw_times;
  if(is_playing == true) {
    if(key == CODED) {
      if(millis() - last_keypressed_time > (2000/frameRate)) frameRate(20*rate);
      switch(keyCode) {
        case LEFT:
          if (snack.direction != 'R') snack.direction = 'L';
          break;
        case RIGHT:
          if (snack.direction != 'L') snack.direction = 'R';
          break;
        case DOWN:
          if (snack.direction != 'U') snack.direction = 'D';
          break;
        case UP:
          if (snack.direction != 'D') snack.direction = 'U';
          break;
      }
    }
  }
}



void show_first_start()
{
  pushMatrix();
  background(0);  
  translate(width/2, height/2 - 50);
  fill(255);  
  textAlign(CENTER); 
  textSize(96);
  text("Snake", 0, 0);

  fill(120);
  textSize(40);
  text("Press 'R' or 'r' to start.", 0, 260);
  popMatrix();
}
void show_setting()
{
  pushMatrix();
  background(0);  
  translate(width/2, height/2 - 50);
  fill(205);  
  textAlign(CENTER); 
  textSize(40);
  text("Press 'e' to choose easy mode.", 0, 0);

  fill(205);
  textSize(40);
  text("Press 'h' to choose hard mode.", 0, 100);
  popMatrix();
}
void show_life_down()
{
  pushMatrix();
  int snake_length = snack.get_length();
  best_score = best_score > snake_length ? (best_score - 2 ): (snake_length - 2);

  background(0);  
  translate(width/2, height/2 - 50);
  fill(255);  
  textAlign(CENTER);
  textSize(60);
  text("You have been slained!", 0, 0);

  fill(120);
  textSize(30);
  text("You have only "+snack.lives + " lives!", 0, 200);
  text("You will return to the game in 3 seconds!", 0, 260);
  popMatrix();
}
void show_game_over()
{
  pushMatrix();
  int snake_length = snack.get_length();
  
  background(0);  
  translate(width/2, height/2 - 50);
  fill(255);  
  textAlign(CENTER); 
  textSize(84);
  text(snake_length - 2 + "/" + best_score, 0, 0);

  fill(120);
  textSize(30);
  text("Score / Best", 0, 200);
  text("Game Over, Press 'R' or 'r' to restart.", 0, 260);
  popMatrix();
}
