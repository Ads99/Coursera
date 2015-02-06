setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data')

if (!file.exists("data")) {
  dir.create("data")
}

# Getting data off webpages - readLines()
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode

# Parsing with XML
# The above generated a lot of unstructured html stuff so we can use the
# XML package to parse this data
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=T)

xpathSApply(html, "//title", xmlValue)
# [1] "Jeff Leek - Google Scholar Citations"

xpathSApply(html, "//td[@id='col-citedby']", xmlValue)

# Another approach - GET from the httr package
library(httr); html2 = GET(url)
content2 = content(html2,as="text")
parsedHtml = htmlParse(content2,asText=TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)

# More complicated - Accessing websites with passwords
pg1 = GET("http://httpbin.org/basic-auth/user/passwd")
#Response [http://httpbin.org/basic-auth/user/passwd]
#Date: 2014-10-16 17:50
#Status: 401
#Content-type: <unknown>
#  <EMPTY BODY>

# So the httr package allows us to authenticate with user name and password
pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
          authenticate("user","passwd"))
pg2
#Response [http://httpbin.org/basic-auth/user/passwd]
#Date: 2014-10-16 17:52
#Status: 200
#Content-type: application/json
#Size: 46 B
#{
#  "authenticated": true, 
#  "user": "user"
#}
names(pg2)

# Using handles (won't need to repeatedly authenticate)
google = handle("http://google.com")
pg1 = GET(handle=google,path="/")
pg2 = GET(handle=google,path="search")

