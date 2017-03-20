//太陽系の惑星とハレー彗星の公転運動の模倣プログラム
float [] colorR = new float [8];
float [] colorG = new float [8];
float [] colorB = new float [8];
float [] measure = new float [8];
float [] distance = new float [8];
float [] rvlCclRatio = new float [9];
String [] planet = {  "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"};
//惑星の色、大きさ、太陽との距離、公転速度、名前に関する配列

float [] asteroidSize = new float [500];
float [] asteroidRad = new float [500];
float [] asteroidDist = new float [500];
float [] asteroidSpeed = new float [500];
//小惑星の大きさ、初期位置、太陽との距離、公転速度に関する配列

float [] dustDist = new float [10];
float [] dustDiam = new float [10];
float [] dustR = new float [10];
//彗星の尾に関する配列

float [] starX = new float [1000];
float [] starY = new float [1000];
float [] shine = new float [1000];
//背景の星のx,y座標、明るさに関する配列


void setup() {
  size(700, 700);
  //サイズ700×700のウィンドウを作成
  //***ここで配列を用いています***
  colorR[0]=175 ;  colorG[0]=175 ;  colorB[0]=175 ;
  colorR[1]=225 ;  colorG[1]=225 ;  colorB[1]=100 ;
  colorR[2]=0   ;  colorG[2]=150 ;  colorB[2]=255 ;
  colorR[3]=235 ;  colorG[3]=100 ;  colorB[3]=0   ;
  colorR[4]=250 ;  colorG[4]=200 ;  colorB[4]=150 ;
  colorR[5]=255 ;  colorG[5]=255 ;  colorB[5]=150 ;
  colorR[6]=0   ;  colorG[6]=255 ;  colorB[6]=255 ;
  colorR[7]=0   ;  colorG[7]=0   ;  colorB[7]=255 ;
  //8つの惑星それぞれの色
  
  rvlCclRatio[0]=0.241;
  rvlCclRatio[1]=0.615;
  rvlCclRatio[2]=1;
  rvlCclRatio[3]=1.881;
  rvlCclRatio[4]=11.86;
  rvlCclRatio[5]=29.46;
  rvlCclRatio[6]=84.01;
  rvlCclRatio[7]=164.79;
  rvlCclRatio[8]=76;  
  //公転周期に差を与える
  
  //***ここで条件分岐を用いています***
  //***ここで繰り返しを用いています***
  for (int m=0 ; m<8 ; m++) {
    if (m<4) {
      measure[m]=15;      //水・金・地・火はサイズ15
    }
    else if (m<6) {
      measure[m]=30;      //木・土はサイズ30
    }
    else {
      measure[m]=20;      //天・海はサイズ20
    }
  }
  
  for (int i=0 ; i<8 ; i++) {
    if (i<=3) {
      distance[i]=(i+1)*35+15;      //惑星の公転軌道の間隔を設定
    } 
    else {
      distance[i]=(i+1)*35+50;      //小惑星帯を描くために間隔を空ける
    }
  }

  for (int j=0 ; j<500 ; j++) {
    asteroidDist[j] = random(180, 200);//それぞれの小惑星の太陽からの距離
    asteroidSpeed[j] = random(2.41, 8.61);//速度
    asteroidRad[j] = random(360);//初期位置
    asteroidSize[j] = random(1, 4);//サイズを設定
  }  

  for (int i=0 ; i<10 ; i++) {
    dustDist[i] = i*5;    //彗星のガスの間隔を設定
    dustDiam[i] = i+10;    //外側ほどガスの広がり具合を大きくする
  }

  for (int k=0 ; k<1000 ; k++) {
    starX[k] = random(700);
    starY[k] = random(700);    //背景の星の座標を設定
  }
}


int q;//カーソルがボタンの中にあるかどうかを表す変数(外なら0、中なら1)
int p=0;//アニメーションの状態を表す変数(1で開始、2で停止)
void mousePressed() {
  //ボタンクリックでアニメーション開始、再度クリックで停止
  //***ここで条件分岐を用いています***
  if (q==1) {
    //q=1の時クリックでボタンが押せる
    p++;
  }
  if (p>2) {
    //pが2を超えたら1に戻す
    p=1;
    //アニメーション停止
    c=1;
    year+=0;
  }
}


float ff=1;//天体の速度の初期値
float theta=25;//彗星の尾の太陽の向きに対する角度のズレ
void keyPressed() {
  //上キーで速度を速くし、下キーで速度を遅くする
  switch (keyCode) {
  case UP:
    if (ff<256) {
      //256倍より遅い速度で動いていればスピードを上げられる
      ff *= 2;      //速度を2倍に
    }
    break;
  case DOWN:
    if (ff>0.125) {
      //1/8倍より速い速度で動いていればスピードを下げられる
      ff *= 0.5;      //速度を半分に
    }
    break;
  }
}


float t;//draw毎に増やす角度
int year=0;//経過年数を表す変数
int c=1;//変数yearが増える条件に使う・地球が1周するごとに1ずつ増える
int tZero=90000;//天体の角度の初期値(度数法)
void draw() {
  background(0); 
  textSize(16);  
  //***ここで関数を用いています***
  star(300);
  //背景に星を描画する関数を作成・最大1000個
  
  noStroke();
  fill(255, 128+50*sin(radians(t*3)), 0);
  ellipse(width/2, height/2, 40, 40);    //太陽を描く
  text("Sun", width/2+10, height/2-20);  //太陽の名前表示
  
  //***ここで繰り返しを用いています***
  for (int i=0 ; i<8 ; i++) {
    stroke(100);
    strokeWeight(1);
    noFill();
    ellipse(width/2, height/2, distance[i]*2, distance[i]*2);     //惑星の公転軌道を描く    
    fill(colorR[i], colorG[i], colorB[i]);
    noStroke();
    ellipse(width/2+distance[i]*cos(radians(t/rvlCclRatio[i])), height/2+distance[i]*sin(radians(t/rvlCclRatio[i])), measure[i], measure[i]);
    //惑星を描く
    if (i==4) {//木星の模様を描く
      stroke(120, 50, 0);
      strokeWeight(3);
      line( width/2+distance[i]*cos(radians(t/rvlCclRatio[i]))+15*cos(radians(-30)), height/2+distance[i]*sin(radians(t/rvlCclRatio[i]))+15*sin(radians(-30))+5, 
      width/2+distance[i]*cos(radians(t/rvlCclRatio[i]))+15*cos(radians(-150)), height/2+distance[i]*sin(radians(t/rvlCclRatio[i]))+15*sin(radians(-150))+5 );
      line( width/2+distance[i]*cos(radians(t/rvlCclRatio[i]))+15*cos(radians(-30)), height/2+distance[i]*sin(radians(t/rvlCclRatio[i]))+15*sin(radians(-30))+10, 
      width/2+distance[i]*cos(radians(t/rvlCclRatio[i]))+15*cos(radians(-150)), height/2+distance[i]*sin(radians(t/rvlCclRatio[i]))+15*sin(radians(-150))+10 );
      strokeWeight(2);
      line( width/2+distance[i]*cos(radians(t/rvlCclRatio[i]))+15*cos(radians(-70)), height/2+distance[i]*sin(radians(t/rvlCclRatio[i]))+15*sin(radians(-70))+1, 
      width/2+distance[i]*cos(radians(t/rvlCclRatio[i]))+15*cos(radians(-110)), height/2+distance[i]*sin(radians(t/rvlCclRatio[i]))+15*sin(radians(-110))+1 );      
      strokeWeight(1);      
      fill(250, 200, 150);
      line( width/2+distance[i]*cos(radians(t/rvlCclRatio[i]))+15*cos(radians(30)), height/2+distance[i]*sin(radians(t/rvlCclRatio[i]))+15*sin(radians(30)), 
      width/2+distance[i]*cos(radians(t/rvlCclRatio[i]))+15*cos(radians(150)), height/2+distance[i]*sin(radians(t/rvlCclRatio[i]))+15*sin(radians(150)) );
      ellipse( width/2+distance[i]*cos(radians(t/rvlCclRatio[i]))+6, height/2+distance[i]*sin(radians(t/rvlCclRatio[i]))+15/2, 10, 5);
      fill(150, 0, 0);
      ellipse( width/2+distance[i]*cos(radians(t/rvlCclRatio[i]))+6, height/2+distance[i]*sin(radians(t/rvlCclRatio[i]))+15/2, 4, 2);
      fill(250, 200, 150);
    }
    if (i==5) {//土星の環を描く
      noFill();
      stroke(128, 128, 75);
      strokeWeight(4);
      arc(width/2+distance[i]*cos(radians(t/rvlCclRatio[i])), height/2+distance[i]*sin(radians(t/rvlCclRatio[i])), 60, 12, radians(-57), radians(237));
      stroke((255+128)/2, (255+128)/2, (150+75)/2);
      strokeWeight(3);
      arc(width/2+distance[i]*cos(radians(t/rvlCclRatio[i])), height/2+distance[i]*sin(radians(t/rvlCclRatio[i])), 50, 6, radians(-50), radians(230));
    }
    if (i==6) {//天王星の環を描く
      noFill();
      stroke(255);
      arc(width/2+distance[i]*cos(radians(t/rvlCclRatio[i])), height/2+distance[i]*sin(radians(t/rvlCclRatio[i])), 8, 35, radians(-150), radians(150));
    }
    text(planet[i], width/2+distance[i]*cos(radians(t/rvlCclRatio[i]))+15, height/2+distance[i]*sin(radians(t/rvlCclRatio[i]))-10);
    //惑星の名前の表示
  }
  //***ここで条件分岐を用いています***
  if (p==0) {
    t=tZero;
    //軌道直後は角度を増やさない
  } else if (p==1) {
    t+=ff;
    //アニメーション開始で角度を増やす
  } else {
    t+=0;
    //アニメーション停止で角度を増やすのをやめる
  }
  //***ここで関数を用いています***
  asteroid(200);
  //小惑星帯を描画する関数を作成・最大500個
  halley(width-75, height/2, 700, 350);
  //ハレー彗星を描画する関数を作成
  
  //***ここで条件分岐を用いています***
  if (t>tZero+c*360) {
    //地球が360°回転するごとに年数が加算される
    year++;
    c++;
    //次に年数が加算されるために必要な地球の公転角度を360°増やす
  }

  textSize(24);
  text("year = "+year, 25, 50);
  //経過年数を表示
  //***ここで関数を用いています***
  button(550, 20, 130, 40);
  //ボタンを表示する関数を作成
  text("×"+ff, 570, 100);  //再生速度を表示
}


//---背景の星についての関数---
//引数は描く星の個数(最大1000個)
void star(float quantity) {
  stroke(255);
  //***ここで繰り返しを用いています***
  for (int i=0 ; i<quantity ; i++) {
    //***ここで条件分岐を用いています***
    if (p==1) {
      //アニメーションが動いているとき明度をランダムで変える
    //***ここで配列を用いています***
      shine[i] = random(2);
    } else {
      shine[i] = 1;
    }
    strokeWeight(shine[i]);
    point(starX[i], starY[i]);    //星を描く
  }
}


//---小惑星についての関数---
//引数は描く小惑星の個数(最大500個)
void asteroid(float quantity) {
  //***ここで繰り返しを用いています***
  for (int j=0 ; j<quantity ; j++) {
    stroke(255);
    //***ここで配列を用いています***
    strokeWeight(asteroidSize[j]);
    point(width/2+asteroidDist[j]*cos(radians(asteroidRad[j]+t*0.1/asteroidSpeed[j])), height/2+asteroidDist[j]*sin(radians(asteroidRad[j]+t*0.1/asteroidSpeed[j])));
    //小惑星を描く
  }
  fill(255);
  text("Asteroid belt", width/2, height/2-210);
  //名前の表示
}


//ハレー彗星についての関数
//1つ目の引数は楕円軌道の中心x座標、2つ目の引数は楕円軌道の中心y座標
//3つ目の引数は楕円軌道の長軸の長さ、4つ目の引数は楕円軌道の短軸の長さ
void halley(float hx, float hy, float majorAxis, float minorAxis) {
  noFill();
  stroke(100);
  strokeWeight(1);
  ellipse(hx,hy,majorAxis,minorAxis);
  fill(150, 255, 255);
  stroke(0, 255, 255);
  strokeWeight(3);
  fill(0, 255, 255);
  //***ここで繰り返しを用いています***
  for (int i=9 ; i>=0 ; i--) {
    //間隔を5ずつ開けてガスを描く
    //***ここで配列を用いています***
    if (dustDist[i]>=(i+1)*5) {
      //ガスが本体から一定の距離離れたら、元の距離に戻す
      dustDist[i] -= 5;
    }
    colorMode(RGB, 256);
    //ガスの色に"透明度"のパラメータを追加
    fill((i+1)*10+155, 255, 255-(i+1)*10, 255-i*25);
    //ガスが彗星から遠ざかるほど色を薄くする
    noStroke();
    ellipse(hx+majorAxis/2*cos(radians(180-t)/76)+dustDist[i]*cos(radians(180-t)/76+radians(theta)), 
    hy+minorAxis/2*sin(radians(180-t)/76)+dustDist[i]*sin(radians(180-t)/76+radians(theta)), dustDiam[i], dustDiam[i] );
    //ガスを描く
    //***ここで条件分岐を用いています***
    if (p==1) {
      //アニメーションを行っている時はガスを彗星本体から遠ざける
      dustDist[i]++;
    } else {
      //アニメーションが停止しているときはガスを動かさない
      dustDist[i]+=0;
    }
  }

  fill(0, 255, 255);
  ellipse(hx+majorAxis/2*cos(radians(180-t)/76), hy+minorAxis/2*sin(radians(180-t)/76), 10, 10);
  //ハレー彗星本体を描く
  text("Halley's comet", hx+majorAxis/2*cos(radians(180-t)/76)+10, hy+minorAxis/2*sin(radians(180-t)/76));
  //ハレー彗星の名前の表示
}


//ボタンについての関数
//1つ目の引数はボタンの左上x座標、2つ目の引数はボタンの左上y座標
//3つ目の引数はボタンの横幅、4つ目の引数はボタンの縦幅
String motion;
void button(float x, float y, float lengthX, float lengthY) {//ボタンについての関数
  //***ここで条件分岐を用いています***
  if( mouseX>x && mouseX<x+lengthX && mouseY>y && mouseY<y+lengthY){
    //カーソルがボタンの内側にあれば、ボタンを押せる
    q=1;
  }else{
    //外側なら、ボタンは効かない
    q=0;
  }

  if (p==1) {
    //pが1(アニメ開始)の時"STOP"と表示、0(アニメ停止)の時"START"と表示
    motion=" STOP";
  }  else {
    motion="START";
  }

  stroke(0, 255, 255);
  strokeWeight(3);
  textSize(30);
  fill(0, 0, 255);
  rect(x, y, lengthX, lengthY);  //ボタンを描く
  fill(255, 255, 0);
  text(motion, x+20, y+30);  //"START/STOP"の文字を描く
}