# Usage: cat 141114_Users-Edits.tsv | python page_name_extractor.py
# Extracts relevant users from the tsv file and writes them into lists
# These lists can then be used to extract revision history from Web interface https://en.wikipedia.org/w/index.php?title=Special:Export&action=submit
# or the data may be queried via an API
import json
import sys
INPUT = sys.stdin
user_edit_count = {}

def main():
	for line in INPUT:
		if line!="\n":
			linesplit = line.split('\t')
#			print linesplit
			user = linesplit[0]
#			print user
			if not(user in user_edit_count):
				try:
					revCount = int(linesplit[4])
					if revCount>1:
						user_edit_count[user] = revCount
				except:
					pass
	counter = 0
	fileNo=1
	nperFile = 5000
	fo =open("list1.txt","w")
	for user in user_edit_count.keys():
		counter+=1
		if((counter/nperFile)>=fileNo):
			fo.close()
			fileNo=fileNo+1
			fileName = "list"+str(fileNo)+".txt"
			fo = open(fileName,"w")
		fo.write("User_talk:"+user+"\n")
	fo.close()

if __name__ == '__main__':
    main()
