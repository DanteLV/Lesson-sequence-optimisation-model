function goodLessons = InitializeLessonSequences(numberOfSequences, numberOfLessons,optimiseRandom,...
    toyModelBasic,toyModelMedium,toyModelHigh, toyModelBStored, toyModelMStored,toyModelHStored,...
    optimiseMaximalCourse,optimiseMax,toyModelHC)
%Lesson Type
%00 normal lecture ---now---> Instructions Alone
%01 active learning --now---> Coaching Alone
%10 work alone  ----now-----> Coaching Group
%11 work groups ----now-----> Instructions Group
if(toyModelBasic || toyModelMedium || toyModelBStored || toyModelMStored)
    lessons = zeros(1, numberOfLessons*2);
    goodLessons = zeros(numberOfSequences, numberOfLessons*2);
    for t = 1:numberOfSequences
        for j = 1:numberOfLessons*2
            s = rand;
            if (s < 0.5)
                lessons(1,j)=0;
            else
                lessons(1,j)=1;
            end
        end
        
        for k = 2:2:numberOfLessons*2
            if (lessons(1,k) == 1)
                lessons(1,k)=0;
            end
        end
        goodLessons(t,:) = lessons;
    end
elseif (toyModelHigh || toyModelHStored || optimiseMax || optimiseMaximalCourse || optimiseRandom || toyModelHC)
    goodLessons = zeros(numberOfSequences, numberOfLessons);
    for i = 1:numberOfSequences
        for j = 1:numberOfLessons*2
            s = rand;
            if (s < 0.5)
                goodLessons(i,j)=0;
            else
                goodLessons(i,j)=1;
            end
        end
    end
    
    
else %including toyModelHighC
    lessons = zeros(1, numberOfLessons*2);
    goodLessons = zeros(numberOfSequences, numberOfLessons*2);
    goodSequences = 0;
    while(goodSequences < numberOfSequences)
        percentageCourse = 0;
        for j = 1:numberOfLessons*2
            s = rand;
            if (s < 0.5)
                lessons(1,j)=0;
            else
                lessons(1,j)=1;
            end
        end
        for k=1:2:numberOfLessons*2
            if(bi2de(lessons(1,k:k+1),'left-msb') == 0)%Instructions alone 1.7
                %  workload = 1.1;
                percentageCourse = percentageCourse + 1.5;
            elseif (bi2de(lessons(1,k:k+1),'left-msb') == 1)%Coaching alone 0.8
                % workload = 0.6;
                percentageCourse = percentageCourse + 0.8;
            elseif (bi2de(lessons(1,k:k+1),'left-msb') == 2)%Coaching groups 0.6
                %workload = 0.8;
                percentageCourse = percentageCourse + 0.6;
            elseif (bi2de(lessons(1,k:k+1),'left-msb') == 3)%Instructions groups 0.7
                %workload = 0.7;
                percentageCourse = percentageCourse + 0.7;
            end
        end
        percentageCourse = (percentageCourse * 100) / numberOfLessons;
        if (percentageCourse >= 95)
            goodSequences = goodSequences +1;
            goodLessons(goodSequences,:) = lessons(1,:);
        end
    end
    
end
end