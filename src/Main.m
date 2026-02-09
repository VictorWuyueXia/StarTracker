clear classes;close all;clc;

 
global f % Image frames

NumOfStars=600;
MapSize=[360 180];%size of the back ground[deg]
FrameSize=[65,48.8];%size of the photo frame[deg]

rings=struct;
rings.NumOfRings=3;%make it into 3 rings
rings.boundary=[3 15];% inner boundary and outer boundary [deg]


[map,PhotoPos,photo,theta]=TestGeneration(NumOfStars,MapSize,FrameSize);
% test data generation (random)
% output(star ID&coodinates "map", photoposition(LeftBottomCorner),
% stars in the photo, tilt angle [deg])
 
fingerprint=DataBaseConstruction(NumOfStars,map,rings,MapSize);

[IDs,labels]=StarID(photo,FrameSize,fingerprint,rings);
% output(actual star IDs, corresponding stars' label in the photo)

[pos,ang]=AttitudeDetermination(map,IDs,photo,labels,FrameSize)

GIFgeneration()

close all