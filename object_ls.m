% Calculate the objective value for the solution
function outputs=object_ls(curr_pop,distance,depart,lunch_points)
curr_pop=curr_pop(ismember(curr_pop,lunch_points)==0);
outputs=0;
depots=find(curr_pop==1);
for i=1:length(depots)-1
    pop_route=curr_pop(depots(i):depots(i+1));
    vehicle=pop_route(ismember(pop_route,1)==0);
    if isempty(vehicle)==1
        fee_vehicle=0;
    else
        fee_vehicle=50;
    end
    outputs=outputs+fee_vehicle;
    j=1;
    while j<length(pop_route)
        if pop_route(j)==1&&depart(i)==0   
            outputs=outputs+distance(i+1,pop_route(j+1));
        else
            outputs=outputs+distance(pop_route(j),pop_route(j+1));
        end
        j=j+1;
    end
end
end
