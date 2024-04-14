try:
    file1 = open("output_py.txt", "r")
    file2 = open("output_sim.txt", "r")
    file3 = open("final_result.txt", "w")
    file1_lines = file1.readlines()
    file2_lines = file2.readlines()
    cnt = 0
    # Iterate over the lines and compare
    for line_num, (line1, line2) in enumerate(zip(file1_lines, file2_lines), start=1):
        # Remove trailing newline characters and compare lines
        line1 = line1.rstrip('\n').lower()
        line2 = line2.rstrip('\n').lower()
        if line1 != line2:
            file3.write(f"{line_num}: no pass\n")
        else:
            file3.write(f"{line_num}: pass\n")
            cnt += 1
        # Check if files have different numbers of lines
        if len(file1_lines) != len(file2_lines):
            print("Files have different numbers of lines.")
            break
    file3.write(f"Pass {cnt}/{len(file1_lines)} test cases")
    file1.close()
    file2.close()
    file3.close()
except:
    print("can not open file1")
