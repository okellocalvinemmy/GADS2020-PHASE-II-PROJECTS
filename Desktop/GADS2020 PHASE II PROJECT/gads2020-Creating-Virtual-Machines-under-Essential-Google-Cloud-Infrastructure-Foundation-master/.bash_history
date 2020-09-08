# Task 1: Create a utility virtual machine
gcloud beta compute instances create my-vm --zone=us-central1-c --machine-type=n1-standard-1 --no-address --image=debian-9-stretch-v20200805  --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard
# Task 2: Create a Windows virtual machine
gcloud beta compute instances create my-windows-vm --zone=europe-west2-a --machine-type=n1-standard-2  --tags=http-server,https-server --image=windows-server-2016-dc-core-v20200813 --image-project=windows-cloud --boot-disk-size=100GB --boot-disk-type=pd-balanced
gcloud compute firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
gcloud compute firewall-rules create default-allow-https --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=https-server
# Task 3: Create a custom virtual machine
gcloud beta compute instances create my-custom-vm --zone=us-west1-b --machine-type=custom-6-32768 --image=debian-9-stretch-v20200805  --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard
clear
git init
