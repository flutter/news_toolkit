"use strict";(self.webpackChunkflutter_news_toolkit_docs=self.webpackChunkflutter_news_toolkit_docs||[]).push([[651],{3905:(e,t,n)=>{n.d(t,{Zo:()=>c,kt:()=>m});var r=n(7294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},o=Object.keys(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var p=r.createContext({}),u=function(e){var t=r.useContext(p),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},c=function(e){var t=u(e.components);return r.createElement(p.Provider,{value:t},e.children)},s={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},d=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,o=e.originalType,p=e.parentName,c=l(e,["components","mdxType","originalType","parentName"]),d=u(n),m=a,h=d["".concat(p,".").concat(m)]||d[m]||s[m]||o;return n?r.createElement(h,i(i({ref:t},c),{},{components:n})):r.createElement(h,i({ref:t},c))}));function m(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=n.length,i=new Array(o);i[0]=d;var l={};for(var p in t)hasOwnProperty.call(t,p)&&(l[p]=t[p]);l.originalType=e,l.mdxType="string"==typeof e?e:a,i[1]=l;for(var u=2;u<o;u++)i[u]=n[u];return r.createElement.apply(null,i)}return r.createElement.apply(null,n)}d.displayName="MDXCreateElement"},4202:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>p,contentTitle:()=>i,default:()=>s,frontMatter:()=>o,metadata:()=>l,toc:()=>u});var r=n(7462),a=(n(7294),n(3905));const o={sidebar_position:1,description:"Learn how to run your news API."},i="Running the API",l={unversionedId:"server_development/running_the_api",id:"server_development/running_the_api",title:"Running the API",description:"Learn how to run your news API.",source:"@site/docs/server_development/running_the_api.md",sourceDirName:"server_development",slug:"/server_development/running_the_api",permalink:"/news_toolkit/server_development/running_the_api",draft:!1,editUrl:"https://github.com/flutter/news_toolkit/tree/main/docs/docs/server_development/running_the_api.md",tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_position:1,description:"Learn how to run your news API."},sidebar:"tutorialSidebar",previous:{title:"Server Development",permalink:"/news_toolkit/category/server-development"},next:{title:"Connecting your Data Source",permalink:"/news_toolkit/server_development/connecting_your_data_source"}},p={},u=[{value:"Overview",id:"overview",level:2},{value:"Running the API Server Locally",id:"running-the-api-server-locally",level:3},{value:"Running the API Server in Docker",id:"running-the-api-server-in-docker",level:3},{value:"API Documentation",id:"api-documentation",level:2},{value:"Running the Documentation Locally",id:"running-the-documentation-locally",level:3},{value:"Contributing to the API Documentation",id:"contributing-to-the-api-documentation",level:3}],c={toc:u};function s(e){let{components:t,...n}=e;return(0,a.kt)("wrapper",(0,r.Z)({},c,n,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"running-the-api"},"Running the API"),(0,a.kt)("h2",{id:"overview"},"Overview"),(0,a.kt)("p",null,"The Google News Template API is written in ",(0,a.kt)("a",{parentName:"p",href:"https://dart.dev"},"Dart")," and uses ",(0,a.kt)("a",{parentName:"p",href:"https://verygoodopensource.github.io/dart_frog"},"Dart Frog"),"."),(0,a.kt)("h3",{id:"running-the-api-server-locally"},"Running the API Server Locally"),(0,a.kt)("p",null,"To run the server locally, run the following command from the current directory:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"dart_frog dev\n")),(0,a.kt)("p",null,"This will start the server on ",(0,a.kt)("a",{parentName:"p",href:"http://localhost:8080"},"localhost:8080"),"."),(0,a.kt)("h3",{id:"running-the-api-server-in-docker"},"Running the API Server in Docker"),(0,a.kt)("p",null,"To run the server in Docker, make sure you have ",(0,a.kt)("a",{parentName:"p",href:"https://docs.docker.com/get-docker/"},"Docker installed"),"."),(0,a.kt)("p",null,"First, create a production build via:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"dart_frog build\n")),(0,a.kt)("p",null,"Next, switch directories into the generated ",(0,a.kt)("inlineCode",{parentName:"p"},"build")," directory."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"cd build\n")),(0,a.kt)("p",null,"Then you can create an image:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"docker build -q .\n")),(0,a.kt)("p",null,"Once you have created an image, you can run the image via:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"docker run -d -p 8080:8080 --rm <IMAGE>\n")),(0,a.kt)("p",null,"To kill the container:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"docker kill <CONTAINER>\n")),(0,a.kt)("p",null,"If you wish to delete an image you can run:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"docker rmi <IMAGE>\n")),(0,a.kt)("h2",{id:"api-documentation"},"API Documentation"),(0,a.kt)("p",null,"The service API documentation can be found in ",(0,a.kt)("inlineCode",{parentName:"p"},"docs/api.apib"),". The documentation uses the ",(0,a.kt)("a",{parentName:"p",href:"https://github.com/apiaryio/api-blueprint"},"API Blueprint")," specification and can be previewed using the ",(0,a.kt)("a",{parentName:"p",href:"https://github.com/apiaryio/apiary-client"},"Apiary Client"),"."),(0,a.kt)("h3",{id:"running-the-documentation-locally"},"Running the Documentation Locally"),(0,a.kt)("p",null,"To run the interactive API documentation locally make sure you have the ",(0,a.kt)("a",{parentName:"p",href:"https://github.com/apiaryio/apiary-client"},"Apiary Client")," installed:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"$ gem install apiaryio\n")),(0,a.kt)("p",null,"Then use the ",(0,a.kt)("inlineCode",{parentName:"p"},"preview")," command to run the documentation:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"$ apiary preview --path docs/api.apib --watch\n")),(0,a.kt)("p",null,"The interactive documentation will be available at ",(0,a.kt)("a",{parentName:"p",href:"http://localhost:8080"},"localhost:8080"),"."),(0,a.kt)("p",null,"Refer to the ",(0,a.kt)("a",{parentName:"p",href:"https://help.apiary.io/tools/apiary-cli"},"Apiary Client Documentation")," for more information."),(0,a.kt)("h3",{id:"contributing-to-the-api-documentation"},"Contributing to the API Documentation"),(0,a.kt)("p",null,"Refer to ",(0,a.kt)("a",{parentName:"p",href:"https://apiblueprint.org/"},"APIBlueprint.org")," for documentation and tutorials on using the API Blueprint Specification."),(0,a.kt)("p",null,"Refer to the ",(0,a.kt)("a",{parentName:"p",href:"https://github.com/apiaryio/api-blueprint/blob/master/API%20Blueprint%20Specification.md"},"API Blueprint Specification")," for more information."),(0,a.kt)("p",null,"It is recommended to install the ",(0,a.kt)("a",{parentName:"p",href:"https://marketplace.visualstudio.com/items?itemName=vncz.vscode-apielements"},"API Elements VSCode Extension")," to provide syntax highlighting and show errors/warnings when using invalid syntax."))}s.isMDXComponent=!0}}]);