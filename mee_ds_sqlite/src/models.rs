use crate::schema::dscontainer;
use diesel::prelude::*;

#[derive(Queryable, Insertable, Debug, Clone)]
#[diesel(table_name = dscontainer)]
pub struct DSContainer {
    pub did: String,
    pub name: String,
    pub version: i32,
    pub version_signature: String,
    pub enc_keys: String,
    pub enc_config: String,
    pub data: Option<String>,
}
