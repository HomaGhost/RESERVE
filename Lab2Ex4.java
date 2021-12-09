import java.util.Arrays;

// javac -encoding utf8 Lab2Ex4.java
// java  Lab2Ex4 Россия 31.12.2031 01.12.2031 11.01.1981 12.05.0006
//java Lab2Ex4 Великобритания 12/10/2002 13/10/2002 15/10/2002 16/10/2002 17/10/2002 18/10/2002
public class Lab2Ex4{
	public static void main(String[] args) {
		DateSaver[] date_parts = new DateSaver[args.length - 1];
		DateHandler date_handl = new DateHandler();
		if(args[0].equals("Россия"))
			date_handl = new RussiaDateFormat();
		else if(args[0].equals("Канада"))
			date_handl = new CanadaDateFormat();
		else if(args[0].equals("Великобритания"))
			date_handl = new BritainDateFormat();
		
		
		for(int i = 1; i < args.length; ++i)
			date_parts[i - 1] =  date_handl.StringToDate(args[i]);
		DateSaver big_date = date_handl.BiggestAndLowestDates(date_parts, true);
		DateSaver low_date = date_handl.BiggestAndLowestDates(date_parts, false);
		DateSaver mid_date = date_handl.GetMiddleDate(big_date, low_date);
		int num_of_bigger_dates = 0;
		
		for(int i = 1; i < date_parts.length; ++i){
			if(date_parts[i].year > mid_date.year)
				num_of_bigger_dates ++;
			else if(date_parts[i].month > mid_date.month)
				num_of_bigger_dates ++;
			else if(date_parts[i].day > mid_date.day)
				num_of_bigger_dates ++;
		}
		
		System.out.println("Наибольшая дата: " + date_handl.DateToString(big_date));
		System.out.println("Наименьшая дата: " + date_handl.DateToString(low_date));
		System.out.println("Средняя дата: " + date_handl.DateToString(mid_date));
		System.out.println("Число дат после средней: " + num_of_bigger_dates);
    }
}

class DateSaver{
	int day = 0, month = 0, year = 0;
	String date = "";
}

class DateHandler{

	public DateSaver StringToDate(String input_date){
		DateSaver date_ = new DateSaver();
		return date_;
	}
	public String DateToString(DateSaver _date){
		String date_  = " ";
		return date_;
	}
	
	public DateSaver BiggestAndLowestDates(DateSaver[] dates, boolean biggest){
		DateSaver needed_date = dates[0];
		for(int i = 1; i < dates.length; ++i){
			if(biggest){
				if(dates[i].year > needed_date.year)
					needed_date = dates[i];
				else if(dates[i].year == needed_date.year){
					if(dates[i].month > needed_date.month)
						needed_date = dates[i];
					else if(dates[i].month == needed_date.month){
						if(dates[i].day > needed_date.day)
							needed_date = dates[i];
					}
				}
			}
			else{
				if(dates[i].year < needed_date.year)
					needed_date = dates[i];
				else if(dates[i].year == needed_date.year){
					if(dates[i].month < needed_date.month)
						needed_date = dates[i];
					else if(dates[i].month == needed_date.month){
						if(dates[i].day < needed_date.day)
							needed_date = dates[i];
					}
				}
			}
		}
		return needed_date;
	}
	
	public DateSaver GetMiddleDate(DateSaver biggest_date, DateSaver lowest_date){
		DateSaver middle_date = new DateSaver();
		middle_date.year = (biggest_date.year + lowest_date.year) / 2;
		//int[] months = new int[12]{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
		//if(middle_date.year % 4 == 0 && middle_date.year % 100 != 0)
		//	months[1] = 29;
		//else
		//	months[1] = 28;
		
		middle_date.month = (biggest_date.month + lowest_date.month) / 2;
		if(middle_date.month >= 6)
			// middle_date.year++;
	
		middle_date.day = (biggest_date.day + lowest_date.day) / 2;
		return middle_date;
	}
	
	/*public DateSaver GetMiddleDate(DateSaver biggest_date, DateSaver lowest_date){
		int num_of_d_big_date = 0;
		int num_of_d_low_date = 0;
		int num_of_d_middle_date = 0;
		DateSaver middle_date = new DateSaver();
		middle_date.year = 1;
		middle_date.month = 1;
		middle_date.day = 1;
		
		// Находим число дней от даты 01.01.0001  в самой большой дате
		for(int i = 1; i < biggest_date.year; ++i){
			if(i % 4 == 0 && i % 100 != 0)
				num_of_d_big_date += 366;
			else
				num_of_d_big_date += 365;
		}
		
		for(int i = 1; i < biggest_date.month; ++i){
			if(i == 2){
				if(biggest_date.year % 4 == 0 && biggest_date.year % 100 != 0)
					num_of_d_big_date += 29;
				else
					num_of_d_big_date += 28;
			}
			else if(i % 2 == 0 )
				num_of_d_big_date += 30;
			else
				num_of_d_big_date += 31;	
		}
		num_of_d_big_date += biggest_date.day - 1;	

		// Находим число дней от даты 00.00.0000  в самой маленькой дате
		for(int i = 1; i < lowest_date.year; ++i){
			if(i % 4 == 0 && i % 100 != 0)
				num_of_d_low_date += 366;
			else
				num_of_d_low_date += 365;
		}
		
		for(int i = 1; i < lowest_date.month; ++i){
			if(i == 2){
				if(lowest_date.year % 4 == 0 && lowest_date.year % 100 != 0)
					num_of_d_low_date += 29;
				else
					num_of_d_low_date += 28;
			}
			else if(i % 2 == 0 )
				num_of_d_low_date += 30;
			else
				num_of_d_low_date += 31;	
		}
		num_of_d_low_date += lowest_date.day - 1;
		
		// Находим число дней от даты 00.00.0000  в средней дате
		num_of_d_middle_date = (num_of_d_big_date + num_of_d_low_date) / 2;

		// Преобразуем это число дней в дату
		int year_num = 1;
		while(num_of_d_middle_date >= 365){
			if(year_num % 4 == 0)
				num_of_d_middle_date -= 366;
			else
				num_of_d_middle_date -= 365;
			year_num++;
			middle_date.year ++;
		}
		while(num_of_d_middle_date >= 365){
			if(year_num % 4 == 0)
				num_of_d_middle_date -= 366;
			else
				num_of_d_middle_date -= 365;
			year_num++;
			middle_date.year ++;
		}
	}*/
	
}

class RussiaDateFormat extends DateHandler{
	@Override
	public String DateToString(DateSaver _date){
		String year = Integer.toString(_date.year);
		String month = Integer.toString(_date.month);
		String day = Integer.toString(_date.day);
		for(int i = 4 - year.length(); i > 0; --i)
			year = '0' +  year;
		if(_date.month < 10)
			month = '0' + month;
		if(_date.day < 10)
			day = '0' + day;
		_date.date = String.format("%s.%s.%s", day, month, year);
		return _date.date;
	}
	@Override
	public DateSaver StringToDate(String input_date){
		DateSaver _date = new DateSaver();
		_date.day = Integer.parseInt(input_date.substring(0, input_date.indexOf('.')));
		_date.month = Integer.parseInt(input_date.substring(input_date.indexOf('.') + 1, input_date.lastIndexOf('.')));
		_date.year = Integer.parseInt(input_date.substring(input_date.lastIndexOf('.') + 1, input_date.length()));
		return _date;
	}
}

class CanadaDateFormat extends DateHandler{
	@Override
	public String DateToString(DateSaver _date){
		String year = Integer.toString(_date.year);
		String month = Integer.toString(_date.month);
		String day = Integer.toString(_date.day);
		for(int i = 4 - year.length(); i > 0; --i)
			year = '0' +  year;
		if(_date.month < 10)
			month = '0' + month;
		if(_date.day < 10)
			day = '0' + day;
		_date.date = String.format("%s-%s-%s", year, month, day);
		return _date.date;
	}
	@Override
	public DateSaver StringToDate(String input_date){
		DateSaver _date = new DateSaver();
		_date.year = Integer.parseInt(input_date.substring(0, input_date.indexOf('.')));
		_date.month = Integer.parseInt(input_date.substring(input_date.indexOf('.') + 1, input_date.lastIndexOf('.')));
		_date.day = Integer.parseInt(input_date.substring(input_date.lastIndexOf('.') + 1, input_date.length()));
		return _date;
	}
}

class BritainDateFormat extends DateHandler{
	@Override
	public String DateToString(DateSaver _date){
		String year = Integer.toString(_date.year);
		String month = Integer.toString(_date.month);
		String day = Integer.toString(_date.day);
		for(int i = 4 - year.length(); i > 0; --i)
			year = '0' +  year;
		if(_date.month < 10)
			month = '0' + month;
		if(_date.day < 10)
			day = '0' + day;
		_date.date = String.format("%s/%s/%s", day, month, year);
		return _date.date;
	}
	@Override
	public DateSaver StringToDate(String input_date){
		DateSaver _date = new DateSaver();
		_date.day = Integer.parseInt(input_date.substring(0, input_date.indexOf('/')));
		_date.month = Integer.parseInt(input_date.substring(input_date.indexOf('/') + 1, input_date.lastIndexOf('/')));
		_date.year = Integer.parseInt(input_date.substring(input_date.lastIndexOf('/') + 1, input_date.length()));
		return _date;
	}
}