#include <OneWire.h>
#include <DallasTemperature.h>

// Data wire is plugged into port 2 on the Arduino
#define ONE_WIRE_BUS 2
#define TEMPERATURE_PRECISION 9

// Setup a oneWire instance to communicate with any OneWire devices (not just Maxim/Dallas temperature ICs)
OneWire oneWire(ONE_WIRE_BUS);

// Pass our oneWire reference to Dallas Temperature. 
DallasTemperature sensors(&oneWire);

// arrays to hold device addresses
DeviceAddress insideThermometer, outsideThermometer;

void setup(void)
{
  // start serial port
  Serial.begin(9600);
  Serial.println("Dallas Temperature IC Control Library Demo");

  // Start up the library
  sensors.begin();

  // locate devices on the bus
  Serial.print("Locating devices...");
  Serial.print("Found ");
  Serial.print(sensors.getDeviceCount(), DEC);
  Serial.println(" devices.");

  // report parasite power requirements
  Serial.print("Parasite power is: "); 
  if (sensors.isParasitePowerMode()) Serial.println("ON");
  else Serial.println("OFF");

 
  if (!sensors.getAddress(insideThermometer, 0)) Serial.println("Unable to find address for Device 0"); 
  if (!sensors.getAddress(outsideThermometer, 1)) Serial.println("Unable to find address for Device 1"); 


  // show the addresses we found on the bus
  Serial.print("Device 0 Address: ");
  printAddress(insideThermometer);
  Serial.println();

   Serial.print("Device 1 Address: ");
  printAddress(outsideThermometer);
  Serial.println();

  // set the resolution to 9 bit
  sensors.setResolution(insideThermometer, TEMPERATURE_PRECISION);
  sensors.setResolution(outsideThermometer, TEMPERATURE_PRECISION);

  Serial.print("Device 0 Resolution: ");
  Serial.print(sensors.getResolution(insideThermometer), DEC); 
 Serial.println();

Serial.print("Device 1 Resolution: ");
 Serial.print(sensors.getResolution(outsideThermometer), DEC); 
Serial.println();
}

// function to print a device address
void printAddress(DeviceAddress deviceAddress)
{
  for (uint8_t i = 0; i < 8; i++)
  {
    // zero pad the address if necessary
    if (deviceAddress[i] < 16) Serial.print("0");
    Serial.print(deviceAddress[i], HEX);
  }
}

// function to print the temperature for a device
void printTemperature(DeviceAddress deviceAddress)
{
  float tempC = sensors.getTempC(deviceAddress);
  Serial.print("\"temp_c\":");
  Serial.print("\"");
  Serial.print(tempC);
  Serial.print("\",\n");
  Serial.print("\"temp_f\":");
  Serial.print("\"");
  Serial.print(DallasTemperature::toFahrenheit(tempC));
  Serial.print("\"\n");
}

// function to print a device's resolution
void printResolution(DeviceAddress deviceAddress)
{
  Serial.print("Resolution: ");
  Serial.print(sensors.getResolution(deviceAddress));
  Serial.println();    
}

// main function to print information about a device
void printData(DeviceAddress deviceAddress)
{
  Serial.print("\n\{");
  Serial.print("\"device_address\":");
  Serial.print("\"");
  printAddress(deviceAddress);
  Serial.print("\",\n");
//  Serial.print(" ");
  printTemperature(deviceAddress);
//  Serial.println();
Serial.print("\},\n");
}

void loop(void)
{ 
  
   
    
    // look for the newline. That's the end of your
    // sentence:
    if (Serial.read() == '\n') {
  
  
  // call sensors.requestTemperatures() to issue a global temperature 
  // request to all devices on the bus
 // Serial.print("Requesting temperatures...");
  sensors.requestTemperatures();
  Serial.println("\{\"messtellen\":[");

  // print the device information
  printData(insideThermometer);
  printData(outsideThermometer);
 
 
 
 
  Serial.print("\n\{");
  Serial.print("\"device_address\":");
  Serial.print("\"");
  Serial.print("0000000000000000");
    Serial.print("\",\n");
  
  
  
  
  Serial.print("\"temp_c\":");
  Serial.print("\"");
  Serial.print("00.00");
    Serial.print("\",\n");
    
    
 
  Serial.print("\"temp_f\":");
  Serial.print("\"");
  Serial.print("00.00");
    Serial.print("\"\n");
  
  
 
//  Serial.println();
Serial.print("\}\n");
 
  

Serial.println("]}");  

}
}
