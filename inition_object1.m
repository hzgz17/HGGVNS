% the objective for inserting synchronization visits
function outputs=inition_object1(population,quality,syn_points,num_caregiver,num_patient,num_syn)
for i=1:size(population,1)                                         
    curr_pop=population{i};                            
    cross_synch=feasiblewithoutTW(curr_pop,quality,syn_points,num_caregiver,num_patient,num_syn);
    if cross_synch==1
        outputs(i,1)=0;
    else
        outputs(i,1)=10e10;
    end
end
end