
Install SPFx React Script editor web part as tenant-scoped solution into Sharepoint Online
How it is said in the following MS article Tenant-Scoped solution deployment for SharePoint Framework solutions, it is possible to make SPFx solution tenant scoped. According to documentation components installed with such solution will become immediately available cross the tenant after solution package will be installed to tenant app catalog. Let’s check few internal details of tenant-scoped solutions using Script editor web part for modern pages built in React as example.

Before to start we will need to install the following prerequisites:

git for Windows
nodejs for Windows
also I usually need to globally install gulp 
npm install -g gulp 
and add resolved folder %appdata%\npm to PATH environment variable
So first of all we need to clone git repository with web part code:

git clone https://github.com/SharePoint/sp-dev-fx-webparts.git

After that go to ~/sp-dev-fx-webparts\samples\react-script-editor and run the following commands:

npm install

which will install necessary dependencies into node_modules subfolder (there are more that 1600 dependencies so it will take some time). After that edit config/package-solution.json file: add "skipFeatureDeployment": true there:



it will make our solution tenant-scoped. Also edit config\write-manifest.json file: set cdnBasePath variable to your CDN path, e.g.

https:<tenant>.sharepoint.com/sites/CDN/SiteAssets/SPFx/react-script-editor

After that run the following commands:

gulp --ship

gulp package-solution --ship

First one should create temp folder. You need go to its deploy subfolder and copy files from there to specified CDN. Second command will create sharepoint/solution folder with pzl-script-editor.sppkg file. This file is zip file so if we will unzip it and check AppManifest.xml we will find that it has SkipFeatureDeployment=”true” attribute:



Now deploy to App catalog and enable "Make this solution available to all sites in the organization" option:



After that solution should be available on all sites of your tenant.
