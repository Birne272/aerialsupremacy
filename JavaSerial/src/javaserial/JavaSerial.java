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
    //final private static String dir = "sampledata/";
   
    
    public static void main(String[] args) {
        String defaultPort = "COM9";
        
       
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
 
                    /*                       
                    try {
                        for (int i = 0; i < 256; i++) {
                            outputStream.write(i);
                        }
                    } catch (Exception e) {
                    }
                    */
                    
                     
                    try {
                        //String filename="sampledata/cam0706_1743.log";
                        //String filename = "sampledata/graksa_UF.log";
                        //String filename = "DataFinal/Graksa/GraksaUPCam.log";
                        String filename = "DataFinal/Raise/RaiseUPCam.log";
                        FileInputStream fin = new FileInputStream(filename);
                        DataInputStream din = new DataInputStream(fin);
                        System.out.println("Total data available : " + din.available() + " bytes");
                        while (din.available() > 0) {
                            int dtx = din.read();
                            outputStream.write(dtx);
                            //++x;
                        }

                    } catch (Exception e) {
                    }
                    
                    
//                    
//                    try {
//                        outputStream.write(0xD);
//                        outputStream.write('3');
//                        outputStream.write('0');
//                        outputStream.write('3');
//                        outputStream.write(0xFF);
//                        outputStream.write(0xD);
//                        for (int i=1;i<201;++i){
//                            
//                            outputStream.write(0xFF);
//                            outputStream.write('0'+i/100);
//                            outputStream.write('0'+(i/10)%10);
//                            outputStream.write('0'+(i%10));
//                            
//                            for (int j = 1; j < 201; j++) {
//                              outputStream.write(255-j);
//                            }
//                            
//                            outputStream.write(0xFF);
//                            outputStream.write('0'+(360-i)/100);
//                            outputStream.write('0'+((360-i)/10)%10);
//                            outputStream.write('0'+((360-i)%10));
//                        }
//
//                    } catch (Exception e) {
//                    }
                    
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
