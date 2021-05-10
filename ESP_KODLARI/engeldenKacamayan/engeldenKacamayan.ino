#define echoPin 13;
#define trigPin 12;
long sure, uzaklık;
int sagSol = 0;

void setup() {
  pinMode(echoPin,INPUT);
  pinMode(trigPin,OUTPUT);

}

void loop() {
  //uzaklık sensoru olçum
  digitalWrite(trigPin, LOW);
  delayMicroseconds(5);
  digitalWrite(trigPin,HIGH)
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  sure = pulseIn(echoPin, HIGH);
  uzaklık = sure / 29.1 / 2;

  if(uzaklık < 15)    //TODO 
  {
    geri();
    delay(500);
    if(sagSol = 1)
    {
      sol();
      delay(500);
      sagSol = 0;
    }
    sag();
    delay(500);
    sagSol = 1;
  }
  else{
    ileri();
  }
}
