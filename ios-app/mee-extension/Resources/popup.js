function e(){return indexedDB.open("MeeExtensionDB",7)}async function n(n){return new Promise(((t,o)=>{const s=e();s.onerror=e=>{o()},s.onsuccess=function(e){const s=e.target.result,a=s.transaction(["domains"],"readwrite").objectStore("domains").get(n);a.onerror=e=>{o()},a.onsuccess=e=>{t(e.target.result)},s.close()}}))}async function t(n){return new Promise(((t,o)=>{const s=e();s.onerror=e=>{o()},s.onsuccess=function(e){const s=e.target.result,a=s.transaction(["domains"],"readwrite").objectStore("domains"),c=a.get(n);c.onerror=e=>{s.close(),o()},c.onsuccess=e=>{const c=e.target.result,r={domain:n,wellknown:!!c&&c.wellknown,enabled:!!c&&!c.enabled},i=a.put(r);i.onerror=e=>{s.close(),o()},i.onsuccess=e=>{s.close(),t(!0)}}}}))}function o(){return new Promise(((e,n)=>{try{chrome.tabs.query({active:!0,currentWindow:!0},(function(n){let t=n[0],o=new URL(t.url).hostname.replace("www.","");e(o)}))}catch(t){n()}}))}async function s(e,t=null){const o=function(e,n=null){return e?e.enabled:!(!n||!n.gpc)}(await n(e),t);a(),document.getElementById("slider-item").checked=o}async function a(){const e=await n("meeExtension");return!e||e.enabled}async function c(){const e=await a();document.getElementById("slider").checked=e,document.getElementById("domain-container").style.display=e?"flex":"none"}chrome.runtime.onMessage.addListener((async function(e,n,t){const a=await o();if("SEND_WELLKNOWN_TO_POPUP"===e.msg){let{domain:n,wellknownData:t}=e.data;n===a&&s(a,t)}})),document.addEventListener("DOMContentLoaded",(async e=>{const n=await o();document.getElementById("current-domain").innerHTML=n||"Undefined",chrome.runtime.sendMessage({msg:"POPUP_LOADED",data:null}),await s(n),await c(),await async function(){const e=await o();chrome.runtime.sendMessage({msg:"APP_COMMUNICATION",type:"GET_DOMAIN_STATUS",data:e}).then((e=>{e.hasConnection?document.getElementById("has-connection").innerHTML=" true":document.getElementById("has-connection").innerHTML=" false"}))}()})),document.getElementById("slider-item").addEventListener("change",(async e=>{const n=await o();chrome.runtime.sendMessage({msg:"APP_COMMUNICATION",type:"UPDATE_DOMAIN_STATUS",data:JSON.stringify({domain:n,gpcEnabled:e.target.checked})}).then((e=>{console.log(e)}));await t(n)&&(chrome.runtime.sendMessage({msg:"UPDATE_SELECTOR"}),s(n))})),document.getElementById("slider").addEventListener("click",(async e=>{const n=await o();await t("meeExtension")&&(chrome.runtime.sendMessage({msg:"UPDATE_ENABLED"}),s(n)),await c()}));
