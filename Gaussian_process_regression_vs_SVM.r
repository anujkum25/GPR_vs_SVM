
## Library for GPR
library(GPFDA)

## library for computing root mean square error
library(Metrics)

# library for SVM
library(e1071)


### K is number of sensors
K=100

## M is number of sensors transmitting signla. Assumption is 60%
M= K*0.6

### rest of the sensors
l=K-M

## generating sensor co-ordinates randomly
x= sample(-10:10,K, replace = T)
y= sample(-10:10,K, replace = T)

### sensor value is modeled as a sine wave
z=sin(x+y)
plot(z, type = 'l', main="Transmitted Signal")

### adding white noise to transmitted values
noise = rnorm(K,mean = 0, sd = 1)

### recieved singal after noise
t= z+noise
plot(t, type = 'l', main="Recieved Signal")

## creating a dataframe of the values
df=data.frame(x,y,z,t)

## splitting into train-test. train are data points for M sensors. test is data points for (k-M) sensors.
set.seed(123)
train_ind <- sample(seq_len(nrow(df)), size = nrow(df)*0.6)

## These are the data that is recieved at the station
train <- df[train_ind, ]
target=train$t

## converting into matrix format for compatibility with function
train <- as.matrix(train)
target= as.matrix(target)

## these values are what we need to find
test <- df[-train_ind, ]
actual <- test$t
test1 <- test[,-c(4)]
test1 <- as.matrix(test1)

##############################################################################################################################
#### GPR

model=gpr(train,t)

model=gpr(Data = train, response = target, Cov = c('linear'), hyper = NULL, mean = 0, gamma = 1, itermax = 100, reltol = 8e-10, trace = 0 )

### function argument description ###
# Data--The input data from train data. Matrix or vectors are both acceptable. Some data.frames are not acceptable.

# response--The response data from train data. Matrix or vectors are both acceptable. Some data.frames are not acceptable.

# Cov	--The kernel functions or covariance functions to use. Default is the sum of 'linear' and 'power exponentiation'.

# hyper	--The hyper parameters. Default is NULL. If not NULL, then must be a list with certain names.

# NewHyper--	Vector of the names of the new hyper parameters from customized kernel function. 
##The names of the hyper-parameters must have the format: xxxxxx.x, i.e. '6 digit' plus 'a dot' plus '1 digit'. 
##This is required for both 'hyper' and 'NewHyper'

# mean--	Is the mean taken out when analysis? Default to be 0, which assumes the mean is zero.
##if assume mean is a constant, mean=1; if assume mean is a linear trend, mean='t'.

# gamma--	Power parameter used in powered exponential kernel function.

# itermax--	Number of maximum iteration in optimization function. Default to be 100. 
##Normally the number of optimization steps is around 20. If reduce 'reltol', the iterations needed will be less.

# reltol--	Relative convergence tolerance. Smaller reltol means more accurate and slower to converge.

# trace--	The value of the objective function and the parameters is printed every trace'th iteration. 
##Defaults to 0 which indicates no trace information is to be printed.


### predicting the sensor value for the sensors which are not transmitting the data
predict=gppredict(train=model,Data.new=test)

predicted_gpr= predict$pred.mean

## computing root mean squared error in prediction
error_gpr=rmse(actual, predicted_gpr)


## actual vs predicted graph for GPR
plot(actual,type="l",col="red", main="Graph for actual Vs predicted value (GPR)", sub = "Red : Actual, Green: Predicted")
lines(predicted_gpr,col="green", type = 'b')

##################################################################################################################################
#################### Building SVM
model2= svm(target~., data=train, Kernel="radial")
predicted_svm=predict(model2,test)

error_svm=rmse(actual, predicted_svm)

## actual vs predicted graph for svm
plot(actual,type="l",col="red", main="Graph for actual Vs predicted value (SVM)", sub = "Red : Actual, Green: Predicted")
lines(predicted_svm,col="green", type = 'b')


####################################################################################################################################
