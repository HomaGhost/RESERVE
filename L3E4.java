import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;

import java.util.Scanner;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.HashSet;


//entities
public class L3E4 {
    public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		HashSet<Integer> firstSet = new HashSet<>();
		HashSet<Integer> firstSetBuf = new HashSet<>();
		HashSet<Integer> secondSet = new HashSet<>();
		String line; 
		List<String> sets = new ArrayList<String>();
		
		int min_set_1 = 0;
		int min_set_2 = 1;
		int min_length = -1;
		int set_num = 1;
		if(args[0].equals("console")){	
			do{
				System.out.print("Введите элементы множества " + set_num + " через пробел: ");
				line = scanner.nextLine();
				sets.add(line);
				++set_num;
			}while(!line.equals(""));
			sets.remove("");
		}
		else if(args[0].equals("file")){
			try {
            Reader reader = new FileReader("file.txt");
            BufferedReader buffReader = new BufferedReader(reader);
            String line_f;
            while((line_f = buffReader.readLine()) != null)
                sets.add(line_f);
            buffReader.close();
			} 
			catch(FileNotFoundException e){
				System.out.println("Файл не найден");
			}
			catch(IOException e){
				System.out.println("Ошибка ввода-вывода");
			}
		}
		
		for(int i = 0; i < sets.size(); ++i){
			String[] one_set = sets.get(i).split(" "); 
			for(int k = 0; k < one_set.length; ++k)
				firstSet.add(Integer.parseInt(one_set[k]));	
			for(int j = i + 1; j < sets.size() - 1; ++j){
				one_set = sets.get(j).split(" ");
				for(int k = 0; k < one_set.length; ++k)
					secondSet.add(Integer.parseInt(one_set[k]));
				
				firstSetBuf = firstSet;
				for(int l = 0; l < secondSet.size(); ++l)
					firstSetBuf.addAll(secondSet);
				if(min_length == -1){
					min_length = firstSetBuf.size();
					min_set_1 = i;
					min_set_2 = j;
				}
				else if(firstSetBuf.size() < min_length){
					min_length = firstSetBuf.size();
					min_set_1 = i;
					min_set_2 = j;
				}
				secondSet.clear();
				firstSetBuf.clear();
			}
			firstSet.clear();
		}
		System.out.print("Минимальное пересечение у множеств: " + (min_set_1 + 1) + " and " + (min_set_2 + 1));
    }
}