Path = '/home/wliu03/Documents/small size';
File = dir(fullfile(Path, '*.txt'));
Filename = {File.name}';
NumFile= size(File,1);
Final_result=[];
start_num=1;
for num_file=start_num:NumFile
    fileID = fopen(fullfile(Path, Filename{num_file}),'r');
    Intro = textscan(fileID,'%s',0,'Delimiter','\n');    
    Block = 1;
    while (~feof(fileID))                               % For each block:                         
       InputText = textscan(fileID,'%s',0,'delimiter','\n');  % Read 2 header lines
       HeaderLines{Block,1} = InputText{1};
       InputText = textscan(fileID,'Num SNR = %f');     % Read the numeric value 
       NumCols = InputText{1};                          % Specify that this is the number of data columns                                                        
       FormatString = repmat('%f',[1,NumCols]);         % Create format string based on the number % of columns                                                         
       InputText = textscan(fileID,FormatString, ...    % Read data block
          'delimiter',',');
       initial_data{Block,1} = cell2mat(InputText);              
       eob = textscan(fileID,'%s',1,'delimiter','\n');  % Read and discard end-of-block marker 
       Block = Block+1;                                 % Increment block index
    end   
    fclose(fileID);
    num_patient=initial_data{1,1}(1); %number of patients
    num_caregiver=initial_data{1,1}(2);% number of caregivers
    worktime=initial_data{1,1}(3); % the due time of caregivers
    num_syn=initial_data{1,1}(4); % number of synchronized visits
    depart=initial_data{2,1}; % the binary parameter of renting the car
    len1=length(initial_data{3,1});   
    m=0;
    for i=1:len1/7
        for j=1:7
            m=m+1;
            data(i,j)=initial_data{3,1}(m);
        end
    end   
    len2=length(initial_data{4,1});
    m=0;
    for i=1:len2/(num_caregiver+1)
        for j=1:num_caregiver+1
            m=m+1;
            data1(i,j)=initial_data{4,1}(m);
        end
    end       
        n=0;
        for i=num_caregiver+2:num_caregiver+num_patient+1
            j=i+num_patient;
            if data(i,5)==1&&data(j,5)==1
                n=n+1;
                syn(n,:)=[i j];
            end
        end
        syn_points=[syn(:,1)' syn(:,2)']; % the pair of synchronized visits
        n=1;
        for i=1:size(data,1)
            if data(i,5)==1
                demand(n)=data(i,1);  
                n=n+1;
            end
        end
        quality=data1(:,2:size(data1,2)); %qualification of caregivers
        servicetime=data(:,4);  %value of service time
        timewindow=data(:,6:7); % value of time windows
        distance=zeros(size(data,1),size(data,1)); %travel distance from node i to node j
        position=data(:,2:3);
        for i=1:size(data,1)
            for j=1:size(data,1)
                if i<=num_caregiver+1&&j<=num_caregiver+1
                    distance(i,j)=0;
                else
                    distance(i,j)=((position(i,1)-position(j,1))^2+(position(i,2)-position(j,2))^2)^0.5;
                end
            end
        end
        Maxgen=30;          %Popsize
        generation=2000;      %generation
        lunch_points=2*num_patient+num_caregiver+2:2*(num_patient+num_caregiver)+1; %points of lunchbreak
        for run=1:15 % run time
            tic;
            population=adjust(distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points,Maxgen,demand); %generate initial population
            bestroute=zeros(generation,num_patient+2*num_caregiver+num_syn+1);
            outputs=object(population,distance,depart,lunch_points);
            [bestoutputs(1),parent_index]=min(outputs);
            bestroute(1,:)=population(parent_index,:);
            j=1;
            while j<=generation
                population_cross=crossover(population,distance,timewindow,servicetime,quality,depart,syn_points,worktime,num_caregiver,num_patient,num_syn,lunch_points);
                [population_search,value]=VNS(population_cross,distance,timewindow,servicetime,quality,depart,worktime,syn_points,num_caregiver,num_patient,num_syn,lunch_points);
                if isempty(find(value==bestoutputs(j), 1))==1
                    [~,offspring_worst_index]=max(value);                     %find the worst solution at this generation
                    population_search(offspring_worst_index,:)=bestroute(j,:);  %selection
                end               
                [offspring_value,offspring_best_index]=min(value);
                if offspring_value<bestoutputs(j)
                    bestoutputs(j+1)=offspring_value;
                    bestroute(j+1,:)=population_search(offspring_best_index,:);
                    count(j)=1;
                else
                    bestoutputs(j+1)=bestoutputs(j);
                    bestroute(j+1,:)=bestroute(j,:);
                    count(j)=0;
                end
                ff=[diff(find(count==0)) 2];
                not_change=diff([0 find(ff~=1)]);
                population=population_search;
                j=j+1;
                if max(not_change)>=2*num_patient %max iterations wihout improving the best solution
                    break
                end
            end
            [minfpbest,final_index]=min(bestoutputs);                        %find the best value and the index of the best solution in all generations
            finalroute=bestroute(final_index,:);                             %best route of this problem
            result{1,1}(run)=minfpbest;
            result{1,2}(run,:)=finalroute;
            population=[];
            population_cross=[];
            population_search=[];
            bestroute=[];
            bestoutputs=[];
            value=[];
            outputs=[];
            ff=[];
            count=[];
            not_change=[];
            t(run)=toc;
        end
        [best_value(num_file),index]=min(result{1,1}); % best value within 15 times
        [worst_value(num_file),index1]=max(result{1,1}); % worst value within 15 times
        ave_value(num_file)=mean(result{1,1}); % mean value within 15 times
        std_value(num_file)=std(result{1,1}); % standard deviation value within 15 times
        ave_time(num_file)=mean(t); % mean times within 15 times
        best_route{num_file,1}=result{1,2}(index,:); % best route within 15 times
        result=[];
        t=[];
        initial_data=[];
        data=[];
        data1=[];
        demand=[];
        syn=[];
        syn_points=[];
        quality=[];
        distance=[];
        position=[];
        servicetime=[];
        timewindow=[];        
        lunch_points=[];
end