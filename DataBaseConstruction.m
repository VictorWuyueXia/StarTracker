function [fingerprint]=DataBaseConstruction(n,map,rings,MapSize)
    
    
    inner=rings.boundary(1);
    outer=rings.boundary(2);
    NumOfRings=rings.NumOfRings;
    width=(outer-inner-1)/NumOfRings;
    gap=1/(NumOfRings-1);
    
    fingerprint=zeros(4,n);
    
    slot=1;
    for i = 1:n%star traversal
        if(map(2,i)>outer & map(2,i)<MapSize(1)-outer & ...
                    map(3,i)>outer & map(3,i)<MapSize(2)-outer) %stars pickable, not near the margin
                
                
            fingerprint(1,slot)=map(1,i);
            for k=1:3% within which ring
                SurroundingStars=[0,0]';% [IDs;distance]
                
                for j = 1:n%stars within the ring
                    vector=[map(2,j)-map(2,i),map(3,j)-map(3,i)]';
                    distance=norm(vector);
                    if(distance>=inner+(k-1)*width+(k-1)*gap & distance<inner+k*width+(k-1)*gap)%if in one of the rings
                        l=size(SurroundingStars,2);
                        SurroundingStars(:,l+1)=[j,distance]';
                    end
                end
                SurroundingStars=SurroundingStars(:,SurroundingStars(1,:)~=0);
                SurroundingStars=sortrows(SurroundingStars',2)';
                SurroundingStars=SurroundingStars(1,:);
                
                crossproduct=[0 0 0]';
                for j=1:size(SurroundingStars,2)% crossproduct sequence
                    star1=i;
                    star2=SurroundingStars(j);
                    vector=[map(2,star2)-map(2,star1),map(3,star2)-map(3,star1),0]';
                    crossproduct=cross(crossproduct,vector);
                    if(crossproduct(1:3)==[0 0 0]')
                        crossproduct=vector;
                    end
                    
                end
                fingerprint(k+1,slot)=norm(crossproduct);
                
                
            end
            slot=slot+1;
            
            
        end
        
    fingerprint=fingerprint(:,fingerprint(1,:)~=0);
    fingerprint=sortrows(fingerprint',[2 3 4])';
    end
end

