function [map,PhotoPos,photo,theta] = TestGeneration(num,MapSize,FrameSize)
    
    n = num;% Number of stars
    map=zeros(3,n);
    map(1,:)=1:n;% [star ID;x-coord;y-coord]
    map(2,:)= rand(1,n)*MapSize(1);% random generation of stars
    map(3,:)= rand(1,n)*MapSize(2);% random generation of stars
    
    PhotoPos(1,:)=rand(1)*(MapSize(1)-FrameSize(1));
    PhotoPos(2,:)=rand(1)*(MapSize(2)-FrameSize(2))
    
    
    
    figure%The whole map and the photo area
    
    plot(map(2,:),map(3,:),'*')
    hold on
    grid on
    axis equal
    
    PhotoFrame=line(NaN,NaN,'color','r','linewidth',2);
    xdata=[0 0 1 1 0];
    ydata=[0 1 1 0 0];
    set(PhotoFrame,'xdata',PhotoPos(1)+xdata*FrameSize(1), ...
        'ydata',PhotoPos(2)+ydata*FrameSize(2));
    drawnow
    
    print("MapNPhoto",'-dpng');
    
    
    
%    The photo captured
    
    StarsInThePhoto=map(1, ...
        map(2,:)>PhotoPos(1) & map(2,:)<PhotoPos(1)+FrameSize(1) & ...
        map(3,:)>PhotoPos(2) & map(3,:)<PhotoPos(2)+FrameSize(2) ...
        );
    photo=[map(2,StarsInThePhoto)-PhotoPos(1)-FrameSize(1)/2;
        map(3,StarsInThePhoto)-PhotoPos(2)-FrameSize(2)/2];
    
    theta=rand(1,1)*360
    
    RotationMatrix=[cosd(theta) -sind(theta)
        sind(theta) cosd(theta)];
    
    for i=1:size(photo,2)
        photo(1:2,i)=RotationMatrix*photo(1:2,i);
    end
    
%     plot(photo(2,:),photo(3,:),'*','markersize',10,'linewidth',2);
%     hold on
%     grid on
%     ax=gca;
%     ax.XAxisLocation='origin';
%     ax.YAxisLocation='origin';
end

