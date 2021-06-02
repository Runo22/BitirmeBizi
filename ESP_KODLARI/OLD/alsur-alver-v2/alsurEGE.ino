// Motor A connections
#define enA 9
#define in1 8
#define in2 7
// Motor B connections
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
    if(gelen == "42"){
      //Serial.print("Konyalı mısın?");
      yon = data.substring(0,2);
      hiz = data.substring(2,4).toInt();
      Serial.print(yon);
      Serial.print(hiz);
      data = "";
      }
    else if(gelen == "79"){
      doesOtonom = true;
    }
  }


   //ELLE SURUS KODLARI
  if(doesOtonom == false){
    if(yon == "48"){
      Serial.print("dur - ");
      Serial.println(hiz);
      dur();
    }
    else if(yon == "49"){
      Serial.print("ileri - ");
      Serial.println(hiz);
      ileri();
    }
    
    else if(yon == "50"){
      Serial.print("sol - ");
      Serial.println(hiz);
      sol();
    }
    else if(yon == "51"){
      Serial.print("geri - ");
      Serial.println(hiz);
      geri();
    }
    
    else if(yon == "52"){
      Serial.print("sag - ");
      Serial.println(hiz);
      sag();
    }
//    else{
//      Serial.print("Sokacam calıs");
//      dur();
//    }
  }

  // OTONOM SURUS KODLARI
    else if(doesOtonom == true){
      //uzaklık sensoru olçum
      digitalWrite(trigPin, LOW);
      delayMicroseconds(5);
      digitalWrite(trigPin,HIGH);
      delayMicroseconds(10);
      digitalWrite(trigPin, LOW);
    
      sure = pulseIn(echoPin, HIGH);
      uzaklik = sure / 29.1 / 2;
    
      if(uzaklik < 15)    //TODO 
      {
        geri();
        delay(500);
        if(sagSol = 1)
        {
          sol();
          delay(500);
          sagSol = 0;
          doesOtonom = false;
          Serial.print("M");
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
    Serial.println("Gitti galiba");
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
void geri(){                //Geri hizi sabit bir değere atanabilir.
  analogWrite(enA, hiz);
  analogWrite(enB, hiz);
  digitalWrite(in1, LOW);
  digitalWrite(in2, HIGH);
  digitalWrite(in3, LOW);
  digitalWrite(in4, HIGH);
}
void sol(){                 //Duruma göre 0 hiz yapılıp a motorun dönme yönü ters çevrilir.
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
