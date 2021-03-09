% Let the start service time of synchronized visits be the same
function new_timepoint=new_time(curr_pop,distance,timewindow,servicetime,num_caregiver,num_patient,timepoint,syn_points,lunch_points,depots,index,len)
while isequal(timepoint(1:num_patient),timepoint(num_patient+1:end))==0
    for ii=1:length(index)
        if timepoint(index(ii))~=timepoint(index(ii)+num_patient)
            if timepoint(index(ii))>timepoint(index(ii)+num_patient)
                point=index(ii)+num_caregiver+num_patient+1;
                timepoint(index(ii)+num_patient)=timepoint(index(ii));
            else
                point=index(ii)+num_caregiver+1;
                timepoint(index(ii))=timepoint(index(ii)+num_patient);
            end
            a=find(curr_pop==point);
            for jj=1:len-1
                if a>depots(jj)&&a<depots(jj+1)
                    part=curr_pop(a:depots(jj+1));
                end
            end
            time=timepoint(index(ii))+servicetime(point);
            lun=intersect(part,lunch_points);
            if isempty(lun)==1
                j=1;
                while j<length(part)
                    time=time+distance(part(j),part(j+1));
                    if any(syn_points==part(j+1))==1
                        timepoint(part(j+1)-num_caregiver-1)=max(timewindow(part(j+1),1),time);
                    end
                    time=max(timewindow(part(j+1),1),time)+servicetime(part(j+1));
                    j=j+1;
                end
            else
                ss=find(part==lun);
                j=1;
                while j<length(part)
                    if j==ss
                        time=time+distance(part(j-1),part(j+1));
                    elseif j+1==ss
                        time=time+0;
                    else
                        time=time+distance(part(j),part(j+1));
                    end
                    if any(syn_points==part(j+1))==1
                        timepoint(part(j+1)-num_caregiver-1)=max(timewindow(part(j+1),1),time);
                    end
                    time=max(timewindow(part(j+1),1),time)+servicetime(part(j+1));
                    j=j+1;
                end
            end
            part=[];
        end
    end
end
new_timepoint=timepoint;
end