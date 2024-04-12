
# FLOATING-POINTING_ALU

## Auto test manual
In auto_test folder, use the package manager [pip](https://pip.pypa.io/en/stable/) to install required modules.
```bash
pip install -r requirements.txt
```

- Create a testcase in `input.txt`
- Run `build.py`
- In testbench file, add the following code:
```verilog
`define LINK_INPUT "<fill in>/auto_test/build.txt"
`define LINK_OUTPUT "<fill in>/auto_test/output_sim.txt"
...
    integer fd, f_in;
...
    initial begin
        f_in = $fopen(`LINK_INPUT, "r");
        fd = $fopen(`LINK_OUTPUT, "w");
        $fmonitorh(fd, out);
        while (!$feof(f_in)) begin
            $fscanf(f_in, "%h %h\n", para1, para2);
            #1;
        end
        $fclose(f_in);
        $fclose(fd);
        $finish;
    end
```
- Run testbench file
- Run `check.py` file
- The result is displayed in `final_result.txt`
```diff
- NOTE:
- A line (testcase) format in input.txt: <para1> <para2>
- Example testcases are saved in multi_TestCase folder
- testcase5 (overflow), and testcase6 (underflow) are used for build.txt, not input.txt.
In this case, only run testbench file and obverse the test console
```
