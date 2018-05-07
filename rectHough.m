clear all
close all

frame = 'amsterdam.jpg';
img = rgb2gray(imread(frame));

BW = edge(img,'canny');

%[H,T,R] = hough(BW,'RhoResolution',0.01);
[H,T,R] = hough(BW,'ThetaResolution',0.1);

%P  = houghpeaks(H,500, 'Threshold', 150);
P  = houghpeaks(H,500);

lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',70);

figure, imshow(img), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

[intersect1, inliers1]=ransac(lines);

figure, imshow(img), hold on
max_len = 0;
for i = 1:length(inliers1)
    k = inliers1(i);
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

lines2 = lines;
lines2(inliers1)=[];

[intersect2, inliers2]=ransac(lines2);

figure, imshow(img), hold on
max_len = 0;
for i = 1:length(inliers2)
    k = inliers2(i);
   xy = [lines2(k).point1; lines2(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines2(k).point1 - lines2(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end


%%
s=size(img);
p_inf1 = intersect1;
p_inf2 = intersect2;

l_inf = cross(p_inf1, p_inf2);
l_inf = l_inf / norm(l_inf);
l_inf = l_inf / l_inf(3);

H = [1, 0, 0; 0, 1, 0];
H(3,:) = l_inf';

boundaries = [1, s(2), s(2), 1; 1, 1, s(1), s(1),; 1, 1, 1, 1];
tl=H*boundaries(:,1);
tl=tl/tl(3);
tr=H*boundaries(:,2);
tr=tr/tr(3);
br=H*boundaries(:,3);
br=br/br(3);
bl=H*boundaries(:,4);
bl=bl/bl(3);
point_boundaries = [tl';tr';br';bl'];
new_boundaries = ceil([max(point_boundaries(:,1)), max(point_boundaries(:,2))]);

figure;
imshow(img);

final_img = uint8(zeros(new_boundaries(2), new_boundaries(1), 3));

for x=1: new_boundaries(1)
    for y=1: new_boundaries(2)
        xy = [x, y, 1]';
        original_point = H\xy;
        original_point = round(original_point/original_point(3));
        
        if (original_point(1) < s(2) && original_point(2) < s(1))
            if (original_point(1) > 0 && original_point(2) > 0)
                final_img(y, x, :) = img(original_point(2), original_point(1),:);
            end
        end
    end
end

[~,ind] = min([norm(intersect1),norm(intersect2)]); %just to rotate final image

if (ind==1)
   pt1=[lines(inliers1(1)).point1,1];
   pt1=H*pt1';
   pt1=pt1/pt1(3);
   pt2=[lines(inliers1(1)).point2,1];
   pt2=H*pt2';
   pt2=pt2/pt2(3);

   line = cross(pt1,pt2);
   angle = atan2d(line(1),line(2));
   final=imrotate(final_img,-angle);
else
   pt1=[lines2(inliers2(1)).point1,1];
   pt1=H*pt1';
   pt1=pt1/pt1(3);
   pt2=[lines2(inliers2(1)).point2,1];
   pt2=H*pt2';
   pt2=pt2/pt2(3);

   line = cross(pt1,pt2);
   angle = atan2d(line(1),line(2));
   final=imrotate(final_img,-angle);
end

imshow(final)