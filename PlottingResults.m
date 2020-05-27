function PlottingResults(students,bestChromosome,learningHistory,alphaHistory,interestHistory,...
    maximumFitness,percentageBest,optimiseBestStudent,optimiseWorstStudent,optimiseMin,optimiseMax,...
    optimiseRandom,toyModelBasic,toyModelBStored,toyModelMedium,toyModelMStored,toyModelHigh,...
    toyModelHStored,toyModelHighC,toyModelHC,optimiseWorstWorstStudent,optimiseWorstBestStudent,...
    optimiseMaximalCourse)

if(toyModelBasic || toyModelBStored)
    load('meanRRBasicValue')
    load('averageRRBasicEffect')
    meanValue = meanRealValue;
elseif(toyModelMedium || toyModelMStored)
    load('meanRRMediumValue')
    load('averageRRMediumEffect')
    meanValue = meanRealValue;
elseif(toyModelHigh || toyModelHStored)
    load('meanRealHighValue')
    load('averageRRHighEffect')
    meanValue = meanRealHighValue;
elseif(toyModelHighC || toyModelHC)
    load('meanRealHighValue') %we should compare with the same value as toyModelHigh 
                              %since we want to see the effect of the curriculum
    load('averageRRHighCEffect')
    meanValue = meanRealHighValue;
else
    load('meanValue')
    load('averageStudentsEffect')
    %meanValue = meanRealValue;
end


bestChromosome = reshape(bestChromosome,[2,length(bestChromosome)/2])';
lessonSequence = {1,length(bestChromosome)};
amountLearning = zeros(length(students),size(learningHistory,2));
cognitiveValue = zeros(length(students),size(alphaHistory,2));
personalInterest = zeros(length(students),size(interestHistory,2));


for j = 1:size(bestChromosome,1)
    if(bi2de(bestChromosome(j,:),'left-msb') == 0)
        lessonSequence{1,j} = 'IA';%Instructions alone
    elseif(bi2de(bestChromosome(j,:),'left-msb') == 1)
        lessonSequence{1,j} = 'CA';%coaching alone
    elseif(bi2de(bestChromosome(j,:),'left-msb') == 2)
        lessonSequence{1,j} = 'CG';%coaching group
    elseif(bi2de(bestChromosome(j,:),'left-msb') == 3)
        lessonSequence{1,j} = 'IG';%instructions group
    end
end

for k = 1:size(learningHistory,2)
    for i = 1:length(students)
        amountLearning(i,k) = learningHistory(i,k); 
        cognitiveValue(i,k) = alphaHistory(i,k);
        personalInterest(i,k) = interestHistory(i,k);
    end
end

maximumStudentEffect = max(sum(learningHistory,2));%supposed to be the mean but the meanvalue was computed with sum 
minimumStudentEffect = min(sum(learningHistory,2));
[~,studentsLearningIndex] = sort(mean(amountLearning,2));
[~,studentsCognitiveIndex] = sort(mean(cognitiveValue,2));
[~,studentsInterestIndex] = sort(mean(personalInterest,2));
% [~,studentsLearningIndex] = sort(mean(amountLearning,2));
% [~,studentsCognitiveIndex] = sort(mean(cognitiveValue,2));
% [~,studentsInterestIndex] = sort(mean(personalInterest,2));

amountLearningSorted = amountLearning(studentsLearningIndex,:)';
cognitiveValueSorted = cognitiveValue(studentsCognitiveIndex,:)';
personalInterestSorted = personalInterest(studentsInterestIndex,:)';

if (toyModelBasic || toyModelBStored || toyModelMedium || toyModelMStored)
%     [~,studentsLearningIndex] = sort(amountLearning(:,1));%needs to be sort every lesson because the best student it's different in every class
    amountLearningSorted = amountLearning(studentsLearningIndex,:)';
    amountLearningSorted = [amountLearningSorted(1,1),amountLearningSorted(1,2);0,0;0,0;0,0];
    lessonSequence1(1,:) = lessonSequence{1,1};
    figure(1)
    b = bar3(amountLearningSorted);
    ax = gca;
    ax.YTick      = 1;
    ax.YTickLabel = lessonSequence1;
    ax.XTick      = 1:length(students);
    ax.XTickLabel = studentsLearningIndex;
    %ax.Position = [0.08 0.1100 0.8 0.8];
    %ax.PlotBoxAspectRatio = [3.2,3.8,1.8];
    ax.FontSize = 12;
    xlabel('Students')
    ylabel('Lesson Types')
    title('Course effect, First Lesson')
    color = zeros(length(b),3);
    for i = 1:length(b)
        color(i,:) = [rand rand rand];
        set(b(i),'facecolor',color(i,:))
    end
    
    if(toyModelBasic || toyModelBStored)
        strConfig = {'Configuration Type:','Toy Model:','2 Students, 4 lessons,','2 Lesson types, no interactions'};
    elseif(toyModelMedium || toyModelMStored)
        strConfig = {'Configuration Type:','Toy Model:','2 Students, 4 lessons,','2 Lesson types, interactions'};
    end
    
    strFit = {'Course Effect /','Average Course effect',num2str(round((maximumFitness / meanValue),2))};
    annotation('textbox', [0.8, 0.95, 0.4, 0], 'String', strConfig,'FitBoxToText','on','LineStyle','none')
    annotation('textbox', [0.8, 0.8, 0.4, 0], 'String', strFit,'FitBoxToText','on','LineStyle','none')
    
%     [~,studentsLearningIndex] = sort(amountLearning(:,2));%needs to be sort every lesson because the best student it's different in every class
    amountLearningSorted = amountLearning(studentsLearningIndex,:)';
    amountLearningSorted = [amountLearningSorted(1,1), amountLearningSorted(1,2);...
        amountLearningSorted(2,1), amountLearningSorted(2,2);0,0;0,0];
    for i=1:2
        lessonSequence2(i,:) = lessonSequence{1,i};
    end
    
    
    figure(2)
    b= bar3(amountLearningSorted);
    ax = gca;
    ax.YTick      = 1:2;
    ax.YTickLabel = lessonSequence2;
    ax.XTick      = 1:length(students);
    ax.XTickLabel = studentsLearningIndex;
    %ax.Position = [0.08 0.1100 0.8 0.8];
    %ax.PlotBoxAspectRatio = [3.2,3.8,1.8];
    ax.FontSize = 12;
    xlabel('Students')
    ylabel('Lesson Types')
    title('Course effect, Second Lesson')
    for i = 1:length(b)
        set(b(i),'facecolor',color(i,:))
    end
    if(toyModelBasic || toyModelBStored)
        strConfig = {'Configuration Type:','Toy Model:','2 Students, 4 lessons,','2 Lesson types, no interactions'};
    elseif(toyModelMedium || toyModelMStored)
        strConfig = {'Configuration Type:','Toy Model:','2 Students, 4 lessons,','2 Lesson types, interactions'};
    end
    
    strFit = {'Course Effect /','Average Course effect',num2str(round((maximumFitness / meanValue),2))};
    annotation('textbox', [0.8, 0.95, 0.4, 0], 'String', strConfig,'FitBoxToText','on','LineStyle','none')
    annotation('textbox', [0.8, 0.8, 0.4, 0], 'String', strFit,'FitBoxToText','on','LineStyle','none')
    
%     [~,studentsLearningIndex] = sort(amountLearning(:,3));%needs to be sort every lesson because the best student it's different in every class
    amountLearningSorted = amountLearning(studentsLearningIndex,:)';
    amountLearningSorted = [amountLearningSorted(1,1), amountLearningSorted(1,2);...
        amountLearningSorted(2,1), amountLearningSorted(2,2);amountLearningSorted(3,1),...
        amountLearningSorted(3,2);0,0];
    for i=1:3
        lessonSequence3(i,:) = lessonSequence{1,i};
    end
    figure(3)
    b = bar3(amountLearningSorted);
    ax = gca;
    ax.YTick      = 1:3;
    ax.YTickLabel = lessonSequence3;
    ax.XTick      = 1:length(students);
    ax.XTickLabel = studentsLearningIndex;
    %ax.Position = [0.08 0.1100 0.8 0.8];
    %ax.PlotBoxAspectRatio = [3.2,3.8,1.8];
    ax.FontSize = 12;
    xlabel('Students')
    ylabel('Lesson Types')
    title('Course effect, Third Lesson')
    for i = 1:length(b)
        set(b(i),'facecolor',color(i,:))
    end
    if(toyModelBasic || toyModelBStored)
        strConfig = {'Configuration Type:','Toy Model:','2 Students, 4 lessons,','2 Lesson types, no interactions'};
    elseif(toyModelMedium || toyModelMStored)
        strConfig = {'Configuration Type:','Toy Model:','2 Students, 4 lessons,','2 Lesson types, interactions'};
    end
    
    strFit = {'Course Effect /','Average Course effect',num2str(round((maximumFitness / meanValue),2))};
    annotation('textbox', [0.8, 0.95, 0.4, 0], 'String', strConfig,'FitBoxToText','on','LineStyle','none')
    annotation('textbox', [0.8, 0.8, 0.4, 0], 'String', strFit,'FitBoxToText','on','LineStyle','none')
    
%    [~,studentsLearningIndex] = sort(amountLearning(:,4));%needs to be sort every lesson because the best student it's different in every class
    amountLearningSorted = amountLearning(studentsLearningIndex,:)';
    amountLearningSorted = [amountLearningSorted(1,1), amountLearningSorted(1,2);...
        amountLearningSorted(2,1), amountLearningSorted(2,2);amountLearningSorted(3,1),...
        amountLearningSorted(3,2);amountLearningSorted(4,1), amountLearningSorted(4,2)];
    for i=1:4
        lessonSequence4(i,:) = lessonSequence{1,i};
    end
    figure(6)
    b = bar3(amountLearningSorted);
    ax = gca;
    ax.YTick      = 1:4;
    ax.YTickLabel = lessonSequence4;
    ax.XTick      = 1:length(students);
    ax.XTickLabel = studentsLearningIndex;
    %ax.Position = [0.08 0.1100 0.8 0.8];
    %ax.PlotBoxAspectRatio = [3.2,3.8,1.8];
    ax.FontSize = 12;
    xlabel('Students')
    ylabel('Lesson Types')
    title('Course effect, Fourth Lesson')
    for i = 1:length(b)
        set(b(i),'facecolor',color(i,:))
    end
    if(toyModelBasic || toyModelBStored)
        strConfig = {'Configuration Type:','Toy Model:','2 Students, 4 lessons,','2 Lesson types, no interactions'};
    elseif(toyModelMedium || toyModelMStored)
        strConfig = {'Configuration Type:','Toy Model:','2 Students, 4 lessons,','2 Lesson types, interactions'};
    end
    
    strFit = {'Course Effect /','Average Course effect',num2str(round((maximumFitness / meanValue),2))};
    annotation('textbox', [0.8, 0.95, 0.4, 0], 'String', strConfig,'FitBoxToText','on','LineStyle','none')
    annotation('textbox', [0.8, 0.8, 0.4, 0], 'String', strFit,'FitBoxToText','on','LineStyle','none')
    
    figure(7)
    b = bar3(cognitiveValueSorted);
    ax = gca;
    ax.YTick      = 1:size(learningHistory,2);
    ax.YTickLabel = lessonSequence;
    ax.XTick      = 1:length(students);
    ax.XTickLabel = studentsCognitiveIndex;
    ax.Position = [0.08 0.1100 0.8 0.8];
    ax.PlotBoxAspectRatio = [3.2,3.8,1.8];
    ax.FontSize = 8;
    xlabel('Students')
    ylabel('Lesson Types')
    title('Efficacy')
    for i = 1:length(b)
        set(b(i),'facecolor',color(i,:))
    end
    
    figure(8)
    b = bar3(personalInterestSorted);
    ax = gca;
    ax.YTick      = 1:size(learningHistory,2);
    ax.YTickLabel = lessonSequence;
    ax.XTick      = 1:length(students);
    ax.XTickLabel = studentsInterestIndex;
    ax.Position = [0.08 0.1100 0.8 0.8];
    ax.PlotBoxAspectRatio = [3.2,3.8,1.8];
    ax.FontSize = 8;
    xlabel('Students')
    ylabel('Lesson Types')
    title('Student engagement')
    for i = 1:length(b)
        set(b(i),'facecolor',color(i,:))
    end
    
else
    
    figure(1)
    b = bar3(amountLearningSorted);
    ax = gca;
    ax.YTick      = 1:size(learningHistory,2);
    ax.YTickLabel = lessonSequence;
    ax.XTick      = 1:length(students);
    ax.XTickLabel = studentsLearningIndex;
    ax.Position = [0.08 0.1100 0.8 0.8];
    ax.PlotBoxAspectRatio = [3.2,3.8,1.8];
    ax.FontSize = 8;
    xlabel('Students')
    ylabel('Lesson Types')
    title('Course effect')
    color = zeros(length(b),3);
    for i = 1:length(b)
        color(i,:) = [rand rand rand];
        set(b(i),'facecolor',color(i,:))
    end
    if(optimiseWorstStudent)
        strConfig = {'Configuration Type:','Optimise for best of worst','single student'};
    elseif(optimiseBestStudent)
        strConfig = {'Configuration Type:','Optimise for best','single student'};
    elseif(toyModelBasic || toyModelBStored)
        strConfig = {'Configuration Type:','Toy Model:','2 Students, 4 lessons,','2 Lesson types, no interactions'};
    elseif(toyModelMedium || toyModelMStored)
        strConfig = {'Configuration Type:','Toy Model:','2 Students, 4 lessons,','2 Lesson types, interactions'};
    elseif(toyModelHigh || toyModelHStored)
        strConfig = {'Configuration Type:','Toy Model:','4 Students, 10 lessons,','4 Lesson types, interactions'};
    elseif(toyModelHighC || toyModelHC)
        strConfig = {'Configuration Type:','Toy Model:','4 Students, 10 lessons,','4 Lesson types, interactions,',...
            'curriculum'};
    elseif(optimiseMaximalCourse)
        strConfig = {'Configuration Type:','Maximal course evaluation'};
    elseif(optimiseMin)
        strConfig = {'Configuration Type:','Optimise for worst total sequence'};
    elseif(optimiseMax)
        strConfig = {'Configuration Type:','Optimise for best total sequence'};
    elseif(optimiseRandom)
        strConfig = {'Configuration Type:','Random sequence'};
    elseif(optimiseWorstBestStudent)
        strConfig = {'Configuration Type:','Optimise for worst of best','single student'};
    elseif(optimiseWorstWorstStudent)
        strConfig = {'Configuration Type:','Optimise for worst','single student'};
    end
    
    if(toyModelBasic || toyModelBStored || toyModelMedium || toyModelMStored || toyModelHigh || toyModelHStored)
        strFit = {'Course Effect /','Average Course effect',num2str(round((maximumFitness / meanValue),2))};
        annotation('textbox', [0.8, 0.95, 0.4, 0], 'String', strConfig,'FitBoxToText','on','LineStyle','none')
        annotation('textbox', [0.8, 0.8, 0.4, 0], 'String', strFit,'FitBoxToText','on','LineStyle','none')
    elseif(toyModelHighC || toyModelHC)
        strFit = {'Course Effect /','Average Course effect',num2str(round((maximumFitness / meanValue),2))};
        strPercent = {'Percentage of course covered', num2str(round(percentageBest,2))};
        annotation('textbox', [0.8, 0.95, 0.4, 0], 'String', strConfig,'FitBoxToText','on','LineStyle','none')
        annotation('textbox', [0.8, 0.8, 0.4, 0], 'String', strFit,'FitBoxToText','on','LineStyle','none')
        annotation('textbox', [0.8, 0.68, 0.4, 0], 'String', strPercent,'FitBoxToText','on','LineStyle','none')
    else
        strFit = {'Course Effect /','Average Course effect',num2str(round((maximumFitness / meanValue),2))};
        strPercent = {'Percentage of course covered', num2str(round(percentageBest,2))};
        strStudent = {'Best Student Effect /', 'Average single Student effect',...
            num2str(round((maximumStudentEffect / averageStudentsEffect),2))};
        strStudentW = {'Worst Student Effect /', 'Average single Student effect',...
            num2str(round((minimumStudentEffect / averageStudentsEffect),2))};
        annotation('textbox', [0.8, 0.95, 0.4, 0], 'String', strConfig,'FitBoxToText','on','LineStyle','none')
        annotation('textbox', [0.8, 0.8, 0.4, 0], 'String', strFit,'FitBoxToText','on','LineStyle','none')
        annotation('textbox', [0.8, 0.68, 0.4, 0], 'String', strPercent,'FitBoxToText','on','LineStyle','none')
        annotation('textbox', [0.8, 0.58, 0.4, 0], 'String', strStudent,'FitBoxToText','on','LineStyle','none')
        annotation('textbox', [0.8, 0.48, 0.4, 0], 'String', strStudentW,'FitBoxToText','on','LineStyle','none')
        
        %%make video
        set(gcf, 'Position', get(0, 'Screensize'));
        v = VideoWriter('rotating.avi');
        v.FrameRate = 1;
        v.Quality = 65;
        open(v);
        for i= 1:50
            camorbit(10,0)
            frame = getframe(gcf);
            writeVideo(v,frame);
        end
        close(v);
    end
    
    
    
    
    figure(2)
    b = bar3(cognitiveValueSorted);
    ax = gca;
    ax.YTick      = 1:size(learningHistory,2);
    ax.YTickLabel = lessonSequence;
    ax.XTick      = 1:length(students);
    ax.XTickLabel = studentsCognitiveIndex;
    ax.Position = [0.08 0.1100 0.8 0.8];
    ax.PlotBoxAspectRatio = [3.2,3.8,1.8];
    ax.FontSize = 8;
    xlabel('Students')
    ylabel('Lesson Types')
    title('Efficacy')
    for i = 1:length(b)
        set(b(i),'facecolor',color(i,:))
    end
    
    figure(3)
    b = bar3(personalInterestSorted);
    ax = gca;
    ax.YTick      = 1:size(learningHistory,2);
    ax.YTickLabel = lessonSequence;
    ax.XTick      = 1:length(students);
    ax.XTickLabel = studentsInterestIndex;
    ax.Position = [0.08 0.1100 0.8 0.8];
    ax.PlotBoxAspectRatio = [3.2,3.8,1.8];
    ax.FontSize = 8;
    xlabel('Students')
    ylabel('Lesson Types')
    title('Student engagement')
    for i = 1:length(b)
        set(b(i),'facecolor',color(i,:))
    end
end