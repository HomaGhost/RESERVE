import java.util.Scanner;


//javac -encoding utf8 L3E1.java
//2,7182818284
//java L3E1

public class L3E1 {
    public static void main(String[] args) {
		int arr_size = 0;
		int task = 0;
		double[] arr = new double[0];
        Scanner scanner = new Scanner(System.in);
		do{
			System.out.println("1.заполнение массива случайным образом ");
			System.out.println("2.ввод элементов массива с клавиатуры");
			System.out.println("3.вывод элементов массива на экран ");
			System.out.println("4.обработка массива ");
			System.out.println("5.изменение массива ");
			System.out.println("6.выход из программы ");
		
			task = scanner.nextInt();
			if(task == 1){
				System.out.print("Введите длину массива: ");
				arr_size = scanner.nextInt();
				arr = new double[arr_size];
				for(int i = 0; i < arr_size; ++i)
					arr[i] = Math.random() * 1000;
			}
			
			if(task == 2){
				System.out.print("Введите длину массива: ");
				arr_size = scanner.nextInt();
				arr = new double[arr_size];
				for(int i = 0; i < arr_size; ++i){
					System.out.print("Введите элемент массива: ");
					arr[i] = scanner.nextDouble();
				}
			}
			
			else if(task == 3){
				System.out.print("Массив: ");
				for(int i = 0; i < arr_size; ++i){
					String arr_i = String.format("%.5f ", arr[i]);
					System.out.print(arr_i);
				}
				System.out.println(" ");
			}
			
			else if(task == 4){
				double sum = 0;
				int first = -1;
				int last = -1;
				for(int i = 0; i < arr_size; ++i){
					if(first == -1 && Math.abs(arr[i] - Math.E) <= 0.00001)
						first = i;
					if(first != -1 && Math.abs(arr[i] - Math.E) <= 0.00001)
						last = i;
				}
				if(first == -1 || last == -1)
					System.out.print("Недостаточно элементов ");
				else{
					for(int i = first + 1; i < last; ++i)
						sum += arr[i];
					System.out.print("Сумма элементов: " + sum);
				}
				System.out.println(" ");
			}

			else if(task == 5){
				int new_size = 0;
				double[] buf_arr = new double[arr_size];
				for(int i = 0; i < arr_size; ++i){
					int full_part = Math.abs((int)arr[i]);
					int sum = 0;
					boolean is_easy = true;
					// Находим сумму цифр целой части числа
					while(full_part > 0){
						sum += full_part % 10;
						full_part /= 10;
					}
					// Проверяем сумму цифр целой части на простоту
					if(sum <= 1)
						is_easy = false;
					else{
						for(int j = 2; j < sum; ++j){
							if(sum % j == 0){
								is_easy = false;
								break;
							}
						}
					}
					// Заполняем буферный массив элементами с не простой суммой цифр
					if(!is_easy){
						buf_arr[new_size] = arr[i];
						++new_size;
					}
				}
				// Переопределяем начальный массив и  заполняем элементами буферного массива
				arr = new double[new_size];
				for(int i = 0; i < new_size; ++i)
					arr[i] = buf_arr[i];
				arr_size = new_size;
				System.out.println(" ");
			}
			else
				continue;
			
		}while(task != 6);

    }
}