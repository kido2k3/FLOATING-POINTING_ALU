from ieee754 import IEEE754
real1 = list()
real2 = list()
res = list()
try:
    f = open("input.txt", "r")
    for line in f:
        # Split the line into two real numbers
        real_numbers = line.strip().split()
        if len(real_numbers) == 2:
            # Process each real number (here, we just print them)
            real_1, real_2 = map(float, real_numbers)
            real1.append(real_1)
            real2.append(real_2)
            # print("First number:", real_1)
            # print("Second number:", real_2)
        else:
            print("Invalid line format:", line.strip())
    # f = open("build.txt", "w")
    f.close()
except:
    print("can not open file1")
print(real1)
print(real2)
try:
    f = open("build.txt", "w")
    for i in range(len(real1)):
        f.write(
            f"{IEEE754(real1[i], 1).hex()[0]} {IEEE754(real2[i], 1).hex()[0]}\n")
    f.close()
except:
    print("can not open file2")
try:
    f = open("output_py.txt", "w")
    for i in range(len(real1)):
        if i == 0:
            num = real1[i] + real2[i]
        elif i == 1:
            num = real1[i] - real2[i]
        else:
            num = real1[i] * real2[i]
        f.write(f"{IEEE754(num, 1).hex()[0]}\n")
    f.close()
except:
    print("can not open file3")
