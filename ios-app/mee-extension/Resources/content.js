!async function(n){const t=await fetch(`${n.origin}/.well-known/gpc.json`);let a;try{a=await t.json()}catch{a=null}chrome.runtime.sendMessage({msg:"DOWNLOAD_WELLKNOWN",data:a})}(new URL(location));
