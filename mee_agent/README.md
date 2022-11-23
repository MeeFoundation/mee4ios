# Mee Agent 

# Generate bindings
1. Check Prerequisites https://mozilla.github.io/uniffi-rs/tutorial/Prerequisites.html
1. Go to the module directory like: `cd ./mee-agent`
1. Install Rust compiler targets for ios `rustup target add aarch64-apple-ios x86_64-apple-ios  aarch64-apple-ios-sim `
1. Install the uniffi-bindgen cli tool `cargo install uniffi_bindgen`
<!-- 1. Instsll lipo `cargo install cargo-lipo` -->
1. Run the following comands: 
Swift
```
uniffi-bindgen generate src/mee_ds.udl --language swift
```
Kotlin
```
uniffi-bindgen generate src/dmee_ds.udl --language kotlin
```
# Add to iOS app
1. follow steps https://github.com/mozilla/uniffi-rs/tree/main/examples/app/ios



---
Mee JS SDK:
 * init(conf, on_authorize)
 * authorize(nonce, ...) 
 * check(idToken)  - validates the ID token and returns claims (sub)

JS SDK config:
* env - DEV/INT/PROD, default: "INT" 
* client_id: client identifier
* scope - default: "openid"  
* claim - default: none, example: {"auth_time": {"essential": true}}
* callback_url - default: ???  (window href + ???)

---
Mee Agent API:
	<!-- Mee iOS app API (require device key): -->
---	
	* get_groups - returns list of GroupTO(id, name, logo)
	* get_contexts(group_id) - returns list of ContextNameTO(id, type(), url, name, logo(favicon), isMeeCert)
	* get_context_info(ctx_id) - return ContexInfoTO(name, consent, attributes, )
	* get_ctx_data(ctx_id, ) - return list of SimpleAttributeTO(id, value)
	* upd_attribute(ctx, att_id, val)
	* get_settings() - returns MeeSettings(...)
---
	<!-- OIDC SIOP -->
	* get_siop_metadata() -  Dynamic Self-Issued OpenID Provider Discovery Metadata
	<!-- OIDC implicit flow: -->
	<!-- 3.2.1.  Implicit Flow Steps -->
	<!-- (Mee iOS App -> Mee Privacy Agent API -> Mee OIDC) -->
	<!-- * Authorization Server Authenticates the End-User (Mee iOS App -> unlock access with FaceId). -->
	<!-- * Authorization Server obtains End-User Consent/Authorization (iOS App Consent UI / Collect Atts -> Mee OIDC -> Mee DS get/check/save consent, updAttribute) -->

	* authorize(req) -> AuthorizeTO(action, consent, ..) 
	* check_consent(req) -> ConsentStatusTO()
	* build_idtoken(req)

	<!-- * Authorization Server sends the End-User back to the Client with an ID Token and, if requested, an Access Token. (Mee iOS App -> iOS app Collect Mee OIDC -> Mee DS get/check/save consent) -->
---
