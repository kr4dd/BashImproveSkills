#!/usr/bin/python

file_txt=open("total_time.txt","r")

sum_total=0

for line in file_txt:
        sum_total+=float(line)

minutes=sum_total/60
hours=minutes/60
days=hours/24

if days>=1:
    print(int(days),'days')
elif hours>=1:
    print(float(hours),'hours')
elif minutes>=1:
    print(float(minutes),'minutes')
else:
    print(float(seconds),'seconds')
