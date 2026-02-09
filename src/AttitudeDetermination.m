function [pos,ang]=AttitudeDetermination(map,IDs,photo,labels,FrameSize)
    if(size(IDs,2)>=2)
        Star1=IDs(1);
        Star2=IDs(2);

        star1=labels(1);
        star2=labels(2);
    elseif(size(IDs,2)==0)
            error('No star identified.');
    else
        Star1=IDs(1);
        star1=labels(1);
        
        MinDistance=1e8;
        Star2=0;
        for i=1:size(map,2)
            if(i==Star1)
                i=i+1;
            end
            d=norm([map(2,i)-map(2,Star1),map(3,i)-map(3,Star1)]');
            MinDistance=min([d,MinDistance]);
            Star2=i*(d==MinDistance)+Star2*(d~=MinDistance);
        end
        
        MinDistance=1e8;
        star2=0;
        for i=1:size(photo,2)
            if(i==star1)
                continue
            end
            d=norm([photo(1,i)-photo(1,star1),photo(2,i)-photo(2,star1)]');
            MinDistance=min([d,MinDistance]);
            star2=i*(d==MinDistance)+star2*(d~=MinDistance);
        end
        
    end
    VectorInTheMap=[map(2,Star2)-map(2,Star1),map(3,Star2)-map(3,Star1)]';
    UnitVectorInTheMap=VectorInTheMap/norm(VectorInTheMap);

    VectorOnThePhoto=[photo(1,star2)-photo(1,star1),photo(2,star2)-photo(2,star1)]';
    UnitVectorOnThePhoto=VectorOnThePhoto/norm(VectorOnThePhoto);

    crossproduct=cross([UnitVectorInTheMap;0],[UnitVectorOnThePhoto;0]);
    crossmag=norm(crossproduct);
    ang=asind(crossmag);

    angs=[ang 180-ang 180+ang 360-ang];
    for i=1:4
        ang=angs(i);
        RotationMatrix=[cosd(ang) -sind(ang)
            sind(ang) cosd(ang)];
        star1pos=RotationMatrix^(-1)*[photo(1,star1) photo(2,star1)]';
        star2pos=RotationMatrix^(-1)*[photo(1,star2) photo(2,star2)]';
        VectorOnThePhoto=star2pos-star1pos;
        UnitVectorOnThePhoto=VectorOnThePhoto/norm(VectorOnThePhoto);
        Difference=UnitVectorOnThePhoto-UnitVectorInTheMap;
        Difference=norm(Difference);
        if(Difference<0.1)
            break
        end
    end

%     star1pos=RotationMatrix^(-1)*[photo(1,star1) photo(2,star1)]';
    PhotoCenter=[map(2,Star1) map(3,Star1)]'-star1pos;
    pos=PhotoCenter-FrameSize'/2;
end

