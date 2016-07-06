library(xlsx)

## Data Loading
setwd("E:/NUS/R learnings/TNelection") ## wks setup
t1 <- read.xlsx("tn_election2016.xls",sheetName = "constituency_results",stringsAsFactors=FALSE)
str(t1)

## Data Cleaning
t1$Const..No. <- as.numeric(t1$Const..No.)
t1[t1$Leading.Party=="All India Anna Dravida Munnetra Kazhagam",]$Leading.Party="ÄIADMK"
t1[t1$Leading.Party=="Dravida Munnetra Kazhagam",]$Leading.Party="DMK"
t1[t1$Leading.Party=="Bharatiya Janata Party",]$Leading.Party="BJP"
t1[t1$Leading.Party=="Indian National Congress",]$Leading.Party="Con"
t1[t1$Leading.Party=="Viduthalai Chiruthaigal Katchi",]$Leading.Party="VCK"
t1[t1$Leading.Party=="Pattali Makkal Katchi",]$Leading.Party="PMK"
t1[t1$Leading.Party=="Communist Party of India",]$Leading.Party="CPI"
t1[t1$Leading.Party=="Manithaneya Makkal Katchi",]$Leading.Party="MMK"
t1[t1$Leading.Party=="Puthiya Tamilagam",]$Leading.Party="PT"


t1[t1$Trailing.Party=="All India Anna Dravida Munnetra Kazhagam",]$Trailing.Party="ÄIADMK"
t1[t1$Trailing.Party=="Dravida Munnetra Kazhagam",]$Trailing.Party="DMK"
t1[t1$Trailing.Party=="Bharatiya Janata Party",]$Trailing.Party="BJP"
t1[t1$Trailing.Party=="Indian National Congress",]$Trailing.Party="Con"
t1[t1$Trailing.Party=="Viduthalai Chiruthaigal Katchi",]$Trailing.Party="VCK"
t1[t1$Trailing.Party=="Pattali Makkal Katchi",]$Trailing.Party="PMK"
t1[t1$Trailing.Party=="Communist Party of India",]$Trailing.Party="CPI"
t1[t1$Trailing.Party=="Manithaneya Makkal Katchi",]$Trailing.Party="MMK"
t1[t1$Trailing.Party=="Puthiya Tamilagam",]$Trailing.Party="PT"


t1$Leading.Party <-as.factor(t1$Leading.Party)
t1$Trailing.Party <-as.factor(t1$Trailing.Party)
t1$Margin<-as.numeric(t1$Margin)
t1$Status<-as.factor(t1$Status)
head(t1)
summary(t1$Trailing.Party)

## Margin Analysis
plot(t1$Leading.Party,t1$Margin)
plot(t1$Trailing.Party,t1$Margin)

## BJP Has lost all 4 places where they can as runner up by huge margins (Cong has won the same constituencies in high margin)
## Margin of difference between AIADMK and DMK where they have lost in very similar
## VCK and CPI have emerged reasonable alternates and lost by small margins
## IUML has just scrapped throught to win


## 2Freq plots
bins <- c(0,500,1000,3000,5000,10000,15000,20000,30000,50000)
freq<-cut(t1$Margin, bins, dig.lab = 5)
table(freq)
transform(table(freq))
plot(table(freq),xlab = "Margin of difference", ylab = "Number of seats")

###############
t2<- read.xlsx("Tamil Nadu ECI Raw.xlsx")

PartyVotes<- aggregate(t2$votes, by= list(category=t2$party),sum)
## aggregate( votes ~ party, t2,sum) same
## tapply(t2$votes, t2$party, sum)

## order of parties
PartyVotes$voteshare = round(PartyVotes$x/sum(t2$votes) *100,2)
vs<- PartyVotes[with(PartyVotes,order(-voteshare)),]

## Stunning 90 parties contesting with one NOTA and Independent 
## Independents and NOTA typically take away 3% votes out anyways.


## Margin with 3rd person


## vote share analysis : ADMK vs DMK and ADMK Vs DMK+Congress
head(vs,n=15)
vs$alliance = "Rest"
vs[vs$category=="All India Anna Dravida Munnetra Kazhagam",]$alliance ="AIADMK"
vs[vs$category=="Dravida Munnetra Kazhagam" | vs$category=="Indian National Congress" | vs$category=="Indian Union Muslim League" | vs$category=="Puthiya Tamilagam"| vs$category=="Manithaneya Makkal Katchi"| vs$category=="Puthiya Tamilagam",]$alliance ="DMK+"
vs[vs$category=="Desiya Murpokku Dravida Kazhagam" | vs$category=="Marumalarchi Dravida Munnetra Kazhagam" | vs$category=="Communist Party of India" | vs$category=="Viduthalai Chiruthaigal Katchi"| vs$category=="Communist Party of India (Marxist)" | vs$category=="Tamil Maanila Congress (Moopanar)",]$alliance ="PWA+"

aggregate(vs$voteshare, by=list(vs$alliance),sum)
## Individual party positions
area<- aggregate(rep(1,3960), by=list(t2$party),sum)

