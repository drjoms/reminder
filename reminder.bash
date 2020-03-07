#lincensed under Apache license, please see copy:
#http://www.apache.org/licenses/LICENSE-2.0.txt
#author Dmitri Seletski
if  test $1 = "--help" 2>>/dev/null || test $1 = "-help" 2>>/dev/null || test $1 = "-h" 2>>/dev/null
then
    echo put ammount of minutes that you need to wait to be remainded and message you want to recieve
    echo example: './reminder.bash 10 pls remind me in ten minutes'
    echo after 10 minutes pop up will come with message "pls remind me in ten minutes"
    echo if process is interupted somehow, reminder remembers about task and will check if you need to be reminded of something. just run command with no arguments.
fi


mkdir ~/.reminder/ 2>>/dev/null
desired_reminder=$( echo $* |awk '{$1=""; print $0 }' )
#echo $desired_time >> ~/.reminder/reminder.dates
#echo desired reminder is: $desired_reminder
if ! test -z "$desired_reminder" ;
then
#    echo reminder is not empty
    time=$(date +%s)
#    echo $time
    inputz=$1
    delay=$(( $inputz * 60 ))
#    delay=$(( $inputz * 1 ))

    #echo $delay
    desired_time=$(( $time + $delay ))
#    echo desired time $desired_time
    saved_line="$desired_time $desired_reminder"
#    echo saved line is $saved_line
    echo $saved_line >> ~/.reminder/reminder.date
    sort -r -o ~/.reminder/reminder.date ~/.reminder/reminder.date

fi


last_line=$(tail -n 1  ~/.reminder/reminder.date 2>>/dev/null)
#gotta be careful here, not sure if sort -r does not add new line, making '-z' always true
if tail -n 1  ~/.reminder/reminder.date 2>>/dev/null >>/dev/null
then
#    echo last line is: $last_line
    desired_time=$(echo $last_line | awk '{print $1}')
#    echo desired time is: $desired_time
    current_time=$(date +%s)
#    echo current time is: $current_time
    while  test $desired_time -gt $current_time 2>>/dev/null
    do
	current_time=$(date +%s)
#	echo time is $(date +%s)
#	echo desired time is $desired_time
	sleep 1s

    done

#    xmessage "$desired_reminder"
    #    echo  "$desired_reminder"
    reminder=$(tail -n 1 ~/.reminder/reminder.date | awk '{$1="";print $0}')
    if ! test -z "$reminder"
       then
	   xmessage "$reminder"
    fi
    
    head -n-1  ~/.reminder/reminder.date > ~/.reminder/reminder.date.tmp
    mv ~/.reminder/reminder.date.tmp ~/.reminder/reminder.date
   
   if ! test -z  "$(cat ~/.reminder/reminder.date)"
	then xmessage "other reminders exist"
   fi
else
    echo lol?
fi
