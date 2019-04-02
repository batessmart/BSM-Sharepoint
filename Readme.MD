<h3 class="post-title entry-title">nstall SPFx React Script editor web part as tenant-scoped solution into Sharepoint Online</h3>
<div class="post-header">&nbsp;</div>
<div id="post-body-9030131601164609065" class="post-body entry-content">
<p>How it is said in the following MS article&nbsp;<a href="https://docs.microsoft.com/en-us/sharepoint/dev/spfx/tenant-scoped-deployment">Tenant-Scoped solution deployment for SharePoint Framework solutions</a>, it is possible to make SPFx solution tenant scoped. According to documentation components installed with such solution will become immediately available cross the tenant after solution package will be installed to tenant app catalog. Let&rsquo;s check few internal details of tenant-scoped solutions using&nbsp;<a href="https://github.com/SharePoint/sp-dev-fx-webparts/tree/dev/samples/react-script-editor">Script editor web part for modern pages built in React</a>&nbsp;as example.</p>
<p>Before to start we will need to install the following prerequisites:</p>
<ul>
<li>git for Windows</li>
<li>nodejs for Windows</li>
<li>also I usually need to globally install gulp&nbsp;<br />npm install -g gulp&nbsp;<br />and add resolved folder %appdata%\npm to PATH environment variable</li>
</ul>
<p>So first of all we need to clone git repository with web part code:</p>
<blockquote>
<p>git clone&nbsp;<a title="https://github.com/SharePoint/sp-dev-fx-webparts.git" href="https://github.com/SharePoint/sp-dev-fx-webparts.git">https://github.com/SharePoint/sp-dev-fx-webparts.git</a></p>
</blockquote>
<p>After that go to ~/sp-dev-fx-webparts\samples\react-script-editor and run the following commands:</p>
<blockquote>
<p>npm install</p>
</blockquote>
<p>which will install necessary dependencies into node_modules subfolder (there are more that 1600 dependencies so it will take some time). After that edit config/package-solution.json file: add "skipFeatureDeployment": true there:</p>
<p><a href="https://3.bp.blogspot.coam/-HWo3y6XxM-o/Wi5yi_Pr_CI/AAAAAAAAEoA/wgtst6UNxIoC4jX7g14ISof-V6zvrIoNQCLcBGAs/s1600/01.png"><img src="https://3.bp.blogspot.com/-HWo3y6XxM-o/Wi5yi_Pr_CI/AAAAAAAAEoA/wgtst6UNxIoC4jX7g14ISof-V6zvrIoNQCLcBGAs/s1600/01.png" border="0" data-original-height="241" data-original-width="544" /></a></p>
<p>it will make our solution tenant-scoped. Also edit config\write-manifest.json file: set cdnBasePath variable to your CDN path, e.g.</p>
<blockquote>
<p>https:&lt;tenant&gt;.sharepoint.com/sites/CDN/SiteAssets/SPFx/react-script-editor</p>
</blockquote>
<p>After that run the following commands:</p>
<blockquote>
<p>gulp --ship</p>
<p>gulp package-solution --ship</p>
</blockquote>
<p>First one should create temp folder. You need go to its deploy subfolder and copy files from there to specified CDN. Second command will create sharepoint/solution folder with pzl-script-editor.sppkg file. This file is zip file so if we will unzip it and check AppManifest.xml we will find that it has SkipFeatureDeployment=&rdquo;true&rdquo; attribute:</p>
<p><a href="https://2.bp.blogspot.com/-YESOf9PqxAI/Wi5ynq71xWI/AAAAAAAAEoE/xTDT52YGWosQaWKjl1cX4rgRZgqaT2ovQCLcBGAs/s1600/02.png"><img src="https://2.bp.blogspot.com/-YESOf9PqxAI/Wi5ynq71xWI/AAAAAAAAEoE/xTDT52YGWosQaWKjl1cX4rgRZgqaT2ovQCLcBGAs/s1600/02.png" border="0" data-original-height="252" data-original-width="674" /></a></p>
<p>Now deploy to App catalog and enable "Make this solution available to all sites in the organization" option:</p>
<p><a href="https://2.bp.blogspot.com/-suioRxyR7IQ/Wi5yrvg3vRI/AAAAAAAAEoI/hw4FPGvZGzsvdGHyAT24-okELgWRQv1sQCLcBGAs/s1600/03.png"><img src="https://2.bp.blogspot.com/-suioRxyR7IQ/Wi5yrvg3vRI/AAAAAAAAEoI/hw4FPGvZGzsvdGHyAT24-okELgWRQv1sQCLcBGAs/s1600/03.png" border="0" data-original-height="379" data-original-width="644" /></a></p>
<p>After that solution should be available on all sites of your tenant.</p>
</div>
