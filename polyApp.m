function meanOfLentgth = polyApp(imgName)
a = imread(imgName);
a_gray = rgb2gray(a);
level = 0.96;
threshold = 5;
a_bw = imbinarize(a_gray,level);
Icomp = imcomplement(a_bw);
hold on
se = strel('disk',4);
closedImg = imclose(Icomp,se);
hold on 
[B,~] = bwboundaries(closedImg);
hold on
lineLengths = [];
egimler = [];

for k = 1:length(B)
   boundary = B{k};
   xCoordinate = boundary(:,2);
   yCoordinate = boundary(:,1);
   size = length(xCoordinate) - 1;
   startX = xCoordinate(1);
   startY = yCoordinate(1);
   stopX = xCoordinate(size);
   stopY = yCoordinate(size);
   
    coefficients = polyfit([startX,stopX], [startY,stopY], 1);
    aConstant = coefficients (1);
    bConstant = coefficients (2);
%    y = aConstant*x + bConstant ==> y = ax+b
%    aConstant* x - y + bConstant = 0 ==> ax - y + b = 0
  
    [max,index] = findDistances(size,aConstant,bConstant,xCoordinate,yCoordinate,1);
    newStartElement = 1;
    newStopElement = size;
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1);

   while index <= size && max > 0.00001
      
       if max > threshold
        startX = xCoordinate(newStartElement);
        startY = yCoordinate(newStartElement);
        stopX = xCoordinate(newStopElement);
        stopY = yCoordinate(newStopElement);
        newStopElement = index;
        coefficients = polyfit([startX,stopX], [startY,stopY], 1);
        aConstant = coefficients (1);
        bConstant = coefficients (2);
        [max,index] = findDistances(newStopElement,aConstant,bConstant,xCoordinate,yCoordinate,newStartElement);  
       else
        
        newStartElement = newStopElement;
        newStopElement = size;
        plot([startX,stopX],[startY,stopY], 'b', 'LineWidth', 4);
        pause(0.15);
        lineLengths = [lineLengths calculateDistance(startX,stopX,startY,stopY)];
        egimler = [egimler findM(startX,stopX,startY,stopY)]
        startX = xCoordinate(newStartElement);
        startY = yCoordinate(newStartElement);
        stopX = xCoordinate(newStopElement);
        stopY = yCoordinate(newStopElement);
        
        
        coefficients = polyfit([startX,stopX], [startY,stopY], 1);
        aConstant = coefficients (1);
        bConstant = coefficients (2);
        [max,index] = findDistances(size,aConstant,bConstant,xCoordinate,yCoordinate,newStartElement); 
         
%         startX = xCoordinate(newXElement);
%         startY = yCoordinate(newXElement);
       end
   end
   
   normalizedValues = normalization(lineLengths);
   meanLength = mean(normalizedValues,2);
   histogram(normalizedValues);
   
   

end
meanOfLentgth = meanLength;
end

function [maximum,index] = findDistances(size,aConstant,bConstant,xCoordinate,yCoordinate,startPoint)
      for l = startPoint: size
       distanceToLine = abs(aConstant * xCoordinate(l) - yCoordinate(l) + bConstant) / sqrt(aConstant^2 + 1);
       distance(l) =  distanceToLine; 
      end
      
      [maximum,index] = max(distance);
end

function d =  calculateDistance (x1,x2,y1,y2)
    d = sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function [normalizedLength] = normalization(length)

    [maxValueOfLength,~] = max(length);
    [~,arrSize] = size(length);
    
    for k = 1 : arrSize
       normalizedLength(k) =  length(k) / maxValueOfLength ;
    end
    [normalizedLength] = normalizedLength;
end

function egim =  findM(startX,stopX,startY,stopY)
    coefficients = polyfit([startX,stopX], [startY,stopY], 1);
    egim = coefficients(1);
end