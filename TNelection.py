#libraries reqd
import urllib
from bs4 import BeautifulSoup
import os
#import csv # reference : http://xlwt.readthedocs.io/en/latest/genindex.html
from xlwt.Workbook import * # reference: http://xlsxwriter.readthedocs.io/worksheet.html
from xlwt import easyxf

# prints the current working directory
print os.getcwd()

# create a xl workbook. XLWT prefered over CSV most cases
workbook = Workbook()
#Add a worksheet
ws=workbook.add_sheet("constituency_results")

style_header = easyxf('font: bold 1, name Arial, height 150; pattern: pattern solid, pattern_fore_colour yellow, pattern_back_colour yellow')
style_cell = easyxf('align: wrap 1; font: height 150')

# Setting the initial heading
ws.write(0,0,"Constituency",style_header)
ws.write(0,1,"Const. No.",style_header)
ws.write(0,2,"Leading Candidate",style_header)
ws.write(0,3,"Leading Party",style_header)
ws.write(0,4,"Trailing Candidate",style_header)
ws.write(0,5,"Trailing Party",style_header)
ws.write(0,6,"Margin",style_header)
ws.write(0,7,"Status",style_header)

pagepattern = "http://eciresults.nic.in/StatewiseS22";

row_num=1
pages=24

# Loop for the 24 pages to be scrapped
for i in range(pages):
    if(i==0):
        url=pagepattern+".htm"
    else:
        url=pagepattern+str(i)+".htm"
    print url
    print "Scrapping page:"+str(i) +"begins"

    html = urllib.urlopen(url).read()
    # print html

    soup = BeautifulSoup(html)
    # prints the type soup object
    # print type(soup)

    # prints the html portion in the original doc
    # print soup.prettify()

    #  get the tables in the page. Those with tag table
    tables = soup.find('table')
    print "Total number of tables in the page :", len(tables)

    #row_num=1
    for row in tables.find_all("tr"):
        if len(row)==8:
            col_num = 0
            for td in row.find_all("td"):
                print td.text
                ws.write(row_num,col_num,td.text,style_cell)
                col_num+=1
            row_num+=1
    print "page:"+str(i) +"ends"
workbook.save('tn_election2016.xls')



### CSV version
# table headers
# header=list()
# for head in tables.find_all('th'):
#     print head.text.strip()
    # header.append(head.text.strip())
#
# with open("tn_election2016.csv", "w") as toWrite:
#     writer = csv.writer(toWrite)
#     writer.writerow(header)
#     for row in tables.find_all('tr'):
#         if len(row) == 8:
#             print row
#             ls = list()
#             for td in row.find_all('td'):
#                 ls.append(str(td.text.strip()))
            # print ls
            # writer.writerow(ls)
#