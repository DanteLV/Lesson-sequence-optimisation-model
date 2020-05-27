function modifiedPopulation = InsertBestSequence(population,bestIndividualIndex,numberOfCopies)

for i=1:numberOfCopies
    population(i,:) = population(bestIndividualIndex,:);
end

modifiedPopulation = population;