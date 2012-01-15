
import java.io.*;
import java.util.*;

public class %task_file_name% {

    // *** START CUT
    // THIS TEXT WILL BE CUTTED OUT UNTIL NEAREST '*** END'

    private InputStream is = null;
    private OutputStream os = null;

    public Main() {
        is = System.in;
        os = System.out;
    }

    public Main(InputStream is, OutputStream os) {
        this.is = is;
        this.os = os;
    }

    // *** END CUT

    public static void main(String[] args) {
        boolean localMachine = false;

        // *** START CUT
        // THIS TEXT WILL BE CUTTED OUT UNTIL NEAREST '*** END'

        localMachine = true;
        String[][] tests = new String[][]{
            // *** START TESTS
            // Next lines are 2-element arrays with sample input in [0] and sample output in [1]
            {"2 3", "2+3=5\r\n"}, // TODO: windows vs linux newlines
            {"0 1", "0+1=1\r\n"},
            {"0 0", "0+0=0\r\n"}
            // *** END TESTS
        };
        int fails = 0, oks = 0;

        for (int testNo = 0; testNo < tests.length; testNo++) {
            System.out.println("Running test #" + testNo + "...");
            int res = test(tests[testNo][0], tests[testNo][1]);
            if (res == 0) {
                oks++;
            }
            if (res == -1) {
                fails++;
            }
        }

        // *** END CUT

        if (!localMachine) {
            new Main().main();
        }

    }

    public static int test(String input, String output) {
        ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(input.getBytes());
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        new Main(byteArrayInputStream, byteArrayOutputStream).main();
        String sol = byteArrayOutputStream.toString();
        int res = 0;

        if (sol.equals(output)) {
            System.out.println("ok");
        } else {
            System.out.println(sol.length() + " " + output.length());
            System.out.println("FAIL!");
            System.out.println("Expected: " + output);
            System.out.println("Your solution: " + sol);
            res = -1;
        }
        return res;
    }

    void main() {
        Scanner s = new Scanner(is);
        PrintStream ps = new PrintStream(os);
        int a = s.nextInt(), b = s.nextInt();
        int c = a+b;
        ps.println(a+"+"+b+"="+c);
        ps.flush();
    }
}
