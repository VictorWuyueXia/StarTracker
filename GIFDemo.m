function []=GIFDemo(star0,star1,starJ,obj,rings,FrameNum)

    %Draw the rings
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
    
    theta=linspace(0,2*pi,100);
    ringx=cos(theta);
    ringy=sin(theta);
    
    radius=[inner inner+width];
    set(obj.ring1, ...
        'xdata',[star0(1)+ringx'*radius(1),star0(1)+ringx'*radius(2)], ...
        'ydata',[star0(2)+ringy'*radius(1),star0(2)+ringy'*radius(2)], ...
        'zdata',zeros(100,2));
    
    radius=[inner+width+gap inner+2*width+gap];
    set(obj.ring2, ...
        'xdata',[star0(1)+ringx'*radius(1),star0(1)+ringx'*radius(2)], ...
        'ydata',[star0(2)+ringy'*radius(1),star0(2)+ringy'*radius(2)], ...
        'zdata',zeros(100,2));
    
    radius=[inner+2*width+2*gap inner+3*width+2*gap];
    set(obj.ring3, ...
        'xdata',[star0(1)+ringx'*radius(1),star0(1)+ringx'*radius(2)], ...
        'ydata',[star0(2)+ringy'*radius(1),star0(2)+ringy'*radius(2)], ...
        'zdata',zeros(100,2));
    
    if FrameNum==1
        print("Rings",'-dpng');
    end
    
    %%
    %Draw the vectors
    set(obj.vec0toJ,'xdata',[star0(1) starJ(1)], ...
        'ydata',[star0(2) starJ(2)]);
    set(obj.vec0to1,'xdata',[star0(1) star1(1)], ...
        'ydata',[star0(2) star1(2)]);
    
    drawnow
    axis equal
    
    %%
%     get the GIF frame
    global f
    im=getframe;
    f{FrameNum}=frame2im(im);
end