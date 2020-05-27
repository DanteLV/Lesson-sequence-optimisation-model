function [students,studentPreferences,studentEfforts] = InitializeStudents(numberOfStudents,rawClass,...
    toyModelBasic,toyModelMedium,toyModelHigh,toyModelHighC)
%Learning Style
%00 Diverging
%01 Accomodating
%10 Converging
%11 Assimilating
if(rawClass || toyModelBasic || toyModelMedium || toyModelHigh || toyModelHighC)
    %---------------IMPORT DATA---------------
class = readtable('Student preferences.csv');
classPreferences = table2array(class);
students = (1:numberOfStudents)';
s = size(classPreferences);
h = s(1);
%Format:
%INSALO  COAALO  COAGRO  INGRO
%...     ...     ...     ...

%--------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------GENERATE CLASS---------------
studentPreferences = zeros(numberOfStudents,4); %Initiate class
for i = 1:numberOfStudents
   % rndPosition = [3 49 31 4];% students selected for the toy model basic and
   % medium #4 and #50 in the table
    rndPosition = randi([1 h+1-i]); %choose random student from population
    studentPreferences(i,:) = classPreferences(rndPosition,:);%put student in class
    % studentPreferences = classPreferences(rndPosition,:);
   classPreferences(rndPosition,:) = []; %remove chosen student from population
end
    
else
    %---------------IMPORT DATA---------------
    learningStyleDistribution = csvread('LearningStyleDistribution.csv',1,0);
    %Format:
    %Div     Acc     Con     Ass
    %...     ...     ...     ...
    
    distributionDataDivergent = csvread('DistributionDataDivergent.csv',1,1);
    distributionDataAccomodating = csvread('DistributionDataAccomodating.csv',1,1);
    distributionDataConvergent = csvread('DistributionDataConvergent.csv',1,1);
    distributionDataAssimilating = csvread('DistributionDataAssimilating.csv',1,1);
    %Format:
    %LS     INSALO  COAALO  COAGRO  INSGRO
    %Mean   ...     ...     ...     ...
    %StdDev ...     ...     ...     ...
    
    %------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %--------------GENERATE CLASS--------------
    
    learningStyleProb = learningStyleDistribution./sum(learningStyleDistribution);
    
    limit = 0.5;
    students = zeros(numberOfStudents,2);
    studentPreferences = zeros(numberOfStudents,4);
    learningStyleProbCumulative = cumsum(learningStyleProb);
    %Format:
    %LS     INSALO  COAALO  COAGRO  INSGRO
    %...    ...     ...     ...     ...
    
    for i = 1:numberOfStudents
        rnd = rand;
        if rnd < learningStyleProbCumulative(1)
            students(i,:) = [0,0]; %Divergent preference
            studentPreferences(i,1) = normrndLimited(distributionDataDivergent(1,1),distributionDataDivergent(2,1),limit); %INSALO preference
            studentPreferences(i,2) = normrndLimited(distributionDataDivergent(1,2),distributionDataDivergent(2,2),limit); %COAALO preference
            studentPreferences(i,3) = normrndLimited(distributionDataDivergent(1,3),distributionDataDivergent(2,3),limit); %COAGRO preference
            studentPreferences(i,4) = normrndLimited(distributionDataDivergent(1,4),distributionDataDivergent(2,4),limit); %INSGRO preference
        elseif rnd < learningStyleProbCumulative(2)
            students(i,:) = [0,1]; %Accomodating preference
            studentPreferences(i,1) = normrndLimited(distributionDataAccomodating(1,1),distributionDataAccomodating(2,1),limit); %INSALO preference
            studentPreferences(i,2) = normrndLimited(distributionDataAccomodating(1,2),distributionDataAccomodating(2,2),limit); %COAALO preference
            studentPreferences(i,3) = normrndLimited(distributionDataAccomodating(1,3),distributionDataAccomodating(2,3),limit); %COAGRO preference
            studentPreferences(i,4) = normrndLimited(distributionDataAccomodating(1,4),distributionDataAccomodating(2,4),limit); %INSGRO preference
        elseif rnd < learningStyleProbCumulative(3)
            students(i,:) = [1,0]; %Convergent preference
            studentPreferences(i,1) = normrndLimited(distributionDataConvergent(1,1),distributionDataConvergent(2,1),limit); %INSALO preference
            studentPreferences(i,2) = normrndLimited(distributionDataConvergent(1,2),distributionDataConvergent(2,2),limit); %COAALO preference
            studentPreferences(i,3) = normrndLimited(distributionDataConvergent(1,3),distributionDataConvergent(2,3),limit); %COAGRO preference
            studentPreferences(i,4) = normrndLimited(distributionDataConvergent(1,4),distributionDataConvergent(2,4),limit); %INSGRO preference
        else
            students(i,:) = [1,1]; %Assimilating preference
            studentPreferences(i,1) = normrndLimited(distributionDataAssimilating(1,1),distributionDataAssimilating(2,1),limit); %INSALO preference
            studentPreferences(i,2) = normrndLimited(distributionDataAssimilating(1,2),distributionDataAssimilating(2,2),limit); %COAALO preference
            studentPreferences(i,3) = normrndLimited(distributionDataAssimilating(1,3),distributionDataAssimilating(2,3),limit); %COAGRO preference
            studentPreferences(i,4) = normrndLimited(distributionDataAssimilating(1,4),distributionDataAssimilating(2,4),limit); %INSGRO preference
        end
    end
end

studentEfforts = 2.5 - studentPreferences.*0.5;
