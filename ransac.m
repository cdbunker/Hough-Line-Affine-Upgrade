function [bestIntersect,inliers] = ransac(lines)
pts1=[];
pts2=[];
for i=1:length(lines)
   pts1 = [pts1;lines(i).point1];
   pts2 = [pts2;lines(i).point2];
end

nums=1:length(pts1);
bestInliers = [];

for it = 1:5000 %probably a better way to do this
    sample = datasample(nums,2,'Replace', false);
    point11 = [pts1(sample(1),:),1];
    point12 = [pts2(sample(1),:),1]; 
    
    point21 = [pts1(sample(2),:),1];
    point22 = [pts2(sample(2),:),1];
    
    line1 = cross(point11,point12);
    line2 = cross(point21,point22);
    intersect = cross(line1, line2);
    intersect = intersect/intersect(3);
    
    currInliers = findInliers(pts1, pts2, intersect);
    if (length(currInliers) > length(bestInliers))
        bestInliers = currInliers;
        bestIntersect = intersect;
    end
end

inliers = bestInliers;
end

function inliers = findInliers(pts1, pts2, intersect)
dist = [];

for i=1:length(pts1)
    d = point_to_line(intersect, pts1(i,:), pts2(i,:));
    dist = [dist,d];
end

inliers = find(dist < 30);
end

function d = point_to_line(pt, v1, v2)
v1=[v1,1];
v2=[v2,1];
a = v1 - v2;
b = pt - v2;
d = norm(cross(a,b)) / norm(a);
end