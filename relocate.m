% 0-1 relocate operator
function pop=relocate(pop_muta,distance,timewindow,servicetime,quality,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points)
    pop=pop_muta;
    b=length(pop_muta);
    points=randperm(b);
    for i=1:length(points)
        if(pop_muta(points(i))~=1)
            removevalue=pop_muta(points(i));
            chromosome=[];
            chromosome=[pop_muta(1:points(i)-1) pop_muta(points(i)+1:end)];
            ff=randperm(length(chromosome)-1);
            for j=1:length(chromosome)-1
                if ff(j)~=points(i)
                    offspring=[chromosome(1:ff(j)) removevalue chromosome(ff(j)+1:end)];
                    cross_synch=potential_feasible(offspring,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points);
                    if cross_synch==1
                        [feasible,~,~]=judgeroute(offspring,distance,timewindow,servicetime,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);
                        if feasible==1
                            pop=offspring;
                            break;
                        end
                    end
                    offspring=[];
                end
            end
            if j<length(chromosome)-1
                break;
            end
        end
    end
end