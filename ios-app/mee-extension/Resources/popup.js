function e(){return indexedDB.open("MeeExtensionDB",13)}async function n(n){return new Promise(((t,o)=>{const a=e();a.onerror=()=>{o("Error in openDB")},a.onsuccess=function(e){const a=e.target.result,s=a.transaction(["domains"],"readwrite").objectStore("domains").get(n);s.onerror=()=>{o(`${n} Result: has't been found`)},s.onsuccess=e=>{t(e.target.result)},a.close()}}))}async function t(n){return new Promise(((t,o)=>{const a=e();a.onerror=e=>{o("Error in openDB")},a.onsuccess=function(e){const a=e.target.result,s=a.transaction(["domains"],"readwrite").objectStore("domains"),c=s.get(n);c.onerror=e=>{a.close(),o(`${n} Result: has't been found`)},c.onsuccess=e=>{const c=e.target.result,r={domain:n,wellknown:!!c&&c.wellknown,enabled:!!c&&!c.enabled},i=s.put(r);i.onerror=e=>{a.close(),o("Error with put data")},i.onsuccess=e=>{a.close(),t({domain:r.domain,isEnabled:r.enabled})}}}}))}const o=()=>new Promise(((e,n)=>{try{chrome.tabs.query({active:!0,currentWindow:!0},(function(n){let t=n[0];const o=(a=t.url,new URL(a).hostname.replace("www.",""));var a;e(o)}))}catch(t){n()}}));async function a(e,t=null){try{const o=function(e,n=null){return e.enabled}(await n(e),t);document.getElementById("slider-domain").checked=o}catch(o){console.log(o),document.getElementById("slider-domain").checked=!1}}async function s(){const e=await async function(){try{const e=await n("meeExtension");return!e||e.enabled}catch(e){return console.log(e),!1}}();document.getElementById("slider-extension").checked=e,document.getElementById("domain-container").style.display=e?"flex":"none"}chrome.runtime.onMessage.addListener((async function(e,n,t){if("SEND_WELLKNOWN_TO_POPUP"===e.msg){const n=await o();let{domain:t,wellknownData:s}=e.data;t===n&&a(n,s)}})),document.addEventListener("DOMContentLoaded",(async e=>{const n=await o();document.getElementById("current-domain").innerHTML=n||"Undefined",chrome.runtime.sendMessage({msg:"POPUP_LOADED",data:null}),await a(n),await s()})),document.getElementById("slider-domain").addEventListener("click",(async e=>{const n=await o(),s=await t(n);s&&(chrome.runtime.sendMessage({msg:"UPDATE_SELECTOR",mode:s.isEnabled?"enable":"disable",domain:s.domain}),a(s.domain))})),document.getElementById("slider-extension").addEventListener("click",(async e=>{const n=await o();await t("meeExtension")&&(chrome.runtime.sendMessage({msg:"UPDATE_ENABLED"}),a(n)),await s()}));
//# sourceMappingURL=popup.js.map
