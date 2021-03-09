% Calculate the objective value for the population
function outputs=object(population,distance,depart,lunch_points)
for i=1:size(population,1)                                              
    outputs(i,1)=0;
    curr_pop=population(i,:);
    curr_pop=curr_pop(ismember(curr_pop,lunch_points)==0);
    depots=find(curr_pop==1);
    for ii=1:length(depots)-1
        pop_route=curr_pop(depots(ii):depots(ii+1));
        vehicle=pop_route(ismember(pop_route,1)==0);
        if isempty(vehicle)==1
            fee_vehicle=0;
        else
            fee_vehicle=50;
        end
        outputs(i,1)=outputs(i,1)+fee_vehicle;
        j=1;
        while j<length(pop_route)
            if pop_route(j)==1&&depart(ii)==0  
                outputs(i,1)=outputs(i,1)+distance(ii+1,pop_route(j+1));
            else
                outputs(i,1)=outputs(i,1)+distance(pop_route(j),pop_route(j+1));
            end
            j=j+1;
        end
    end 
end
end
