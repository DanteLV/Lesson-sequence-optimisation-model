function bestRandomSequences = RandomizeSequence(bestSequence,numberOfStudents,maximumFitness,...
  studentsInfluence,personalInterest,alpha,numberOfLessons,percentageBest,studentPreferences,studentEfforts,...
  learningBest)

randomTimes = 1000;
bestChromosome = reshape(bestSequence,[2,length(bestSequence)/2])';
bestRandomSequences = zeros(11,2);
bestRandomSequences(1,:) = [maximumFitness,percentageBest];
randomSequences = zeros(randomTimes + 1,2);%the one obtained from the optimization
bestStudents = zeros(randomTimes + 1,1);
worstStudents = zeros(randomTimes + 1,1);

%%%Only used to obtain mean values
%learningHistory = cell(randomTimes,1);
%meanStudentsLearning = zeros(randomTimes,1);

for i=1:randomTimes
    newSequence = zeros(1,numberOfLessons *2);
    orderSequence = randperm(numberOfLessons);
    k = 1; %variable for iteration
    for j=1:2:numberOfLessons*2
         newSequence(1,j:j+1) = bestChromosome(orderSequence(k),:);
         k = k + 1;
    end
    [fitness,~,~,learningHistory,percentageCourse] = EvaluateSequence(numberOfStudents,studentsInfluence,personalInterest,...
        newSequence,alpha,numberOfLessons,studentPreferences,studentEfforts);
    randomSequences(i,:) = [fitness,percentageCourse];
    bestStudents(i) = max(mean(learningHistory,2));
    worstStudents(i) = min(mean(learningHistory,2));
    %meanStudentsLearning(i) = mean(sum(learningHistory{i,1},2)); %% used for mean values
%     [~,idxMin] = min(bestRandomSequences(2:end,1));
%     if(fitness > bestRandomSequences(idxMin+1,1))
%         bestRandomSequences(idxMin+1,:) = [fitness,percentageCourse];
%     end
end

%averageStudentsEffect = mean(meanStudentsLearning);%% used for mean values
optimizedBestStudent = max(mean(learningBest,2));
optimizedWorstStudent = min(mean(learningBest,2));
randomSequences(end,:) = [maximumFitness,percentageBest]; 
bestStudents(end) = optimizedBestStudent;
worstStudents(end) = optimizedWorstStudent;
maxStudentBestValue = max(bestStudents);
minStudentBestValue = min(bestStudents);
maxStudentWorstValue = max(worstStudents);
minStudentWorstValue = min(worstStudents);
maxValue = max(randomSequences(:,1));
minValue = min(randomSequences(:,1));
binRanges = linspace(minValue,maxValue,20);
binStudentBestRanges = linspace(minStudentBestValue,maxStudentBestValue,20);
binStudentWorstRanges = linspace(minStudentWorstValue,maxStudentWorstValue,20);
% figure(16)
figure(4)
[binCounts,binInd] = histc(randomSequences(:,1),binRanges);
bar(binRanges,binCounts,'histc')
hold on;
scatter(maximumFitness,binCounts(binInd(end)),40,'filled','MarkerFaceColor','red')
title("Effect of randomizing sequence's order")
%figure(17)
figure(5)
scatter(randomSequences(:,1),randomSequences(:,2),'*')
hold on;
plot(randomSequences(end,1),randomSequences(end,2),'d','MarkerSize',10);
%Best Students
figure(9)
[binStudBestCounts,binStudBestInd] = histc(bestStudents,binStudentBestRanges);
bar(binStudentBestRanges,binStudBestCounts,'histc')
hold on;
scatter(optimizedBestStudent,binStudBestCounts(binStudBestInd(end)),40,'filled','MarkerFaceColor','red')
title("Best Student Effect randomizing sequence's order")
%WorstStudents
figure(10)
[binStudWorstCounts,binStudWorstInd] = histc(worstStudents,binStudentWorstRanges);
bar(binStudentWorstRanges,binStudWorstCounts,'histc')
hold on;
scatter(optimizedWorstStudent,binStudWorstCounts(binStudWorstInd(end)),40,'filled','MarkerFaceColor','red')
title("Worst Student Effect randomizing sequence's order")