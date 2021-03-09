% crossover operator
function pop_cross=crossover(pop_sel,distance,timewindow,servicetime,quality,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points)
Pc=0.95;
for i=1:size(pop_sel,1)/2
    if rand<Pc
        nnper1=randperm(size(pop_sel,1),2);
        value1=object_ls(pop_sel(nnper1(1),:),distance,depart,lunch_points);
        value2=object_ls(pop_sel(nnper1(2),:),distance,depart,lunch_points);
        if value1<=value2
            parentA=pop_sel(nnper1(1),:);
        else
            parentA=pop_sel(nnper1(2),:);
        end
        nnper2=randperm(size(pop_sel,1),2);
        value3=object_ls(pop_sel(nnper2(1),:),distance,depart,lunch_points);
        value4=object_ls(pop_sel(nnper2(2),:),distance,depart,lunch_points);
        if value3<=value4
            parentB=pop_sel(nnper2(1),:);
        else
            parentB=pop_sel(nnper2(2),:);
        end
        offspring1=OX2(parentA,parentB,lunch_points);
        offspring2=OX2(parentB,parentA,lunch_points);
        cross_synch=potential_feasible(offspring1,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points);
        if cross_synch==1
            [feasible,~,~]=judgeroute(offspring1,distance,timewindow,servicetime,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);
            if feasible==1
                pop_cross(2*i-1,:)=offspring1;
            else
                pop_cross(2*i-1,:)=parentB;
            end
        else
            pop_cross(2*i-1,:)=parentB;
        end
        cross_synch=potential_feasible(offspring2,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points);
        if cross_synch==1
            [feasible,~,~]=judgeroute(offspring2,distance,timewindow,servicetime,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);
            if feasible==1
                pop_cross(2*i,:)=offspring2;
            else
                pop_cross(2*i,:)=parentA;
            end
        else
            pop_cross(2*i,:)=parentA;
        end
    else
        pop_cross(2*i-1,:)=pop_sel(2*i-1,:);
        pop_cross(2*i,:)=pop_sel(2*i,:);
    end
end
end