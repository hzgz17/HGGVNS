% OX2 operator
function offspring=OX2(parentA,parentB,lunch_points)
parentA=parentA(ismember(parentA,[1,lunch_points])==0);
points1=randperm(length(parentA),round(0.2*length(parentA)));
points1=sort(points1);
for n=1:length(points1)
    tt(n)=parentA(points1(n));
    ss(n)=find(parentB==tt(n));
end
ss=sort(ss);
for n=1:length(points1)
    parentB(ss(n))=tt(n);
end
offspring=parentB;
end