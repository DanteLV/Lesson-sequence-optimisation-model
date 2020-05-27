function influence = StudentsInfluenceR(numberOfStudents,toyModelBasic,toyModelBStored)

if(toyModelBasic || toyModelBStored)
    influence = zeros(numberOfStudents);
else
    influence = rand(numberOfStudents);
    influence = influence - diag(diag(influence,0)); %Self-influence = 0
end