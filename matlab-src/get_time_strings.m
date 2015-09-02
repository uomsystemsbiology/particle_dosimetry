function time_descriptions = get_time_strings(time_intervals, total_time_seconds)
    time_descriptions = {};
    for i=time_intervals
        t = round(total_time_seconds * i);
        time_val = 0;
        time_minutes = t/60;
        time_hours = time_minutes/60;
        time_days = time_hours/24;
        time_years = time_days/365;
        
        if(time_years >= 1)
            time_val = time_years;
            time_name = ' years';
        elseif(time_days >=1)
            time_val = time_days;
            time_name = ' days';
        elseif(time_hours >= 1)
            time_val = time_hours;
            time_name = ' hours';
        elseif(time_minutes >= 1)
            time_val = time_minutes;
            time_name = ' minutes';      
        end
        
        if time_val == 0
            time_desc = 'start';
        else
            time_desc = strcat(num2str(time_val),' ',time_name);
            if(time_val ==1)
               time_desc = time_desc(1:end-1);
            end            
        end
        
        time_descriptions = [time_descriptions, {time_desc}];
    end
end
