/**
 * @brief SPI master for byte example, communicates with FPGA over SPI interface
 * @file  arduino-spi_byte.ino
 * Platform: Arduino 101 or 3.3 Volt Arduino UNO R3 using Arduino IDE
 * Documentation: https://coertvonk.com/hw/math-talk/bytes-exchange-with-arduino-as-master-30816
 *
 * Demonstrates byte exchange with FPGA where Arduino is the SPI master
 *   - Waits for the serial port to be connected (115200 baud)
 *   - The Arduino sends an alternating pattern of 0xAA and 0x55 to the FPGA.
 *   - On the FPGA, LED[0] will be on when it receives 0xAA.  Consequentially it will blink with 10% duty cycle.
 *   - The FPGA always returns 0x55, what is displayed on the serial port.
 *   
 * The protocol is specified at https://coertvonk.com/hw/math-talk/bytes-exchange-protocol-30814
 * 
 *           Arduino   Xilinx    Altera
 *                     FPGA J#4  GPIO_0
 * ssFPGA    10        J4#1      JP1#4
 * MOSI      11        J4#2      JP1#6
 * MISO      12        J4#3      JP1#8
 * SCK       13        J4#4      JP1#10
 * GND       GND       J4#5      JP1#12
 *
 * Tested versions:
 *   - Arduino IDE 1.8.19
 *   - Intel Curie Boards support package 2.0.5
 *
 * GNU GENERAL PUBLIC LICENSE Version 3, check the file LICENSE for more information
 * (c) Copyright 2015-2022, Coert Vonk
 * All rights reserved.  Use of copyright notice does not imply publication.
 * All text above must be included in any redistribution
 **/

#include <SPI.h>

uint8_t const ssFPGA = 10;


void setup()
{
    pinMode(ssFPGA, OUTPUT);
    digitalWrite(ssFPGA, 0);
    SPI.begin();
    
    Serial.begin(115200);
	  while (!Serial) {
		    ; // wait
	  }
  	Serial.println("spi_byte");
}
//
//void loop() 
//{
//    digitalWrite(ssFPGA, 0);
//    for ( uint8_t ii = 0; ii < 10; ii++) {
//        //delay( 10 );
//        SPI.beginTransaction( SPISettings( 4000000, MSBFIRST, SPI_MODE3 ) );
//        {
//            (void)SPI.transfer(ii == 0 ? 0xAA : 0x55 );
//        }
//        SPI.endTransaction();
//    }
//    digitalWrite(ssFPGA, 1);
//
//  	static int ii = 0;
//	  if (++ii % 1024 == 0) {
//		    Serial.print(".");  // show a sign of life
//	  }
//}




unsigned int readRegister(byte thisRegister, int bytesToRead) {
  byte inByte = 0;           // incoming byte from the SPI
  unsigned int result = 0;   // result to return
//  Serial.print(thisRegister, BIN);
//  Serial.print("\t");
  // SCP1000 expects the register name in the upper 6 bits
  // of the byte. So shift the bits left by two bits:
  //thisRegister = thisRegister << 2;
  // now combine the address and the command into one byte
  byte dataToSend = thisRegister;
  //Serial.println(thisRegister, BIN);
  // take the chip select low to select the device:

  // send the device the register you want to read:
  Serial.print("Register reading from: ");
  Serial.println(dataToSend,BIN);
  
  SPI.beginTransaction(SPISettings(1000000,MSBFIRST,SPI_MODE3));
  digitalWrite(ssFPGA, LOW);
  result = SPI.transfer(dataToSend);
  // send a value of 0 to read the first byte returned:
  //result = SPI.transfer(0x00);
  // decrement the number of bytes left to read:
  bytesToRead--;
  // if you still have another byte to read:
  if (bytesToRead > 0) {
    // shift the first byte left, then get the second byte:
    result = result << 8;
    inByte = SPI.transfer(0x00);
    // combine the byte you just got with the previous one:
    result = result | inByte;
    // decrement the number of bytes left to read:
    bytesToRead--;
  }
    digitalWrite(ssFPGA, HIGH);
    SPI.endTransaction();

  return(result);
}

  void writeRegister(byte thisRegister, byte thisValue) {

  // SCP1000 expects the register address in the upper 6 bits
  // of the byte. So shift the bits left by two bits:
  //thisRegister = thisRegister << 2;
  // now combine the register address and the command into one byte:
  byte dataToSend = thisRegister;

  SPI.beginTransaction(SPISettings(1000000,MSBFIRST,SPI_MODE3));

    // take the chip select low to select the device:
  digitalWrite(ssFPGA, LOW);

  SPI.transfer(dataToSend); //Send register location
  SPI.transfer(thisValue);  //Send value to record into register

  // take the chip select high to de-select:
  digitalWrite(ssFPGA, HIGH);

  SPI.endTransaction();

}



void loop(){

  byte valueSend = 255;
  Serial.print("Sending byte:");
  Serial.println(valueSend, BIN);
  writeRegister(0xAA, valueSend);
  byte valueRead = readRegister(0xAA,1);
  Serial.print("Received byte: ");
  Serial.println(valueRead);

  delay(1000);

}
