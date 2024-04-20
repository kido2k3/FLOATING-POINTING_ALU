try:
    file1 = open("netlist.v", "r")
    mach = dict()
    file1_lines = file1.readlines()
    tr = str()
    tr
    cnt = 0
    # Iterate over the lines and compare
    for(line1) in file1_lines:
        # Remove trailing newline characters and compare lines
        line1 = line1.rstrip('\n').lower()
        string = line1.split()
        if len(string) != 0 and '(' not in string[0] and '.' not in string[0] and 'csa' not in string[0] and 'sub' not in string[0] and 'add' not in string[0]:
            if string[0] in mach:
                mach[string[0]] += 1
            else:
                mach[string[0]] = 1
    for item in mach:
        print(item, mach.get(item))
    file1.close()
    
except:
    print("can not open file1")
