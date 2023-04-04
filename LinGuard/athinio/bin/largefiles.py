import xml.etree.ElementTree as ET
import sys
import xml.dom.minidom
import os
import subprocess
import fcntl
import lxml.etree as etree
file1='/var/neridio/largefile.xml'
file2='/var/neridio/Asecfile.xml'
file3='/var/neridio/Msecfile.xml'
file4='/var/neridio/banned_ip.xml'
file5='/athinio/system/services.xml'
file6='/athinio/system/open_ports.xml'
file7='/athinio/system/nouser_noowner.xml'
file8='/athinio/system/world_writable_files.xml'
file9='/athinio/system/suid_sgid_files.xml'
file10='/athinio/system/zero_uid.xml'
file11='/athinio/system/user_emptypass_list.xml'
file12='/athinio/system/accstat.xml'

#arr=[]
#root = ET.parse('/athinio/system/param_cmd_52.xml').getroot()
#Count= root.find('noofparameters').text
#for i in range(0,int(Count)):
  # a=root.find('param'+str(i)).text
   #arr.append(a)
#print arr

def unlockfile(fd):
    while True:
        try:
            fcntl.flock(fd, fcntl.LOCK_UN)
            break
        except IOError as e:
            if e.errno != errno.EAGAIN:
                raise
            else:
                time.sleep(0.1)
        return 0
def lockfile(fd):
    #only advisory locking
    while True:
        try:
            fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
            break
        except IOError as e:
            if e.errno != errno.EAGAIN:
                return -1
            else:
                time.sleep(0.1)
        return 0
def convertXML_to_prettyXML(file1):
        with open(file1) as f:
               x=etree.parse(file1)
               final_xml=etree.tostring(x,pretty_print=True)
        sys.stdout = open(file1,"w")
        lockfile(sys.stdout)
        print(final_xml)
        unlockfile(sys.stdout)
        sys.stdout.close()


  
#if sys.argv[1] in arr:
def create(file1,out,root,sub1,sub3,sub4,sub5,sub6):
 if(sub3):
  root1=ET.Element(root)
  child2=ET.SubElement(root1,"Currently_failed")
  child2.text=sub3
  child3=ET.SubElement(root1,"Total_failed")
  child3.text=sub4
  child4=ET.SubElement(root1,"Currently_banned")
  child4.text=sub5
  child5=ET.SubElement(root1,"Total_banned")
  child5.text=sub6
  num=ET.SubElement(root1,'Count')
  num.text= "1"
  child1=ET.SubElement(root1,sub1)
  child1.text=out

  ET.ElementTree(root1).write(file1,encoding="UTF-8",xml_declaration=True,method="xml")
  convertXML_to_prettyXML(file1)
 else:
  root1=ET.Element(root)
  num=ET.SubElement(root1,'Count')
  num.text= "1"
  child1=ET.SubElement(root1,sub1)
  child1.text=out
  ET.ElementTree(root1).write(file1,encoding="UTF-8",xml_declaration=True,method="xml")
  convertXML_to_prettyXML(file1)

def append(file1,out,sub2):
  root1=ET.parse(file1).getroot()
  num = int(root1.find('Count').text)
  num = str(num+1)
  child1=ET.SubElement(root1,sub2+num)
  child1.text=out
  root1.find('Count').text=str(num)
  doc= ET.ElementTree(root1)
  doc.write(file1,encoding="UTF-8",xml_declaration=True,method="xml")
  convertXML_to_prettyXML(file1)

arr=[]
if (sys.argv[1] == "/athinio/system/LARGEFILES"):
  root = "LARGE_FILES"
  sub1 = "file_1"
  sub2 = "file_"
  sub3 = 0
  sub4 = 0
  sub5 = 0
  sub6 = 0

  with open(sys.argv[1],'r') as f:
    f=f.readlines()
  for i in f:
    arr.append(i)
  for j in arr:
    if not os.path.isfile(file1):
      create(file1,j,root,sub1,sub3,sub4,sub5,sub6)
    else:
      append(file1,j,sub2)
if (sys.argv[1] == "/athinio/system/ASECFILES"):
  root = "ACCESS_FILES"
  sub1 = "file_1"
  sub2 = "file_"
  sub3 = 0
  sub4 = 0
  sub5 = 0
  sub6 = 0

  with open(sys.argv[1],'r') as f:
    f=f.readlines()
  for i in f:
    arr.append(i)
  for j in arr:
    if not os.path.isfile(file2):
      create(file2,j,root,sub1,sub3,sub4,sub5,sub6)
    else:
      append(file2,j,sub2)

if (sys.argv[1] == "/athinio/system/MSECFILES"):
  root = "MODIFIED_FILES"
  sub1 = "file_1"
  sub2 = "file_"
  sub3 = 0
  sub4 = 0
  sub5 = 0
  sub6 = 0
  with open(sys.argv[1],'r') as f:
    f=f.readlines()
  for i in f:
    arr.append(i)
  for j in arr:
    if not os.path.isfile(file3):
      create(file3,j,root,sub1,sub3,sub4,sub5,sub6)
    else:
      append(file3,j,sub2)
if (sys.argv[1] == "/athinio/system/BANNEDIP"):
  root = "BANNED_IP"
  sub1 = "ip_1"
  sub2 = "ip_"
  sub3 = sys.argv[2]
  sub4 = sys.argv[3]
  sub5 = sys.argv[4]
  sub6 = sys.argv[5]  
  with open(sys.argv[1],'r') as f:
    f=f.readlines()
  for i in f:
    arr = i.split()
    #print arr
    for j in arr:
      #print j
      if not os.path.isfile(file4):
        create(file4,j,root,sub1,sub3,sub4,sub5,sub6)
      else:
         append(file4,j,sub2)
if (sys.argv[1] == "/athinio/system/CONNECTEDIP"):
  arr1=''
  replace=''
  with open(sys.argv[1],'r') as f:
    f=f.readlines()
  for i in f:
    arr.append(i)
  with open(sys.argv[2],'r') as f1:
    f1=f1.readlines()
   
  for j in f1:
    if "ignoreip" in j:
       replace="ignoreip = 127.0.0.1"
       for k in arr:
         replace = replace+" "+k
    else:
       #print j
       arr1=arr1+j+"\n"

  #print arr1+replace
  total=arr1+replace
  with open(sys.argv[2],'w') as f2:
     f2.write(total)

if (sys.argv[1] == "/athinio/system/LIST_SERVICE_ON"):
  root = "SERVICES"
  sub1 = "service_1"
  sub2 = "service_"
  sub3 = 0
  sub4 = 0
  sub5 = 0
  sub6 = 0
 
  with open(sys.argv[1],'r') as f:
    f=f.readlines()
  for i in f:
    arr.append(i)
    #print arr
  for j in arr:
      #print j
     if not os.path.isfile(file5):
        create(file5,j,root,sub1,sub3,sub4,sub5,sub6)
     else:
         append(file5,j,sub2)

if (sys.argv[1] == "/athinio/system/ACCSTAT"):
  root = "USER_LIST"
  sub1 = "user_1"
  sub2 = "user_"
  sub3 = 0
  sub4 = 0
  sub5 = 0
  sub6 = 0

  with open(sys.argv[1],'r') as f:
    f=f.readlines()
  for i in f:
    arr.append(i)
    #print arr
  for j in arr:
      #print j
     if not os.path.isfile(file12):
        create(file12,j,root,sub1,sub3,sub4,sub5,sub6)
     else:
         append(file12,j,sub2)

if (sys.argv[1] == "/athinio/system/LIST_OPEN_PORTS"):
  root = "OPEN_PORTS"
  sub1 = "port_1"
  sub2 = "port_"
  sub3 = 0
  sub4 = 0
  sub5 = 0
  sub6 = 0

  with open(sys.argv[1],'r') as f:
    f=f.readlines()
  for i in f:
    arr.append(i)
    #print arr
  for j in arr:
      #print j
     if not os.path.isfile(file6):
        create(file6,j,root,sub1,sub3,sub4,sub5,sub6)
     else:
         append(file6,j,sub2)
 
if (sys.argv[1] == "/athinio/system/NOOWN_NOUSER"):
  root = "FILES"
  sub1 = "file_1"
  sub2 = "file_"
  sub3 = 0
  sub4 = 0
  sub5 = 0
  sub6 = 0

  with open(sys.argv[1],'r') as f:
    f=f.readlines()
  for i in f:
    arr.append(i)
    #print arr
  for j in arr:
      #print j
     if not os.path.isfile(file7):
        create(file7,j,root,sub1,sub3,sub4,sub5,sub6)
     else:
         append(file7,j,sub2)

if (sys.argv[1] == "/athinio/system/WW_FILES"):
  root = "WW_FILES"
  sub1 = "file_1"
  sub2 = "file_"
  sub3 = 0
  sub4 = 0
  sub5 = 0
  sub6 = 0

  with open(sys.argv[1],'r') as f:
    f=f.readlines()
  for i in f:
    arr.append(i)
    #print arr
  for j in arr:
      #print j
     if not os.path.isfile(file8):
        create(file8,j,root,sub1,sub3,sub4,sub5,sub6)
     else:
         append(file8,j,sub2)

if (sys.argv[1] == "/athinio/system/SUID_SGID"):
  root = "SUID_SGID_FILES"
  sub1 = "file_1"
  sub2 = "file_"
  sub3 = 0
  sub4 = 0
  sub5 = 0
  sub6 = 0

  with open(sys.argv[1],'r') as f:
    f=f.readlines()
  for i in f:
    arr.append(i)
    #print arr
  for j in arr:
      #print j
     if not os.path.isfile(file9):
        create(file9,j,root,sub1,sub3,sub4,sub5,sub6)
     else:
         append(file9,j,sub2)
if (sys.argv[1] == "/athinio/system/ZEROUID"):
  root = "Users"
  sub1 = "user_1"
  sub2 = "user_"
  sub3 = 0
  sub4 = 0
  sub5 = 0
  sub6 = 0

  with open(sys.argv[1],'r') as f:
    f=f.readlines()
  for i in f:
    arr.append(i)
    #print arr
  for j in arr:
      #print j
     if not os.path.isfile(file10):
        create(file10,j,root,sub1,sub3,sub4,sub5,sub6)
     else:
         append(file10,j,sub2)

if (sys.argv[1] == "/athinio/system/EMPTYPASS"):
  root = "Users"
  sub1 = "user_1"
  sub2 = "user_"
  sub3 = 0
  sub4 = 0
  sub5 = 0
  sub6 = 0

  with open(sys.argv[1],'r') as f:
    f=f.readlines()
  for i in f:
    arr.append(i)
    #print arr
  for j in arr:
      #print j
     if not os.path.isfile(file11):
        create(file11,j,root,sub1,sub3,sub4,sub5,sub6)
     else:
         append(file11,j,sub2)


