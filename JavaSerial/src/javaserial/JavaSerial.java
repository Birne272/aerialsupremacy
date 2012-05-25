/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package javaserial;
import gnu.io.*;
import java.io.*;
import java.util.Enumeration;

/**
 *
 * @author SAM
 */
public class JavaSerial {
    
    private static Enumeration        portList;
    private static CommPortIdentifier portId;
    private static String             messageString = "Hello, world!";
    private static SerialPort         serialPort;
    private static OutputStream       outputStream;
    private static InputStream        inputStream; 
    private static boolean            outputBufferEmptyFlag = false;
    
    private static BufferedReader reader = null;
    final private static String dir = "sampledata/";
   
    
    public static void main(String[] args) {
        String defaultPort = "COM9";
        
        try{
            String filename = "data";
            //String filename = "sample.txt";
            reader = new BufferedReader(new FileReader(dir+filename));
        } catch(FileNotFoundException ex) {
            System.err.format("FileNotFoundException: %s%n",ex);
        }
        int data[] = new int[41000];
        int temp=0,temp2,k,i=0;
        try {
            while (temp != -1) {   
                k = 100;
                temp2=0;
                do { 
                     temp = reader.read();
                     if (temp>='0'&&temp<='9'){
                         temp2+=(temp-(int) '0')*k;
                         k/=10;
                     }
                } while (temp != (int) ' ');
                if(k==1)temp2/=10;
                i++;
                data[i]=temp2;
            } 
        } catch (Exception e) {
            System.err.println(e);
        }
        
        portList = CommPortIdentifier.getPortIdentifiers();
        boolean portFound = false;
        while (portList.hasMoreElements()) {
            portId = (CommPortIdentifier) portList.nextElement();
 
            if (portId.getPortType() == CommPortIdentifier.PORT_SERIAL) {
 
                if (portId.getName().equals(defaultPort)) {
                    System.out.println("Found port " + defaultPort);
 
                    portFound = true;
 
                    try {
                        serialPort =
                            (SerialPort) portId.open("SimpleWrite", 2000);
                    } catch (PortInUseException e) {
                        System.out.println("Port in use.");
                        continue;
                    }
 
                    try {
                        outputStream = serialPort.getOutputStream();
                        inputStream = serialPort.getInputStream();
                    } catch (IOException e) {}
 
                    try {
                        serialPort.setSerialPortParams(9600,
                                                       SerialPort.DATABITS_8,
                                                       SerialPort.STOPBITS_1,
                                                       SerialPort.PARITY_NONE);
                    } catch (UnsupportedCommOperationException e) {}
       
 
                    try {
                        serialPort.notifyOnOutputEmpty(true);
                    } catch (Exception e) {
                        System.out.println("Error setting event notification");
                        System.out.println(e.toString());
                        System.exit(-1);
                    }
                   
                   
                    System.out.println("TX Started");
 
                                           
                    for (int idx = 0; idx < data.length; idx++) {
                        if(idx%1000==0){System.out.println("--"+idx);}
                        try {
                            outputStream.write(data[idx]);
                        } catch (IOException ex) {}
                    }
                                      
                    System.out.format("Success: %d char sent\n",data.length);
                    
                    try {
                       Thread.sleep(2000);  // Be sure data is xferred before closing
                    } catch (Exception e) {}
                    serialPort.close();
                    System.exit(1);
                }
            }
        }
 
        if (!portFound) {
            System.out.println("port " + defaultPort + " not found.");
        }
       
    }
}
