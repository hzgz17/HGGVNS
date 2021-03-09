% the objective for inserting real visits
function outputs=inition_object(population,distance,timewindow,servicetime,quality,depart,worktime,lunch_points)
for i=1:size(population,1)                                        
    curr_pop=population{i};                            
     outputs(i,1)=0;
    depots=find(curr_pop==1);
    len=length(depots);
    for ii=1:len-1
        pop_route=curr_pop(depots(ii):depots(ii+1));
        lunpoint=intersect(pop_route,lunch_points);
        s=find(pop_route==lunpoint);
        n=1;
        time=0;
        while n<length(pop_route)
            if pop_route(n)==1&&depart(ii)==0  
                time=time+distance(ii+1,pop_route(n+1));
                outputs(i,1)=outputs(i,1)+distance(i+1,pop_route(n+1));
            elseif n==s
                time=time+distance(pop_route(n-1),pop_route(n+1));
                outputs(i,1)=outputs(i,1)+distance(pop_route(n-1),pop_route(n+1));
            else
                time=time+distance(pop_route(n),pop_route(n+1));
                outputs(i,1)=outputs(i,1)+distance(pop_route(n),pop_route(n+1));
            end
            penalty1=500*max(time-timewindow(pop_route(n+1),2),0);
            penalty2=5000*(1-quality(pop_route(n+1),ii));
            time=max(timewindow(pop_route(n+1),1),time)+servicetime(pop_route(n+1));
            outputs(i,1)=outputs(i,1)+penalty1+penalty2;
            n=n+1;
        end
        penalty3=500*max(time-worktime,0);
        outputs(i,1)=outputs(i,1)+penalty3;
    end
end
end