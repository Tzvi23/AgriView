%% Video Aqcuisition
        vid = videoinput('winvideo', 1, 'YUY2_1024x576');
        src = getselectedsource(vid);
        vid.FramesPerTrigger = 1;

        vid.ReturnedColorspace = 'rgb';

        vid.FramesPerTrigger = 50;

        preview(vid);
        
        %MsgBox to adjust camera
        uiwait(msgbox('Press Ok when Ready to Continue'));
        
        start(vid);
        
        %Takes 50 frames pictures and takes the 49 frame as picture
        ImageTest = getdata(vid);
        data = ImageTest(:,:,:,49);
        subplot(3,3,7);
        imshow(data);
        fontSize = 12;
        title('Last Captured Image', 'FontSize', fontSize);
        stoppreview(vid);
        closepreview;