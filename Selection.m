function iSelected = Selection(fitness, pTournament, tournamentSize, percentageCourse,optimiseMin,...
    learningHistory,optimiseBestStudent,optimiseWorstStudent,toyModelBasic,toyModelBStored,toyModelMedium,...
    toyModelMStored,toyModelHigh,toyModelHStored,optimiseMaximalCourse,optimiseWorstWorstStudent,...
    optimiseWorstBestStudent,optimiseMax,toyModelHC,toyModelHighC)

populationSize = size(fitness,1);
iTmp = zeros(tournamentSize,1);
bestStudentSequences = zeros(tournamentSize,1);
worstStudentSequences = zeros(tournamentSize,1);
selectionTmp = true;
%selectionCourseTmp = true;
for i = 1:tournamentSize
    iTmp(i) = 1 + fix(rand*populationSize);%j individuals selected
    if(optimiseBestStudent || optimiseWorstBestStudent)
        bestStudentSequences(i) = max(mean(learningHistory{iTmp(i),1},2));
    elseif(optimiseWorstStudent || optimiseWorstWorstStudent)
        worstStudentSequences(i) = min(mean(learningHistory{iTmp(i),1},2));
    end
end

while(selectionTmp)
    
    r = rand;
    
    if (r < pTournament)
        
        %Optimise for the worst sequence
        if(optimiseMin)
            [~,iTmpSelected] = min(fitness(iTmp));
            iSelected = iTmp(iTmpSelected);
            selectionTmp = false;%finish selection
        end    
            %Optimise for the best Student
        if(optimiseBestStudent)
            [~,iTmpSelected] = max(bestStudentSequences);%select the best individual
            if (percentageCourse(iTmp(iTmpSelected)) >= 95)
                iSelected = iTmp(iTmpSelected);
                selectionTmp = false;%finish selection
            else
                if(size(iTmp,1) == 1)%if there is only one value left choose that one
                    [~,iTmpSelected] = max(bestStudentSequences);
                    iSelected = iTmp(iTmpSelected);
                    selectionTmp = false;
                else
                    iTmp(iTmpSelected) = [];
                    bestStudentSequences(iTmpSelected) = [];
                end
            end
        end
            %Optimise for the worst student
        if(optimiseWorstStudent)
            [~,iTmpSelected] = max(worstStudentSequences);%select the best for the worst student
            if (percentageCourse(iTmp(iTmpSelected)) >= 95)
                iSelected = iTmp(iTmpSelected);
                selectionTmp = false;%finish selection
            else
                if(size(iTmp,1) == 1)%if there is only one value left choose that one
                    [~,iTmpSelected] = max(worstStudentSequences);
                    iSelected = iTmp(iTmpSelected);
                    selectionTmp = false;
                else
                    iTmp(iTmpSelected) = [];
                    worstStudentSequences(iTmpSelected) = [];
                end
            end
        end
            
            %Optimise for the worstWorstStudent
            
        if(optimiseWorstWorstStudent)
            [~,iTmpSelected] = min(worstStudentSequences);%select the worst for the worst student
            if (percentageCourse(iTmp(iTmpSelected)) >= 95)
                iSelected = iTmp(iTmpSelected);
                selectionTmp = false;%finish selection
            else
                if(size(iTmp,1) == 1)%if there is only one value left choose that one
                    [~,iTmpSelected] = min(worstStudentSequences);
                    iSelected = iTmp(iTmpSelected);
                    selectionTmp = false;
                else
                    iTmp(iTmpSelected) = [];
                    worstStudentSequences(iTmpSelected) = [];
                end
            end
        end
            
            %Optimise for the worstBestStudent
            
        if(optimiseWorstBestStudent)
            [~,iTmpSelected] = min(bestStudentSequences);%select the best individual
            if (percentageCourse(iTmp(iTmpSelected)) >= 95)
                iSelected = iTmp(iTmpSelected);
                selectionTmp = false;%finish selection
            else
                if(size(iTmp,1) == 1)%if there is only one value left choose that one
                    [~,iTmpSelected] = min(bestStudentSequences);
                    iSelected = iTmp(iTmpSelected);
                    selectionTmp = false;
                else
                    iTmp(iTmpSelected) = [];
                    bestStudentSequences(iTmpSelected) = [];
                end
            end
        end
            %Optimise for toyModelBasic, toyModelMedium,
            %toyModelHigh, MaximalCourse
            
        if(toyModelBasic || toyModelBStored || toyModelMedium || toyModelMStored || toyModelHigh...
                || toyModelHStored || optimiseMaximalCourse)
            [~,iTmpSelected] = max(fitness(iTmp));%select the best individual
            iSelected = iTmp(iTmpSelected);
            selectionTmp = false;%finish selection
        end
            
            %Optimise for the best sequence and toyModelHC
        if(optimiseMax || toyModelHC || toyModelHighC)
            [~,iTmpSelected] = max(fitness(iTmp));%select the best individual
            if (percentageCourse(iTmp(iTmpSelected)) >= 95)
                iSelected = iTmp(iTmpSelected);
                selectionTmp = false;%finish selection
            else
                if(size(iTmp,1) == 1)%if there is only one value left choose that one
                    [~,iTmpSelected] = max(fitness(iTmp));
                    iSelected = iTmp(iTmpSelected);
                    selectionTmp = false;
                else
                    iTmp(iTmpSelected) = [];
                end
            end
        end
        
        %If the probability of selecting the best individual is less than r
    else
        
        %for the Worst sequence
        if(optimiseMin)
            if(size(iTmp,1) == 1)%if there is only one value left choose that one
                [~,iTmpSelected] = min(fitness(iTmp));
                iSelected = iTmp(iTmpSelected);
                selectionTmp = false;
            else
                [~,idx] = min(fitness(iTmp));
                iTmp(idx) = [];%delete the min value and continue with j-1 individuals
            end
        end
            
            %for the Best Student
        if(optimiseBestStudent)
            if(size(iTmp,1) == 1)%if there is only one value left choose that one
                [~,iTmpSelected] = max(bestStudentSequences);
                iSelected = iTmp(iTmpSelected);
                selectionTmp = false;
            else
                [~,idx] = max(bestStudentSequences);
                iTmp(idx) = [];%delete the max value and continue with j-1 individuals
                bestStudentSequences(idx) = [];
            end
        end
        
            %for the Worst Student
        if(optimiseWorstStudent)
            if(size(iTmp,1) == 1)%if there is only one value left choose that one
                [~,iTmpSelected] = max(worstStudentSequences);%it needs to be the best for the worst student
                iSelected = iTmp(iTmpSelected);
                selectionTmp = false;
            else
                [~,idx] = max(worstStudentSequences);%it needs to be the best for the worst student
                iTmp(idx) = [];%delete the max value and continue with j-1 individuals
                worstStudentSequences(idx) = [];
            end
        end
            
            %Optimise for worstWorstStudent
            
        if(optimiseWorstWorstStudent)
            if(size(iTmp,1) == 1)%if there is only one value left choose that one
                [~,iTmpSelected] = min(worstStudentSequences);%it needs to be the worst for the worst student
                iSelected = iTmp(iTmpSelected);
                selectionTmp = false;
            else
                [~,idx] = min(worstStudentSequences);%it needs to be the worst for the worst student
                iTmp(idx) = [];%delete the max value and continue with j-1 individuals
                worstStudentSequences(idx) = [];
            end
        end
            %Optimise for the worstBestStudent
            
        if(optimiseWorstBestStudent)
            if(size(iTmp,1) == 1)%if there is only one value left choose that one
                [~,iTmpSelected] = min(bestStudentSequences);
                iSelected = iTmp(iTmpSelected);
                selectionTmp = false;
            else
                [~,idx] = min(bestStudentSequences);%optimise for the worst best student
                iTmp(idx) = [];%delete the max value and continue with j-1 individuals
                bestStudentSequences(idx) = [];
            end
        end
            
            %Optimise for MaximalCouse, toyModelBasic, toyModelMedium, toyModelHigh,
        if(toyModelBasic || toyModelBStored || toyModelMedium || toyModelMStored || toyModelHigh...
                || toyModelHStored || optimiseMaximalCourse)
            if(size(iTmp,1) == 1)%if there is only one value left choose that one
                [~,iTmpSelected] = max(fitness(iTmp));
                iSelected = iTmp(iTmpSelected);
                selectionTmp = false;
            else
                [~,idx] = max(fitness(iTmp));
                iTmp(idx) = [];%delete the max value and continue with j-1 individuals
            end
        end
            
            %for the Best sequence, toyModelHC
        if(optimiseMax || toyModelHC || toyModelHighC)
            if(size(iTmp,1) == 1)%if there is only one value left choose that one
                [~,iTmpSelected] = max(fitness(iTmp));
                iSelected = iTmp(iTmpSelected);
                selectionTmp = false;
            else
                [~,idx] = max(fitness(iTmp));
                iTmp(idx) = [];%delete the max value and continue with j-1 individuals
            end
            
        end
    end
    
end