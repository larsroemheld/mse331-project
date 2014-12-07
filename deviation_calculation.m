load('wiki_user_basic.mat');%Pre-processed data File which contains user_id, age, numWeekEdits
p =0.1; % parameter for m2 and m3
n= length(user_id);%No of users
deviation = zeros(n,4);%Initial deviations to 0
prev_id = 0;
user_start_index=0;
counter=0;
for i = 1:length(user_id)
    if(user_id(i)== prev_id)
        %Calculate the data for old user
        edits = [edits; numWeekEdits(i)];
        age = week_number_since_registration(i,1);
        last10w_edits = edits(max(1,age-9):age,1);
        m1 =0.5* ( max(last10w_edits)- min(last10w_edits) );
        m2 = p*numWeekEdits(i-1); %p% of last Edit
        m3 = p*mean(edits(1:age)); %p% of Avg edits upto that point
        m4 = std(edits(1:age));  %Stdeviation of Edits upto that point
        deviation(i,:)= [m1 m2 m3 m4]; 
    else
        edits=[numWeekEdits(i)];
        last10w_edits =edits ;
        % New users
        user_start_index = i;
        prev_id = user_id(i);
        counter=counter+1;
    end
end
M= [user_id week_number_since_registration deviation];
M = M(2:length(M),:);
dlmwrite('deviation_Data.csv', M, 'precision', '%i')%Write data to a csv file
