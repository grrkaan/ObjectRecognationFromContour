mean2 =  polyApp('elma1.jpg');
mean1 =  polyApp('elma2.jpg');

means = [mean1,mean2];
[minimum,~] = min(means);
[maximum,~] = max(means);
percent = (minimum * 100 ) / maximum;
title(strcat('They are same with ', num2str(percent) , '% '));