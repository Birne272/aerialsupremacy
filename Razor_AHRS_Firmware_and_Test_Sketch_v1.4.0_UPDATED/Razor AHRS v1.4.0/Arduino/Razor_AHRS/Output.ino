/* This file is part of the Razor AHRS Firmware */
void print3digit(int x)
{
  if(x>999){
    x=999;
  }
  if(x<10)
   {
     Serial.print('0');
   }
  if(x<100)
  {
     Serial.print('0');
  }
  Serial.print(x);   
}

// Output angles: yaw, pitch, roll
void output_angles()
{
  if (output_mode == OUTPUT__MODE_ANGLES_BINARY)
  {
    float ypr[3];  
    ypr[0] = TO_DEG(yaw);
    ypr[1] = TO_DEG(pitch);
    ypr[2] = TO_DEG(roll);
    Serial.write((byte*) ypr, 12);  // No new-line
  }
  else if (output_mode == OUTPUT__MODE_ANGLES_TEXT)
  {
      Serial.print("#YPR=");
      Serial.print(((int)TO_DEG(yaw))); Serial.print(",");
      Serial.print(((int)TO_DEG(pitch))); Serial.print(",");
      Serial.print(((int)TO_DEG(roll))); Serial.println();
  }
  else if (output_mode == KOMURINDOH)
  {
      float ypr[3];  
      ypr[0] = (int)TO_DEG(yaw);
      ypr[1] = (int)TO_DEG(pitch);
      ypr[2] = (int)TO_DEG(roll);
      for(int i=0; i<3;++i){
        if(ypr[i]<0){
          ypr[i]+=360;
        }
      }
      
      int acctemp[3];  
      acctemp[0]=(int)((accel[0]+2000)/4);
      acctemp[1]=(int)((accel[1]+2000)/4);
      acctemp[2]=(int)((accel[2]+2000)/4);
      
      /////////
      /*
     
      Serial.print("303");
      Serial.print(" ");
      print3digit(ypr[0]);//psi
      Serial.print(" ");
      print3digit(ypr[1]);//theta
      Serial.print(" ");
      print3digit(ypr[2]);//phi
      Serial.print(" ");
      */
      ///*
      Serial.print("303");
      Serial.print(" ");
      print3digit(acctemp[0]);
      Serial.print(" ");
      print3digit(acctemp[1]);
      Serial.print(" ");
      print3digit(acctemp[2]);
      Serial.print(" ");
      //*/
      
      int temp = (((int)(ypr[0]/4))*10)+((int)(ypr[1]/40));
      print3digit(temp);
      Serial.print(" ");
      temp = (((int)(ypr[1]/4))%10)*100+((int)(ypr[2]/4));
      print3digit(temp);
      Serial.write(10);
      /////////

  }
}

void output_calibration(int calibration_sensor)
{
  if (calibration_sensor == 0)  // Accelerometer
  {
    // Output MIN/MAX values
    Serial.print("accel x,y,z (min/max) = ");
    for (int i = 0; i < 3; i++) {
      if (accel[i] < accel_min[i]) accel_min[i] = accel[i];
      if (accel[i] > accel_max[i]) accel_max[i] = accel[i];
      Serial.print(accel_min[i]);
      Serial.print("/");
      Serial.print(accel_max[i]);
      if (i < 2) Serial.print("  ");
      else Serial.println();
    }
  }
  else if (calibration_sensor == 1)  // Magnetometer
  {
    // Output MIN/MAX values
    Serial.print("magn x,y,z (min/max) = ");
    for (int i = 0; i < 3; i++) {
      if (magnetom[i] < magnetom_min[i]) magnetom_min[i] = magnetom[i];
      if (magnetom[i] > magnetom_max[i]) magnetom_max[i] = magnetom[i];
      Serial.print(magnetom_min[i]);
      Serial.print("/");
      Serial.print(magnetom_max[i]);
      if (i < 2) Serial.print("  ");
      else Serial.println();
    }
  }
  else if (calibration_sensor == 2)  // Gyroscope
  {
    // Average gyro values
    for (int i = 0; i < 3; i++)
      gyro_average[i] += gyro[i];
    gyro_num_samples++;
      
    // Output current and averaged gyroscope values
    Serial.print("gyro x,y,z (current/average) = ");
    for (int i = 0; i < 3; i++) {
      Serial.print(gyro[i]);
      Serial.print("/");
      Serial.print(gyro_average[i] / (float) gyro_num_samples);
      if (i < 2) Serial.print("  ");
      else Serial.println();
    }
  }
}

void output_sensors()
{
  Serial.print("#ACC=");
  Serial.print(accel[0]); Serial.print(",");
  Serial.print(accel[1]); Serial.print(",");
  Serial.print(accel[2]); Serial.println();

  Serial.print("#MAG=");
  Serial.print(magnetom[0]); Serial.print(",");
  Serial.print(magnetom[1]); Serial.print(",");
  Serial.print(magnetom[2]); Serial.println();

  Serial.print("#GYR=");
  Serial.print(gyro[0]); Serial.print(",");
  Serial.print(gyro[1]); Serial.print(",");
  Serial.print(gyro[2]); Serial.println();
}

