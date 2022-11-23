// mod models;

// #[macro_use]
// extern crate lazy_static;

// use ::r2d2::Pool;
// use diesel::r2d2::{Pool, ConnectionManager};
use mee_ds_sqlite::models::DSContainer;
use mee_ds_sqlite::MeeDataStorage;
use std::env;
use std::sync::Arc;

// use std::sync::{Arc, RwLock};
// use once_cell::sync::Lazy;

// static DEFAULT_LIST: Lazy<RwLock<Option<Arc<SqliteConnection>>>> = Lazy::new(|| RwLock::new(None));

// getSelf - returns self context( ContexInfoTO )
// getGrops - returns list of GroupTO(id, name, logo)
// contexts - returns list of ContextNameTO(id, type(), url, name, logo(favicon), isMeeCert)
// getContextInfo - return ContexInfoTO(name, consent, attributes, )
// updAttribute(ctx, att)

#[derive(Debug, thiserror::Error)]
pub enum MeeErr {
    // #[error("DsSqliteErr: {code} - {msg}")]
    // DsSqliteErr { code: u32, msg: String },
    #[error(transparent)]
    DSErr(#[from] mee_ds_sqlite::MeeDsSqliteErr),

    #[error("unknown error")]
    Unknown,
}

type Result<T, E = MeeErr> = std::result::Result<T, E>;

pub struct MeeAgent {
    ds: Arc<MeeDataStorage>,
}

impl MeeAgent {
    pub fn new(ds_url: String) -> Self {
        Self {
            ds: Arc::new(MeeDataStorage::new(ds_url)),
        }
    }

    pub fn get_self_ctx(&self) -> Result<DSContainer> {
        Ok(self.ds.get_self_ctx()?)
    }

    pub fn get_ctx(&self, ctx_id: String) -> Result<Option<DSContainer>> {
        Ok(self.ds.get_ctx(ctx_id)?)
    }

}

pub fn get_agent(database_url: String) -> Arc<MeeAgent> {
    Arc::new(MeeAgent::new(database_url))
}

uniffi_macros::include_scaffolding!("mee");
