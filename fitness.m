% Calculate the objective value of the infeasible solution
function [timepoints,outputs]=fitness(curr_pop,distance,timewindow,servicetime,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points)
timepoints=zeros(size(curr_pop,1),2*num_patient);
outputs=zeros(size(curr_pop,1),1);
for i=1:size(curr_pop,1)
    pop=curr_pop(i,:);
    depots=find(pop==1);
    len=length(depots);
    index=order(pop,depots,syn_points,num_caregiver,num_patient,num_syn);
    for ii=1:len-1
        pop_route=pop(depots(ii):depots(ii+1));
        lunpoint=intersect(pop_route,lunch_points);
        s=find(pop_route==lunpoint);
        a=pop_route(ismember(pop_route,syn_points));
        if isempty(a)==0
            j=1;
            time=0;
            while j<length(pop_route)
                if j==s
                    if pop_route(j-1)==1&&depart(ii)==0
                        time=time+distance(ii+1,pop_route(j+1));
                    end
                    time=time+distance(pop_route(j-1),pop_route(j+1));
                elseif j+1==s
                    time=time+0;
                else
                    if pop_route(j)==1&&depart(ii)==0
                        time=time+distance(ii+1,pop_route(j+1));
                    else
                        time=time+distance(pop_route(j),pop_route(j+1));
                    end
                end
                if any(syn_points==pop_route(j+1))==1
                    timepoints(i,pop_route(j+1)-num_caregiver-1)=max(timewindow(pop_route(j+1),1),time);
                    if pop_route(j+1)==a(end)
                        break
                    end
                end
                time=max(timewindow(pop_route(j+1),1),time)+servicetime(pop_route(j+1));
                j=j+1;
            end
        end
    end
    timepoints(i,:)=new_time(pop,distance,timewindow,servicetime,num_caregiver,num_patient,timepoints(i,:),syn_points,lunch_points,depots,index,len);
    outputs(i,1)=0;
    for ii=1:len-1
        pop_route=pop(depots(ii):depots(ii+1));
        lunpoint=intersect(pop_route,lunch_points);
        s=find(pop_route==lunpoint);
        vehicle=pop_route(ismember(pop_route,[1 lunch_points])==0);
        if isempty(vehicle)==1
            fee_vehicle=0;
        else
            fee_vehicle=50;
        end
        outputs(i,1)=outputs(i,1)+fee_vehicle;
        j=1;
        time=0;
        while j<length(pop_route)
            if j==s
                if pop_route(j-1)==1&&depart(ii)==0
                    time=time+distance(ii+1,pop_route(j+1));
                    outputs(i,1)=outputs(i,1)+distance(ii+1,pop_route(j+1));
                end
                time=time+distance(pop_route(j-1),pop_route(j+1));
                outputs(i,1)=outputs(i,1)+distance(pop_route(j-1),pop_route(j+1));
            elseif j+1==s
                time=time+0;
                outputs(i,1)=outputs(i,1)+0;
            else
                if pop_route(j)==1&&depart(ii)==0
                    time=time+distance(ii+1,pop_route(j+1));
                    outputs(i,1)=outputs(i,1)+distance(ii+1,pop_route(j+1));
                else
                    time=time+distance(pop_route(j),pop_route(j+1));
                    outputs(i,1)=outputs(i,1)+distance(pop_route(j),pop_route(j+1));
                end
            end
            if any(syn_points==pop_route(j+1))==1
                time=timepoints(1,pop_route(j+1)-num_caregiver-1);
            end
            penalty1=5000*max(time-timewindow(pop_route(j+1),2),0);
            outputs(i,1)=outputs(i,1)+penalty1;
            time=max(timewindow(pop_route(j+1),1),time)+servicetime(pop_route(j+1));
            j=j+1;
        end
        penalty3=500*max(time-worktime,0);
        outputs(i,1)=outputs(i,1)+penalty3;
    end
end
end