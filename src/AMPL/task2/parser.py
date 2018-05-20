i = 1
f = open('scenariusze2.data','r+')
content = f.readlines()
for line in content:
    line = str(i) + " " + line
    f.write(line)
    i+=1
f.close()
