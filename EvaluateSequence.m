function [amountOfLearningChromosome,alphaHistory,interestHistory,historyLearningClass,percentageCourse] = ...
    EvaluateSequence(numberOfStudents,studentsInfluence,currentInterest,chromosome,alpha,...
    numberOfClasses,studentPreferences,studentEfforts)

chromosome = reshape(chromosome,[2,length(chromosome)/2])';
studentInterest = zeros(numberOfStudents,1);
amountOfLearning = zeros(numberOfStudents,1);
amountOfLearningClass = zeros(length(chromosome),1);
historyLearningClass = zeros(numberOfStudents,length(chromosome));
alphaHistory = zeros(numberOfStudents,length(chromosome));
interestHistory = zeros(numberOfStudents,length(chromosome));
stress = zeros(numberOfStudents,1);
percentageCourse = 0;

for k = 1:length(chromosome)
    if(bi2de(chromosome(k,:),'left-msb') == 0)
        workload = 1.5;
        percentageCourse = percentageCourse + 1.5; %Instructions Alone
    elseif (bi2de(chromosome(k,:),'left-msb') == 1)
        workload = 0.8;
        percentageCourse = percentageCourse + 0.8; % Coaching Alone
    elseif (bi2de(chromosome(k,:),'left-msb') == 2)
        workload = 0.6;
        percentageCourse = percentageCourse + 0.6; % Coaching Group
    elseif (bi2de(chromosome(k,:),'left-msb') == 3)
        workload = 0.7;
        percentageCourse = percentageCourse + 0.7;% Instructions Group
    end
    for j = 1:numberOfStudents
        studentInterest(j) = PersonalInterest(numberOfStudents,studentsInfluence,currentInterest,j);
        stress(j) = workload * EffortMatrix(studentEfforts,chromosome(k,:),j);
        amountOfLearning(j) = studentInterest(j) *...
            PreferenceMatrix(studentPreferences,chromosome(k,:),j);
    end
    
    historyLearningClass(:,k) = amountOfLearning;
    interestHistory(:,k) = studentInterest;
    amountOfLearningClass(k) = sum(amountOfLearning);
    alphaHistory(:,k) = UpdateAlphas(alpha,historyLearningClass,k);
    alpha = (1/k) .* sum(alphaHistory,2);
    currentInterest = UpdatePInterest(alpha,currentInterest,stress);
end

percentageCourse = (percentageCourse * 100) / numberOfClasses;
amountOfLearningChromosome = sum(amountOfLearningClass);