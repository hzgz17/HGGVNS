% the order of the synchronization adjustment
function index=order(population,depots,syn_points,num_caregiver,num_patient,num_syn)
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
factor=sum(M,2);
[~,index]=sort(factor,'descend');
end