% generate initial feasible solutions
function population=adjust(distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points,Maxgen,demand)
population=zeros(Maxgen,num_patient+2*num_caregiver+num_syn+1);
for n=1:Maxgen
    pop=inition_insert(demand,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points);
    feasible=0;
    i=1;
    while feasible==0
        pop_mute=localmove(pop,distance,timewindow,servicetime,quality,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);
        [pop_search,~]=localsearch_infeasible(pop_mute,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points);
        [feasible,~,~]=judgeroute(pop_search,distance,timewindow,servicetime,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);
        pop=pop_search;
        i=i+1;
    end
    population(n,:)=pop;
end
end
