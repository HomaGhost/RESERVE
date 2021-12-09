import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


//javac -encoding utf8 L3E2.java
public class L3E2 {
    public static void main(String[] args) {
		List<String[]> lines = new ArrayList<String[]>();
		int start_ind = 1;
		int min_num;
        try {
            Reader reader = new FileReader("L3E2.csv");
            BufferedReader buffReader = new BufferedReader(reader);
            String line;
            while((line = buffReader.readLine()) != null) {
                String[] line_arr_str = line.split(";");
				lines.add(line_arr_str);
            }
			
			min_num = Integer.parseInt(lines.get(0)[start_ind]);
			for(int i = 0; i < lines.size(); ++i){
				for(int j = start_ind; j < lines.get(i).length; ++j){
					if(min_num > Integer.parseInt(lines.get(i)[j]))
						min_num = Integer.parseInt(lines.get(i)[j]);
				}	
				++start_ind;
			}
			
			for(int i = 0; i < lines.size(); ++i){
				for(int j = 0; j < lines.get(i).length; ++j){
					if(min_num == Integer.parseInt(lines.get(i)[j])){
						String output = String.format("Элемент %s, с индексом %d,%d ", lines.get(i)[j], i, (i * lines.get(i).length + j )%4);   //
						System.out.println(output);
					}
					
				
				}	
			   
			}
			buffReader.close();
        } catch(FileNotFoundException e) {
            System.out.println("Файл не найден");
        } catch(IOException e) {
            System.out.println("Ошибка ввода-вывода");
        }				 
    }
}