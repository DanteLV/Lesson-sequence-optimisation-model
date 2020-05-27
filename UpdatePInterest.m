function newPInterest = UpdatePInterest(cognitiveValue,previousPInterest,stress)

newPInterest = zeros(length(cognitiveValue),1);

for i = 1:length(cognitiveValue)
%      newPInterest(i) = previousPInterest(i) + (cognitiveValue(i) - stress(i));
    if(cognitiveValue(i) >= 0.5)
        newPInterest(i) = previousPInterest(i) + (3 + cognitiveValue(i) - stress(i));%3, (1.5(normal lecture)*2) max value in stress
    else
        newPInterest(i) = previousPInterest(i) + (3 - cognitiveValue(i) - stress(i)); 
    end
%     if(cognitiveValue(i) >= 0.5)
%         X = (1+cognitiveValue(i)) * previousPInterest(i) - (1 - cognitiveValue(i)) * stress(i);
%         newPInterest(i) = X;
%     else
%         X = (1-cognitiveValue(i)) * previousPInterest(i) - (1 + cognitiveValue(i)) * stress(i);
%         newPInterest(i) = X;      % heaviside(X) *    
%     end
 end
