% shaking procedure
function chromosome=shaking(chromosome,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points)    
if randi(6)<=2   %0-1 relocation
    chromosome=relocate(chromosome,distance,timewindow,servicetime,quality,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);
elseif randi(6)<=4&&randi(6)>2  %1-1 exchange
    chromosome=exchange(chromosome,distance,timewindow,servicetime,quality,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);
elseif randi(6)>4     %2 opt*
    chromosome=opt(chromosome,distance,timewindow,servicetime,quality,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);
end
end