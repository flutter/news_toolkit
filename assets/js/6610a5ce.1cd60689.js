"use strict";(self.webpackChunkflutter_news_toolkit_docs=self.webpackChunkflutter_news_toolkit_docs||[]).push([[969],{3905:(e,t,r)=>{r.d(t,{Zo:()=>s,kt:()=>m});var n=r(7294);function o(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function i(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function a(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?i(Object(r),!0).forEach((function(t){o(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):i(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function u(e,t){if(null==e)return{};var r,n,o=function(e,t){if(null==e)return{};var r,n,o={},i=Object.keys(e);for(n=0;n<i.length;n++)r=i[n],t.indexOf(r)>=0||(o[r]=e[r]);return o}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(n=0;n<i.length;n++)r=i[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(o[r]=e[r])}return o}var c=n.createContext({}),l=function(e){var t=n.useContext(c),r=t;return e&&(r="function"==typeof e?e(t):a(a({},t),e)),r},s=function(e){var t=l(e.components);return n.createElement(c.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},f=n.forwardRef((function(e,t){var r=e.components,o=e.mdxType,i=e.originalType,c=e.parentName,s=u(e,["components","mdxType","originalType","parentName"]),f=l(r),m=o,g=f["".concat(c,".").concat(m)]||f[m]||p[m]||i;return r?n.createElement(g,a(a({ref:t},s),{},{components:r})):n.createElement(g,a({ref:t},s))}));function m(e,t){var r=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var i=r.length,a=new Array(i);a[0]=f;var u={};for(var c in t)hasOwnProperty.call(t,c)&&(u[c]=t[c]);u.originalType=e,u.mdxType="string"==typeof e?e:o,a[1]=u;for(var l=2;l<i;l++)a[l]=r[l];return n.createElement.apply(null,a)}return n.createElement.apply(null,r)}f.displayName="MDXCreateElement"},9342:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>c,contentTitle:()=>a,default:()=>p,frontMatter:()=>i,metadata:()=>u,toc:()=>l});var n=r(7462),o=(r(7294),r(3905));const i={sidebar_position:1,description:"Learn how to configure your repository on GitHub."},a="GitHub Setup",u={unversionedId:"project_configuration/github",id:"project_configuration/github",title:"GitHub Setup",description:"Learn how to configure your repository on GitHub.",source:"@site/docs/project_configuration/github.md",sourceDirName:"project_configuration",slug:"/project_configuration/github",permalink:"/news_toolkit/project_configuration/github",draft:!1,editUrl:"https://github.com/flutter/news_toolkit/tree/main/docs/docs/project_configuration/github.md",tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_position:1,description:"Learn how to configure your repository on GitHub."},sidebar:"tutorialSidebar",previous:{title:"Project Configuration",permalink:"/news_toolkit/category/project-configuration"},next:{title:"Social Authentication Setup",permalink:"/news_toolkit/project_configuration/social_authentication"}},c={},l=[],s={toc:l};function p(e){let{components:t,...r}=e;return(0,o.kt)("wrapper",(0,n.Z)({},s,r,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"github-setup"},"GitHub Setup"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},"Create repository within the \u2018Github Organization\u2019 to enable:",(0,o.kt)("ul",{parentName:"li"},(0,o.kt)("li",{parentName:"ul"},"The following recommended branch protection rules:",(0,o.kt)("ul",{parentName:"li"},(0,o.kt)("li",{parentName:"ul"},"Require a pull request before merging (require approvals, dismiss stale pull request approvals when new commits are pushed, require review from Code Owners)."),(0,o.kt)("li",{parentName:"ul"},"Require status checks to pass before merging (require branches to be up to date before merging)."),(0,o.kt)("li",{parentName:"ul"},"Require linear history."))),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("a",{parentName:"li",href:"https://github.com/integrations/slack/blob/master/README.md"},"Slack Integration")," (recommended)"),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("a",{parentName:"li",href:"https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-branches"},"Auto-deletion")," and ",(0,o.kt)("a",{parentName:"li",href:"https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-auto-merge-for-pull-requests-in-your-repository"},"auto-merge")," for branches"),(0,o.kt)("li",{parentName:"ul"},"Draft PRs"))),(0,o.kt)("li",{parentName:"ul"},"Grant Admin access to at least one developer to enable secrets creation.")))}p.isMDXComponent=!0}}]);