const e=(e=!0)=>{try{const n=`\n        Object.defineProperty(Navigator.prototype, "globalPrivacyControl", {\n          get: () => ${e},\n          configurable: true,\n          enumerable: true\n        });\n        document.currentScript.parentElement.removeChild(document.currentScript);\n      `,t=document.createElement("script");t.innerHTML=n,document.documentElement.prepend(t)}catch(n){console.error(`Failed to set DOM signal: ${n}`)}};(()=>{let n=new URL(location);!async function(e){const n=await fetch(`${e.origin}/.well-known/gpc.json`);let t;try{t=await n.json()}catch{t=null}chrome.runtime.sendMessage({msg:"DOWNLOAD_WELLKNOWN",data:t})}(n),chrome.runtime.sendMessage({msg:"CHECK_ENABLED",data:n.hostname}).then((n=>{navigator.hasOwnProperty("globalPrivacyControl")||(n.isEnabled?e(!0):e(!1))})),chrome.runtime.sendMessage({msg:"APP_COMMUNICATION",type:"GET_DOMAIN_STATUS",data:n.hostname}).then((e=>{console.log(e)}))})();
//# sourceMappingURL=content.js.map
