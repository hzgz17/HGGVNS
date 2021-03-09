% 1-1 exchange operator
function pop_muta=exchange(pop_muta,distance,timewindow,servicetime,quality,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points)
    b=length(pop_muta);
    points=randperm(b);
    for i=1:length(points)
        if(pop_muta(points(i))~=1)
            removevalue=pop_muta(points(i));
            if isempty(find(syn_points==removevalue, 1))==1
                judge=1;
            else
                judge=0;
            end
            ff=randperm(length(pop_muta)-1);
            for j=1:length(pop_muta)-1
                offspring=pop_muta;
                if ff(j)~=points(i)&&pop_muta(ff(j))~=1&&(judge||abs(pop_muta(ff(j))-removevalue~=num_patient))                   
                    tem=offspring(points(i));
                    offspring(points(i))=offspring(ff(j));
                    offspring(ff(j))=tem;
                    cross_synch=potential_feasible(offspring,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points);
                    if cross_synch==1
                        [feasible,~,~]=judgeroute(offspring,distance,timewindow,servicetime,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);
                        if feasible==1
                            pop_muta=offspring;
                            break;
                        end
                    end
                end
            end
            if j<length(pop_muta)-1
                break;
            end
        end
    end
end