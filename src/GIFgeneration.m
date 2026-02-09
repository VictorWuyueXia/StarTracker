function []=GIFgeneration()
    
    NumOfColors=256;
    
    global f
    
    [im,colormap]=rgb2ind(f{1},NumOfColors,'nodither');
    imwrite(im,colormap,'DemoAnimation.gif','DelayTime',1,'LoopCount',inf,'WriteMode','overwrite');
    for i=2:length(f)
        im=rgb2ind(f{i},colormap,'nodither');      
        imwrite(im,colormap,'DemoAnimation.gif','DelayTime',1,'WriteMode','append');
    end
    
end

