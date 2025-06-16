#!/bin/bash
kinit -kt /usr/security/keytabs/svc-l-aap-etl.kt svc-l-aap-etl;

function p() {
   ldt=$(date +'%y/%m/%d-%H:%M')
   echo "$ldt: $*" >> $runlogfile
   echo "$ldt: $*"
}

function l() {
   ldt=$(date +'%y/%m/%d-%H:%M')
   echo "$ldt: $batchid: $*" >> $logfile
}

function rh() {
   if [[ "$1" == "-p" ]]; then
      shift
      p "remote hdfs dfs $*"
   fi
   sudo -u svc-l-aap-etl ssh -n 10.105.81.252 "sudo -u svc-l-aap-etl kinit -kt /usr/security/keytabs/svc-l-aap-etl.kt svc-l-aap-etl; hdfs dfs $*"
}

function lh() {
   if [[ "$1" == "-p" ]]; then
      shift
      p "hdfs dfs $*"
   fi
   hdfs dfs $*
}

# Process Parameters

batchid=$(date +'%y%m%d%H%M%S%N')
runlogfile=${0}.${batchid}.runlog
logfile=$0.log
replace_yn=n
list_only_yn=n

if [[ "$1" == "-l" ]]; then
   list_only_yn=y
   src_dir="$2"
elif [[ "$1" == "-r" ]]; then
   replace_yn=y
   src_dir="$2"
else
   src_dir="$1"
fi

p "----------------------------------------------------------------------------------------------------"
p "PROCESSING: $src_dir"
p "----------------------------------------------------------------------------------------------------"

if [[ "$src_dir" =~ /prod/.* ]]; then prod_dir_yn=y; else prod_dir_yn=n; fi

if [[ "$replace_yn" == "n" ]]; then

   p "Get list of local items (files and directories)"
   lh -ls -R $src_dir > ${0}.${batchid}.local
   p "Found $(cat ${0}.${batchid}.local 2>/dev/null | wc -l) items"
   p "Get list of remote items (files and directories)"
   if [[ $prod_dir_yn == y ]]; then
      rh -p -ls -R $src_dir > ${0}.${batchid}.remote
   else
      rh -p -ls -R /prod$src_dir > ${0}.${batchid}.remote
   fi
   p "Found $(cat ${0}.${batchid}.remote 2>/dev/null | wc -l) items"

   p "Transform local file list"
   cat ${0}.${batchid}.local  | awk '{print $8$9$10 " " $5 " " substr($1,1,1)}' | sed 's/\/ /\//' | sort -u > ${0}.${batchid}.local.list

   p "Transform remote file list"
   cat ${0}.${batchid}.remote | awk '{print $8$9$10 " " $5 " " substr($1,1,1)}' | sed 's/\/ /\//' | sort -u > ${0}.${batchid}.remote.list

   if [[ $prod_dir_yn == n ]]; then
      cat ${0}.${batchid}.local.list | sed 's/^/\/prod/' > ${0}.${batchid}.local.list.tmp
      mv -f ${0}.${batchid}.local.list.tmp ${0}.${batchid}.local.list
   fi

   p "Calc diffs"
   # -23 means not in file 2 (remote) or both
   comm -23 ${0}.${batchid}.local.list ${0}.${batchid}.remote.list > ${0}.${batchid}.new.temp
   # -13 means not in file 1 (local) or both
   comm -13 ${0}.${batchid}.local.list ${0}.${batchid}.remote.list > ${0}.${batchid}.del.temp

   cat ${0}.${batchid}.new.temp | sed -n 's/\(^\/.......................*\)/\1/p' \
   | sed 's/\//00000000002222222222/g' \
   | sed 's/ /00000000001111111111/g' \
   | sort \
   | sed 's/00000000001111111111/ /g' \
   | sed 's/00000000002222222222/\//g' > ${0}.${batchid}.new.list

   cat ${0}.${batchid}.del.temp | sed -n 's/\(^\/.......................*\)/\1/p' | cut -d" " -f1 | sort > ${0}.${batchid}.del.list

   rm -rf ${0}.${batchid}.del.dedup.list
   last_del="nothing!"
   for item in $(cat ${0}.${batchid}.del.list); do
      if ! [[ $item =~ $last_del.* ]]; then
         echo $item >> ${0}.${batchid}.del.dedup.list
         last_del=$item/
      fi
   done

   rm -rf ${0}.${batchid}.new.dedup.list
   last_new="nothing!"
   for item in $(cat ${0}.${batchid}.new.list | sed 's/ /0#xsp/g'); do
      new_item=${item/0#xsp*/}
      if ! [[ $new_item =~ $last_new.* ]]; then
         echo $item | sed 's/0#xsp/ /g' >> ${0}.${batchid}.new.dedup.list
         last_new=$new_item/
      fi
   done
   sed -i ${0}.${batchid}.new.dedup.list "/\/dc\/pdaoa_dc_parquet_data_v2/d"
else
   echo $src_dir > ${0}.${batchid}.del.dedup.list
   echo $src_dir d > ${0}.${batchid}.new.dedup.list
   p "Running in REPLACE mode"
fi
# Add a file end marker to the new dedup list
echo "END" >> ${0}.${batchid}.new.dedup.list

items_to_add=$(cat ${0}.${batchid}.new.dedup.list | wc -l)
let items_to_add=items_to_add-1

p "ITEMS TO DELETE: $(cat ${0}.${batchid}.del.dedup.list | wc -l) items.  To view: cat ${0}.${batchid}.del.dedup.list"
p "ITEMS TO ADD: $items_to_add items.  To view: cat ${0}.${batchid}.new.dedup.list"

if [[ "$list_only_yn" != "y" ]]; then

   p "------------------"
   p "Processing Deletes"
   p "------------------"
   total_del=$(cat ${0}.${batchid}.del.dedup.list | wc -l)
   item_num=1
   c=0
   item_list=""

   for item in $(cat ${0}.${batchid}.del.dedup.list); do
      # Check for the kill switch (file pc.KILL)
      if [[ -e $0.KILL ]]; then
         p "---------------------------------"
         p "KILL FILE $0.KILL found - exiting"
         p "---------------------------------"
         exit 2
      fi

      p "$item_num of $total_del - Delete: $item"
      if [[ $c -lt 100 ]]; then
         item_list="$item_list $item"
         let c=c+1
      else
         rh -rm -r -skipTrash $item_list >> $runlogfile
         l "Deleted Through to $item_num of $total_del"
         c=0
         item_list=$item
      fi
      let item_num=item_num+1
   done
   l "Delete remainder"
   rh -rm -r $item_list >> $runlogfile
   l "Deleted Through to $item_num of $total_del"

   total_new=$(cat ${0}.${batchid}.new.dedup.list | wc -l)
   item_num=1
   batch_num=0

   p "--------------------------"
   p "Processing Add Directories"
   p "--------------------------"

   for fline in $(cat ${0}.${batchid}.new.dedup.list | sed '/-$/d' | sed 's/ /0#xsp/g'); do
      line=${fline//0#xsp/ }

      # Check for the kill switch (file pc.KILL)
      if [[ -e $0.KILL ]]; then
         p "---------------------------------"
         p "KILL FILE $0.KILL found - exiting"
         p "---------------------------------"
         exit 2
      fi

      item=$(echo $line | cut -d" " -f1)

      p "--------------------------------------------------------------------------------"
      p "ITEM $item_num of $total_new: Directory: $line"
      p "--------------------------------------------------------------------------------"

      p "Extract Item From Local HDFS"
      rm -rf ${0}.${batchid}.extracted_dir
      if [[ $prod_dir_yn == y ]]; then
         lh "-get $item ${0}.${batchid}.extracted_dir"
      else
         lh "-get ${item:5:1000} ${0}.${batchid}.extracted_dir"
      fi

      extract_size=$(du -d0 -h ${0}.${batchid}.extracted_dir 2>/dev/null | sed 's/[\t ].*//')
      extract_items=$(ls -R ${0}.${batchid}.extracted_dir 2>/dev/null | wc -l)
      let extract_items=extract_items-1
      p "Size: $extract_size - Num Files: $extract_items"

      if [[ -e ${0}.${batchid}.extracted_dir ]]; then
         p "Copy Data to Remote"
         sudo -u svc-l-aap-etl ssh 10.105.81.252 "rm -rf ${0}.${batchid}.extracted_dir"
         scp -r ${0}.${batchid}.extracted_dir 10.105.81.252:${0}.${batchid}.extracted_dir > /dev/null
         rm -r  ${0}.${batchid}.extracted_dir/*
         dir=$(dirname $item)
         if [[ "$last_dir_made" != "$dir" ]]; then
            rh "-mkdir -p $dir"
         fi
         last_dir_made=$dir
         p "Upload to remote HDFS"
         rh "-put ${0}.${batchid}.extracted_dir $item"
         l "Added $item_num of $total_new: $item - Size: $extract_size - Num Files: $extract_items"
      else
         p "Item not in local so must be a corrupted name - skip"
      fi

      let item_num=item_num+1
   done

   p "--------------------"
   p "Processing Add Files"
   p "--------------------"

   prev_item_dir="START"
   item_list=""

   for fline in $(cat ${0}.${batchid}.new.dedup.list | sed '/d$/d' | sed 's/ /0#xsp/g'); do
      line=${fline//0#xsp/ }

      # Check for the kill switch (file pc.KILL)
      if [[ -e $0.KILL ]]; then
         p "---------------------------------"
         p "KILL FILE $0.KILL found - exiting"
         p "---------------------------------"
         exit 2
      fi

      item=$(echo $line | cut -d" " -f1)

      p "--------------------------------------------------------------------------------"
      p "ITEM $item_num of $total_new: $line"
      p "--------------------------------------------------------------------------------"

      item_dir=$(dirname $item)
      if [[ "$prev_item_dir" != "START" && "$item_dir" != "$prev_item_dir" ]]; then
         p "Processing $prev_item_dir"
         p "Processing $item_list"
         p "Extract Items From Local HDFS"
         rm -rf ${0}.${batchid}.extracted_dir
         mkdir ${0}.${batchid}.extracted_dir

         lh "-get $item_list ${0}.${batchid}.extracted_dir"

         extract_size=$(du -d0 -h ${0}.${batchid}.extracted_dir 2>/dev/null | sed 's/[\t ].*//')
         extract_items=$(ls -R ${0}.${batchid}.extracted_dir 2>/dev/null | wc -l)
         let extract_items=extract_items-1
         p "Size: $extract_size - Num Files: $extract_items"

         if [[ -e ${0}.${batchid}.extracted_dir ]]; then
            p "Copy Data to Remote"
            sudo -u svc-l-aap-etl ssh 10.105.81.252 "rm -rf ${0}.${batchid}.extracted_dir"
            scp -r ${0}.${batchid}.extracted_dir 10.105.81.252:${0}.${batchid}.extracted_dir > /dev/null
            rm -r  ${0}.${batchid}.extracted_dir/*
            p "Upload to remote HDFS"
            p "-put ${0}.${batchid}.extracted_dir/* $prev_item_dir"
            rh "-put ${0}.${batchid}.extracted_dir/* $prev_item_dir"
            #rm -r ${0}.${batchid}.extracted_dir/*
            l "Added $item_num of $total_new: $item - Size: $extract_size - Num Files: $extract_items"
         else
            p "Item not in local so must be a corrupted name - skip"
         fi
         item_list=""
      fi
      if [[ $prod_dir_yn == y ]]; then
         item_list="$item_list $item"
      else
         item_list="$item_list ${item:5:1000}"
      fi
      prev_item_dir="$item_dir"

      let item_num=item_num+1
   done
fi

p "--------"
p "Finished"
p "--------"

p "Remove temporary files"

mv ${0}.${batchid}.runlog $(dirname ${0})/runlog_archive/
rm -r ${0}.${batchid}.*
