#Problem Statement: 

#To examine which are the factors which influence,  Customer Lifetime Value (CLV) of Insurance Premium Company, based on the given attributes of the customer
#Business Context: What are the  attributes of customer, who have a higher Customer Lifetime Value

#Since the dependent variable is continuous, we have to use Multiple Linear Regression Model
#to predict the values.

#Preparing the environment for MLRM
library(boot) 
library(car)
library(QuantPsyc)
library(lmtest)
library(sandwich)
library(vars)
library(nortest)
library(MASS)
library(caTools)
library(dplyr)
library(Hmisc)
library(rms)

#Setting the Working Directory
Path<-"E:/IVY PRO SCHOOL/R"
setwd(Path)
getwd()

data=read.csv("Fn-UseC_-Marketing-Customer-Value-Analysis.csv")
data1=data#To create a backup of original data


#Basic Exploration of the data 
str(data1)
summary(data1)
dim(data1)

#Renaming the Dependent var
colnames(data1)[which(names(data)=="Customer.Lifetime.Value")]="clv"


#Outlier Treatment through quantile method of dependent variable 
quantile(data1$clv,c(0,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.85,0.9,0.95,0.99,0.995,1))
bench<-round(quantile(data1$clv, 0.75)+1.5*IQR(data1$clv),0)
data1$clv<-ifelse(data1$clv> bench ,(data1$clv == bench),(data1$clv<-data1$clv))


#Missing values Identification and Treatment

as.data.frame(colSums(is.na(data3)))

#Dropping the redundant variables from the data frame

as.data.frame(colnames(data3))
data4=select(data3,-c(Customer,State,Effective.To.Date))

str(data4)#final dataset for modelling

#Converting relevant variables to factors
names<-c("Response","Coverage","Education","EmploymentStatus","Gender","Location.Code","Marital.Status","Policy.Type","Policy","Renew.Offer.Type","Sales.Channel","Vehicle.Class","Vehicle.Size")    
data4[,names]<-lapply(data4[,names], factor)

#Splitting the data into training and test data set

set.seed(123)

spl = sample.split(data4$clv, 0.7)#Splits the overall data into train and test data in 70:30 ratio

original.data = subset(data4, spl == TRUE)
str(original.data)
dim(original.data)

test.data = subset(data4, spl == FALSE)
str(test.data)
dim(test.data)


#Fitting the model

#Iteration.1 We start with testing all variables

LinearModel0=lm(clv~.,data=original.data)
summary(LinearModel0)

#Removing the first two insignificant variables: policy and policy types
#Iteration.2.
LinearModel1=lm(clv~.-Policy-Policy.Type, data=original.data)
summary(LinearModel1)


#Removing the insignificant variables: Total Claim, Sales Channels, Marital  Status, Location
#Iteration.3.
LinearModel2=lm(clv~.-Policy-Policy.Type-Total.Claim.Amount-Sales.Channel-Marital.Status-Location.Code, data=original.data)
summary(LinearModel2)


#Removing the insignificant classes in dummy variables and response, GENDER
#Iteration.4.
LinearModel3=lm(clv~Coverage+	Education+	EmploymentStatus+	Income+	Monthly.Premium.Auto+	Months.Since.Policy.Inception+	Number.of.Open.Complaints+	Number.of.Policies +	Renew.Offer.Type+	Vehicle.Class+	Vehicle.Size, data=original.data)
summary(LinearModel3)


#Iteration.5.
LinearModel4=lm(clv~Coverage+I(Education=="College")+I(Education =="High School or Below")+EmploymentStatus+Income+	 Monthly.Premium.Auto+		Number.of.Open.Complaints+	Number.of.Policies +	Renew.Offer.Type+	I(Vehicle.Class=="SUV")+I(Vehicle.Class=="Sports Car")+ Vehicle.Size, data=original.data)
summary(LinearModel4)


#Iteration.6.
LinearModel5=lm(clv~	Coverage+	I(Education=="College")+I(Education =="High School or Below")+I(EmploymentStatus == "Unemployed")+Income+	 Monthly.Premium.Auto+		Number.of.Open.Complaints+	Number.of.Policies +	Renew.Offer.Type+	I(Vehicle.Class=="SUV")+I(Vehicle.Class=="Sports Car"), data=original.data)
summary(LinearModel5)

##---------------------------------------------------Final Model

FinalModel=lm(clv~	Coverage+	I(Education=="College")+I(Education =="High School or Below")+I(EmploymentStatus == "Unemployed")+Income+	 Monthly.Premium.Auto+		Number.of.Open.Complaints+	Number.of.Policies +	Renew.Offer.Type+	I(Vehicle.Class=="SUV")+I(Vehicle.Class=="Sports Car"), data=original.data)
summary(FinalModel)

#Checking Multicollinearity in the model

vif(FinalModel)

## Get the predicted or fitted values
fitted(FinalModel)

par(mfrow=c(2,2))
plot(FinalModel)

## MAPE
original.data$pred <- fitted(FinalModel)

#Calculating MAPE
attach(original.data)
MAPE<-print((sum((abs(clv-pred))/clv))/nrow(original.data))

##################################### Checking of Assumption ############################################

# residuals should be uncorrelated ##Autocorrelation
# Null H0: residuals from a linear regression are uncorrelated. Value should be close to 2. 
#Less than 1 and greater than 3 -> concern
## Should get a high p value

durbinWatsonTest(FinalModel)
dwt(FinalModel)
#Since, the p-value is >0.05, we fail to reject H0: (No Autocorrelation)

# Checking multicollinearity
vif(FinalModel) #no multicollinearity present

# Constant error variance: Heteroscedasticity

# Breusch-Pagan test
bptest(FinalModel)  # Null hypothesis -> error is non-homogeneous (p value should be more than 0.05)


## Normality testing Null hypothesis is data is normal.

resids <- FinalModel$residuals
ad.test(resids) #get Anderson-Darling test for normality 


#Testing the model on test data 
##Iteration 1:test data
fit1<- lm(clv~Coverage+	I(Education=="College")+I(Education =="High School or Below")+I(EmploymentStatus == "Unemployed")+Income+	 Monthly.Premium.Auto+		Number.of.Open.Complaints+	Number.of.Policies +	Renew.Offer.Type+	I(Vehicle.Class=="SUV")+I(Vehicle.Class=="Sports Car"), data=test.data)
summary(fit1)


##Remove I(EmploymentStatus=="Unemployed"),I(Education=="College"),I(Education =="High School or Below") 
fit2<- lm(clv~Coverage+Income+	 Monthly.Premium.Auto+		Number.of.Open.Complaints+	Number.of.Policies +	Renew.Offer.Type+	I(Vehicle.Class=="SUV")+I(Vehicle.Class=="Sports Car"),data=test.data)
summary(fit2)

##Remove Coverage Extended
fit3<- lm(clv~Coverage+Income+	 Monthly.Premium.Auto+		Number.of.Open.Complaints+	Number.of.Policies +	I(Renew.Offer.Type=="Offer2")+I(Renew.Offer.Type=="Offer4")+	I(Vehicle.Class=="SUV")+I(Vehicle.Class=="Sports Car"),data=test.data)
summary(fit3)

##Final Model
fit<- lm(clv~Coverage+Income+	 Monthly.Premium.Auto+		Number.of.Open.Complaints+	Number.of.Policies +	I(Renew.Offer.Type=="Offer2")+I(Renew.Offer.Type=="Offer4")+	I(Vehicle.Class=="SUV")+I(Vehicle.Class=="Sports Car"), data=test.data)
summary(fit)

#Check Vif, vif>2 means presence of multicollinearity
vif(fit) #no multicollinearity present

options(scipen = 999)
## Get the predicted or fitted values
fitted(fit)

write.csv(test.data, "testdataCLV.csv")
## MAPE
test.data$pred <- fitted(fit)


#Calculating MAPE
attach(test.data)
(sum((abs(clv-pred))/clv))/nrow(test.data)


##################################### Checking of Assumption ############################################

# residuals should be uncorrelated ##Autocorrelation
# Null H0: residuals from a linear regression are uncorrelated. Value should be close to 2. 
#Less than 1 and greater than 3 -> concern
## Should get a high p value

durbinWatsonTest(fit)
dwt(fit)

# Checking multicollinearity
vif(fit) 

#Constant error variance (Heteroscedasticity)

options(scipen=999)

# Breusch-Pagan test
bptest(fit) 

## Normality testing: Null hypothesis is data is normal.
resids1 <- fit$residuals
ad.test(resids1) #get Anderson-Darling test for normality 



