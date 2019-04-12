# Load packages and data
library("caret")
data(iris)
dataset <- iris

# Partition data into separate datasets
validation_index <- createDataPartition(dataset$Species, p = 0.80, list = FALSE)
validation <- dataset[-validation_index,]
dataset <- dataset[validation_index,]

# Density plots for each attributes by class value
scales <- list(x = list(relation = "free"), y = list(relation = "free"))
x <- dataset[,1:4]
y <- dataset[,5]
featurePlot(x = x, y = y, plot = "density", scales = scales)

# Run algorithms using 10-fold cross validation
control <- trainControl(method = "cv", number = 10)
metric <- "Accuracy"

# Build 5 different models to compare
set.seed(23) # LDA (linear)
fit.lda <- train(Species~., data = dataset, method = "lda", metric = metric, trControl = control)
set.seed(23) # CART (nonlinear)
fit.cart <- train(Species~., data = dataset, method = "rpart", metric = metric, trControl = control)
set.seed(23) # kNN
fit.knn <- train(Species~., data = dataset, method = "knn", metric = metric, trControl = control)
set.seed(23) # SVM (complex nonlinear)
fit.svm <- train(Species~., data = dataset, method = "svmRadial", metric = metric, trControl = control)
set.seed(23) # Random Forest
fit.rf <- train(Species~., data = dataset, method = "rf", metric = metric, trControl = control)

# Summarize accuracy of models
results <- resamples(list(lda = fit.lda, cart = fit.cart, knn = fit.knn, svm = fit.svm, rf = fit.rf))
summary(results)
dotplot(results)

# Summarize best model fit
print(fit.lda)

# Estimate best model fit on validation dataset
predictions <- predict(fit.lda, validation)
confusionMatrix(predictions, validation$Species)
