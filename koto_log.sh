#!/bin/bash

#$HOME/.kotoへ移動
cd ~/.koto

COUNT=10000
CNT=0

echo `date` "### UPDATE CHECK Started."

LAST_TIME_RECEIVED=`cat TMP.json | jq '. [] .timereceived' | tail -1`

# LAST_TIME_RECEIVEDを含むレコードを探す(${i}番目を1件取り出して比較)
for ((i=0; i<${COUNT}; i++)) do
  tTIME=`/opt/koto/koto-cli listtransactions "*" 1 ${i} | jq '. [] .timereceived'`

  # 何件目で一致?
  if [ "${tTIME}" = "${LAST_TIME_RECEIVED}" ]; then
    CNT=$i
    break
  fi
done
echo $CNT
if [ $CNT = 0 ]; then
  # 更新はなし
  echo `date` "### UPDATE is NOT EXIST."
  exit
fi
# $CNT件目まで出力
/opt/koto/koto-cli listtransactions "*" $CNT > TMP.json
nTIME=`/opt/koto/koto-cli listtransactions "*" 1 | jq '. [] .timereceived'`
echo `date` "### NEW LASTTIME-RECEIVED: "${nTIME} "(`date -d @${nTIME}`)"
# コピーして ${timereceived}.json を作成
cp TMP.json ${nTIME}.json