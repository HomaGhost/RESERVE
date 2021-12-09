import java.util.Arrays;

// javac -encoding utf8 ex2.java;
public class ex2 {
	public static void main(String[] args) {
		String input_str = "";
		for (int i = 0; i < args.length; ++i) {
			input_str += args[i];
			input_str += " ";
		}
		String rus_alphabet_big = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЭЮЯ";
		StringBuilder _rus_alfabet_big = new StringBuilder(rus_alphabet_big);
		StringBuilder _input_str = new StringBuilder(input_str);
		int needed_letter = 0;

		for (int i = 0; i < _input_str.length() - 2; ++i) {
			if (_input_str.charAt(i) == '.' && _input_str.charAt(i + 1) == '.' && _input_str.charAt(i + 2) == '.') {
				int first = i + 1;
				int last = i + 3;
				if (needed_letter >= _rus_alfabet_big.length())
					needed_letter = 0;
				_input_str.setCharAt(i, _rus_alfabet_big.charAt(needed_letter));
				++needed_letter;
				_input_str.delete(first, last);
			}
		}
		System.out.println(_input_str);
	}
}