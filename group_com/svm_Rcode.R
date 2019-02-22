##Support VEctor Machine R-code
install.packages("e1071")
library(e1071)
install.packages("ROCR", repos = "http://cran.us.r-project.org")
library(ROCR)

##information score
a<-read.csv("datafile.csv",header=F)
ax=as.matrix(a[,1:2])
axx=as.matrix(a[,2:1])
ay=as.vector(a[,3])
colnames(ax)<-NULL
colnames(ay)<-NULL
plot(axx,col=(3-ay),xlab="cells",ylab="information score" )
legend("topright",legend=c("A","B"),col=c("black","red"),pch=c(1, 1))
adata=data.frame(x=ax,y=as.factor(ay))
#linear
asvmfit=svm(y~.,data=adata,kernel="linear", cost=10)
summary(asvmfit)
plot(asvmfit,adata)
#radial
asvmfit=svm(y~.,data=adata,kernel="radial",  gamma=1, cost=10000)
summary(asvmfit)
plot(asvmfit,adata)
#cross validationa
train=sample(56,46)
svmfit=svm(y~., data=adata[train,], kernel="linear",  cost=10)
plot(svmfit, adata[train,])
summary(svmfit)
tune.out=tune(svm, y~., data=adata[train,], kernel="linear", ranges=list(cost=c(0.1,1,10,100,1000),gamma=c(0.5,1,2,3,4)))
summary(tune.out)
table(true=adata[-train,"y"], pred=predict(tune.out$best.model,newdata=adata[-train,]))
#roc curve
rocplot=function(pred, truth, ...){
  predob = prediction(pred, truth)
  perf = performance(predob, "tpr", "fpr")
  plot(perf,...)}
svmfit.opt=svm(y~., data=adata[train,], kernel="linear", cost=10,decision.values=T)
fitted=attributes(predict(svmfit.opt,adata[train,],decision.values=TRUE))$decision.values
par(mfrow=c(1,2))
rocplot(fitted,adata[train,"y"],main="Training Data")
svmfit.flex=svm(y~., data=adata[train,], kernel="linear", cost=10, decision.values=T)
fitted=attributes(predict(svmfit.flex,adata[train,],decision.values=T))$decision.values
rocplot(fitted,adata[train,"y"],add=T,col="red")
fitted=attributes(predict(svmfit.opt,adata[-train,],decision.values=T))$decision.values
rocplot(fitted,adata[-train,"y"],main="Test Data")
fitted=attributes(predict(svmfit.flex,adata[-train,],decision.values=T))$decision.values
rocplot(fitted,adata[-train,"y"],add=T,col="red")

##AvgFr
a<-read.csv("datafile2.csv",header=F)
ax=as.matrix(a[,1:2])
axx=as.matrix(a[,2:1])
ay=as.vector(a[,3])
colnames(ax)<-NULL
colnames(ay)<-NULL
plot(axx,col=(3-ay),xlab="cells",ylab="AvgFr")
legend("topright",legend=c("A","B"),col=c("black","red"),pch=c(1, 1))
adata=data.frame(x=ax,y=as.factor(ay))
#linear
asvmfit=svm(y~.,data=adata,kernel="linear", cost=10)
summary(asvmfit)
plot(asvmfit,adata)
#radial
asvmfit=svm(y~.,data=adata,kernel="radial",  gamma=1, cost=10000)
summary(asvmfit)
plot(asvmfit,adata)
#cross validationa
train=sample(56,46)
svmfit=svm(y~., data=adata[train,], kernel="linear",  cost=10)
plot(svmfit, adata[train,])
summary(svmfit)
tune.out=tune(svm, y~., data=adata[train,], kernel="linear", ranges=list(cost=c(0.1,1,10,100,1000),gamma=c(0.5,1,2,3,4)))
summary(tune.out)
table(true=adata[-train,"y"], pred=predict(tune.out$best.model,newdata=adata[-train,]))
#roc curve
rocplot=function(pred, truth, ...){
  predob = prediction(pred, truth)
  perf = performance(predob, "tpr", "fpr")
  plot(perf,...)}
svmfit.opt=svm(y~., data=adata[train,], kernel="linear", cost=10,decision.values=T)
fitted=attributes(predict(svmfit.opt,adata[train,],decision.values=TRUE))$decision.values
par(mfrow=c(1,2))
rocplot(fitted,adata[train,"y"],main="Training Data")
svmfit.flex=svm(y~., data=adata[train,], kernel="linear", cost=10, decision.values=T)
fitted=attributes(predict(svmfit.flex,adata[train,],decision.values=T))$decision.values
rocplot(fitted,adata[train,"y"],add=T,col="red")
fitted=attributes(predict(svmfit.opt,adata[-train,],decision.values=T))$decision.values
rocplot(fitted,adata[-train,"y"],main="Test Data")
fitted=attributes(predict(svmfit.flex,adata[-train,],decision.values=T))$decision.values
rocplot(fitted,adata[-train,"y"],add=T,col="red")


##Coherence
a<-read.csv("datafile3.csv",header=F)
ax=as.matrix(a[,1:2])
axx=as.matrix(a[,2:1])
ay=as.vector(a[,3])
colnames(ax)<-NULL
colnames(ay)<-NULL
plot(axx,col=(3-ay),xlab="cells",ylab="coherence")
legend("topright",legend=c("A","B"),col=c("black","red"),pch=c(1, 1))
adata=data.frame(x=ax,y=as.factor(ay))
#linear
asvmfit=svm(y~.,data=adata,kernel="linear", cost=10)
summary(asvmfit)
plot(asvmfit,adata)
#radial
asvmfit=svm(y~.,data=adata,kernel="radial",  gamma=1, cost=10000)
summary(asvmfit)
plot(asvmfit,adata)
#cross validationa
train=sample(56,46)
svmfit=svm(y~., data=adata[train,], kernel="linear",  cost=10)
plot(svmfit, adata[train,])
summary(svmfit)
tune.out=tune(svm, y~., data=adata[train,], kernel="linear", ranges=list(cost=c(0.1,1,10,100,1000),gamma=c(0.5,1,2,3,4)))
summary(tune.out)
table(true=adata[-train,"y"], pred=predict(tune.out$best.model,newdata=adata[-train,]))
#roc curve
rocplot=function(pred, truth, ...){
  predob = prediction(pred, truth)
  perf = performance(predob, "tpr", "fpr")
  plot(perf,...)}
svmfit.opt=svm(y~., data=adata[train,], kernel="linear", cost=10,decision.values=T)
fitted=attributes(predict(svmfit.opt,adata[train,],decision.values=TRUE))$decision.values
par(mfrow=c(1,2))
rocplot(fitted,adata[train,"y"],main="Training Data")
svmfit.flex=svm(y~., data=adata[train,], kernel="linear", cost=10, decision.values=T)
fitted=attributes(predict(svmfit.flex,adata[train,],decision.values=T))$decision.values
rocplot(fitted,adata[train,"y"],add=T,col="red")
fitted=attributes(predict(svmfit.opt,adata[-train,],decision.values=T))$decision.values
rocplot(fitted,adata[-train,"y"],main="Test Data")
fitted=attributes(predict(svmfit.flex,adata[-train,],decision.values=T))$decision.values
rocplot(fitted,adata[-train,"y"],add=T,col="red")

##peak
a<-read.csv("datafile4.csv",header=F)
ax=as.matrix(a[,1:2])
axx=as.matrix(a[,2:1])
ay=as.vector(a[,3])
colnames(ax)<-NULL
colnames(ay)<-NULL
plot(axx,col=(3-ay),xlab="cells",ylab="peak")
legend("topright",legend=c("A","B"),col=c("black","red"),pch=c(1, 1))
adata=data.frame(x=ax,y=as.factor(ay))
#linear
asvmfit=svm(y~.,data=adata,kernel="linear", cost=10)
summary(asvmfit)
plot(asvmfit,adata)
#radial
asvmfit=svm(y~.,data=adata,kernel="radial",  gamma=1, cost=10000)
summary(asvmfit)
plot(asvmfit,adata)
#cross validationa
train=sample(56,46)
svmfit=svm(y~., data=adata[train,], kernel="linear",  cost=10)
plot(svmfit, adata[train,])
summary(svmfit)
tune.out=tune(svm, y~., data=adata[train,], kernel="linear", ranges=list(cost=c(0.1,1,10,100,1000),gamma=c(0.5,1,2,3,4)))
summary(tune.out)
table(true=adata[-train,"y"], pred=predict(tune.out$best.model,newdata=adata[-train,]))
#roc curve
rocplot=function(pred, truth, ...){
  predob = prediction(pred, truth)
  perf = performance(predob, "tpr", "fpr")
  plot(perf,...)}
svmfit.opt=svm(y~., data=adata[train,], kernel="linear", cost=10,decision.values=T)
fitted=attributes(predict(svmfit.opt,adata[train,],decision.values=TRUE))$decision.values
par(mfrow=c(1,2))
rocplot(fitted,adata[train,"y"],main="Training Data")
svmfit.flex=svm(y~., data=adata[train,], kernel="linear", cost=10, decision.values=T)
fitted=attributes(predict(svmfit.flex,adata[train,],decision.values=T))$decision.values
rocplot(fitted,adata[train,"y"],add=T,col="red")
fitted=attributes(predict(svmfit.opt,adata[-train,],decision.values=T))$decision.values
rocplot(fitted,adata[-train,"y"],main="Test Data")
fitted=attributes(predict(svmfit.flex,adata[-train,],decision.values=T))$decision.values
rocplot(fitted,adata[-train,"y"],add=T,col="red")
