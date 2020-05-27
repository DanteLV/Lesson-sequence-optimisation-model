function studentInterest = PersonalInterest(numberOfStudents,studentsInfluence,currentInterest,studentJ)

studentInterest = 0;
for i = 1:numberOfStudents
    if (i == studentJ)
        studentInterest = studentInterest + 0;
    else
        studentInterest = studentInterest + ((1-studentsInfluence(i,studentJ)) * currentInterest(studentJ) +...
            studentsInfluence(i,studentJ) * currentInterest(i));
    end
end

studentInterest = (1/(numberOfStudents-1)) * heaviside(studentInterest) * studentInterest;