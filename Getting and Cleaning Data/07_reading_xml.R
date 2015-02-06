setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data')

if (!file.exists("data")) {
  dir.create("data")
}

library(XML)
fileUrl <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl,useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
# "breakfast_menu"

names(rootNode)
# food   food   food   food   food 
#"food" "food" "food" "food" "food"

# Directly access parts of the XML document
rootNode[[1]]
#<food>
#<name>Belgian Waffles</name>
#  <price>$5.95</price>
#  <description>Two of our famous Belgian Waffles with plenty of real maple syrup</description>
#  <calories>650</calories>
#  </food>

rootNode[[1]][[1]]
#<name>Belgian Waffles</name>

# Programatically extract parts of the file
xmlSApply(rootNode,xmlValue)

# XPath
# /node - Top level node
# //node - Node at any level
# node[@attr-name] - Node with an attribute name
# node[@attr-name='bob'] - Node with attribute name attr-name='bob'

# Get the items on the menu and prices
xpathSApply(rootNode,"//name",xmlValue)
# [1] "Belgian Waffles"             "Strawberry Belgian Waffles"  "Berry-Berry Belgian Waffles"
# [4] "French Toast"                "Homestyle Breakfast"

xpathSApply(rootNode,"//price",xmlValue)
# [1] "$5.95" "$7.95" "$8.95" "$4.50" "$6.95"

# Another example
# Extract content by attributes
fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileUrl,useInternal=TRUE)
scores <- xpathSApply(doc,"//li[@class='score']",xmlValue)
teams <- xpathSApply(doc,"//li[@class='team-name']",xmlValue)

scores
# [1] "23-16" "26-6"  "23-21" "38-10" "20-13"

teams
# [1] "Cincinnati"   "Pittsburgh"   "Cleveland"    "Carolina"     "Indianapolis" "Tampa Bay"    "Atlanta"     
# [8] "Cincinnati"   "Pittsburgh"   "Tennessee"    "New Orleans"  "San Diego"    "Miami"        "Jacksonville"
# [15] "Houston"      "Cleveland"