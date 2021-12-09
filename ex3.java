package source;

import by.vsu.mf.ai.ssd.strings.Job;

public class ex3 implements Job {
    public void perform(StringBuilder str_Builder) {
        /* реализация */
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
                for (int j = i; j < i + 3; ++j) {
                    if (needed_letter >= _rus_alfabet_big.length())
                        needed_letter = 0;
                    _input_str.setCharAt(j, _rus_alfabet_big.charAt(needed_letter));
                    ++needed_letter;
                }
            }
        }
        System.out.println(_input_str);
    }
}
