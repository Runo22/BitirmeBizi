// Motor A
#define enA 9
#define in1 8
#define in2 7
// Motor B
#define enB 3
#define in3 5
#define in4 4

String data, gelen, yon;
int hiz;

//Otonom için
#define echoPin 13
#define trigPin 12
long sure, uzaklik;
int sagSol = 0;
bool doesOtonom = false;

void setup() {
  Serial.begin(9600);
  
  pinMode(enA, OUTPUT);
  pinMode(enB, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);

  digitalWrite(in1, LOW);
  digitalWrite(in2, LOW);
  digitalWrite(in3, LOW);
  digitalWrite(in4, LOW);

  //otonom için
  pinMode(echoPin,INPUT);
  pinMode(trigPin,OUTPUT);
}

void loop() { 
  if(Serial.available() > 0){
    gelen = Serial.read();
    data = data + gelen;
    //Serial.print(data);
    if(gelen == "42"){  // 42 => * 
      yon = data.substring(0,2);
      hiz = data.substring(2,4).toInt();
      // Serial.print(yon);
      // Serial.print(hiz);
      data = "";
      }
    else if(gelen == "79"){
      doesOtonom = true;
    }
  }

   //ELLE SURUS KODLARI
  if(doesOtonom == false){
    checkSpeed();
    if(yon == "48"){
      dur();
    }
    else if(yon == "49"){
      ileri();
    }
    
    else if(yon == "50"){
      sol();
    }
    else if(yon == "51"){
      geri();
    }
    
    else if(yon == "52"){
      sag();
    }
  }

  // OTONOM SURUS KODLARI
    else if(doesOtonom == true){
      //uzaklık sensoru olcum
      digitalWrite(trigPin, LOW);
      delayMicroseconds(5);
      digitalWrite(trigPin,HIGH);
      delayMicroseconds(10);
      digitalWrite(trigPin, LOW);
    
      sure = pulseIn(echoPin, HIGH);
      uzaklik = sure / 29.1 / 2;
    
      if(uzaklik < 15)
      {
        geri();
        delay(500);
        if(sagSol = 1)
        {
          sol();
          delay(500);
          sagSol = 0;
          doesOtonom = false;
          Serial.print("M"); // manuele gecmek icin
        }
        else{
          sag();
          delay(500);
          sagSol = 1; 
        } 
      }
      else{
        ileri();
      }
    } 
}

//MOTOR kontrol kodları
void dur(){
  digitalWrite(in1, LOW);
  digitalWrite(in2, LOW);
  digitalWrite(in3, LOW);
  digitalWrite(in4, LOW);
}
void ileri(){
  analogWrite(enA, hiz);
  analogWrite(enB, hiz);
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);
  digitalWrite(in3, HIGH);
  digitalWrite(in4, LOW);
}
void geri(){
  analogWrite(enA, hiz);
  analogWrite(enB, hiz);
  digitalWrite(in1, LOW);
  digitalWrite(in2, HIGH);
  digitalWrite(in3, LOW);
  digitalWrite(in4, HIGH);
}
void sol(){
  analogWrite(enA, 0);
  analogWrite(enB, hiz);
  digitalWrite(in1, LOW);
  digitalWrite(in2, LOW);
  digitalWrite(in3, HIGH);
  digitalWrite(in4, LOW);
}
void sag(){
  analogWrite(enA, hiz);
  analogWrite(enB, 0);
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);
  digitalWrite(in3, LOW);    
  digitalWrite(in4, LOW);
}

int checkSpeed(){
  if(hiz == 48){
    hiz = 0;
    }
    else if(hiz == 49){
    hiz = 126;
    }
    else if(hiz == 50){
    hiz = 255;
    }
    return hiz;
  }