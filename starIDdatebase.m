clear;close all; clc;

n = 100;
starCoord = rand(n,2)*50;



for i = 1:n
    % plot the star field map
    x1 = starCoord(i,1);
    y1 = starCoord(i,2);
    plot(x1,y1,'*')
    hold on
    
    % identify the stars within distance of 5
    % store the index of those stars in starWithin5
    k = 1;  
    for j = 1:n      
        if (j ~= i)
            r = norm(starCoord(i,:)-starCoord(j,:));
            if r <= 5
                starWithin5(i,k) = j;
                k = k+1;
            end
        end
    end
    
    % in case that there's no star within 5
%     p = size(starWithin5(i,:));
%     p = p(1);
%     if p < i
%         % star within 10
%     end
end


m = size(starWithin5);
m = m(2);
for i = 1:n
    Star1 = [starCoord(i,:), 0];
    k = 1;
    for j = 1:m
        starIndex = starWithin5(i,j);
        if starIndex ~= 0
            Star2 = [starCoord(starIndex,:),0];
            V = cross(Star1, Star2);
            mag = norm(V);
            corssProMag(i,k) = mag;
            corssProUnit(i,k,:) = V/mag;
            k = k+1;
        end 
    end
    
    p = size(corssProMag);
    p = p(1);
    if p == i
        corssProMag(i,:) = sort(corssProMag(i,:));
    end
    
end
            
            
            


