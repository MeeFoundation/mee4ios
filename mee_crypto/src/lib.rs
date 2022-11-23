#[derive(Debug, thiserror::Error)]
pub enum MeeCryptoErr {
    // #[error(transparent)]
    // DSErr(#[from] mee_ds_sqlite::MeeDsSqliteErr),
    #[error("unknown error")]
    Unknown,
}

type Result<T, E = MeeCryptoErr> = std::result::Result<T, E>;
//TODO define API, follow NIST reccomendations
pub trait CryptoProvider {
    fn encrypt() -> Result<()>;
    fn decrypt() -> Result<()>;
}

