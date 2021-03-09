function [pop_search,value]=VNS(population,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points)
for i=1:size(population,1)
    chromosome=population(i,:);
    chromosome=shaking(chromosome,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points);
    bestvalue=object_ls(chromosome,distance,depart,lunch_points);
    k=1;
    while k<=3
        [pop,outputs]=LS(chromosome,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points,k,bestvalue);
        if outputs<bestvalue
            chromosome=pop;
            bestvalue=outputs;
            k=1;
        else
            k=k+1;
        end
    end
    pop_search(i,:)=chromosome;
    value(i)=outputs;
end
end