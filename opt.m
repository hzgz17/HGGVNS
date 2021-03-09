% 2-opt* operator
function pop=opt(pop_muta,distance,timewindow,servicetime,quality,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points)
   pop=pop_muta;
   depots=find(pop_muta==1);
   p=randperm(length(depots)-1,4);
   for i=1:length(p)
       part1=[];
       part1=pop_muta(depots(p(i))+1:depots(p(i)+1)-1);
       ff=randperm(length(part1));
       for j=1:length(part1)
           part11=[];
           part12=[];
           part11=part1(1:ff(j));
           part12=part1(ff(j)+1:end);
           nn=1;
           for m=1:length(p)
               if m~=i
                   part2=pop_muta(depots(p(m))+1:depots(p(m)+1)-1);
                   gg=randperm(length(part2));
                   for n=1:length(part2)
                       offspring=[];
                       part21=part2(1:gg(n));
                       part22=part2(gg(n)+1:end);
                       if p(i)<p(m)
                          offspring=[pop_muta(1:depots(p(i))) part11 part22 pop_muta(depots(p(i)+1):depots(p(m))) part21 part12 pop_muta(depots(p(m)+1):end)];
                       else
                          offspring=[pop_muta(1:depots(p(m))) part21 part12 pop_muta(depots(p(m)+1):depots(p(i))) part11 part22 pop_muta(depots(p(i)+1):end)]; 
                       end
                       cross_synch=potential_feasible(offspring,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points);
                       if cross_synch==1
                           [feasible,~,~]=judgeroute(offspring,distance,timewindow,servicetime,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);
                           if feasible==1
                               pop=offspring;
                               break;
                           end
                       end
                        part21=[];
                        part22=[];
                   end
                   part2=[];
               end
               if m<length(p)
                   break;
               end
           end
       end
       if j<length(part1)
           break;
       end
   end
end