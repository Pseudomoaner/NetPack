function [meshClass,class1Prop,class2Prop,class3Prop,class4Prop] = classifyDropMesh(triAngs,triAreas,triLens,verbose,dropArea)

triAreas = triAreas/dropArea; %Normalize the area of the triangles according to the average drop area.
triLens = triLens/sqrt(dropArea/pi); %Normalize the length of the triangles according to the average drop radius

class1AngThresh = [60,67];
class2AngThresh = [83,97];
class1AreaThresh = [0.25,0.75]; %For both hexagonal and square packings, the mesh triangles should be half the area of the constituting droplets.
class2AreaThresh = [0.25,0.75]; 
class3Grad = 0.0545; %From idealised triangles (equilateral and icosoles right-angled)
class3Intercept = 3.73;

class1Angs = and(triAngs(:,3) > class1AngThresh(1), triAngs(:,3) < class1AngThresh(2));
class2Angs = and(triAngs(:,3) > class2AngThresh(1), triAngs(:,3) < class2AngThresh(2));
class4Angs = and(triAngs(:,3) > class1AngThresh(2), triAngs(:,3) < class2AngThresh(1));

class1Areas = and(triAreas > class1AreaThresh(1), triAreas < class1AreaThresh(2));
class2Areas = and(triAreas > class2AreaThresh(1), triAreas < class2AreaThresh(2));
class4Areas = and(triAreas > mean([class1AreaThresh(1),class2AreaThresh(1)]),triAreas < mean([class1AreaThresh(2),class2AreaThresh(2)]));

class1 = and(class1Angs,class1Areas);
class2 = and(class2Angs,class2Areas);
class4 = and(class4Angs,class4Areas);
badPack = ~or(or(class1,class2),class4);

class3Lens = or(((triAngs(:,3) * class3Grad) + class3Intercept) <= triLens,badPack);

meshClass = nan(size(class1Angs));
meshClass(and(class1,~class3Lens)) = 2; %Hexagonal - want yellow
meshClass(and(class2,~class3Lens)) = 3; %Square - want red
meshClass(and(class4,~class3Lens)) = 1; %Amorphous - want light blue
meshClass(class3Lens) = 0; %No-pack - want dark blue

if verbose
    figure
    xlabel('Largest angle (degrees)','FontSize',15)
    ylabel('Triangle area (Proportion of average drop area)','FontSize',15)
    hold on
    patch([class1AngThresh(1),class1AngThresh(1),class1AngThresh(2),class1AngThresh(2)],[class1AreaThresh(1),class1AreaThresh(2),class1AreaThresh(2),class1AreaThresh(1)],[0,1,0]);
    patch([class2AngThresh(1),class2AngThresh(1),class2AngThresh(2),class2AngThresh(2)],[class2AreaThresh(1),class2AreaThresh(2),class2AreaThresh(2),class2AreaThresh(1)],[0,0,1]);
    plot(triAngs(:,3),triAreas,'r.')
end

class1Prop = sum(triAreas(meshClass == 2))/sum(triAreas);
class2Prop = sum(triAreas(meshClass == 3))/sum(triAreas);
class3Prop = sum(triAreas(meshClass == 0))/sum(triAreas);
class4Prop = sum(triAreas(meshClass == 1))/sum(triAreas);

fprintf('Hexagonal packing fraction = %d\n',class1Prop)
fprintf('Square packing fraction = %d\n',class2Prop)
fprintf('No-pack packing fraction = %d\n',class3Prop)
fprintf('Amorphous packing fraction = %d\n',class4Prop)