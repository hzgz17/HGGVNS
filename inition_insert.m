%initial insertion
function route=inition_insert(demand,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points)
route=ones(1,num_caregiver+1);
for i=1:length(route)-1
    depot=find(route==1);
    route=[route(1:depot(i)) lunch_points(i) route(depot(i)+1:end)];
end
number=syn_points;
number=number(randperm(length(number)));
while length(number)>=1 %insert the synchronized visits 
    for i=1:length(route)-1
        po{i,1}=[route(1:i) number(1) route(i+1:end)];
    end    
    outputs1=inition_object1(po,quality,syn_points,num_caregiver,num_patient,num_syn);
    [~,ind]=min(outputs1);
    route=po{ind,1};
    po=[];
    number=number(ismember(number,route)==0);
end
demand=demand(ismember(demand,syn_points)==0);
demand=demand(randperm(length(demand)));
while length(demand)>=1 %insert the real visits 
    for i=1:length(route)-1
        pop{i,1}=[route(1:i) demand(1) route(i+1:end)];
    end
    outputs=inition_object(pop,distance,timewindow,servicetime,quality,depart,worktime,lunch_points);
    [~,index]=min(outputs);
    route=pop{index,1};
    pop=[];
    demand=demand(ismember(demand,route)==0);
end
end

