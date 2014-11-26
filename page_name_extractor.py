# Usage: cat 141114_Users-Edits.tsv | python page_name_extractor.py
# Extracts relevant users from the tsv file and writes them into lists
# These lists can then be used to extract revision history from Web interface https://en.wikipedia.org/w/index.php?title=Special:Export&action=submit
# or the data may be queried via an API
import json
import sys
from subprocess import call
from urllib import urlencode

INPUT = sys.stdin
user_edit_count = {}

def main():
	for line in INPUT:
         if line!="\n":
			linesplit = line.split('\t')
			user = linesplit[0]
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
	pages = ""
	lang = "en"
	curl = """curl 'https://{2}.wikipedia.org/w/index.php?title=Special:Export&action=submit' -H 'Origin: https://{2}.wikipedia.org' -H 'Accept-Encoding: gzip,deflate,sdch' -H 'User-Agent: Mozilla/5.0 Chrome/35.0' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: https://{2}.wikipedia.org/wiki/Special:Export' -H 'Connection: keep-alive' -H 'DNT: 1' --compressed --data '{0}' > {1}"""
	nUsers = len(user_edit_count)
	for user in user_edit_count.keys():
		counter+=1
		pages = pages + "User_talk:"+user+"\n";
		fo.write("User_talk:"+user+"\n")    
		if((counter/nperFile)>=fileNo or counter == nUsers):
                    fo.close()
                    data = {
                            'catname': '',
                            'pages': pages,
                            'curonly': '1',
                            'wpDownload': '1',
                      }
                    enc_data = urlencode(data)
                    downloadFileName = "data_"+str(fileNo)+".xml"
                    call(curl.format(enc_data, downloadFileName, lang), shell=True)
                    pages = ""
                    if(counter != nUsers):
                    	fileNo=fileNo+1
                    	fileName = "list"+str(fileNo)+".txt"
                    	fo = open(fileName,"w")

if __name__ == '__main__':
    main()