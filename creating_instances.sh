#!/bin/bash
##################################  VARIABLES  #####################################
read -p "Please enter AWS region. (Please enter to select default) :- " region_aws 
region_aws=${region_aws:-$(aws configure get region --output text)}
while [[ -z ${region_aws} ]]
do
read -p "Please enter the region to continue :- " region_aws
done
echo -e "\033[0;32m Your region is ${region_aws}. \033[0m"
sleep 1
read -p "Please enter the number of instances you want to create :- " cnt_ins
cnt_ins=${cnt_ins:-1}
echo -e "\033[0;32m The number of instances you've chosen to be created is ${cnt_ins}. \033[0m"
sleep 1
echo -e "\033[2;33m Please select the image input type...\033[0m"
select image_input in owned amazon_default
do
case ${image_input} in
owned)
mapfile -t ami_list < <(aws ec2 describe-images --region ${region_aws} --owners self --query 'Images[*].[Name,ImageId]' --output text)
select ami_Id in "${ami_list[@]}"
do
ami_id=$(awk '{print $2}' <<< "$ami_Id")
echo -e "\033[0;32m You have selected the windows image type and its imid is ${ami_id}.\033[0m "
done
break ;
;;
amazon_default)
echo -e "\033[2;33m Please select one os type among these and aws will determine it's imid itself. \033[0m"
sleep 1
select Machine_OS_type in Windows Ubuntu Amazon Other
do 
case ${Machine_OS_type} in
Windows)
window_imid=$(aws ec2 describe-images --region ${region_aws} \
  --owners amazon \
  --filters "Name=name,Values=Windows_Server-2022-English-Full-Base-*" \
            "Name=state,Values=available" \
            "Name=root-device-type,Values=ebs" \
  --query 'Images | sort_by(@, &CreationDate)[-1].ImageId' \
  --output text)
echo -e "\033[0;32m You have selected the windows image type and its imid is ${window_imid}.\033[0m "
ami_id="${window_imid}"
break ;
;;
Ubuntu)
ubuntu_imid=$(aws ec2 describe-images --region ${region_aws} \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" \
            "Name=state,Values=available" \
  --query 'Images | sort_by(@, &CreationDate)[-1].ImageId' \
  --output text)
echo -e "\033[0;32m You have selected the Ubuntu image type and its imid is ${ubuntu_imid}.\033[0m "
ami_id="${ubuntu_imid}"
break ;
;;
Amazon)
amazon_imid=$(aws ec2 describe-images --region ${region_aws} \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-2023.*-x86_64" \
            "Name=state,Values=available" \
            "Name=root-device-type,Values=ebs" \
  --query 'Images | sort_by(@, &CreationDate)[-1].ImageId' \
  --output text)
echo -e "\033[0;32m You have selected the Amazon image type and its imid is ${amazon_imid}.\033[0m "
ami_id="${amazon_imid}"
break ;
;;
Other)
read -p "Please enter the image id manually :- " machine_id
echo -e "\033[0;32m You have successfully entered the manual imid and it is ${machine_id}. \033[0m "
ami_id="${machine_id}"
break ;
;;
*)
echo -e "\033[0;31m Please select from the given options to continue. \033[0m"
;;
esac
done
break ;
;;
esac
done
sleep 1
read -p "Please enter the instance type.(please enter for by default t3.micro) :- " instance_type
instance_type=${instance_type:-t3.micro}
echo -e "\033[0;32m Your instance type is ${instance_type} \033[0m"
read -p "Please enter the profile name with which you wish to continue " username
username=${username:- default}
read -p "Enter the access key pair name to continue " keyname
keyname=${keyname:-default}
echo -e "\033[0;32m Your key pair name for the instances is ${keyname} \033[0m"
read -p "Please enter the security group name.(Enter for default sgid) :- " sgname
sgname=${sgname:-Default}
read -p "Please enter the name for ec2 instance :- " Name_ec2 
####################################################################################
##################################  FUNCTIONS  #####################################
function aws_instance_creating (){
aws ec2 run-instances \
 --count ${cnt_ins} \
 --image-id ${ami_id} \
 --instance-type ${instance_type} \
 --region ${region_aws} \
 --profile ${username} \
 --key-name ${keyname} \
 --security-groups ${sgname} \
 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${Name_ec2}}]" 
sleep 2
echo -e "\033[0;32m THE OPERATION TO RUN CUSTOM EC2 INSTANCE HAS BEEN SUCCESSFUL \033[0m"
}
####################################################################################
aws_instance_creating >> /dev/null
