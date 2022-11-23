#[derive(Debug, thiserror::Error)]
pub enum MeeOidcErr {
    // #[error(transparent)]
    // DSErr(#[from] mee_ds_sqlite::MeeDsSqliteErr),
    #[error("unknown error")]
    Unknown,
}

type Result<T, E = MeeOidcErr> = std::result::Result<T, E>;
// <!-- OIDC implicit flow
// <!-- (Mee iOS App -> Mee Privacy Agent API -> Mee OIDC) -->
// <!-- * Authorization Server Authenticates the End-User (Mee iOS App -> unlock access with FaceId). -->
// <!-- * Authorization Server obtains End-User Consent/Authorization (iOS App Consent UI / Collect Atts -> Mee OIDC -> Mee DS get/check/save consent, updAttribute) -->
// <!-- * Authorization Server sends the End-User back to the Client with an ID Token and, if requested, an Access Token. (Mee iOS App -> iOS app Collect Mee OIDC -> Mee DS get/check/save consent) -->
pub trait OidcProvider {
    // * authorize(req) -> AuthorizeTO(action, consent, ..)
    fn authorize() -> Result<()>;
    // * check_consent(req) -> ConsentStatusTO()
    fn check_consent() -> Result<()>;
    fn build_idtoken() -> Result<()>;
}

pub trait SiopProvider {
    // Returns Discovery Metadata
    // @see https://openid.net/specs/openid-connect-self-issued-v2-1_0.html#name-dynamic-self-issued-openid-
    fn get_siop_metadata() -> Result<()>;
}
