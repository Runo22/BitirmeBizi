// Motor A connections
#define enA = 9;
#define in1 = 8;
#define in2 = 7;
// Motor B connections
#define enB = 3;
#define in3 = 5;
#define in4 = 4;

String data, gelen, yonG, hizG;
int yon, hiz;

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
}

void loop() {
  if(Serial.available() > 0){
    gelen = Serial.read();
    data = data + gelen;
    if(gelen == "10"){              //10 = Line feed
      yonG = data.substring(0,2);
      hizG = data.substring(2,4);
      if(hizG != "13"){             //13 = Carriage return
        hiz = hizG.toInt();
        yon = yonG.toInt();
      }
      data = "";  //?
    }
  }



  
  if(yon == 48){
    Serial.print("dur - ");
    Serial.println(hiz);
    dur();
  }
  else if(yon == 49){
    Serial.print("ileri - ");
    Serial.println(hiz);
    ileri();
  }
  
  else if(yon == 50){
    Serial.print("sol - ");
    Serial.println(hiz);
    sol();
  }
  else if(yon == 51){
    Serial.print("geri - ");
    Serial.println(hiz);
    geri();
  }
  
  else if(yon == 52){
    Serial.print("sag - ");
    Serial.println(hiz);
    sag();
  }
  else{
    Serial.print("def - ");
    Serial.println(hiz);
    dur();
  }
}


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

void yavasla(){
  
    
  
  
  }
