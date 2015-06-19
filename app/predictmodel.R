predictsexe <- function(nonzero=1,nonhighcorr=0,scale=0,pca=0,model='glm',seeds=990666){
  set.seed(seeds) #990666 0.8
                  # 298194 0.95
                  # 971767 0.55
  
  
  df= read.csv('data.csv')
  df=df[,-1]
  df$SEXE=factor(df$SEXE)
  library(caret)
  library(dplyr)
  
  intrain<-createDataPartition(y = df$SEXE, p = 0.80, list = FALSE)
  training = df[intrain,]
  testing = df[-intrain,]
  outcome_train=training$SEXE
  training=training[,-1]
  outcome_test=testing$SEXE
  testing=testing[,-1]
  
  if(nonzero==1){
    nsv <- nearZeroVar(df,saveMetrics=TRUE)
    df=df[,!nsv$nzv]
    training = df[intrain,]
    testing = df[-intrain,]
    outcome_train=training$SEXE
    training=training[,-1]
    outcome_test=testing$SEXE
    testing=testing[,-1]
    #print('nonzero')
  }
  
  if(nonhighcorr==1){
    cormat= cor(training)
    findCorrelation(cormat, cutoff=.9, verbose=FALSE)
    training= training[,-findCorrelation(cormat)]
    testing= testing[,-findCorrelation(cormat)]
    #print('nonhighcorr')
  }
  
  if(scale==1){
    preProc_scale = preProcess(training, method =c('center', 'scale'), thresh= 0.80)
    training=predict(preProc_scale, training)
    testing = predict(preProc_scale, testing)
    #print('scale')
  }
  
  if(pca==1){
    preProc_pca = preProcess(training, method = 'pca', thresh= 0.80)
    training=predict(preProc_pca, training)
    testing = predict(preProc_pca, testing)
    #print('pca')
  }
  
  
  #add outcome
  training$SEXE=outcome_train
  testing$SEXE=outcome_test
  
  #calucate the model
  if(model=='gbm'){
    modelFit = train(training$SEXE~., method= model, data=training, verbose=FALSE)
  } else{
    modelFit = train(training$SEXE~., method= model, data=training)
    
  }
  print(confusionMatrix(testing$SEXE,predict(modelFit,testing)))

  
  # what variables are important?
  VI=varImp(modelFit)$importance 
  VI=cbind(Important_variables = rownames(VI),VI) %>% arrange(desc(Overall))
  VI= VI[1:5,]

  if(pca==0){
    return(VI)
  }
  
  if(pca==1){
    print(VI)
    print('5 top variables that make the most important components:')
    temp=na.omit(as.numeric(unlist(strsplit(as.character(VI[,1]), '[^0-9]+'))))
    COMP=data.frame(component1=names(sort(preProc_pca$rotation[,temp[1]], decreasing = TRUE)[1:5] ),
                    component2=names(sort(preProc_pca$rotation[,temp[2]], decreasing = TRUE)[1:5] ),
                    component3=names(sort(preProc_pca$rotation[,temp[3]], decreasing = TRUE)[1:5] ),
                    component4=names(sort(preProc_pca$rotation[,temp[4]], decreasing = TRUE)[1:5] ),
                    component5=names(sort(preProc_pca$rotation[,temp[5]], decreasing = TRUE)[1:5] )
    )
    return(COMP)
  }
  
  
}