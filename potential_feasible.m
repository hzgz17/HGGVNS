% whether the solution is potentially feasible 
function cross_synch=potential_feasible(population,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points)
cross_synch=1;
n=1;
m=1;
while n<length(population)
    if quality(population(n),m)==1
        n=n+1;
    else
        cross_synch=0;
        break
    end
    if population(n)==1
        m=m+1;
    end
end
depots=find(population==1);
if cross_synch==1
    feasible1=1;
    feasible2=1;
    for ii=1:length(depots)-1
        pop_route=population(depots(ii):depots(ii+1));
        lunpoint=intersect(pop_route,lunch_points);
        s=find(pop_route==lunpoint);
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
            if time<=timewindow(pop_route(j+1),2)&&time<=worktime
                time=max(timewindow(pop_route(j+1),1),time)+servicetime(pop_route(j+1));
                j=j+1;
            else
                feasible1=0;
                break
            end
        end
    end
    for ii=1:length(depots)-1
        pop_route=population(depots(ii):depots(ii+1));
        lunpoint=intersect(pop_route,lunch_points);
        s=find(pop_route==lunpoint);
        j=1;
        time=0;
        while j<length(pop_route)
            if j==s
                time=time+0;
            elseif j+1==s
                if pop_route(j)==1&&depart(ii)==0
                    time=time+distance(ii+1,pop_route(j+2));
                else
                    time=time+distance(pop_route(j),pop_route(j+2));
                end
            else
                if pop_route(j)==1&&depart(ii)==0
                    time=time+distance(ii+1,pop_route(j+1));
                else
                    time=time+distance(pop_route(j),pop_route(j+1));
                end
            end
            if time<=timewindow(pop_route(j+1),2)&&time<=worktime
                time=max(timewindow(pop_route(j+1),1),time)+servicetime(pop_route(j+1));
                j=j+1;
            else
                feasible2=0;
                break
            end
        end
    end
    if feasible1==0&&feasible2==0
        cross_synch=0;
    end
end
if cross_synch==1
    M=zeros(num_syn,num_syn);
    for i=1:length(depots)-1
        route=population(depots(i):depots(i+1));
        syn_route=route(ismember(route,syn_points));
        for j=1:length(syn_route)
            if syn_route(j)>num_caregiver+num_patient+1
                syn_route(j)=syn_route(j)-num_patient;
            end
        end
        if length(syn_route)>=2
            for j=1:length(syn_route)-1
                for k=j+1:length(syn_route)
                    M(syn_route(j)-num_caregiver-1,syn_route(k)-num_caregiver-1)=1;
                end
            end
        end
    end
    for n=1:num_syn
        for i=1:num_syn
            for j=1:num_syn
                if (M(i,j)==1)||(M(i,n)==1&&M(n,j)==1)
                    M(i,j)=1;
                end
            end
        end
    end
    for i=1:num_syn
        if M(i,i)==1
            cross_synch=0;
            break
        end
    end
end
end