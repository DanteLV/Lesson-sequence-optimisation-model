function newAlphas = UpdateAlphas(previousAlphas,historyLearningClass,lessonNumber)

newAlphas = zeros(length(previousAlphas),1);
for j = 1:length(previousAlphas)
    meanLearning = (1/lessonNumber) * sum(historyLearningClass(j,:));
    meanClassLearning = (1/(size(historyLearningClass,1)-1)) *... 
         (sum(historyLearningClass(:,lessonNumber))-historyLearningClass(j,lessonNumber));
    functionArgument = (1 - previousAlphas(j)) * (historyLearningClass(j,lessonNumber) - meanClassLearning) +...
                 previousAlphas(j) * (historyLearningClass(j,lessonNumber) - meanLearning);
    newAlphas(j) = 1 / (1 + exp(-0.01*functionArgument));%0.01,100converges too fast, 0.1 fluctuates too much
end