"use strict";(self.webpackChunkflutter_news_toolkit_docs=self.webpackChunkflutter_news_toolkit_docs||[]).push([[4],{3905:(e,t,n)=>{n.d(t,{Zo:()=>u,kt:()=>f});var i=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function r(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);t&&(i=i.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,i)}return n}function a(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?r(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):r(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,i,o=function(e,t){if(null==e)return{};var n,i,o={},r=Object.keys(e);for(i=0;i<r.length;i++)n=r[i],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);for(i=0;i<r.length;i++)n=r[i],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var p=i.createContext({}),c=function(e){var t=i.useContext(p),n=t;return e&&(n="function"==typeof e?e(t):a(a({},t),e)),n},u=function(e){var t=c(e.components);return i.createElement(p.Provider,{value:t},e.children)},s={inlineCode:"code",wrapper:function(e){var t=e.children;return i.createElement(i.Fragment,{},t)}},d=i.forwardRef((function(e,t){var n=e.components,o=e.mdxType,r=e.originalType,p=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),d=c(n),f=o,m=d["".concat(p,".").concat(f)]||d[f]||s[f]||r;return n?i.createElement(m,a(a({ref:t},u),{},{components:n})):i.createElement(m,a({ref:t},u))}));function f(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var r=n.length,a=new Array(r);a[0]=d;var l={};for(var p in t)hasOwnProperty.call(t,p)&&(l[p]=t[p]);l.originalType=e,l.mdxType="string"==typeof e?e:o,a[1]=l;for(var c=2;c<r;c++)a[c]=n[c];return i.createElement.apply(null,a)}return i.createElement.apply(null,n)}d.displayName="MDXCreateElement"},6415:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>p,contentTitle:()=>a,default:()=>s,frontMatter:()=>r,metadata:()=>l,toc:()=>c});var i=n(7462),o=(n(7294),n(3905));const r={sidebar_position:3,description:"Learn how to configure authentication in your Flutter news application."},a="Authentication",l={unversionedId:"flutter_development/authentication",id:"flutter_development/authentication",title:"Authentication",description:"Learn how to configure authentication in your Flutter news application.",source:"@site/docs/flutter_development/authentication.md",sourceDirName:"flutter_development",slug:"/flutter_development/authentication",permalink:"/news_toolkit/flutter_development/authentication",draft:!1,editUrl:"https://github.com/flutter/news_toolkit/tree/main/docs/docs/flutter_development/authentication.md",tags:[],version:"current",sidebarPosition:3,frontMatter:{sidebar_position:3,description:"Learn how to configure authentication in your Flutter news application."},sidebar:"tutorialSidebar",previous:{title:"Working with Translations",permalink:"/news_toolkit/flutter_development/translations"},next:{title:"Analytics",permalink:"/news_toolkit/flutter_development/analytics"}},p={},c=[],u={toc:c};function s(e){let{components:t,...n}=e;return(0,o.kt)("wrapper",(0,i.Z)({},u,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"authentication"},"Authentication"),(0,o.kt)("p",null,"Currently, this project supports multiple ways of authentication such as ",(0,o.kt)("inlineCode",{parentName:"p"},"email"),", ",(0,o.kt)("inlineCode",{parentName:"p"},"google"),", ",(0,o.kt)("inlineCode",{parentName:"p"},"apple"),", ",(0,o.kt)("inlineCode",{parentName:"p"},"twitter")," and ",(0,o.kt)("inlineCode",{parentName:"p"},"facebook")," login."),(0,o.kt)("p",null,"The current implementation of the login functionality can be found in ",(0,o.kt)("a",{parentName:"p",href:"https://github.com/VGVentures/google_news_template/blob/e25b4905604f29f6a2b165b7381e696f4ebc22ee/packages/authentication_client/firebase_authentication_client/lib/src/firebase_authentication_client.dart#L20"},"FirebaseAuthenticationClient")," inside the ",(0,o.kt)("inlineCode",{parentName:"p"},"packages/authentication_client")," package."),(0,o.kt)("p",null,"The package depends on the third-party packages that expose authentication methods such as:"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("inlineCode",{parentName:"li"},"firebase_auth")),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("inlineCode",{parentName:"li"},"flutter_facebook_auth")),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("inlineCode",{parentName:"li"},"google_sign_in")),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("inlineCode",{parentName:"li"},"sign_in_with_apple")),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("inlineCode",{parentName:"li"},"twitter_login"))),(0,o.kt)("p",null,"To enable authentication, configure each authentication method:"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},'For email login, enable the Email/password sign-in provider in the Firebase Console of your project. In the same section, enable Email link sign-in method. On the dynamic links page, set up a new dynamic link URL prefix (e.g. yourApplicationName.page.link) with a dynamic link URL of "/email_login".'),(0,o.kt)("li",{parentName:"ul"},"For Google login, enable the Google sign-in provider in the Firebase Console of your project. You might need to generate a SHA1 key for use with Android."),(0,o.kt)("li",{parentName:"ul"},"For Apple login, ",(0,o.kt)("a",{parentName:"li",href:"https://firebase.google.com/docs/auth/ios/apple#configure-sign-in-with-apple"},"configure sign-in with Apple")," in the Apple's developer portal and ",(0,o.kt)("a",{parentName:"li",href:"https://firebase.google.com/docs/auth/ios/apple#enable-apple-as-a-sign-in-provider"},"enable the Apple sign-in provider")," in the Firebase Console of your project."),(0,o.kt)("li",{parentName:"ul"},"For Twitter login, register an app in the Twitter developer portal and enable the Twitter sign-in provider in the Firebase Console of your project."),(0,o.kt)("li",{parentName:"ul"},"For Facebook login, register an app in the Facebook developer portal and enable the Facebook sign-in provider in the Firebase Console of your project.")),(0,o.kt)("p",null,"Once configured, make sure to update the Firebase config file (Google services) in your application."),(0,o.kt)("p",null,"For more detailed usage of these authentication methods, check ",(0,o.kt)("a",{parentName:"p",href:"https://firebase.google.com/docs/auth/flutter/federated-auth"},"firebase.google.com")," documentation."))}s.isMDXComponent=!0}}]);