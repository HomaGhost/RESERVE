import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.Scanner;
import java.util.Comparator;

//javac -encoding utf8 L3E3.java
class Student{
	private String stud_name;
	private int kurs;
	private String subj_name;
	private int mark;
	private double middle_mark;
	
	public String GetStudName(){
		return stud_name;
	}
	public int GetKurs(){
		return kurs;
	}
	public String GetSubjName(){
		return subj_name;
	}
	public int GetMark(){
		return mark;
	}
	
	public double GetMiddleMark(){
		return middle_mark;
	}
	
	public void SetStudName(String name){
		stud_name = name;
	}
	public void SetKurs(int kurs){
		this.kurs = kurs;
	}
	public void SetSubjName(String name){
		subj_name = name;
	}
	public void SetMark(int mark){
		this.mark = mark;
	}
	
	public void SetMiddleMark(double mark){
		middle_mark = mark;
	}
	
	public String StudToString(){
		String stud_info = stud_name + ";" + kurs + ";" + subj_name + ";" + mark;
		return stud_info;
	}
	
	public Student StringToStud(String str){
		String[] parts = str.split(";");
		Student stud = new Student();
		stud.stud_name = parts[0];
	    stud.kurs = Integer.parseInt(parts[1]);
		stud.subj_name = parts[2];
		stud.mark = Integer.parseInt(parts[3]);
		return stud;
	}
}

public class L3E3 {
    @SuppressWarnings("unchecked")
    public static void main(String[] args) {
		int task_num = 0;
		int line_num = 0;
		Scanner scanner = new Scanner(System.in);
		Student stud = new Student();
        List entities;
		List students = new ArrayList<>();
        try {
            InputStream is = new FileInputStream("L3E3.bin");
            ObjectInputStream ois = new ObjectInputStream(is);
            entities = (List)ois.readObject();
            ois.close();
        } catch(IOException | ClassNotFoundException e) {
            entities = new ArrayList<>();
        }
		
		do{
			System.out.println("Что вы хотите сделать?\n1. Прочесть файл\n2. Записать в файл \n3. Редактировать файл \n4. Удалить данные \n5. Сформировать списки \n6. Выйти");
			task_num = scanner.nextInt();
			if(task_num == 1)
				System.out.println(entities);
			else if(task_num == 2){
				SetStud(scanner, stud);
				entities.add(stud.StudToString());
			}
			else if(task_num == 3){
				if(entities.size() != 0){
					do{
						System.out.println("Введите номер данных для редактирования");
						line_num = scanner.nextInt();
					}
					while(line_num <= 0|| line_num > entities.size());
					
					SetStud(scanner, stud);
					entities.set(line_num - 1, stud.StudToString());
				}
			}
			
			else if(task_num == 4){
				if(entities.size() != 0){
					System.out.println("Введите номер данных для удаления");
					line_num = scanner.nextInt();
					
					if(line_num > 0 && line_num < entities.size()){
						System.out.println("Deleted");
						entities.remove(line_num - 1);
					}
					else
						System.out.println("Not found");
				}
			}
			
			else if(task_num == 5){
				for(int i = 0; i < entities.size(); ++i){
					String str = (String)entities.get(i);
					students.add(stud.StringToStud(str));
				}
				students.sort(Comparator.comparing(Student::GetKurs)); // Сортируем студентов по курсу
				//Student std = (Student)students.get(0);
				//System.out.println(std.GetKurs() + " ");
				
				List deducted_students = new ArrayList<>(); // Отчисленные
				List problem_students = new ArrayList<>(); // Проблемные
				List best_students = new ArrayList<>(); // Лучшие
				List best_students_obj = new ArrayList<>();
				for(int i = 0; i < students.size(); ++i){
					Student std = (Student)students.get(i);
					String std_name = std.GetStudName();
					int middle_mark = 0;
					int num_of_marks = 0;
					boolean check_middle_mark = true;
					int num_of_failed = 0;
					if(std.GetMark() < 4){
						check_middle_mark = false;
						num_of_failed ++;
						//System.out.println("Студент " + std.GetStudName());
						//System.out.println("Провалено " + num_of_failed);
					}
					else{
						middle_mark += std.GetMark();
						num_of_marks++;
					}
					for(int j = i + 1; j < students.size(); ++j){
						Student std_2 = (Student)students.get(j);
						String std_2_name = std_2.GetStudName();
						if(std_2_name.equals(std_name)){
							if(std_2.GetMark() < 4){
								num_of_failed ++;
								check_middle_mark = false;
								//System.out.println("Студент " + std.GetStudName());
								//System.out.println("Провалено " + num_of_failed);
							}
							else if(check_middle_mark){
								middle_mark += std.GetMark();
								num_of_marks++;
							}
						}
						if(std_2.GetKurs() != std.GetKurs())
							break;
					}
					//System.out.println("Студент " + std.GetStudName());
					//System.out.println("Провалено " + num_of_failed);
				
					if(num_of_failed >= 3 && !deducted_students.contains(std.GetStudName()))
						deducted_students.add(std.GetStudName());
					else if(!check_middle_mark && !deducted_students.contains(std.GetStudName()))
						problem_students.add(std.GetStudName());
					else if(check_middle_mark && !deducted_students.contains(std.GetStudName())){
						std.SetMiddleMark(middle_mark / num_of_marks);
						best_students.add(std.GetStudName());
						best_students_obj.add(std);
					}
				}
				System.out.println("Отчислены: ");
				for(int i = 0; i <  deducted_students.size(); ++i){
					String stud_name = (String)deducted_students.get(i);
					System.out.println("Студент " + stud_name);
				}
				
				System.out.println("Проблемы у: ");
				for(int i = 0; i <  problem_students.size(); ++i){
					String stud_name = (String)problem_students.get(i);
					System.out.println("Студент " + stud_name);
				}
				
				int curr_kurs = 1;
				List best_students_kurs = new ArrayList<>();
				while(best_students_obj.size() > 0){
					Student std = (Student)best_students_obj.get(0);
					int std_kurs = std.GetKurs();
					System.out.println("Лучшие студенты курса " + curr_kurs);
					for(int i = 0; i < best_students_obj.size(); ++i){
						std = (Student)best_students_obj.get(i);
						std_kurs = std.GetKurs();
						if(std_kurs == curr_kurs){
							best_students_kurs.add(best_students_obj.get(i));
							best_students_kurs.sort(Comparator.comparing(Student::GetMiddleMark).reversed());
						}
					}
					for(int i = 0; i < best_students_kurs.size(); ++i)
						best_students_obj.remove(best_students_kurs.get(i));
					for(int i = 0; i < best_students_kurs.size(); ++i){
						Student best_stud = (Student)best_students_kurs.get(i);
						System.out.println("Студент " + best_stud.GetStudName() + " с баллом " + best_stud.GetMiddleMark());
					}
					//System.out.println("Лучших студентов осталось " + best_students_obj.size());
					++curr_kurs;
					best_students_kurs.clear();
				}	
				deducted_students.clear();
				problem_students.clear();
				best_students.clear();
				best_students_obj.clear();
				students.clear();
			}
			
			try {
            OutputStream os = new FileOutputStream("L3E3.bin");
            ObjectOutputStream oos = new ObjectOutputStream(os);
            oos.writeObject(entities);
            oos.close();
			} catch(IOException e){
				System.out.println("Невозможно сохранить файл");
			}
		}
		while(task_num != 6);
    }
	
	static void SetStud(Scanner scanner, Student stud){
		System.out.println("Введите имя студента");
		scanner.nextLine();
		stud.SetStudName(scanner.nextLine());
				
		System.out.println("Введите курс студента");
		stud.SetKurs(scanner.nextInt());
				
		System.out.println("Введите название предмета");
		scanner.nextLine();
		stud.SetSubjName(scanner.nextLine());
				
		System.out.println("Введите оценку");
		stud.SetMark(scanner.nextInt());
	}
}