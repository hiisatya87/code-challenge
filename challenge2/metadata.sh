#!/bin/bash
# Below code will query the meta data of an instance within GCP and provide a json formatted output.

echo " Instance available are as follows : "
echo
gcloud compute instances list | awk '{print $1}'

echo " Enter the name that you need metadata in json format "
read meta
echo
gcloud compute instances list --filter="name=('$meta')" --format json
echo

echo "Select pre-listed key to view the data individually
diskSizeGb
architecture
creationTimestamp
cpuPlatform
networkIP
natIP
automaticRestart"
echo
echo "Do your desired metadata key listed above ? (y/n)"
read b
if [ $b == y ]
then
echo
echo "Enter the key name :"
read c
echo
gcloud compute instances list --filter="name=('$meta')" --format json | grep $c
elif [ $b == n ]
then
echo " select the key from the below metadata value of $meta instance "
gcloud compute instances list --filter="name=('$meta')" --format json
echo
echo " Enter the key name to get the value : "
read p
gcloud compute instances list --filter="name=('$meta')" --format json | grep $p
echo
sleep 3
echo
fi
echo
echo " Do you want to continue with finding more individual metadata value for the specific key? : (y/n)"
read out
if [ $out == y ]
then
while true
do
echo " Please note since you have selected option as yes so loop will continue , once you are done with your required metadata value  can exit anytime by pressing ctrl+c from the keyboard"
echo "enter the key name: "
read out1
gcloud compute instances list --filter="name=('$meta')" --format json | grep $out1
done
elif [ $out == n ]
then
echo "Going to exit since option no is selected"
fi