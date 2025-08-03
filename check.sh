#!/bin/bash

cd $(dirname $0)

if [ $# -ne 2 ]
then
  echo "usage: $0 authority_id process_id"
  exit 1
fi

source "personal_data.txt"

ret_val=$(curl -s "https://stuttgart.konsentas.de/api/getOtaStartUp/?signupform_id=$1&userauth=&queryParameter%5Bsignup_new%5D=1")
jwt=$(echo "$ret_val" | yq -r '.data.ota_jwt')
next_op_id=$(echo "$ret_val" | yq -r '.data.op_id')

ret_val=$(curl -s -H "Authorization: Bearer $jwt" \
  -X POST \
  -F "formdata[processes][0]=opt-$2" \
  -F "op_id=$next_op_id" \
  -F "navigation=1" \
  https://stuttgart.konsentas.de/api/postOtaNextStep/ \
  )

ret=$(echo "$ret_val" | yq -r '.code')

if [ $ret -ne 3 ]
then
  echo "first call:"
  echo "$ret_val"
  exit 1
fi

next_op_id=$(echo "$ret_val" | yq -r '.data.op_id')

ret_val=$(curl -s -H "Authorization: Bearer $jwt" \
  -X POST \
  -F "0=" \
  -F "formdata[processes][0]=" \
  -F "op_id=$next_op_id" \
  -F "navigation=1" \
  https://stuttgart.konsentas.de/api/postOtaNextStep/ \
  )

ret=$(echo "$ret_val" | yq -r '.code')

if [ $ret -ne 3 ]
then
  echo "second call:"
  echo "$ret_val"
  exit 1
fi

next_op_id=$(echo "$ret_val" | yq -r '.data.op_id')

ret_val=$(curl -s -H "Authorization: Bearer $jwt" \
  https://stuttgart.konsentas.de/api/brick_ota_termin_getFirstAvailableTimeslot/ \
  )

ret=$(echo "$ret_val" | yq -r '.code')

if [ $ret -ne 3 ]
then
  echo "third call:"
  echo "$ret_val"
  exit 1
fi

echo "$ret_val" | yq -r '.data | tostring'

termin=$(echo "$ret_val" | yq -r '.data.termin')
echo "$termin" | grep "^null$" > /dev/null
if [ $? -eq 0 ]
then
  exit 0
fi

ret_val=$(curl -s -H "Authorization: Bearer $jwt" \
  "https://stuttgart.konsentas.de/api/brick_ota_termin_getTimeslot/?start=1742943600&end=5337702000" \
  )
echo "$ret_val" | yq -r '.data | tostring'
ret_val=$(curl -s -H "Authorization: Bearer $jwt" \
  "https://stuttgart.konsentas.de/api/brick_ota_termin_getTimeslot/?start=1742943600&end=1750888800" \
  )
echo "$ret_val" | yq -r '.data | tostring'

exit 0

termins_length=$(echo "$ret_val" | yq -r '.data.termins | length')
if [ $termins_length -eq 0 ]
then
  exit 0
fi

termin_recno=$(echo "$ret_val" | yq -r '.data.termins[0].recno')

ret_val=$(curl -s -H "Authorization: Bearer $jwt" \
  -X POST \
  -F "formdata[abc]=abc" \
  -F "formdata[ota_termin_id]=$termin_recno" \
  -F "ota_termin_resource_group=" \
  -F "formdata[ota_termin_resource_group]=" \
  -F "op_id=$next_op_id" \
  -F "navigation=1" \
  https://stuttgart.konsentas.de/api/postOtaNextStep/ \
  )
echo "$ret_val" | yq -r '.data | tostring'

next_op_id=$(echo "$ret_val" | yq -r '.data.op_id')

ret_val=$(curl -s -H "Authorization: Bearer $jwt" \
  -X POST \
  -F "formdata[GF_Anrede]=$GF_Anrede" \
  -F "formdata[GF_Vorname]=$GF_Vorname" \
  -F "formdata[GF_Nachname]=GF_Nachname" \
  -F "formdata[GF_Staatsangehoerigkeit]=$GF_Staatsangehoerigkeit" \
  -F "formdata[Geburtsdatum]=$Geburtsdatum" \
  -F "formdata[GF_Email]=$GF_Email" \
  -F "GF_Telefon=" \
  -F "formdata[GF_Telefon]=" \
  -F "formdata[GF_Strasse]=$GF_Strasse" \
  -F "formdata[GF_Hausnummer]=$GF_Hausnummer" \
  -F "formdata[GF_PLZ]=$GF_PLZ" \
  -F "formdata[GF_Ort]=$GF_Ort" \
  -F "Bemerkung=" \
  -F "formdata[Bemerkung]=" \
  -F "formdata[GF_Datenschutz]=1" \
  -F "op_id=$next_op_id" \
  -F "navigation=1" \
  https://stuttgart.konsentas.de/api/postOtaNextStep/ \
  )
echo "$ret_val" | yq -r '.data | tostring'
