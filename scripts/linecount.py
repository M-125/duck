import os
files=os.listdir(".")
counter=0
for file in files:
	fl=open(file)
	for e in fl.readlines():
		counter+=1
	fl.close()

print(counter)
