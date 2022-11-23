// @generated automatically by Diesel CLI.

diesel::table! {
    dscontainer (did) {
        did -> Text,
        name -> Text,
        version -> Integer,
        version_signature -> Text,
        enc_keys -> Text,
        enc_config -> Text,
        data -> Nullable<Text>,
    }
}
