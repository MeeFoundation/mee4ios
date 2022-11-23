pub mod models;
mod schema;

use diesel::prelude::*;
use diesel::sqlite::SqliteConnection;
use models::DSContainer;

static SELF_CTX_ID: &str = "self";

#[derive(Debug, thiserror::Error)]
pub enum MeeDsSqliteErr {
    #[error("DsSqliteErr: {code} - {msg}")]
    DsSqliteErr { code: u32, msg: String },

    #[error("ConnectionError")]
    ConnectionError(#[from] diesel::ConnectionError),

    #[error("SqlError")]
    SqlError(#[from] diesel::result::Error),
}

type Result<T, E = MeeDsSqliteErr> = std::result::Result<T, E>;

pub struct MeeDataStorage {
    db_url: String,
}

impl MeeDataStorage {
    pub fn new(database_url: String) -> Self {
        Self {
            db_url: database_url,
        }
    }

    pub fn establish_connection(&self) -> Result<SqliteConnection> {
        let conn = SqliteConnection::establish(&self.db_url)?;
        Ok(conn)
    }

    pub fn get_ctx(&self, ctx_id: String) -> Result<Option<DSContainer>> {
        use self::schema::dscontainer::dsl::*;
        let mut conn = self.establish_connection()?;
        let results = dscontainer
            .filter(did.eq(ctx_id))
            .limit(1)
            .load::<DSContainer>(&mut conn)?;

        match results.as_slice() {
            [ctx] => Ok(Some(ctx.clone())),
            _ => Ok(None),
        }
    }

    // pub fn upd(to: CollectionTO, sub: &str, conn: &MysqlConnection) -> Result<CollectionTO, AppError> {
    //     use crate::schema::collection::dsl::*;
    //     diesel::update(collection.filter(uuid.eq(&to.id)).filter(user_id.eq(sub)))
    //         .set((name.eq(&to.name), note.eq(&to.note), modified.eq(Utc::now().naive_utc())))
    //         .execute(conn)?;
    //     CollectionRepo::get(&to.id, sub, conn)
    // }

    pub fn upd_ctx_data(&self, ctx: DSContainer) -> Result<i32> {
        use self::schema::dscontainer::dsl::*;
        let mut conn = self.establish_connection()?;
        let results = dscontainer
            .filter(did.eq(&ctx.did))
            .limit(1)
            .load::<DSContainer>(&mut conn)?;

        match results.as_slice() {
            [_old_ctx] => {
                //FIXME check ctx verstion, update signature, etc
                let v = ctx.version + 1;
                diesel::update(dscontainer.filter(did.eq(&ctx.did)))
                    .set((data.eq(&ctx.data), version.eq(&v)))
                    .execute(&mut conn)?;
                Ok(v)
            }
            _ => Ok(0),
        }
    }

    pub fn get_self_ctx(&self) -> Result<DSContainer> {
        use self::schema::dscontainer::dsl::*;
        let mut conn = self.establish_connection()?;
        let results = dscontainer
            .filter(did.eq(SELF_CTX_ID))
            .limit(1)
            .load::<DSContainer>(&mut conn)?;

        match results.as_slice() {
            [self_ctx] => Ok(self_ctx.clone()),
            _ => Err(MeeDsSqliteErr::DsSqliteErr {
                code: 1001,
                msg: String::from("Not found"),
            }),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use dotenvy::dotenv;
    use std::env;

    struct Temp {
        x: i32,
        y: i32,
    }

    #[actix_rt::test]
    async fn test_ctx() {
        let t1 = Temp { x: 1, y: 1 };
        let r;
        {
            let x = 5;
            r = &x;
        }
        println!("r: {}", r);
        assert_eq!(t1.x, 1);
    }

    #[actix_rt::test]
    async fn test_get_self_ctx() {
        dotenv().ok();
        let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
        let ds = MeeDataStorage::new(database_url);

        match ds.get_self_ctx() {
            Ok(res) => {
                assert_eq!(res.did, SELF_CTX_ID);
            }
            Err(e) => panic!("get self ctx error: {:?}", e),
        }
    }
}
