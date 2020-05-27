function population = TwoLessonTypes(tempPopulation)
%This fucntion will keep only two types of lessons for the toy model
%Intstrutions Alone IA 00
%Coaching Group     CG 10
population = zeros(size(tempPopulation));
for i = 1:size(tempPopulation,1)
    for j = 2:2:size(tempPopulation,2)
        if(tempPopulation(i,j) == 1)
            tempPopulation(i,j) = 0;%it can't have a 1 in the second position, that's for CA and IG
        end
    end
    population(i,:) = tempPopulation(i,:);
end