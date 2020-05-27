clear all; clf;clc; close all;

%%%Different optimizations
optimiseBestStudent = false; %optimise for the best student,max(max)
optimiseWorstStudent = false; %optimise for the best of the worst student,max(min)
optimiseWorstWorstStudent = false;%optimise for the worst worst student,min(min)
optimiseWorstBestStudent = true;%optimise for the wrost best student,min(max)
optimiseMin = false; %finds the worst chromosome
optimiseMax = false; %finds the best chromosome with curriculum
optimiseMaximalCourse = false;%finds maximum value without curriculum
optimiseRandom = false; %it means no evolution needed

%%%Configurations with Stored Classes
classFixed = true;%same class for every configuration except toyModel, Real data
toyModelBStored = false;%real students, always optimise for the best
toyModelMStored = false;%real students, always for the best
toyModelHStored = false;%real students, always for the best
toyModelHC = false;%same as toyModelHStored, but with curriculum added, always for the best

%Toy model without stored class
toyModelBasic = false;% 2 students, 4 lessos, 2 lesson types, no interactions
toyModelMedium = false;%2 students, 4 lessons, 2 lesson types, interactions
toyModelHigh = false;%4 students, 10 lessons, 4 lesson types, interactions
toyModelHighC = false;%High + curriculum

%%%Different configurations of classes
% storedClass = false;%random individuality students, not raw
% storedClassRaw = false;%raw students and fixed distribution of them
rawClass = false;%random students to generate new stored class

%%%Parameters for the optimization
populationSize = 30;%30,100 for toyBasic & medium,10000 to compute average
numberOfLessons = 40;%40,4,10
crossoverProbability = 0.6;%0.8,0.7 maximalCourseEffect & optimiseMax & BestBestStudent & ToyModelHighC,...
                           % 0.6 BestWorst
mutationProbability =0.0125;%0.0125 c/m, 0.125 toyBasic & medium, 0.05 toyHigh,where c = 1 and m = length of chromosome
tournamentSelectionParameter = 0.85;%needs to be between 0.7 - 0.8, 0.75 safer,...
                                   %0.8 maximalCourseEffect & optimiseMax & BestBestStudent & 
                                   %& toyModelHigh & toyModelHighC, 0.85
                                   %BestWorst
tournamentSize = 25;%10, 20 maximalCourseEffect & optimiseMax & BestBestStudent & BestWorst,...
                    %70 ToyModelHigh, 60 ToyModelHighC, 25 BestWorst
numberOfCopies = 2;%2
numberOfGenerations = 200;%200
fitness = zeros(populationSize,1);
percentageCourse = zeros(populationSize,1);
numberOfStudents = 30;%30,2,4
%individuality = 0.5 .* rand(numberOfStudents,1);% creates a number to change effort and preference matrices

% samplesAverage = 10;
% averageMaximumFitness = zeros(samplesAverage,1);

population = InitializeLessonSequences(populationSize, numberOfLessons, optimiseRandom,toyModelBasic,...
    toyModelMedium,toyModelHigh, toyModelBStored, toyModelMStored, toyModelHStored,optimiseMaximalCourse,...
    optimiseMax,toyModelHC);
if(classFixed)
    students = (1:numberOfStudents)';
    load('preferencesStudentsReal')
    load('effortsStudentsReal')
    load('influenceStudentsReal')
    load('alphaStudentsReal')
    load('personalInterestStudentsReal')
end
    
if(toyModelBStored || toyModelMStored)
    students = (1:numberOfStudents)';
    load('toyModelBM alpha')
    load('toyModelBM efforts')
    load('toyModelBM interest')
    load('toyModelBM preferences')
    if(toyModelBStored)
        studentsInfluence = StudentsInfluenceR(numberOfStudents,toyModelBasic,toyModelBStored);
    else
        load('toyModelM influence')
    end
end
    
if(toyModelHStored || toyModelHC)
    students = (1:numberOfStudents)';
    load('toyModelH alpha')
    load('toyModelH efforts')
    load('toyModelH interest')
    load('toyModelH preferences')
    load('toyModelH influence')
end


if(rawClass || toyModelBasic || toyModelMedium || toyModelHigh || toyModelHighC)
    [students,studentPreferences,studentEfforts] = InitializeStudents(numberOfStudents,rawClass,...
        toyModelBasic,toyModelMedium,toyModelHigh,toyModelHighC);
    studentsInfluence = StudentsInfluenceR(numberOfStudents,toyModelBasic,toyModelBStored);
    alpha = 0.5 + 0.4 .* rand(numberOfStudents,1);%Initial cognitive component (0.5, 0.9)  r = a + (b-a).*rand(N,1).
    personalInterest = 0.2 + 2.6 .* rand(numberOfStudents,1); %Initial personal interest, (0.2,2.8), 3 max stress
end


if(optimiseRandom)
    % for t = 1:samplesAverage%only used for the average
    %    population = InitializeLessonSequences(populationSize, numberOfLessons, optimiseRandom);%""
    %   students = InitializeStudents(numberOfStudents);%""
    %  studentsInfluence = StudentsInfluenceR(numberOfStudents);%""
    
    %%%randomFitness = zeros(populationSize,1);
    %%%meanStudentsLearning = zeros(populationSize,1);
    %%%for i=1:populationSize
    
    bestIndividualIndex = randi(populationSize);
    chromosome = population(bestIndividualIndex,:);
   %%%  chromosome = population(i,:);
    [fitness,alphaHistory,interestHistory,learningHistory,percentageCourse] = ...
        EvaluateSequence(numberOfStudents,studentsInfluence,personalInterest,chromosome,...
        alpha,numberOfLessons,studentPreferences,studentEfforts);
    maximumFitness = fitness;
   %%% randomFitness(i) = fitness; 
   %%%meanStudentsLearning(i) = mean(sum(learningHistory,2));
    xBest = population(bestIndividualIndex,:);
    alphaBest = alphaHistory;
    interestBest = interestHistory;
    learningBest = learningHistory;
    percentageBest = percentageCourse;
  %%%  end
    % averageMaximumFitness(t) = maximumFitness;%only used for the average
    %end
% % %     meanRealValue = mean(randomFitness);
% % %     averageStudentsEffect = mean(meanStudentsLearning);
else
    %     s= 0;
    %     for t = 1:samplesAverage
    %         population = InitializeLessonSequences(populationSize, numberOfLessons, optimiseRandom);
    %         students = InitializeStudents(numberOfStudents);
    %         studentsInfluence = StudentsInfluenceR(numberOfStudents)toyModelBasic = false;% 2 students, 4 lessos, 2 lesson types, no interactions
    
    for iGeneration = 1:numberOfGenerations
        iGeneration
        if(optimiseMin)
            maximumFitness = inf; %Assumes non-negative fitness values! i.e. no negative amount of learning
        else
            maximumFitness = 0.0; 
        end
        highestLearn = 0;
        learningHistory = cell(populationSize,1);
        lowestLearn = inf;
        xBest = zeros(1,2); % [0 0]
        bestIndividualIndex = 0;
        for i = 1:populationSize
            chromosome = population(i,:);
            [fitness(i),alphaHistory,interestHistory,learningHistory{i,1},percentageCourse(i)] = ...
                EvaluateSequence(numberOfStudents,studentsInfluence,personalInterest,chromosome,...
                alpha,numberOfLessons,studentPreferences,studentEfforts);
            
             %Optimise for ToyModelBasic & Medium, & optimiseMaximalCourse 
            if(toyModelBasic || toyModelBStored || toyModelMedium || toyModelMStored || toyModelHigh...
                        || toyModelHStored || optimiseMaximalCourse)
                    if (fitness(i) > maximumFitness)
                        maximumFitness = fitness(i);
                        bestIndividualIndex = i;
                        xBest = population(i,:);
                        alphaBest = alphaHistory;
                        interestBest = interestHistory;
                        learningBest = learningHistory{i,1};
                        percentageBest = percentageCourse(i);
                    end
            end
            
            %Optimise for best total sequence
             if(optimiseMax || toyModelHC || toyModelHighC)
                    if (fitness(i) > maximumFitness && percentageCourse(i) >= 95)
                        maximumFitness = fitness(i);
                        bestIndividualIndex = i;
                        xBest = population(i,:);
                        alphaBest = alphaHistory;
                        interestBest = interestHistory;
                        learningBest = learningHistory{i,1};
                        percentageBest = percentageCourse(i);
                    end
             end
            
           
            
            
                %Optimise for the Worst total sequence
            if(optimiseMin)
                if (fitness(i) < maximumFitness)
                    maximumFitness = fitness(i);
                    bestIndividualIndex = i;
                    xBest = population(i,:);
                    alphaBest = alphaHistory;
                    interestBest = interestHistory;
                    learningBest = learningHistory{i,1};
                    percentageBest = percentageCourse(i);
                end
            end
            
           %Optimise for the Best Student
            if(optimiseBestStudent)
                currentHighestLearn = max(mean(learningHistory{i,1},2));
                if (currentHighestLearn > highestLearn && percentageCourse(i) >= 95)
                    highestLearn = currentHighestLearn;
                    maximumFitness = fitness(i);%highest learn student
                    bestIndividualIndex = i;
                    xBest = population(i,:);
                    alphaBest = alphaHistory;
                    interestBest = interestHistory;
                    learningBest = learningHistory{i,1};
                    percentageBest = percentageCourse(i);
                end
            end
            
            %Optimise for best of Worst Student
            if(optimiseWorstStudent)
                currentLowestLearn = min(mean(learningHistory{i,1},2));
                if (currentLowestLearn > highestLearn && percentageCourse(i) >= 95)%aiming to maximise the minimum value
                    highestLearn = currentLowestLearn;
                    maximumFitness = fitness(i);%
                    bestIndividualIndex = i;
                    xBest = population(i,:);
                    alphaBest = alphaHistory;
                    interestBest = interestHistory;
                    learningBest = learningHistory{i,1};
                    percentageBest = percentageCourse(i);
                end
            end
            
            %Optimise for worst student
            if(optimiseWorstWorstStudent)
                currentLowestLearn = min(mean(learningHistory{i,1},2));
                if (currentLowestLearn < lowestLearn && percentageCourse(i) >= 95)%aiming to minimise the minimum value
                    lowestLearn = currentLowestLearn;
                    maximumFitness = fitness(i);%
                    bestIndividualIndex = i;
                    xBest = population(i,:);
                    alphaBest = alphaHistory;
                    interestBest = interestHistory;
                    learningBest = learningHistory{i,1};
                    percentageBest = percentageCourse(i);
                end
            end
            
            %Optimise for worst of the best student
            if(optimiseWorstBestStudent)
                currentLowestLearn = max(mean(learningHistory{i,1},2));
                if (currentLowestLearn < lowestLearn && percentageCourse(i) >= 95)%aiming to minimise the maximum value
                    lowestLearn = currentLowestLearn;
                    maximumFitness = fitness(i);%
                    bestIndividualIndex = i;
                    xBest = population(i,:);
                    alphaBest = alphaHistory;
                    interestBest = interestHistory;
                    learningBest = learningHistory{i,1};
                    percentageBest = percentageCourse(i);
                end
            end
        end
        
        tempPopulation = population;
        
        for i = 1:2:populationSize
            i1 = Selection(fitness,tournamentSelectionParameter,tournamentSize,percentageCourse,...
                optimiseMin,learningHistory,optimiseBestStudent,optimiseWorstStudent,toyModelBasic,...
                toyModelBStored,toyModelMedium,toyModelMStored,toyModelHigh,toyModelHStored,...
                optimiseMaximalCourse,optimiseWorstWorstStudent,optimiseWorstBestStudent,optimiseMax,...
                toyModelHC,toyModelHighC);
            i2 = Selection(fitness,tournamentSelectionParameter,tournamentSize,percentageCourse,...
                optimiseMin,learningHistory,optimiseBestStudent,optimiseWorstStudent,toyModelBasic,...
                toyModelBStored,toyModelMedium,toyModelMStored,toyModelHigh,toyModelHStored,...
                optimiseMaximalCourse,optimiseWorstWorstStudent,optimiseWorstBestStudent,optimiseMax,...
                toyModelHC,toyModelHighC);
            chromosome1 = population(i1,:);
            chromosome2 = population(i2,:);
            
            r = rand;
            if (r < crossoverProbability)
                newChromosomePair = Crossover(chromosome1,chromosome2);
                tempPopulation(i,:) = newChromosomePair(1,:);
                tempPopulation(i+1,:) = newChromosomePair(2,:);
            else
                tempPopulation(i,:) = chromosome1;
                tempPopulation(i+1,:) = chromosome2;
            end
        end % Loop over population
        
        for i = 1:populationSize
            originalChromosome = tempPopulation(i,:);
            mutatedChromosome = Mutation(originalChromosome,mutationProbability);
            tempPopulation(i,:) = mutatedChromosome;
        end
        
        if(toyModelBasic || toyModelBStored || toyModelMedium || toyModelMStored && maximumFitness > 0)
            tempPopulation = InsertBestSequence(tempPopulation,bestIndividualIndex,numberOfCopies);
            population = TwoLessonTypes(tempPopulation);%to keep only two types of lessons 
        elseif(maximumFitness > 0)
            tempPopulation = InsertBestSequence(tempPopulation,bestIndividualIndex,numberOfCopies);
            population = tempPopulation;
        else
            population = tempPopulation;
        end
        
        
        
    end % Loop over generations
    %averageMaximumFitness(t) = maximumFitness; %only used for average
    % s = s +1  %only used for average
end
%end

%it is only used to compute the average
% maxValue = max(averageMaximumFitness(:,1));
% minValue = min(averageMaximumFitness(:,1));
% binRanges = linspace(minValue,maxValue,20);
% binCounts = histc(averageMaximumFitness(:,1),binRanges);
% bar(binRanges,binCounts,'histc')
% title('Average lesson effect for random sequences')

randomSequence = RandomizeSequence(xBest,numberOfStudents,maximumFitness,studentsInfluence,...
    personalInterest,alpha,numberOfLessons,percentageBest,studentPreferences,studentEfforts,learningBest);
PlottingResults(students,xBest,learningBest,alphaBest,interestBest,maximumFitness,percentageBest,...
    optimiseBestStudent,optimiseWorstStudent,optimiseMin,optimiseMax,optimiseRandom,toyModelBasic,...
    toyModelBStored,toyModelMedium,toyModelMStored,toyModelHigh,toyModelHStored,toyModelHighC,toyModelHC,...
    optimiseWorstWorstStudent,optimiseWorstBestStudent,optimiseMaximalCourse)
% Print final result
format long;
disp('xBest');
disp(xBest);
disp('maximumFitness');
disp(maximumFitness);
disp('percentage Course');
disp(percentageBest);