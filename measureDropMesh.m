function [triAngs,triAreas,triPerims] = measureDropMesh(tri,faceX,faceY)
%Measures the geometrical properties of the triangular mesh specified by tri, faceX, faceY.

triAngs = zeros(size(tri,1),3);
triAreas = zeros(size(tri,1),1);
triPerims = zeros(size(tri,1),1);

for i = 1:size(tri,1)
    xPt = faceX(tri(i,:));
    yPt = faceY(tri(i,:));
    
    %Heron's formula for area
    a = sqrt((xPt(1) - xPt(2)).^2 + (yPt(1) - yPt(2)).^2);
    b = sqrt((xPt(2) - xPt(3)).^2 + (yPt(2) - yPt(3)).^2);
    c = sqrt((xPt(3) - xPt(1)).^2 + (yPt(3) - yPt(1)).^2);
    
    s = (a + b + c) / 2;
    
    triAreas(i) = sqrt(s * (s-a) * (s-b) * (s-c));
    
    %Calculate the angle between corners of triangle using cosine rule
    triAngsTmp = zeros(3,1);
    triAngsTmp(1) = acosd((a^2 + b^2 - c^2)/(2*a*b));
    triAngsTmp(2) = acosd((b^2 + c^2 - a^2)/(2*b*c));
    triAngsTmp(3) = acosd((c^2 + a^2 - b^2)/(2*c*a));
    
    triAngs(i,:) = sort(triAngsTmp);
    
    %Find the triangle perimeter
    sides = [a,b,c];
    triPerims(i) = sum(sides);
end