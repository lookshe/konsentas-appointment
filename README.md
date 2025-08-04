Scripts that can help you to get an appointment at https://stuttgart.konsentas.de

# current limitation
The complete process was only tested with Ausländerbehörde and Einarbeitungs und Ausbildungsbürgerbüro.

# requirements
- bash
- curl
- sed
- grep
- date
- yq (https://mikefarah.gitbook.io/yq/)
- nodejs

# how to use
After an appointment was made you will receive an email and should disable the cron job.

## get authority id to use
`./list_authority_ids.sh` shows the needed ids for authority from https://stuttgart.konsentas.de.

## get process id to use
`node list_process_ids.js $authority_id` shows the needed process ids for given authority id. Take care that this script lists all possible processes without checking if these are enabled or not.

## adjust personal data
adjust personal data in `personal_data.txt`.

## adjust cron script
adjust `AUTHORITY_ID` and `PROCESS_ID` in `cron.sh`.

## add cron job
add a cron job `cron.sh` to be executed every minute:
```
* * * * * "/path/to/cron.sh"
```

