/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package csvparapl;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.text.Normalizer;

public class CSVparaPL {
    
    

    
    
    public static void main(String[] args) throws IOException {

        String csvFile = "C:\\Users\\f6car\\Desktop\\Trabalho SRCR\\cidades.csv";
        BufferedReader br = null;
        String line = "";
        String cvsSplitBy = ",";
        FileWriter myWriter = new FileWriter("C:\\Users\\f6car\\Desktop\\Trabalho SRCR\\cidades.pl");

        try {

            br = new BufferedReader(new FileReader(csvFile));
            br.readLine();
            
            while ((line = br.readLine()) != null) {

                
                String[] country = line.split(cvsSplitBy);

                myWriter.write("cidade(" + country[0] + "," + '"' + country[1] + '"' + "," + country[2] + "," + country[3] + "," + '"' + country[4] + '"' + "," + '"' + country[5] + '"' + ")." +"\n");

            }
            myWriter.close();

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

    }
    
    
    

}

