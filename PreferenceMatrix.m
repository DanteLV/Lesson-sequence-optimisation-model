function preference = PreferenceMatrix(studentPreferences,lessonType,student)

lessonType = bi2de(lessonType,'left-msb') + 1;
preference = studentPreferences(student,lessonType);