% VNS
function [pop,value]=LS(chromosome,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points,k,bestvalue)
outputs=bestvalue;
value=bestvalue;
pop=chromosome;
m=1;
while m<=30&&outputs>=bestvalue
    if k==1   %0-1 relocation
        pop_search=relocate(chromosome,distance,timewindow,servicetime,quality,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);
    elseif k==2  %1-1 exchange
        pop_search=exchange(chromosome,distance,timewindow,servicetime,quality,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);
    elseif k==3     %2 opt*
        pop_search=opt(chromosome,distance,timewindow,servicetime,quality,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);    
    end
    outputs=object_ls(pop_search,distance,depart,lunch_points);
    m=m+1;
    if outputs<value
        value=outputs;
        pop=pop_search;
    end
end
value=outputs;
end
