import java.util.Scanner;
import java.util.Arrays;
import java.util.Comparator;

// chcp 1251 - изменение языка консоли
//java lab21 aaassssssaaaa  aassssaaasssaaaasssaaa
public class lab21 {
    static String str1, str2;

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        for (int i = 0; i < args.length; i++)
            System.out.println(args[i]);

        System.out.println("-------------------Length increasing sort--------------------");
        Arrays.sort(args, new L2E1Compatator1());
        for (int i = 0; i < args.length; i++)
            System.out.println(args[i]);

        System.out.println("-------------------enter sub--------------------");
        str1 = scanner.nextLine();
        str2 = scanner.nextLine();
        System.out.println("-------------------Sort by part between substrings--------------------");
        Arrays.sort(args, new L2E1Compatator2());
        for (int i = 0; i < args.length; i++)
            System.out.println(args[i]);
    }

}

class L2E1Compatator1 implements Comparator<String> {
    public int compare(String s1, String s2) {
        s1 = new StringBuilder(s1).toString();
        s2 = new StringBuilder(s2).toString();
        return s1.length() - s2.length();
    }
}

class L2E1Compatator2 implements Comparator<String> {

    lab21 lb = new lab21();

    public int compare(String s1, String s2) {
        String str1 = lb.str1;
        String str2 = lb.str2;
        s1 = new StringBuilder(s1).toString();
        s2 = new StringBuilder(s2).toString();

        // Находит позиции первого вхождения подстроки str1 и последнего подстроки str2
        int index_s1_1 = s1.indexOf(str1);
        int index_s2_1 = s2.indexOf(str1);
        int index_s1_2 = s1.lastIndexOf(str2);
        int index_s2_2 = s2.lastIndexOf(str2);

        if (index_s1_1 < 0 || index_s1_2 < 0 || index_s2_1 < 0 || index_s2_2 < 0)
            System.out.println("No substring found. Sorting can't be valid.");
        else {
            String sub_str1 = s1.substring(index_s1_1, index_s1_2);
            String sub_str2 = s2.substring(index_s2_1, index_s2_2);
            return sub_str1.compareTo(sub_str2);
        }
        return s1.compareTo(s2);
    }
}