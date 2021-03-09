% whether the solution is feasible
function [feasible,timepoint,timepoint1]=judgeroute(pop,distance,timewindow,servicetime,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points)
depots=find(pop==1);
len=length(depots);
index=order(pop,depots,syn_points,num_caregiver,num_patient,num_syn);
timepoint=zeros(1,2*num_patient);
timepoint1=zeros(1,2*num_patient);
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
                timepoint(pop_route(j+1)-num_caregiver-1)=max(timewindow(pop_route(j+1),1),time);
                if pop_route(j+1)==a(end)
                    break
                end
            end
            time=max(timewindow(pop_route(j+1),1),time)+servicetime(pop_route(j+1));
            j=j+1;
        end
    end
end
timepoint=new_time(pop,distance,timewindow,servicetime,num_caregiver,num_patient,timepoint,syn_points,lunch_points,depots,index,len);
for ii=1:len-1
    pop_route=pop(depots(ii):depots(ii+1));
    lunpoint=intersect(pop_route,lunch_points);
    s=find(pop_route==lunpoint);
    fea(ii)=1;
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
            time=timepoint(pop_route(j+1)-num_caregiver-1);
        end
        if time<=timewindow(pop_route(j+1),2)&&time<=worktime
            time=max(timewindow(pop_route(j+1),1),time)+servicetime(pop_route(j+1));
            j=j+1;
        else
            fea(ii)=0;
            break
        end
    end
end
num=find(fea==1);
if length(num)==len-1
    feasible=1;
else
    feasible=0;
end
end