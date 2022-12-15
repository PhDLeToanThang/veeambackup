# veeambackup:

**1. Veeam Powered Network (VeeamPN)**
If you follow Veeam, you have certainly not missed quite a few blog posts about Veeam PN (Powered Network) software. Already during VeeamON 2017, we could see a functional demo, but the solution was not GA at that time. Now Veeam has finally released the final version of Veeam PN and it's available from Azure Marketplace (Hub Appliance) and as an OVA package for local deployment (Site Gateway).
The product can be used to easily setup VPN connections over a public network.

VeeamPN At the heart of this new solution is Veeam PN, which extends an on-premises network to an Azure network, enhancing the ability to back up anything, anywhere and restore to Azure. It's designed to simplify and automate the setup of a data recovery site in Microsoft Azure.

There are two different connection scenarios possible, depending what you need/want to do:
    Site-to-site VPN between company offices and a Microsoft Azure network to which VMs restored in Microsoft Azure are connected.
    Point-to-site VPN between remote computers and a Microsoft Azure network to which VMs restored in Microsoft Azure are connected.

**There are Two components of Veeam PN:**
1. Hub Appliance – deployable from Azure Marketplace
2. Site Gateway –  downloadable from the Veeam.com website and deployed on-premises
The architecture overview below can give you more details.

![image](https://user-images.githubusercontent.com/106635733/207789463-6a9595e3-a225-4f8b-b1cd-9d734d737a5a.png)

**Veeam PN – The Features:**
1. Provides seamless and secure networking between on-premises and Azure-based IT resources
2. Delivers easy-to-use and fully automated site-to-site network connectivity between any site
3. Designed for both SMB and enterprise customers, as well as service providers
Here is another picture from Veeam PN user guide:

![image](https://user-images.githubusercontent.com/106635733/207789750-7feb6230-01e1-43cf-961b-1484ffc4a36e.png)

**Veeam PN System Requirements:**
**1. Network Hub:**
  whether installed At Azure or On-premises (for site-to-site scenario) needs to run on at least ESXi/vSphere 5.0 or higher (hardware version 8 or later), needs 1Gb of RAM. For “point-to-site” scenario you need Microsoft Azure account in order to be able to set up an A1 VM at least (1 core, 1.75 GB memory, 70 GB of disk space).

**2.Site Gateway:**
 The on-premise part also called Site Gateway is an appliance which has a disk size of 3.9Gb (thin provisioned) or 16Gb thick.
Veeam has an online user guide for Veeam PN where you can follow the different configuration steps or how-tos.

Check it out here.
- Few other fellow bloggers, including Anthony Spiteri at Veeam blog (link below), has already written about Veeam PN. As being said, the product is now GA, so go and download your copy to test it out.
- Veeam PN enables organizations to use Microsoft Azure for restoring their data and ensure business continuity without the need for a dedicated recovery site. If you have a remote site, you won't need Azure.

**Sum-up:**
It also simplifies the configuration and deployment of the restoration site with the new Veeam PN (Powered Network), which is a complete networking solution. You can also use Veeam PN for easy migrations of your local workloads into Microsoft Azure.
