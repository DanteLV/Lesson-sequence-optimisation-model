function effort = EffortMatrix(studentEfforts,lessonType,student)

lessonType = bi2de(lessonType,'left-msb') + 1;
effort = studentEfforts(student,lessonType);
