% whether the solution is feasible without time window constriants
function cross_synch=feasiblewithoutTW(population,quality,syn_points,num_caregiver,num_patient,num_syn)
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
if cross_synch==1
    depots=find(population==1);
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