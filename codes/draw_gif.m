function draw_gif(filename, i, slice)
imshow(slice)
drawnow

set(gcf, 'color', [1 1 1])

frame = getframe(1);
im = frame2im(frame);
[imind, cm] = rgb2ind(im,256);

if i == 1
    imwrite(imind,cm,filename,'gif','Loopcount',inf);
else
    imwrite(imind,cm,filename,'gif','WriteMode','append');
end
end