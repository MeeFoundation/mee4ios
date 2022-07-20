#  Idea on how to pass a parameter to not installed app

When a user clicks on the "connect with mee" button the app can be not installed yet.
In that case, we need to redirect the user to our web app page, passing some partner data to it (https://getmee.org/install/{some data like partner id})
Then our page saves that partner id to local storage and redirects the user to AppStore.
When the user finishes installing Mee ios app and opens it, biometrics initialization dialog appears. After the user finished inisialisation, we open Mee web app again, reading customer id,
we saved earlier. Then we just open Mee ios app hardlink, passing there our customer id.


