package samplepackage.jelly;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static java.util.Arrays.sort;

public class Jelly {
    public static void main(String[] args) {

        StringBuilder cp=new StringBuilder() ;
        for (char current='a';current<='z';current++)
        cp.append(current);
        System.out.println(cp);


        StringBuilder cpc=new StringBuilder("start");
        cpc.append("Big40Willy");
        StringBuilder mcm =cpc.append(" Glefuly Broward County 1800..");

        System.out.println(mcm);
System.out.println("-----------------------------------------------------------------------------------------------");

        StringBuilder sb = new StringBuilder("animals");

        String sub = sb.substring(sb.indexOf("a"), sb.indexOf("al"));
        int len = sb.length();
        char ch = sb.charAt(6);
        sub.concat("als");
        System.out.println(sub + " " + len + " " + ch);

        System.out.println("-----------------------------------------------------------------------------------------");

        StringBuilder dovi = new StringBuilder().append(1).append('c');
        dovi.append("-").append(false);

        int[] differentSize = {8,9,5,89,65,9,212,9};
System.out.println(differentSize[2]);
System.out.println(differentSize.length);

        sort(differentSize);
for (int i=0; i<differentSize.length;i++) {
    System.out.println(differentSize[i]+"\t");
    System.out.println();
}
        List<Integer> numbers = new ArrayList<>();
numbers.add(1); numbers.add(2);
numbers.remove(0);
System.out.println(numbers);
System.out.println("------------------------------------------------------------------------------------------------");

        List<Integer> numbers1 = new ArrayList<>();
        numbers.add(99); numbers.add(5); numbers.add(81);
        Collections.sort(numbers1);
        System.out.println(numbers1);



        //System.out.println(Arrays.binarySearch(numbers, 2));
        //System.out.println(cp.equals(ccp1));
    }
}







        /*
        while(x>0) {
            do {    x -= 2 ;
        } while (x>5);
        x--;
        System.out.print(x);
        }
    }
}
*/