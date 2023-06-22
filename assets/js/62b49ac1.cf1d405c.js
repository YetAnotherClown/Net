"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[218],{3905:(e,t,n)=>{n.d(t,{Zo:()=>p,kt:()=>y});var r=n(67294);function i(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function a(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function o(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?a(Object(n),!0).forEach((function(t){i(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):a(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,i=function(e,t){if(null==e)return{};var n,r,i={},a=Object.keys(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||(i[n]=e[n]);return i}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(i[n]=e[n])}return i}var d=r.createContext({}),s=function(e){var t=r.useContext(d),n=t;return e&&(n="function"==typeof e?e(t):o(o({},t),e)),n},p=function(e){var t=s(e.components);return r.createElement(d.Provider,{value:t},e.children)},u="mdxType",c={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},f=r.forwardRef((function(e,t){var n=e.components,i=e.mdxType,a=e.originalType,d=e.parentName,p=l(e,["components","mdxType","originalType","parentName"]),u=s(n),f=i,y=u["".concat(d,".").concat(f)]||u[f]||c[f]||a;return n?r.createElement(y,o(o({ref:t},p),{},{components:n})):r.createElement(y,o({ref:t},p))}));function y(e,t){var n=arguments,i=t&&t.mdxType;if("string"==typeof e||i){var a=n.length,o=new Array(a);o[0]=f;var l={};for(var d in t)hasOwnProperty.call(t,d)&&(l[d]=t[d]);l.originalType=e,l[u]="string"==typeof e?e:i,o[1]=l;for(var s=2;s<a;s++)o[s]=n[s];return r.createElement.apply(null,o)}return r.createElement.apply(null,n)}f.displayName="MDXCreateElement"},38170:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>d,contentTitle:()=>o,default:()=>c,frontMatter:()=>a,metadata:()=>l,toc:()=>s});var r=n(87462),i=(n(67294),n(3905));const a={sidebar_position:2},o="Querying Data",l={unversionedId:"handling-data/querying-data",id:"handling-data/querying-data",title:"Querying Data",description:"To query data, you must iterate over it in a for loop.",source:"@site/docs/handling-data/querying-data.md",sourceDirName:"handling-data",slug:"/handling-data/querying-data",permalink:"/Net/docs/handling-data/querying-data",draft:!1,editUrl:"https://github.com/YetAnotherClown/Net/edit/main/docs/handling-data/querying-data.md",tags:[],version:"current",sidebarPosition:2,frontMatter:{sidebar_position:2},sidebar:"defaultSidebar",previous:{title:"Sending Data",permalink:"/Net/docs/handling-data/sending-data"},next:{title:"Compressing Data",permalink:"/Net/docs/handling-data/compressing-data"}},d={},s=[],p={toc:s},u="wrapper";function c(e){let{components:t,...n}=e;return(0,i.kt)(u,(0,r.Z)({},p,n,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("h1",{id:"querying-data"},"Querying Data"),(0,i.kt)("p",null,"To query data, you must iterate over it in a for loop.\nTo do this, you can either iterate over the Net object itself or use the ",(0,i.kt)("inlineCode",{parentName:"p"},"Net:query()")," method."),(0,i.kt)("p",null,"By default, both of these options will return a tuple consisting of\n",(0,i.kt)("inlineCode",{parentName:"p"},"position, sender, identifier, args..."),"."),(0,i.kt)("p",null,"This may become a lot of values quickly, some of which you may not need. To solve this, you can pass in\nspecific Types into the ",(0,i.kt)("inlineCode",{parentName:"p"},"Net:query()")," method to filter them out."),(0,i.kt)("p",null,"For example,"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-lua"},'local MyIdentifier = Net.identifier("myIdentifier")\n\nfor i, sender, args... in Net:query(MyIdentifier) do\n    -- Retrieves all packets with the specified identifier\nend\n')),(0,i.kt)("p",null,"This example only filters out the Identifier. We can also filter out by the Sender by adding\n",(0,i.kt)("inlineCode",{parentName:"p"},"{ Players }"),", ",(0,i.kt)("inlineCode",{parentName:"p"},"Player"),", or ",(0,i.kt)("inlineCode",{parentName:"p"},"Net.Server"),"."),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-lua"},"for i, args... in Net:query(YetAnotherClown, MyIdentifier) do\n    -- Retrieves all packets from YetAnotherClown with the specified Identifier\nend\n")),(0,i.kt)("p",null,"Great, so we managed to filter out both our Sender and Identifier arguments. But what if we provide\nmultiple Identifiers or Players? When a table or tuple of Players, or a tuple of Identifiers is provided,\nthe iterator will return the sender and identifier respectfully as neither is known beforehand."),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-lua"},'local MyIdentifier = Net.identifier("myIdentifier")\nlocal MyOtherIdentifier = Net.identifier("myIdentifier")\n\nfor i, identifier, args... in Net:query(MyIdentifier, MyOtherIdentifier) do\n    -- Retrieves all packets of the specified identifiers\nend\n')))}c.isMDXComponent=!0}}]);