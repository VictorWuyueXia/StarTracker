function [IDs,labels] = StarID(photo,FrameSize,fingerprint,rings)
%%
%   demo

    figure
    
    plot(photo(1,:),photo(2,:),'*','markersize',10,'linewidth',2);
    hold on
    grid on
    axis equal
    
    ax=gca;
    ax.XAxisLocation='origin';
    ax.YAxisLocation='origin';
    
    obj=struct;
    obj.ring1=surf(NaN(3,100),NaN(3,100),NaN(3,100), ...
        'FaceColor','r','FaceAlpha',0.3,'EdgeColor','k','LineWidth',1,"EdgeAlpha",0);
    obj.ring2=surf(NaN(3,100),NaN(3,100),NaN(3,100), ...
        'FaceColor','r','FaceAlpha',0.3,'EdgeColor','k','LineWidth',1,"EdgeAlpha",0);
    obj.ring3=surf(NaN(3,100),NaN(3,100),NaN(3,100), ...
        'FaceColor','r','FaceAlpha',0.3,'EdgeColor','k','LineWidth',1,"EdgeAlpha",0);
    obj.vec0toJ=line(NaN,NaN,'color','k','linewidth',2);
    obj.vec0to1=line(NaN,NaN,'color','r','linewidth',2);
    
    FrameNum=1;%Number of GIF frame

%%
%     Prepare the photo and the rings
    characters=zeros(4,4);
    photo=[1:size(photo,2);photo];% label the stars captured
    
    inner=rings.boundary(1);
    outer=rings.boundary(2);
    NumOfRings=rings.NumOfRings;
    if NumOfRings~=1
        width=(outer-inner-1)/NumOfRings;
        gap=1/(NumOfRings-1);
    else
        width=outer-inner;
        gap=0;
    end
 
%     find characteristics of the stars captured
    slot=1;
    for i = 1:size(photo,2)%star traversal in the photo
        if(norm(photo(2:3,i))<FrameSize(2)/2-outer) %stars pickable, not near the margin
                
                
            characters(1,slot)=photo(1,i);
            for k=1:3% within which ring
                SurroundingStars=[0,0]';% [IDs;distance]
                
                for j = 1:size(photo,2)%stars within the ring
                vector=[photo(2,j)-photo(2,i),photo(3,j)-photo(3,i)]';
                distance=norm(vector);
                    if(distance>=inner+(k-1)*width+(k-1)*gap & distance<inner+k*width+(k-1)*gap)%if in one of the rings
                        l=size(SurroundingStars,2);
                        SurroundingStars(:,l+1)=[photo(1,j),distance]';
                    end
                end
                SurroundingStars=SurroundingStars(:,SurroundingStars(1,:)~=0);
                SurroundingStars=sortrows(SurroundingStars',2)';
                SurroundingStars=SurroundingStars(1,:);
                
                clear j
                
                crossproduct=[0 0 0]';
                for J=1:size(SurroundingStars,2)% crossproduct sequence
                    star0=photo(1,i);
                    starJ=SurroundingStars(J);
                    star1=SurroundingStars(1);
                    vector=[photo(2,starJ)-photo(2,star0),photo(3,starJ)-photo(3,star0),0]';
                    crossproduct=cross(crossproduct,vector);
                    if(crossproduct(1:3)==[0 0 0]')
                        crossproduct=vector;
                    end
 
%Demos
                    %Demonstration
                    GIFDemo([photo(2,star0) photo(3,star0)], ...
                        [photo(2,star1) photo(3,star1)], ...
                        [photo(2,starJ),photo(3,starJ)], ...
                        obj,rings,FrameNum);
                    FrameNum=FrameNum+1;
                    
                end
                characters(k+1,slot)=norm(crossproduct);
                
                
            end
            slot=slot+1;
            if slot==5
                break
            end
            
        end
        
    end
    
    characters=characters(:,characters(1,:)~=0);
    
    %%
    %know which ones they are
    candidates={};
    for i=1:size(characters,2)% for each star measured
        candidates{i}=0;
        key=characters(2:4,i);
        for j=1:size(fingerprint,2)
            if(abs(fingerprint(2,j)-key(1))<0.1 & ...
                    abs(fingerprint(3,j)-key(2))<0.1 & ...
                    abs(fingerprint(4,j)-key(3))<0.1)
                candidates{i}(size(candidates{i},2)+1)=fingerprint(1,j);
            end
        end
        candidates{i}=candidates{i}(candidates{i}~=0);
    end
    
    % there may be multiple candidates, need a method to pinpoint the ...
    % candidates, which ones exactly are they
    
    for i=1:size(candidates,2)
        if(size(candidates{i},2)==0)
            pause;
        end
    end
    
    labels=characters(1,:);
    for i=1:size(candidates,2)
        IDs(i)=candidates{i}(1);
    end
   
    if(size(labels,2)==0)
    	error('No star identified.');
    end
end

